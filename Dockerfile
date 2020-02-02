#=================================================
# woolink/openwrt-build-env
# Description: OpenWrt build environment in docker
# Lisence: MIT
# Author: leilei.wang
#=================================================
ARG MY_IMAGE_TAG=16.04
FROM ubuntu:$MY_IMAGE_TAG


LABEL maintainer leilei.wang

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8

COPY ./sources.list /etc/apt/sources.list

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get update -qq && apt-get upgrade -qqy && \
    apt-get install -qqy git wget curl vim nano htop tmux tree sudo ca-certificates zsh command-not-found uuid-runtime tzdata openssh-server lrzsz build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler lzop && \
    apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* var/tmp/*

ARG MY_USER=llwang
ARG MY_GROUP=asmc
RUN mkdir /var/run/sshd && \
    groupadd "${MY_GROUP}" && \
    useradd -m -g "$MY_GROUP" -G sudo -s /usr/bin/zsh "$MY_USER" && \
    echo "$MY_USER:$MY_USER" | chpasswd && \
    echo "%$MY_GROUP ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    curl -fsSL git.io/gotop.sh | bash

ARG MY_USER=llwang
ARG MY_GROUP=asmc
USER $MY_USER
WORKDIR /home/$MY_USER

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

EXPOSE 22

CMD [ "sudo", "/usr/sbin/sshd", "-D" ]
