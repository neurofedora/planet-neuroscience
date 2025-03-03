#!/bin/bash

# Copyright 2021 Ankur Sinha
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
# File : update.sh
#
# build the planet and commit

check_git () {
    if ! command -v git; then
        echo "Git is required."
        exit -1
    else
        git config user.email "neuro-sig@lists.fedoraproject.org"
        git config user.name "neurofedorabot"
    fi
}

refresh_repo () {
    git pull --force
}

check_pluto () {
    if ! command -v pluto; then
        mkdir ~/bin/
        # to remove all gems: GEM_PATH="$HOME/.local/share/gem/ruby" gem uninstall --all -I
        gem install --user-install sqlite3  -n ~/bin/ || exit -1
        gem install --user-install activerecord -n ~/bin/ || exit -1
        # require at least v2.2.1: https://github.com/feedreader/pluto/issues/49#issuecomment-2629012419
        gem install --user-install feedparser -v '>= 2.2.1' -n ~/bin/ || exit -1
        gem install --user-install pluto rss -n ~/bin/ || exit -1
    fi
}

rebuild_planet () {
    ~/bin/pluto build planet.ini -t neuroscience -o docs || exit -1
}

commit_update () {
    git add .
    git commit -m ":rocket: Regenerated"
    git push -u origin master
}

usage () {
    echo "update.sh: update the planet"
    echo "Usage: update.sh -[lg]"
    echo
    echo "-g: GitHub actions build"
    echo "-l: local build"
}

while getopts "lg" OPTION
do
    case $OPTION in
        l)
            check_git
            check_pluto
            refresh_repo
            rebuild_planet
            commit_update
            exit 0
            ;;
        g)
            check_git
            check_pluto
            rebuild_planet
            commit_update
            exit 0
            ;;
        ?)
            usage
            exit 0
            ;;
    esac
done
