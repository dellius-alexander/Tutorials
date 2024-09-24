# dockerd

## Description

`dockerd` is the persistent process that manages containers. Docker 
uses different binaries for the daemon and client. To run the daemon, type `dockerd`.

To run the daemon with debug output, use `dockerd --debug` or add 
`"debug": true` to [the `daemon.json` file](./configure_docker_daemon.md#docker-daemon-configuration-file).

> **Note**  
> **Enabling experimental features**  
> Enable experimental features by starting `dockerd` with the `--experimental` flag 
or adding `"experimental": true` to the `daemon.json` file.

## Environment variables

The following environment variables are supported by the `dockerd` daemon. Some of 
these are supported both by the Docker Daemon and the `docker` CLI. Refer to 
[Environment variables](https://docs.docker.com/reference/cli/docker/#environment-variables) to learn more.

| Variable            | Description                                                                                                                                                           |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DOCKER_CERT_PATH`  | Location of your authentication keys. Used both by the `docker` CLI and the `dockerd`.                                                                                |
| `DOCKER_DRIVER`     | The storage driver to use.                                                                                                                                            |
| `DOCKER_RAMDISK`    | If set, this disables `pivot_root`.                                                                                                                                   |
| `DOCKER_TLS_VERIFY` | When set, Docker uses TLS and verifies the remote. This is used by both `docker` and `dockerd`.                                                                       |
| `DOCKER_TMPDIR`     | Location for temporary files created by the daemon.                                                                                                                   |
| `HTTP_PROXY`        | Proxy URL for HTTP requests. See the [Go specification](https://pkg.go.dev/golang.org/x/net/http/httpproxy#Config).                                                   |
| `HTTPS_PROXY`       | Proxy URL for HTTPS requests. See the [Go specification](https://pkg.go.dev/golang.org/x/net/http/httpproxy#Config).                                                  |
| `MOBY_DISABLE_PIGZ` | Disables the use of `unpigz` to decompress layers in parallel.                                                                                                        |
| `NO_PROXY`          | Comma-separated values specifying hosts that should be excluded from proxying. See the [Go specification](https://pkg.go.dev/golang.org/x/net/http/httpproxy#Config). |

---

## Proxy configuration

> **Note**  
> Refer to the [Docker Desktop manual](https://docs.docker.com/desktop/networking/#httphttps-proxy-support) 
if you are running [Docker Desktop](https://docs.docker.com/desktop/).

If you are behind an HTTP proxy server, for example in corporate settings, you may have to configure the Docker daemon to use the proxy server for operations such as pulling and pushing images. The daemon can be configured in three ways:

1. Using environment variables (`HTTP_PROXY`, `HTTPS_PROXY`, and `NO_PROXY`).
2. Using the `http-proxy`, `https-proxy`, and `no-proxy` fields in the [daemon configuration file](./configure_docker_daemon#docker-daemon-configuration-file) 
(Docker Engine version 23.0 or later).
3. Using the `--http-proxy`, `--https-proxy`, and `--no-proxy` command-line options 
(Docker Engine version 23.0 or later).

The command-line and configuration file options take precedence over environment 
variables. Refer to the [control and configure Docker with systemd](https://docs.docker.com/engine/daemon/proxy/) guide for 
more details.

---

## dockerd CLI Arguments Examples

### Usage

```bash
Usage: dockerd [OPTIONS]
```

A self-sufficient runtime for containers.

### Options


- `--add-runtime runtime`  
  Register an additional OCI-compatible runtime (default `[]`).

- `--allow-nondistributable-artifacts list`  
  Allow push of non-distributable artifacts to the registry.

- `--api-cors-header string`  
  Set CORS headers in the Engine API.

- `--authorization-plugin list`  
  Authorization plugins to load.

- `--bip string`  
  Specify the network bridge IP.

- `-b, --bridge string`  
  Attach containers to a network bridge.

- `--cdi-spec-dir list`  
  CDI specification directories to use.

- `--cgroup-parent string`  
  Set the parent cgroup for all containers.

- `--config-file string`  
  Daemon configuration file (default `/etc/docker/daemon.json`).

- `--containerd string`  
  containerd grpc address.

- `--containerd-namespace string`  
  Containerd namespace to use (default `moby`).

- `--containerd-plugins-namespace string`  
  Containerd namespace to use for plugins (default `plugins.moby`).

- `--cpu-rt-period int`  
  Limit the CPU real-time period in microseconds for the parent cgroup (not supported with cgroups v2).

- `--cpu-rt-runtime int`  
  Limit the CPU real-time runtime in microseconds for the parent cgroup (not supported with cgroups v2).

- `--cri-containerd`  
  Start containerd with cri.

- `--data-root string`  
  Root directory of persistent Docker state (default `/var/lib/docker`).

- `-D, --debug`  
  Enable debug mode.

- `--default-address-pool pool-options`  
  Default address pools for node-specific local networks.

- `--default-cgroupns-mode string`  
  Default mode for containers cgroup namespace (`host` | `private`) (default `private`).

- `--default-gateway ip`  
  Container default gateway IPv4 address.

- `--default-gateway-v6 ip`  
  Container default gateway IPv6 address.

- `--default-ipc-mode string`  
  Default mode for containers ipc (`shareable` | `private`) (default `private`).

- `--default-network-opt mapmap`  
  Default network options (default `map[]`).

- `--default-runtime string`  
  Default OCI runtime for containers (default `runc`).

- `--default-shm-size bytes`  
  Default shm size for containers (default `64MiB`).

- `--default-ulimit ulimit`  
  Default ulimits for containers (default `[]`).

- `--dns list`  
  DNS server to use.

- `--dns-opt list`  
  DNS options to use.

- `--dns-search list`  
  DNS search domains to use.

- `--exec-opt list`  
  Runtime execution options.

- `--exec-root string`  
  Root directory for execution state files (default `/var/run/docker`).

- `--experimental`  
  Enable experimental features.

- `--fixed-cidr string`  
  IPv4 subnet for fixed IPs.

- `--fixed-cidr-v6 string`  
  IPv6 subnet for fixed IPs.

- `-G, --group string`  
  Group for the Unix socket (default `docker`).

- `--help`  
  Print usage.

- `-H, --host list`  
  Daemon socket(s) to connect to.

- `--host-gateway-ip ip`  
  IP address that the special `host-gateway` string in `--add-host` resolves to (defaults to the IP address of the default bridge).

- `--http-proxy string`  
  HTTP proxy URL to use for outgoing traffic.

- `--https-proxy string`  
  HTTPS proxy URL to use for outgoing traffic.

- `--icc`  
  Enable inter-container communication (default `true`).

- `--init`  
  Run an init in the container to forward signals and reap processes.

- `--init-path string`  
  Path to the docker-init binary.

- `--insecure-registry list`  
  Enable insecure registry communication.

- `--ip ip`  
  Default IP when binding container ports (default `0.0.0.0`).

- `--ip-forward`  
  Enable `net.ipv4.ip_forward` (default `true`).

- `--ip-masq`  
  Enable IP masquerading (default `true`).

- `--ip6tables`  
  Enable addition of `ip6tables` rules (experimental).

- `--iptables`  
  Enable addition of `iptables` rules (default `true`).

- `--ipv6`  
  Enable IPv6 networking.

- `--label list`  
  Set key=value labels to the daemon.

- `--live-restore`  
  Enable live restore of Docker when containers are still running.

- `--log-driver string`  
  Default driver for container logs (default `json-file`).

- `-l, --log-level string`  
  Set the logging level (`debug` | `info` | `warn` | `error` | `fatal`) (default `info`).

- `--log-opt map`  
  Default log driver options for containers (default `map[]`).

- `--max-concurrent-downloads int`  
  Set the max concurrent downloads (default `3`).

- `--max-concurrent-uploads int`  
  Set the max concurrent uploads (default `5`).

- `--max-download-attempts int`  
  Set the max download attempts for each pull (default `5`).

- `--metrics-addr string`  
  Set default address and port to serve the metrics API on.

- `--mtu int`  
  Set the containers network MTU (default `1500`).

- `--network-control-plane-mtu int`  
  Network Control plane MTU (default `1500`).

- `--no-new-privileges`  
  Set `no-new-privileges` by default for new containers.

- `--no-proxy string`  
  Comma-separated list of hosts or IP addresses for which the proxy is skipped.

- `--node-generic-resource list`  
  Advertise user-defined resources.

- `--oom-score-adjust int`  
  Set the `oom_score_adj` for the daemon.

- `-p, --pidfile string`  
  Path to use for daemon PID file (default `/var/run/docker.pid`).

- `--raw-logs`  
  Full timestamps without ANSI coloring.

- `--registry-mirror list`  
  Preferred registry mirror.

- `--rootless`  
  Enable rootless mode; typically used with RootlessKit.

- `--seccomp-profile string`  
  Path to seccomp profile (default `"builtin"`).

- `--selinux-enabled`  
  Enable selinux support.

- `--shutdown-timeout int`  
  Set the default shutdown timeout (default `15`).

- `-s, --storage-driver string`  
  Storage driver to use.

- `--storage-opt list`  
  Storage driver options.

- `--swarm-default-advertise-addr string`  
  Set default address or interface for swarm advertised address.

- `--tls`  
  Use TLS; implied by `--tlsverify`.

- `--tlscacert string`  
  Trust certs signed only by this CA (default `~/.docker/ca.pem`).

- `--tlscert string`  
  Path to TLS certificate file (default `~/.docker/cert.pem`).

- `--tlskey string`  
  Path to TLS key file (default `~/.docker/key.pem`).

- `--tlsverify`  
  Use TLS and verify the remote.

- `--userland-proxy`  
  Use userland proxy for loopback traffic (default `true`).

- `--userland-proxy-path string`  
  Path to the userland proxy binary.

- `--userns-remap string`  
  User/Group setting for user namespaces.

- `--validate`  
  Validate daemon configuration and exit.

- `-v, --version`  
  Print version information and quit.

---

## Use Cases for `dockerd`

1. **Running the Docker Daemon with Debug Mode**
    - Use this to start the Docker daemon with detailed logging, useful for troubleshooting.
   
   ```bash
   dockerd --debug
   ```
   Alternatively, you can set the debug mode in the docker `daemon.json` configuration file:
   
   ```json
   {
     "debug": true
   }
   ```

2. **Using a Custom Configuration File**
    - You can specify a custom `daemon.json` configuration file using the `--config-file` option.
   ```bash
   dockerd --config-file /path/to/your/daemon.json
   ```

3. **Allowing Insecure Registries**
    - To push images to an insecure registry (one without a trusted TLS certificate), you can enable this by starting the daemon with the `--insecure-registry` option.
   ```bash
   dockerd --insecure-registry myregistry.local:5000
   ```

4. **Running the Docker Daemon with an Additional Runtime**
    - Register a custom runtime such as `runc` or `kata-runtime`.
   ```bash
   dockerd --add-runtime myruntime=/usr/local/bin/custom-runtime
   ```

5. **Using Experimental Features**
    - If you want to test new features, you can enable experimental features by adding the `--experimental` flag.
   ```bash
   dockerd --experimental
   ```

6. **Running Docker on a Custom Port**
    - The Docker daemon by default listens on Unix socket (`/var/run/docker.sock`), but you can configure it to listen on a custom TCP port for remote API access.
   ```bash
   dockerd -H tcp://0.0.0.0:2375
   ```

7. **Enabling IP Masquerading**
    - Docker enables IP masquerading by default, but you can disable it using the following option.
   ```bash
   dockerd --ip-masq=false
   ```

### Use Cases for Docker Socket (`/var/run/docker.sock`)

1. **Communicating with the Docker Daemon via REST API**
    - The Docker socket allows you to communicate with the Docker daemon using Docker’s REST API. You can use tools like `curl` to interact with the API through the socket.
   ```bash
   curl --unix-socket /var/run/docker.sock http://localhost/v1.41/info
   ```
   This will return information about the Docker daemon such as the number of containers, images, and system resources.

2. **Mounting the Docker Socket in Containers for Docker-in-Docker**
    - You can mount the Docker socket inside a container to allow the container to control the Docker daemon on the host. This is often used in CI/CD pipelines or to enable services like `Portainer` or `Docker Compose`.
   ```bash
   docker run -v /var/run/docker.sock:/var/run/docker.sock -it ubuntu
   ```
   This allows the container to execute Docker commands as if it were running on the host.

3. **Using Docker Compose with Docker Socket**
    - Docker Compose can manage multi-container applications. By mounting the Docker socket inside a container running Docker Compose, you can manage the entire Docker ecosystem from within a container.
   ```bash
   docker run -v /var/run/docker.sock:/var/run/docker.sock docker/compose up
   ```

4. **Integrating with Docker from a Web Application (e.g., Portainer)**
    - Tools like Portainer, a Docker management UI, rely on accessing the Docker socket to interact with the Docker daemon. Portainer can be run by mounting the Docker socket to allow the UI to manage the Docker daemon.
   ```bash
   docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer
   ```

5. **Security Implications of Docker Socket**
    - Because the Docker socket gives full control over the Docker daemon, it's important to manage it securely. One common approach is to use tools like `socat` to restrict or proxy access to the socket:
   ```bash
   socat TCP-LISTEN:2375,reuseaddr,fork UNIX-CLIENT:/var/run/docker.sock
   ```
   This will expose the Docker socket over TCP, but it should only be done in a secure environment, as it allows remote Docker API access.

### Practical Examples in CI/CD and DevOps

1. **CI/CD Pipeline with Jenkins**
    - Jenkins running in a Docker container can interact with Docker on the host by mounting the Docker socket, allowing the pipeline to build and manage Docker images and containers.
   ```bash
   docker run -v /var/run/docker.sock:/var/run/docker.sock jenkins/jenkins
   ```

2. **Automating Container Management with Cron Jobs**
    - A cron job script can interact with Docker to perform regular maintenance tasks like cleaning up unused containers and images by accessing the Docker socket.
   ```bash
   #!/bin/bash
   docker system prune -f
   ```
   Add this script to a cron job and mount the Docker socket if necessary to allow it to interact with the Docker daemon.

