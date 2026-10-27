FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
      && apt-get install -y -q --no-install-recommends \
        zsh \
        starship \
        make \
        git \
        git-lfs \
        ca-certificates \
        curl \
        gawk \
        vim \
        less \
        fzf \
        tmux \
        universal-ctags \
        libimage-exiftool-perl \
        direnv \
        urlview \
      && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

COPY . /root/dotfiles
WORKDIR /root/dotfiles

RUN make -j

ENTRYPOINT ["zsh"]
