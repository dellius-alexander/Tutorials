# Setting up VM Bridge Networking on Proxmox VE server with multiple IP addresses

> Note:
> 
> This guide assumes you have a Proxmox VE server installed and running. You should have 
> a basic understanding of networking concepts and the Proxmox VE environment. You should 
> also have control over setting static ip addresses on your network router while setting up 
> the bridge network to use DHCP. 
> 
> For a simple setup without VLANs or custom DNS requirements, these settings are not necessary.

The Proxmox Virtual Environment (VE) server allows you to create virtual machines (VMs) and 
containers on a single host. To enable communication between VMs, containers, and the external
network, you can configure VM bridges that connect the virtual interfaces to the physical network 
interfaces.

To configure `/etc/network/interfaces` and create four VM bridges (`vmbr0`, `vmbr1`, `vmbr2`, and `vmbr3`) 
for each physical interface (`eno1`, `eno2`, `eno3`, and `eno4`), you need to define each interface as 
part of a bridge. Below is the full configuration file:

```bash
# /etc/network/interfaces

# loopback interface
auto lo
iface lo inet loopback

# Bridge for eno1
auto vmbr0
iface vmbr0 inet dhcp
        bridge-ports eno1
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        dns-nameservers <your internal dns nameserver or external (75.75.75.75, 8.8.8.8)>
        dns-search mydomain.com

# Bridge for eno2
auto vmbr1
iface vmbr1 inet dhcp
        bridge-ports eno2
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        dns-nameserver <your internal dns nameserver or external (75.75.75.75, 8.8.8.8)>
        dns-search mydomain.com

# Bridge for eno3
auto vmbr2
iface vmbr2 inet dhcp
        bridge-ports eno3
        bridge-stp off
        bridge-fd 0 
        bridge-vlan-aware yes
        dns-nameserver <your internal dns nameserver or external (75.75.75.75, 8.8.8.8)>
        dns-search mydomain.com

# Bridge for eno4
auto vmbr3
iface vmbr3 inet dhcp
        bridge-ports eno4
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        dns-nameserver <your internal dns nameserver or external (75.75.75.75, 8.8.8.8)>
        dns-search mydomain.com
```

### Explanation:

1. **Loopback Interface (`lo`)**:
    - `auto lo`: Automatically brings up the loopback interface on boot.
    - `iface lo inet loopback`: Specifies the loopback configuration.

2. **Bridge Configuration**:
    - **General Bridge Options**:
        - `bridge-ports`: Specifies the physical interface to be bridged (e.g., `eno1` for `vmbr0`).
        - `bridge-stp off`: Disables the Spanning Tree Protocol (STP) for simplicity. If you need to avoid loops, you can set it to `on`.
        - `bridge-fd 0`: Sets the forwarding delay to zero.
        - `bridge-maxwait 0`: Sets the maximum wait time for the bridge to become active.
        - `bridge-vlan-aware yes`: Enables VLAN awareness on the bridge, allowing it to manage VLAN traffic if needed.

3. **VM Bridges (`vmbr0` to `vmbr3`)**:
    - Each bridge (`vmbr0`, `vmbr1`, `vmbr2`, and `vmbr3`) is associated with a different physical interface (`eno1`, `eno2`, `eno3`, and `eno4` respectively).
    - **DHCP Configuration**:
        - `iface vmbrX inet dhcp`: Configures each bridge interface to obtain an IP address via DHCP.

4. **Configure VLANs (`bridge-vids`)**:
   - **Purpose**: This setting is used to define VLAN IDs that the bridge can handle. It makes the bridge VLAN-aware, allowing it to pass traffic for specific VLANs only.
   - **Use Case**:
       - If you have VLANs configured on your network and want the bridge to manage multiple VLANs (e.g., VLAN 10, 20, 30), you should set this.
       - This is useful when your Proxmox setup needs to communicate with different VLANs across different VMs.
   - **Example**:
     ```bash
     bridge-vids 2-4094
     ```
       - This example sets the bridge to handle all VLANs from 2 to 4094.

   - **When Not Needed**: If you are not using VLANs in your network, you can omit this setting.

5. dns-search`
   - **Purpose**: Specifies the domain to be appended during DNS lookups. It helps resolve hostnames that do not have a fully qualified domain name (FQDN) by appending the specified domain automatically.
   - **Use Case**:
       - If you have a specific search domain (e.g., `mydomain.com`) that is frequently used, you should set this to streamline hostname resolution.

   - **Example**:
     ```bash
     dns-search mydomain.com
     ```
       - This will allow the system to append `mydomain.com` to a hostname if no domain is specified.

   - **When Not Needed**: If you prefer to use FQDNs directly or if DNS search is not necessary for your network configuration, you can omit this setting.

6. **DNS Nameserver setup (`dns-nameservers`)**:
   - **Purpose**: Specifies the DNS servers that the bridge interface should use for DNS resolution.
   - **Use Case**:
       - If you have specific DNS servers that the interface should use (e.g., internal DNS servers or specific external ones like Google's `8.8.8.8`), you should set this.

   - **Example**:
     ```bash
     dns-nameservers 8.8.8.8 8.8.4.4
     ```
       - This sets the DNS servers for the bridge interface.

   - **When Not Needed**: If you are using DHCP for the bridge, and it provides DNS settings automatically, you can omit this.

7. **Restart Networking Service**:
   - After saving the changes to `/etc/network/interfaces`, you can restart the networking service to apply
   the new configurations:

    ```bash
    sudo systemctl restart networking
    ```

8. **Additional Notes**:
   - **Static IP Configuration**: If you need to assign static IP addresses to the bridge interfaces, you can replace `inet dhcp` with `inet static` and add the necessary IP, netmask, gateway, and DNS server configurations.
   - **Multiple IP Addresses**: If you need to assign multiple IP addresses to a single bridge interface, you can use the `post-up` directive to add additional IP addresses after the interface is up. For example:
     ```bash
     post-up ip addr add <ip_address>/<subnet_mask> dev <interface>
     ```
   - Replace `<ip_address>` and `<subnet_mask>` with the desired IP address and subnet mask, and `<interface>` with the bridge interface name.
   
### Conclusion:

This configuration ensures that each physical interface is part of its own bridge, which can be used 
for different VMs or network segments. The bridges are set to obtain IP addresses via DHCP, but you can 
also configure static IP addresses if needed. The `bridge-vlan-aware` option is enabled to allow the 
bridges to handle VLAN traffic if required. The `dns-nameservers` and `dns-search` settings are optional 
and depend on your specific network setup and requirements, such as custom DNS servers or search domains. 

