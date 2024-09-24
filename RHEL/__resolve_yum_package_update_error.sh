#!/bin/bash
# Step 1: Check Network Connectivity
ping -c 4 google.com

# Step 2: Update Repository Metadata
sudo yum clean all
sudo yum makecache

# Step 3: Check Repository Configuration
# Ensure that the repository configuration files in /etc/yum.repos.d/ are correct and not corrupted.
# You can manually inspect these files or use the following command to list them:
ls /etc/yum.repos.d/

# Step 4: Clear YUM Cache
sudo yum clean all

# Step 5: Try Alternative Mirrors
# Edit the repository configuration files to use alternative mirrors.
# For example, you can edit /etc/yum.repos.d/CentOS-Base.repo and change the baseurl or mirrorlist.

# Example of editing a repository file to use an alternative mirror
sudo sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo
sudo sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Base.repo

# Step 6: Retry the YUM command
sudo yum update
