#!/usr/bin/env bash
#####################################################################
# FOR Ubuntu 18.04
#####################################################################
# Syntax: ./install_cuda.sh [DEBIAN distribution] [DEBIAN version] [CPU architecture]
#####################################################################
if [ "${#}" -ne 3 ]; then
    DISTRO=${1:-"ubuntu1804"}
    VERSION=${2:-"18.04"}
    ARCH=${3:-"x86_64"}
fi
# # 1. Install repository meta-data
# dpkg -i cuda-repo-${DISTRO}_${VERSION}_${ARCH}.deb
# 2. Installing the CUDA public GPG key
# #    When installing using the local repo:
# apt-key add /var/cuda-repo-${DISTRO}-${VERSION}/7fa2af80.pub
# When installing using network repo on Ubuntu 20.04/18.04:
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/7fa2af80.pub &&
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/ /" &&
# Pin file to prioritize CUDA repository:
wget https://developer.download.nvidia.com/compute/cuda/repos/${DISTRO}/${ARCH}/cuda-${DISTRO}.pin &&
mv cuda-${DISTRO}.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&
# Update apt repos
apt-get update -y &&
sudo apt-get install -y \
libnvidia-extra-495 \
nvidia-driver-495 \
cuda-drivers-495 \
cuda-drivers \
cuda-runtime-11-5 \
cuda-demo-suite-11-5 \
cuda
# apt-get install nvidia-gds
# To add this path to the PATH variable:
export PATH=/usr/local/cuda-11.5/bin${PATH:+:${PATH}} &&
# To change the environment variables for 64-bit operating systems:
export LD_LIBRARY_PATH=/usr/local/cuda-11.5/lib64\
                     ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}





