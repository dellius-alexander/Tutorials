# Install Dotnet

## Install using Apt Repository
### Ubuntu 18.04 ✔️

Installing with APT can be done with a few commands. Before you install .NET, run the following commands to add the Microsoft package signing key to your list of trusted keys and add the package repository.

Open a terminal and run the following commands:

```bash
wget https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```
The .NET SDK allows you to develop apps with .NET. If you install the .NET SDK, you don't need to install the corresponding runtime. To install the .NET SDK, run the following commands:

There are two placeholders in the following set of commands.
- {dotnet-package}

This represents the .NET package you're installing, such as aspnetcore-runtime-3.1. This is used in the following sudo apt-get install command.

- {os-version}

This represents the distribution version you're on. This is used in the wget command below. The distribution version is the numerical value, such as 20.04 on Ubuntu or 10 on Debian.

If you downloaded the deb package and it failed to install, try purging the package list:

```bash
sudo dpkg --purge packages-microsoft-prod && \
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
```

Then, try to install .NET again. If that doesn't work, you can run a manual install with the following commands:

```bash
sudo apt-get install -y gpg && \
wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o  microsoft.asc.gpg && \
sudo mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
wget https://packages.microsoft.com/config/ubuntu/18.04/prod.list && \
sudo mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
sudo chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
sudo chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
sudo apt-get update && \
sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y dotnet-sdk-5.0
  ```