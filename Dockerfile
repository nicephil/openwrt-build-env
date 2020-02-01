#=================================================
# woolink/openwrt-build-env
# Description: OpenWrt build environment in docker
# Lisence: MIT
# Author: leilei.wang
#=================================================
ARG IMAGE_TAG=18.04
FROM ubuntu:$IMAGE_TAG

LABEL maintainer leilei.wang

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8

COPY ./sources.list /etc/apt/sources.list

#RUN echo "nameserver 223.5.5.5" > /etc/resolv.conf

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update -qq && apt-get upgrade -qqy

RUN apt-get install -qqy git wget curl vim nano htop tmux tree sudo ca-certificates zsh command-not-found uuid-runtime tzdata openssh-server lrzsz 

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update -qq && apt-get upgrade -qqy

RUN apt-get install -qqy build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler

RUN mkdir /var/run/sshd && \
    useradd -m -G sudo -s /usr/bin/zsh user && \
    echo 'user:user' | chpasswd && \
    echo 'user ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/user && \
    chmod 440 /etc/sudoers.d/user && \
    curl -fsSL git.io/gotop.sh | bash

USER user
WORKDIR /home/user

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended && \
    git clone git://github.com/zsh-users/zsh-syntax-highlighting .oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone git://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-completions .oh-my-zsh/custom/plugins/zsh-completions && \
    echo "autoload -U compinit && compinit" >> .zshrc && \
    sed -i '/^ZSH_THEME=/c\ZSH_THEME="ys"' .zshrc && \
    sed -i '/^plugins=/c\plugins=(git sudo z command-not-found zsh-syntax-highlighting zsh-autosuggestions zsh-completions)' .zshrc && \
    curl -fsSL git.io/oh-my-tmux.sh | bash && \
    mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh


RUN sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


EXPOSE 22

CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
