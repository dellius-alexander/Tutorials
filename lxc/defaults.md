# Default LXC configuration file (`/etc/lxc/default.conf`)

These explanations include the purpose, command syntax, and 
what each setting achieves on a low level.

### 1. **Hostname Configuration**

**Setting**: `lxc.uts.name`

- **Example**:
  ```bash
  lxc.uts.name = mycontainer
  ```
- **Explanation**:
    - The `lxc.uts.name` setting specifies the hostname for containers.
    - **UTS** (UNIX Time-Sharing) namespace isolates system identifiers like hostname and domain name.
    - When you set `lxc.uts.name`, it assigns a hostname to the container upon creation. This name is what the container will use when identifying itself on the network and internally.
    - On a low level, it changes the `hostname` system call result inside the container.
    - This hostname is not exposed to the outside world by default unless you configure network settings that allow hostname propagation.

### 2. **Environment Variables**

**Setting**: `lxc.environment`

- **Example**:
  ```bash
  lxc.environment = PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  lxc.environment = LANG=en_US.UTF-8
  ```
- **Explanation**:
    - `lxc.environment` allows you to set environment variables that will be available inside the container when it starts.
    - The environment variables work similarly to those set in `/etc/environment` on a regular Linux system. They define the environment settings for processes within the container, such as paths for binaries (`PATH`) and locale settings (`LANG`).
    - On a low level, LXC injects these environment variables when launching processes in the container. It modifies the environment block of the processes spawned, ensuring consistency and compatibility of the container environment with applications running inside.

### 3. **Root Filesystem Path**

**Setting**: `lxc.rootfs.path`

- **Example**:
  ```bash
  lxc.rootfs.path = dir:/var/lib/lxc/mycontainer/rootfs
  ```
- **Explanation**:
    - `lxc.rootfs.path` specifies the path to the root filesystem for the container. This is where all the files and directories for the container’s OS are located.
    - The format `dir:/path/to/rootfs` means that the container’s root filesystem is stored as a directory on the host. You can also use other formats like `btrfs`, `zfs`, or `lvm` to indicate different storage backends.
    - On a low level, LXC mounts this directory as the `/` (root) directory when the container starts. It sets up an isolated filesystem namespace for the container, making sure it has its own independent file structure.

### 4. **Network Configuration**

**Setting**: `lxc.net.0.*`

- **Examples**:
  ```bash
  lxc.net.0.type = veth
  lxc.net.0.link = lxcbr0
  lxc.net.0.flags = up
  lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
  ```
- **Explanation**:
    - `lxc.net.0.*` configures the networking for the container. `net.0` represents the first network interface.
        - `lxc.net.0.type = veth`: This sets the network type to a virtual Ethernet device (`veth`), which creates a pair of interfaces, one inside the container and one on the host.
        - `lxc.net.0.link = lxcbr0`: This connects the container’s `veth` interface to the bridge `lxcbr0`, which typically connects the container to the host network and allows it to communicate with other containers and the host.
        - `lxc.net.0.flags = up`: This brings up the network interface when the container starts.
        - `lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx`: This sets the MAC address of the container’s network interface to ensure it is unique on the network.
    - On a low level, these settings instruct LXC to create and configure the network namespace for the container, isolate the network interface, and set up virtual networking to enable communication between containers and the host.

### 5. **Memory and CPU Limits**

**Settings**:
- Memory Limit: `lxc.cgroup.memory.limit_in_bytes`
- CPU Limit: `lxc.cgroup.cpuset.cpus`

- **Examples**:
  ```bash
  lxc.cgroup.memory.limit_in_bytes = 512M
  lxc.cgroup.cpuset.cpus = 0,1
  ```
- **Explanation**:
    - `lxc.cgroup.memory.limit_in_bytes` limits the amount of memory the container can use. In this example, it restricts the container to use only 512MB of RAM. It utilizes Linux cgroups (control groups) to enforce these limits at the kernel level.
    - `lxc.cgroup.cpuset.cpus` restricts the container to use only the specified CPU cores (in this case, CPU cores `0` and `1`). This isolates CPU usage, allowing finer control over resource allocation.
    - On a low level, LXC configures the cgroup controller for the container, which the kernel then enforces. It ensures that resource usage for the container stays within the defined limits, preventing it from using more than the allocated CPU or memory resources.

### 6. **Mount Points**

**Setting**: `lxc.mount.entry`

- **Example**:
  ```bash
  lxc.mount.entry = /data/mounted-directory data none bind,create=dir
  ```
- **Explanation**:
    - This setting allows you to mount a directory from the host system (`/data/mounted-directory`) inside the container at the specified path (`data` in this case). The `bind` option means it’s a bind mount, which maps an existing directory on the host to the container.
    - `create=dir` ensures that if the mount point (`/data`) does not exist in the container, it will be created as a directory.
    - On a low level, LXC uses the `mount` system call to bind-mount directories from the host into the container’s filesystem namespace. This provides shared access to host resources without duplicating data.

### 7. **CPU Priority**

**Setting**: `lxc.cgroup.cpu.shares`

- **Example**:
  ```bash
  lxc.cgroup.cpu.shares = 1024
  ```
- **Explanation**:
    - `lxc.cgroup.cpu.shares` assigns a relative weight for CPU time allocation to the container. The default value is `1024`, and setting this value higher or lower changes the container's CPU priority relative to others.
    - For example, if you have two containers with values `1024` and `512`, the first container will get double the CPU time compared to the second.
    - On a low level, this interacts with the Linux cgroup CPU controller, modifying the scheduling priority and ensuring that the container’s processes get a proportionate share of the CPU cycles based on its assigned weight.

### 8. **Console Configuration**

**Setting**: `lxc.tty.max`

- **Example**:
  ```bash
  lxc.tty.max = 4
  ```
- **Explanation**:
    - `lxc.tty.max` specifies the number of pseudo-terminals (TTYs) available in the container. By default, this value is `4`, providing up to four TTY sessions.
    - On a low level, it sets up `/dev/tty` devices in the container’s `/dev` directory, allowing processes within the container to access terminal sessions. This is particularly useful for logging in directly or debugging via terminal access.

### 9. **Capabilities Management**

**Setting**: `lxc.cap.drop`

- **Example**:
  ```bash
  lxc.cap.drop = sys_admin
  ```
- **Explanation**:
    - `lxc.cap.drop` removes specific capabilities from the container’s capability set, limiting what it can do even if a process gains root access inside the container. `sys_admin` is one of the most powerful capabilities, and dropping it restricts actions like mounting filesystems or changing system time.
    - On a low level, it uses the Linux capabilities system to strip unnecessary or dangerous privileges from processes, improving container security and isolation.

### Conclusion

By configuring these options in the default LXC configuration file (`/etc/lxc/default.conf`), you set up standardized behavior for containers, ensuring security, consistency, and efficient resource use. These settings operate at a low level by leveraging Linux namespaces, cgroups, and capabilities to isolate containers and control their access to the host system and hardware.
