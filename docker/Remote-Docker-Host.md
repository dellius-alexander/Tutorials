# Run commands on remote Docker host  

This is how to connect to another host with your docker client, without modifying your local Docker installation or when you don't have a local Docker installation.  

## Enable Docker Remote API  

First be sure to enable the Docker Remote API on the remote host.  

This can easily be done with a container.  
For HTTP connection use [jarkt/docker-remote-api](https://hub.docker.com/r/jarkt/docker-remote-api/).  
For HTTPS connection use [kekru/docker-remote-api-tls](https://hub.docker.com/r/kekru/docker-remote-api-tls/).  

You can also configure the Docker engine to expose the remote API. Read [Enable Docker Remote API with TLS client verification](https://gist.github.com/kekru/974e40bb1cd4b947a53cca5ba4b0bbe5) for more information.

## Download docker client  

If you don't have a local Docker installation, you need to download the `docker client` (= docker cli), which is a simple executable.  
And then add it to your PATH variable.  

Here are some ways how to get the executable.  
You only need **one** of the steps for you OS, not all:

+ Linux:
  + Either: (Any Linux)  
    Download tgz file from [download.docker.com/linux/static](https://download.docker.com/linux/static/) and unzip it.
    You only need the `docker` file, which must be added to your PATH.  
    Maybe this [script](https://gist.github.com/kekru/fd6cd68239d6da87ca1b1a55564c1921) helps downloading it.  
  + Or: (Ubuntu/Debian)  
    `$ apt-get install docker-ce-cli`
  + Or: (Centos)  
    `$ yum install docker-ce-cli`
+ MacOS:  
  + Either:  
    Download tgz file from [download.docker.com/mac/static](https://download.docker.com/mac/static/) and unzip it.
    You only need the `docker` file, which must be added to your PATH.
  + Or:  
    Install [Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/) (Full Docker Engine in VM + client)
+ Windows
  + Either: (Only *old 2017* builds are available)  
    Download tgz file from [download.docker.com/win/static](https://download.docker.com/win/static/) and unzip it.
    You only need the `docker.exe` file, which must be added to your PATH.  
  + Or:  
    Download a build of [StefanScherer/docker-cli-builder](https://github.com/StefanScherer/docker-cli-builder/releases/)
  + Or: (Powershell with [Chocolatey](https://chocolatey.org/install) required)  
    `$ choco install docker-cli`  
    Will install latest [StefanScherer/docker-cli-builder](https://github.com/StefanScherer/docker-cli-builder/releases/) release for you.  
  + Or: (Windows 10 Pro required)  
    Install [Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/) (Full Docker Engine in VM + client)

## HTTPS connection configuration

Docker's Remote API client authentication works with certificates.  
See [Protect the Docker daemon socket](https://docs.docker.com/engine/security/https/) or my [Enable Docker Remote API with TLS client verification](https://gist.github.com/kekru/974e40bb1cd4b947a53cca5ba4b0bbe5) on how to create server and client certificates.  

For the following examples copy ca.pem (CA certificate), cert.pem (client certificate) and key.pem (client's private key) in `/home/me/docker-tls/` or `C:\users\me\docker-tls\`.

## Connect to remote api

Now we will see some ways on how to connect to a docker remote api.

### Set alias (Linux and Mac)  

For HTTP connection set the following alias:  

```bash
alias dockerx="docker -H=your-remote-server.org:2375"
```  

For HTTPS connection set the following alias:  

```bash
alias dockerx="docker \
  --tlsverify \
  -H=your-remote-server.org:2376 \
  --tlscacert=/home/me/docker-tls/ca.pem \
  --tlscert=/home/me/docker-tls/cert.pem \
  --tlskey=/home/me/docker-tls/key.pem"
```

Now you can run commands on the remote machine with `dockerx` instead of `docker`.  

Example:

```bash
dockerx ps
```

### Create .bat file (Windows)

Create a file `dockerx.bat`.  
For HTTP connection the content of the bat file should be:  

```bash
docker -H=your-remote-server.org:2375 %*
```  

For HTTPS connection the content of the bat file should be:  

```bat
docker ^
  --tlsverify ^
  -H=your-remote-server.org:2376 ^
  --tlscacert=C:\users\me\docker-tls\ca.pem ^
  --tlscert=C:\users\me\docker-tls\cert.pem ^
  --tlskey=C:\users\me\docker-tls\key.pem %*
```

(If this does not work remove the carets (^) and the line breaks)

Now you can run commands on the remote machine with `dockerx.bat` instead of `docker`.  

Example:

```bash
dockerx.bat ps
```

### Set env var (Linux, Mac, Windows)

You can set environment vars to define the docker remote api that should be connected to.  

For HTTP connection

```bash
# Linux/Mac
export DOCKER_HOST="tcp://your-remote-server.org:2375"

# Windows Powershell
$env:DOCKER_HOST="tcp://your-remote-server.org:2375"
```

For HTTPS connection

```bash
# Linux/Mac
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://your-remote-server.org:2376"
export DOCKER_CERT_PATH="/home/me/docker-tls"

# Windows Powershell
$env:DOCKER_TLS_VERIFY="1"
$env:DOCKER_HOST="tcp://your-remote-server.org:2376"
$env:DOCKER_CERT_PATH="C:\users\me\docker-tls"
```

Be sure that your `DOCKER_CERT_PATH` directory contains the following files:

+ ca.pem (CA certificate)
+ cert.pem (client certificate)
+ key.pem (client's private key)

Now any docker command will run against the remote api

```bash
docker ps
```

Do switch back to local docker, unset the env vars:  

```bash
# Linux/Mac
unset DOCKER_HOST
unset DOCKER_TLS_VERIFY
unset DOCKER_CERT_PATH

# Windows Powershell
Remove-Item env:DOCKER_HOST
Remove-Item env:DOCKER_TLS_VERIFY
Remove-Item env:DOCKER_CERT_PATH
```

### Reuse SSH connection (Linux, Mac, Windows(?))

If you already added an SSH public key to your remote server, then you can use this ssh credentials for your docker connection, too. You don't need to configure the remote api on the server for this approach.  
(Should work on Windows, but I did only test on Linux yet)

Set the env var to a ssh address:

```bash
# Linux/Mac
export DOCKER_HOST="ssh://username@your-remote-server.org"

# Windows Powershell
$env:DOCKER_HOST="ssh://username@your-remote-server.org"
```

Now any docker command will run against the remote api

```bash
docker ps
```

Do switch back to local docker, unset the env vars:  

```bash
# Linux/Mac
unset DOCKER_HOST

# Windows Powershell
Remove-Item env:DOCKER_HOST
```

### Docker Context (Linux, Mac, Windows)

Since Docker 19.03 there is the `docker context` command. You can define multiple remote servers and switch between them.  

Create a context for HTTPS  
(Change paths for Windows)

```bash
docker context create example-server \
  --description "connection to example server" \
  --docker "host=tcp://your-remote-server.org:2376, \
     ca=/home/me/docker-tls/ca.pem, \
     cert=/home/me/docker-tls/cert.pem, \
     key=/home/me/docker-tls/key.pem"
```

(For HTTP connection remove ca, cert and key and switch port to 2375. For SSH connection use ssh address)

Now you can call the remote server with:

```bash
docker --context example-server ps
```

Or choose the context and then all following command will call the remote server

```bash
docker context use example-server
docker ps
```
