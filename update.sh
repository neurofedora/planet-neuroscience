#!/bin/bash

# Copyright 2021 Ankur Sinha
# Author: Ankur Sinha <sanjay DOT ankur AT gmail DOT com> 
# File : update.sh
#
# build the planet and commit

if ! command -v git; then
    echo "Git is required."
    exit -1
else
    git pull --force
fi

if ! command -v pluto; then
    echo "pluto is not installed. Please install using 'gem install pluto'"
    exit -1
fi

if [ -f "planet.db" ];
then
    pluto update planet.ini
else
    pluto --err build planet.ini -t neuroscience -o docs
fi

# Rename file
pushd docs
    if [ -f "planet.neuroscience.html" ]; then
        mv planet.neuroscience.html index.html
    fi
popd

git add .
git commit -m "Regenerated"
git push -u origin master

exit 0
