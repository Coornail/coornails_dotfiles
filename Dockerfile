FROM ubuntu:16.04

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        zsh\
        make\
        git\
        ca-certificates \
        curl \
        locales\
        python\
        gawk\
      && rm -rf /var/lib/apt/lists/*

# Configure locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

COPY . /root/dotfiles
WORKDIR /root/dotfiles
RUN make -j

ENTRYPOINT ["zsh"]
