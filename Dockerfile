FROM ruby:latest

# Setup rootless env
ARG USER=fedora

WORKDIR /home/${USER}
COPY . .
RUN useradd ${USER} && \
    chown -R ${USER}:${USER} .
USER ${USER}

# Install deps
RUN bundle install

ENTRYPOINT ["pluto"]
