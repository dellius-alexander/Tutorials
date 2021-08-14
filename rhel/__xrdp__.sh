#!/usr/bin/env bash
#####################################################################
# Install the EPEL repository configuration package using the following command.
yum install -y epel-release && \
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
# install xrdp package on CentOS 7 / RHEL 7
yum -y install xrdp tigervnc-server && \
# start the xrdp service
systemctl start xrdp && \
# xrdp should now be listening on 3389. You can confirm this by using netstat command.
netstat -antup | grep xrdp && \
# enable the xrdp service at system startup
systemctl enable xrdp && \
# Configure the firewall to allow RDP connection from external machines
firewall-cmd --permanent --add-port=3389/tcp && \
firewall-cmd --reload && \
# Configure SELinux
chcon --type=bin_t /usr/sbin/xrdp && \
chcon --type=bin_t /usr/sbin/xrdp-sesman