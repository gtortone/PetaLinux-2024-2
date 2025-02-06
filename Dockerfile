FROM		   ubuntu:24.04
MAINTAINER	gcccompil3r@gmail.com
LABEL 		authors="gcccompil3r@gmail.com"

#build with docker build --build-arg PETALINUX_INSTALLER=petalinux-v2019.2-final-installer.run -t petalinux

#RUN apt-get update -o Acquire::CompressionTypes::Order::=gz

ARG PETALINUX_INSTALLER
ARG PETALINUX

#ENV DEBIAN_FRONTEND=noninteractive

# add sourcelist
#RUN sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list && \
#    cat /etc/apt/sources.list 
   
# package update
RUN apt-get -y update

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Apt-Utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends apt-utils

RUN apt-get -y install build-essential sudo expect emacs openssh-server gcc gawk diffstat xvfb chrpath socat xterm autoconf libtool libtool-bin python3 git net-tools zlib1g-dev libncurses5-dev libssl-dev xz-utils locales \
wget tftp-hpa cpio gcc-multilib tofrodos iproute2 gnupg flex bison unzip make texinfo libsdl1.2-dev libglib2.0-dev zlib1g screen lsb-release vim libgtk2.0-dev libselinux1 tar rsync bc dialog bind9-dnsutils

# locale update
RUN locale-gen en_US.UTF-8 && \
   update-locale LANG=en_US.UTF-8

# change /bin/sh symlink
RUN rm /bin/sh && \
   ln -s /bin/bash /bin/sh

# create directory /opt/pkg
RUN mkdir -p /opt/pkg && \
   chown ubuntu /opt/pkg

RUN usermod -aG sudo ubuntu && \
   echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install libtinfo5
RUN wget http://security.ubuntu.com/ubuntu/pool/universe/n/ncurses/libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
   dpkg -i libtinfo5_6.3-2ubuntu0.1_amd64.deb && \
   rm libtinfo5_6.3-2ubuntu0.1_amd64.deb

USER ubuntu 
ENV HOME /home/ubuntu
ENV LANG en_US.UTF-8
WORKDIR /home/ubuntu

# install petalinux
COPY --chown=ubuntu:ubuntu ${PETALINUX_INSTALLER} /home/ubuntu/${PETALINUX_INSTALLER}
RUN chmod +x /home/ubuntu/${PETALINUX_INSTALLER}
RUN /home/ubuntu/${PETALINUX_INSTALLER} -y -d /opt/pkg/petalinux
RUN echo "export TERM=linux" >> /home/ubuntu/.bashrc
RUN echo "source /opt/pkg/petalinux/settings.sh" >> /home/ubuntu/.bashrc
# fix screen startup issue
RUN echo "ulimit -n 1024" >> /home/ubuntu/.bashrc
RUN rm -f ${PETALINUX_INSTALLER}
