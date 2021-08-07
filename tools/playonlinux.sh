#!/bin/bash
####################### DISTRIBUTION ######################
# # For the Cosmic version
# # Type the following commands:

# wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
# wget http://deb.playonlinux.com/playonlinux_cosmic.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux

# For the Bionic version
# Type the following commands:

wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
wget http://deb.playonlinux.com/playonlinux_bionic.list -O /etc/apt/sources.list.d/playonlinux.list
apt-get update
apt-get install playonlinux

# # For the Xenial version
# # Type the following commands:

# wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
# wget http://deb.playonlinux.com/playonlinux_xenial.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux

# # For the Trusty version
# # Type the following commands:

# wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
# wget http://deb.playonlinux.com/playonlinux_trusty.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux

# # For the Saucy version
# # Type the following commands:

# wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
# wget http://deb.playonlinux.com/playonlinux_saucy.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux

# # For the Precise version
# # Type the following commands:

# wget -q "http://deb.playonlinux.com/public.gpg" -O- | apt-key add -
# wget http://deb.playonlinux.com/playonlinux_precise.list -O /etc/apt/sources.list.d/playonlinux.list
# apt-get update
# apt-get install playonlinux
###########################################################
###########################################################
apt-get install xterm winbind
###########################################################
###########################################################
# Installing WineHQ packages
# ----------------- On Ubuntu & Linux Mint ----------------- 
dpkg --add-architecture i386 && \
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
apt-key add winehq.key && \
add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
apt-get update && \
apt-get install --install-recommends winehq-stable