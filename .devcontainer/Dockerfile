FROM ubuntu:latest

ARG ARG_DOCKER_ENTRYPOINT

RUN apt-get update                     && \
    apt-get install -y tmux            && \
    apt-get install -y build-essential && \
    apt-get install -y vim             && \
    apt-get install -y git             && \
    apt-get install -y sudo            && \
    apt-get install -y curl            && \
    apt-get install -y zip             && \
    apt-get install -y unzip           && \
    apt-get install -y tar             && \
    apt-get install -y python3         && \
    apt-get install -y python3-pip


COPY ${ARG_DOCKER_ENTRYPOINT} /root
RUN chmod +x /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]
