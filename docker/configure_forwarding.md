# Configure Docker Network Bridge Filtering on CentOS 9

When working with Docker or other containerization tools, you may encounter 
warnings related to `bridge-nf-call` settings and `ip6tables`. These warnings 
can be resolved by configuring the network bridge filtering on your CentOS 9 system.

This `WARNING` message is usually displayed when you run the docker command `docker info`:

```bash
# docker info warning message
WARNING: bridge-nf-call-iptables is disabled
WARNING: bridge-nf-call-ip6tables is disabled
```

### Steps to Configure Network Bridge Filtering on CentOS 9

### 1. **Load the `br_netfilter` Kernel Module**
The `br_netfilter` module allows filtering on bridge interfaces, which is needed for iptables functionality with Docker and similar tools.

Run the following command to load the `br_netfilter` module:

```bash
sudo modprobe br_netfilter
```

To verify that the module was loaded, run:

```bash
lsmod | grep br_netfilter
```

If the module is listed, it has been successfully loaded.

### 2. **Make `br_netfilter` Persistent Across Reboots**

To ensure that the `br_netfilter` module is loaded automatically after each reboot, 
you need to add it to the system’s module configuration:

```bash
echo "br_netfilter" | sudo tee /etc/modules-load.d/br_netfilter.conf
```

### 3. **Enable IPv4/IPv6 Forwarding**

You should also ensure that IP forwarding is enabled for both IPv4 and IPv6, 
which is often required for Docker networking:

#### IPv4 Forwarding:
Add the following line to the `/etc/sysctl.conf` file to enable IPv4 forwarding:

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

#### IPv6 Forwarding:
To enable IPv6 forwarding, add the following:

```bash
sudo sysctl -w net.ipv6.conf.all.forwarding=1
```

Make the changes permanent by adding these lines to `/etc/sysctl.conf`:

```bash
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
```

Then, apply the changes with:

```bash
sudo sysctl -p
```

### 4. **Restart Docker**

If you're using Docker, restart the Docker service to apply the new network configurations:

```bash
sudo systemctl restart docker
docker info

```

This should resolve the warnings you are seeing related to `ip6tables`, and 
`bridge-nf-call` settings. After completing these steps, your CentOS 9 system 
should be configured to work properly with the network bridge filtering.
