FROM ubuntu:24.10

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
      && apt-get install -y -q --no-install-recommends \
        zsh\
        make\
        git\
        ca-certificates \
        curl \
        gawk\
        vim\
        less\
        emacs\
        fzf\
      && rm -rf /var/lib/apt/lists/*

ENV LANG C.UTF-8

COPY . /root/dotfiles
WORKDIR /root/dotfiles

RUN make -j

ENTRYPOINT ["zsh"]
