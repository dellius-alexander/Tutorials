# Containerd Configuration for Kubernetes with Kubeadm

To use `containerd` as the container runtime for Kubernetes with `kubeadm`, you 
need to configure the `/etc/containerd/config.toml` file properly. The configuration 
file must enable the Container Runtime Interface (CRI) plugin, adjust the `cgroup` 
settings, and ensure that containerd communicates over the correct socket for Kubernetes.

#### Containerd Configuration File: `/etc/containerd/config.toml`

```toml
version = 2

# Enable the CRI plugin which is essential for Kubernetes to interact with containerd.
# By default, it is enabled, but if it is disabled, you must explicitly enable it.
disabled_plugins = []  # Ensure CRI plugin is enabled by having an empty array.

# Root directory where containerd stores its data, including images, containers, and other runtime state.
root = "/var/lib/containerd"

# State directory where containerd keeps runtime state information such as sockets and lock files.
state = "/run/containerd"

# The subreaper option is enabled to reparent orphaned processes started by containers.
subreaper = true

# The OOM score for containerd processes. Kubernetes recommends setting it to a low value 
# (such as 0) to prevent containerd from being killed before containers.
oom_score = 0

[grpc]
  # The address for the containerd gRPC server, which Kubernetes uses to communicate with containerd.
  # This should be set to a Unix socket for local communication.
  address = "/run/containerd/containerd.sock"

  # User and group IDs for the socket, generally set to root (0) for proper access control.
  uid = 0
  gid = 0

[debug]
  # Debugging address for containerd. This socket can be used for debugging containerd if needed.
  # Not generally required for normal Kubernetes operations but can be used for troubleshooting.
  address = "/run/containerd/debug.sock"
  
  # Debug level settings. Setting this to "info" provides general information. For debugging,
  # you can set it to "debug".
  level = "info"

[plugins]
  # Configure the CRI plugin for Kubernetes
  [plugins."io.containerd.grpc.v1.cri"]
    # Set the sandbox image used for pods in Kubernetes. This should be a pause container image
    # compatible with your cluster’s architecture (e.g., amd64, arm64).
    sandbox_image = "registry.k8s.io/pause:3.9"

    # Use the systemd cgroup driver, which is recommended for Kubernetes to ensure consistency
    # with the kubelet. This setting helps Kubernetes better manage and isolate resources.
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
        SystemdCgroup = true

    # Adjust image pull settings.
    [plugins."io.containerd.grpc.v1.cri".registry]
      # Configures insecure registries if needed (useful in dev environments, not recommended for production).
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]

    # Additional settings for runtime configuration (optional and configurable based on requirements).
    [plugins."io.containerd.grpc.v1.cri".containerd]
      snapshotter = "overlayfs"  # Snapshotter type used by containerd. Overlayfs is the default and most common.

      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        runtime_type = "io.containerd.runc.v2"  # Specifies the runtime used for Kubernetes pods.
        runtime_engine = ""
        runtime_root = ""

      [plugins."io.containerd.grpc.v1.cri".cni]
        # Directory where CNI configuration files are stored. Kubernetes uses CNI plugins for networking.
        bin_dir = "/opt/cni/bin"
        conf_dir = "/etc/cni/net.d"
        max_conf_num = 1  # Number of CNI configurations to use; 1 is typical for a single network setup.

[metrics]
  # Metrics address is configured to expose metrics for monitoring containerd health and performance.
  # This is optional and mainly used for integration with monitoring systems like Prometheus.
  address = "127.0.0.1:1338"
  grpc_histogram = false  # Set to true if you want detailed gRPC latency metrics (may impact performance).
```

### Detailed Explanations

1. **General Settings**:
    - `version = 2`: Specifies the configuration version. `v2` is the latest version of the containerd config format.
    - `root`: Defines where containerd stores its runtime state data (e.g., containers, images).
    - `state`: The directory where containerd keeps runtime state files, sockets, and lock files.
    - `subreaper` and `oom_score`: These settings ensure containerd runs optimally and isn’t killed under memory pressure.

2. **GRPC Settings**:
    - The gRPC server address (`address = "/run/containerd/containerd.sock"`) is the Unix socket Kubernetes uses to communicate with containerd.
    - `uid` and `gid` are set to `0` (root) for proper access permissions.

3. **Debug Settings**:
    - Provides an address for a debug socket (`/run/containerd/debug.sock`).
    - `level` is set to `"info"`, but it can be set to `"debug"` for more detailed logs during troubleshooting.

4. **CRI Plugin**:
    - **Sandbox Image**: `sandbox_image = "registry.k8s.io/pause:3.9"` is the image used for Kubernetes pod sandboxes.
    - **Systemd Cgroup**: Set to `true` (`SystemdCgroup = true`) for consistency with kubelet, which also uses systemd by default.
    - **Registry Settings**: Mirrors are configured to point to Docker Hub (`docker.io`). You can add other mirrors if needed.

5. **Runtime and Snapshotter Configuration**:
    - Uses `overlayfs` as the snapshotter, which is common and efficient for most Linux systems.
    - Specifies `runc` as the runtime (`io.containerd.runc.v2`), the default and recommended OCI runtime for Kubernetes.

6. **CNI Configuration**:
    - Defines CNI binary and configuration directories (`/opt/cni/bin` and `/etc/cni/net.d`), which are where Kubernetes and Calico (or other CNI plugins) place their configuration files.

7. **Metrics**:
    - Configures a local metrics endpoint (`127.0.0.1:1338`) for monitoring containerd performance, useful for integrating with systems like Prometheus.

This configuration ensures that `containerd` is properly set up as the runtime for Kubernetes with `kubeadm`, enabling Kubernetes to use `containerd` efficiently while maintaining compatibility with CNI plugins and systemd.
