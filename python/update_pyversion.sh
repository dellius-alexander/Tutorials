#!/bin/bash

# This script is configured or yum repositories
# Must be run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install the latest version of Python: 3.10, 3.11, and 3.12
# and virtual environment also
yum update -y && yum install -y python3.9 python3.11 python3.12 \
python3-pip python3.11-pip python3.12-pip


# Update the alternatives for python3
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 2
alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 3

# Update the alternatives for pip3
alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.9 1
alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 2
alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.12 3

# Set the default version of python3 to 3.12
alternatives --set python3 /usr/bin/python3.12
alternatives --set pip3 /usr/bin/pip3.12

