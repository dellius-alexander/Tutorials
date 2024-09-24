#!/usr/bin/env bash
###########################################################
# If your system is 64 bit, enable 32 bit architecture (if you haven't already):
dpkg --add-architecture i386 && \

# Ubuntu 18.04
# Linux Mint 19.x
add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' &&

# Stable branch
# Depandencies
curl -fsSLo /tmp/libfaudio0_21.02-1_i386.deb  http://ftp.us.debian.org/debian/pool/main/f/faudio/libfaudio0_21.02-1_i386.deb && \
curl -fsSLo /tmp/libstb0_0.0~git20180212.15.e6afb9c-1_i386.deb  http://ftp.us.debian.org/debian/pool/main/libs/libstb/libstb0_0.0~git20180212.15.e6afb9c-1_i386.deb && \
curl -fsSLo /tmp/libsdl2-2.0-0_2.0.9+dfsg1-1_i386.deb http://ftp.us.debian.org/debian/pool/main/libs/libsdl2/libsdl2-2.0-0_2.0.9+dfsg1-1_i386.deb && \
curl -fsSLo /tmp/libc6_2.31-13_i386.deb http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.31-13_amd64.deb && \
sudo dpkg -i /tmp/libc6_2.31-13_i386.deb && \
sudo dpkg -i /tmp/libsdl2-2.0-0_2.0.9+dfsg1-1_i386.deb && \
sudo dpkg -i /tmp/libstb0_0.0~git20180212.15.e6afb9c-1_i386.deb && \
sudo apt-get update && \
sudo apt-get --fix-broken --install-recommends install -y \
libglib2.0-0 \
libgstreamer-plugins-base1.0-0=1.10.0 \
libgstreamer1.0-0=1.0.0 \
libsdl2-2.0-0>= 2.0.12 \
libstb0 \
libc-bin \
sudo dpkg -i /tmp/libfaudio0_21.02-1_i386.deb && \
sudo apt-get update && \
sudo apt-get --fix-broken --install-recommends install -y \
libfaudio0 \
libcapi20-3 \
libcups2 \
libglu1-mesa \
libglu1 \
libgsm1 \
libgssapi-krb5-2 \
libkrb5-3 \
libodbc1 \
ibosmesa6 \
libsane \
libsane1 \
libsdl2-2.0-0 \
libv4l-0 \
libxcomposite1 \
libxcursor1 \
libxi6 \
libxinerama1 \
libxrandr2 \
libxrender1 \
libxslt1.1 \
winehq-stable 