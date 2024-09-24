# Docker daemon configuration overview

Docker daemon configuration is a critical aspect of managing Docker containers and images.
The Docker daemon is the core of the Docker engine, and it is responsible for managing
Docker objects such as images, containers, networks, and volumes.

In this guide, we will explore the various aspects of Docker daemon configuration,
including the configuration file (`daemon.json`), Docker context, overlay2 driver storage,
volume storage and remote access to the Docker daemon.


## Docker Daemon Configuration file

The following table shows the location where the Docker daemon expects to find
the configuration file by default, depending on your system and how you're running
the daemon.

| OS and configuration | File location                            |
|----------------------|------------------------------------------|
| Linux, regular setup | /etc/docker/daemon.json                  |
| Linux, rootless mode | ~/.config/docker/daemon.json             |
| Windows              | C:\ProgramData\docker\config\daemon.json |
| macOS                | ~/.docker/daemon.json                    |

The Docker daemon reads its configuration from the `daemon.json` file.

For rootless mode, the daemon respects the `XDG_CONFIG_HOME` variable.
If set, the expected file location is `$XDG_CONFIG_HOME/docker/daemon.json`.

You can also explicitly specify the location of the configuration file on startup,
using the `dockerd --config-file` flag.

---

## Configuring Docker Context

### Create a new context using SSH and TLS with key-based authentication using Docker CLI

```bash
docker context create new-context-name \
  --description "Docker context for remote server using SSH and TLS with key-based authentication for Docker Desktop on Synology NAS" \
  --docker "host=ssh://user@<ip address:port | url:port>" \
  --docker "skip-tls-verify=true" \
  --docker "key=/path/to/private/key" \
  --docker "tls=true" \
  --default-stack-orchestrator swarm 
```

### Create a new context using SSH and TLS with key-based authentication using Docker Compose

```yaml
version: '3.8'

services:
  context:
    image: docker:20.10.7
    command: context create new-context-name \
      --description "Docker context for remote server using SSH and TLS with key-based authentication for Docker Desktop on Synology NAS" \
      --docker "host=ssh://user@<ip address:port | url:port>" \
      --docker "skip-tls-verify=true" \
      --docker "key=/path/to/private/key" \
      --docker "tls=true" \
      --default-stack-orchestrator swarm
```

---

## Configuring remote access

***Note**: Remote access to the Docker daemon is disabled by default for security reasons.
If you need to enable remote access, you can do so by configuring the Docker daemon to
listen on a specific IP address and port. If conflicting settings are present in the
`daemon.json` file, that does not match the systemd unit file, the docker daemon will
not start.*

### Configure Docker daemon to listen on a specific IP address with daemon.json

1. Set the hosts array in the `/etc/docker/daemon.json` to connect to the Unix socket
   and an IP address, as follows:

    ```json
    {
      "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2375"]
    }
    ```

2. Restart the Docker daemon to apply the changes:

    ```bash
    sudo systemctl restart docker
    ```

3. Verify that the Docker daemon is listening on the specified IP address:

    - ***Note**: The `netstat` command is typically pre-installed in most Linux distributions.
      If it’s not, you can install it by installing the `‘net-tools’` package. On Debian and
      Ubuntu systems, use the command `sudo apt-get install net-tools`, and on CentOS and similar
      OS's, use the command `sudo yum install net-tools`.*

    ```bash
    sudo netstat -tuln | grep 2375
    ```

### Configuring remote access with systemd unit file

1. Use the command `sudo systemctl edit docker.service` to open an `override file` for `docker.service` in a text editor.

2. Add or modify the following lines, substituting your own values.

    ```ini
   ; /etc/systemd/system/docker.service.d/docker-daemon-override.conf
   [Service]
   ExecStart=
   ExecStart=/usr/bin/dockerd -H fd:// -H tcp://127.0.0.1:2375
    ```

3. Reload the systemd manager configuration:

    ```bash
    sudo systemctl daemon-reload
    ```

4. Restart the Docker service:

    ```bash
    sudo systemctl restart docker
    ```

5. Verify that the Docker daemon is listening on the specified IP address:

    ```bash
    sudo netstat -tuln | grep 2375
    tcp        0      0 127.0.0.1:2375          0.0.0.0:*               LISTEN      3758/dockerd
    sudo netstat -lntp | grep dockerd
    tcp        0      0 127.0.0.1:2375          0.0.0.0:*               LISTEN      3758/dockerd
    ```

### Lastly, allow access to the remote API through a firewall

1. Open the port 2375 in the firewall:

    ```bash
   # On Debian/Ubuntu systems
    sudo ufw allow 2375/tcp
    # On CentOS/RHEL systems
    sudo firewall-cmd --zone=public --add-port=2375/tcp --permanent
    ```

--- 

## Configure Docker to store its `overlay2` storage and volumes in the `~/.docker/` directory

We need to modify the Docker daemon configuration file (`daemon.json`). Here are the steps:

1. Create or Edit the `daemon.json` File:
    - The `daemon.json` file is typically located at `/etc/docker/daemon.json`. If it doesn't exist,
      you can create it.
2. Add Configuration for `data-root`:
    - Add or update the data-root configuration to point to the desired directory you want
      docker to use as storage (`~/.docker/`).

    - Here is an example of what the `daemon.json` file should look like:

    ```json
    {
      "data-root": "~/.docker/",
      "storage-driver": "overlay2"
    }
    ```

3. Restart Docker:
    - After saving the changes to the `daemon.json` file, restart the Docker daemon to apply the changes.

```bash
sudo systemctl restart docker
```

---

## Docker daemon configuration file use cases

### Basic Structure of `daemon.json`

The `daemon.json` file is typically located at `/etc/docker/daemon.json` (or on Windows at `C:\ProgramData\docker\config\daemon.json`) and is a JSON-formatted file.

Example structure:
```json
{
  "key": "value"
}
```

### 1. **Configuring Default Log Driver**
By default, Docker uses the `json-file` log driver. You can change the default log driver globally for all containers in the `daemon.json` file.

```json
{
  "log-driver": "syslog"
}
```

Use case:
- If you're using a centralized logging system like `syslog` or `fluentd`, you can configure Docker to use these drivers by default.

### 2. **Setting Up Insecure Registries**
If you're running a private Docker registry without TLS (for testing purposes or on a trusted internal network), you can allow Docker to interact with insecure registries by configuring them in `daemon.json`.

```json
{
  "insecure-registries": ["myregistry.local:5000"]
}
```

Use case:
- This is useful in a development environment where you need to push/pull Docker images to/from a local private registry without SSL.

### 3. **Configuring Default Bridge Network Subnet**
You can configure Docker to use a specific subnet for the default bridge network.

```json
{
  "bip": "192.168.1.5/24"
}
```

Use case:
- This is helpful when you have networking conflicts and want Docker to avoid using the default IP range for its bridge network.

### 4. **Enabling Experimental Features**
Docker includes experimental features that are not yet ready for production. You can enable these features in the `daemon.json` file.

```json
{
  "experimental": true
}
```

Use case:
- This is useful if you want to test cutting-edge Docker features like Docker Swarm with features like service mesh before they are officially released.

### 5. **Configuring DNS Servers**
You can configure Docker to use specific DNS servers for all containers.

```json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

Use case:
- If you're working in an environment where DNS resolution needs to be handled by specific DNS servers (such as Google’s DNS servers), you can configure this globally so all containers inherit this setting.

### 6. **Setting Default cgroup Driver**
You can specify which cgroup driver Docker uses by default. This is particularly useful in Kubernetes environments where `systemd` might be required.

```json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
```

Use case:
- When running Docker as part of a Kubernetes cluster, setting `systemd` as the cgroup driver aligns Docker with Kubernetes' default configuration.

### 7. **Limiting Concurrent Downloads and Uploads**
Docker can limit the number of concurrent downloads and uploads to save bandwidth or optimize resource usage.

```json
{
  "max-concurrent-downloads": 3,
  "max-concurrent-uploads": 5
}
```

Use case:
- If your system is low on resources or you want to manage network bandwidth better, you can limit the number of concurrent downloads/uploads of images to avoid overwhelming the system.

### 8. **Enabling Live Restore**
You can configure Docker to enable the live restore feature, which ensures that containers keep running even if the Docker daemon stops or restarts.

```json
{
  "live-restore": true
}
```

Use case:
- In production environments, enabling live restore can improve reliability by ensuring that containers remain up and running even if the Docker daemon goes down for an upgrade or restart.

### 9. **Setting Storage Driver Options**
Docker can be configured to use a specific storage driver and set options related to that driver.

```json
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
```

Use case:
- This is useful when running Docker on systems with specific file systems or when you need to tweak storage performance using options such as overriding kernel checks.

### 10. **Using TLS for Docker Remote API**
To secure the Docker daemon and prevent unauthorized access, you can configure TLS certificates in the `daemon.json` file.

```json
{
  "tls": true,
  "tlscacert": "/path/to/ca.pem",
  "tlscert": "/path/to/server-cert.pem",
  "tlskey": "/path/to/server-key.pem",
  "tlsverify": true
}
```

Use case:
- This configuration ensures that only clients with a trusted certificate can interact with Docker’s remote API, improving security in environments where Docker is exposed over a network.

### 11. **Setting a Default Runtime**
You can set a default runtime for all containers, for example, switching from `runc` to `nvidia` for GPU workloads.

```json
{
  "default-runtime": "nvidia"
}
```

Use case:
- This is essential in environments where specific workloads (e.g., machine learning models requiring GPU support) always need to use a particular runtime.

### 12. **Default Address Pools for Networks**
You can set default IP address pools that Docker uses when creating custom bridge networks.

```json
{
  "default-address-pools": [
    {
      "base": "172.80.0.0/16",
      "size": 24
    }
  ]
}
```

Use case:
- This ensures that custom bridge networks created by users use predefined subnets, avoiding collisions and ensuring consistency across environments.

### 13. **Disabling Userland Proxy**
Docker enables a userland proxy by default for handling network traffic. You can disable this to increase performance on systems where it is not needed.

```json
{
  "userland-proxy": false
}
```

Use case:
- Disabling the userland proxy may improve network performance for containers by allowing direct communication using `iptables` rules instead.

### 14. **Automatic Pruning of Unused Images**
Docker can be configured to automatically prune unused containers, images, and volumes to conserve disk space.

```json
{
  "prune": {
    "enabled": true,
    "threshold": "30GB"
  }
}
```

Use case:
- This is useful in environments with limited disk space, allowing Docker to automatically remove unused resources without manual intervention.

### 15. **Modifying Default ulimit Settings**
You can set default ulimit values for all containers, controlling resource limits like file descriptors.

```json
{
  "default-ulimit": {
    "nofile": {
      "Soft": 64000,
      "Hard": 64000
    }
  }
}
```

Use case:
- This configuration is essential for applications that need to handle a large number of file descriptors, like databases or web servers under heavy load.
