# Synology Domain/LDAP Client Setup Guide for DS1618+ on DSM 7.2

This guide provides step-by-step instructions to configure the "Domain/LDAP" client in the Synology NAS Control Panel to connect to an LDAP server (configured on the same or another Synology NAS) for user authentication and permission management. It includes DNS implementation for DDNS addresses (`domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com`), SSL configuration, and best practices.

## Prerequisites

- **Synology DS1618+** running **DSM 7.2** or later.
- Administrative access to DSM.
- LDAP server already configured (e.g., as per the previous guide) with:
    - Base DN: `dc=domain_name_1,dc=com`.
    - Root DN: `cn=admin,dc=domain_name_1,dc=com`.
    - Hostname: `ldap.domain_name_1.com`.
    - LDAPS enabled on port 636.
- Domain names: `domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com`.
- DNS server configured on the NAS (as per the previous guide) or an external DNS server.
- Valid SSL certificate for `ldap.domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com` (e.g., Let’s Encrypt).
- Router with port forwarding for LDAPS (port 636) and DNS (port 53, if using NAS DNS server).
- Access to your domain registrar’s DNS settings for `domain_name_1.com`.

## Step 1: Verify LDAP Server Connectivity

1. **Test LDAP Server**:
    - From a client on the same network, verify LDAPS connectivity using `ldapsearch`:

      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "cn=admin,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```
    - Enter the Root DN password (`<YourStrongPassword123!>`).
    - Ensure no SSL errors and the command returns LDAP entries.
2. **Check DNS Resolution**:
    - Verify that `ldap.domain_name_1.com` resolves to the LDAP server’s IP:

      ```bash
      nslookup ldap.domain_name_1.com
      ```
    - If using the NAS’s DNS server (e.g., `192.168.1.100`), specify it:

      ```bash
      nslookup ldap.domain_name_1.com 192.168.1.100
      ```

## Step 2: Configure Domain/LDAP Client in Control Panel

1. **Log in to DSM**:
    - Open a web browser and navigate to `https://<NAS_IP>:5001` or `http://<NAS_IP>:5000`.
    - Log in with an administrator account.
2. **Open Control Panel**:
    - From the DSM desktop, click **Control Panel**.
3. **Navigate to Domain/LDAP**:
    - Go to **Domain/LDAP &gt; Domain/LDAP**.
4. **Join LDAP Server**:
    - Select **LDAP** (not Domain, which is for Active Directory).
    - Fill in the following fields:
        - **Server address**: `ldap.domain_name_1.com`.
        - **Encryption**: Select **LDAPS**.
        - **Port**: `636` (default for LDAPS).
        - **Base DN**: `dc=domain_name_1,dc=com`.
        - **Bind DN**: `cn=admin,dc=domain_name_1,dc=com`.
        - **Password**: `<YourStrongPassword123!>` (Root DN password).
        - **Profile**: Select **Custom** to manually configure attributes (or use a preset like `OpenLDAP` if compatible).
    - **Advanced Settings**:
        - **User base DN**: `ou=users,dc=domain_name_1,dc=com` (where LDAP users are stored).
        - **Group base DN**: `ou=groups,dc=domain_name_1,dc=com` (where LDAP groups are stored).
        - **Username attribute**: `uid` (common for OpenLDAP).
        - **Group name attribute**: `cn`.
        - **Home directory attribute**: `homeDirectory` (e.g., `/home/%uid%` for user home folders).
        - **Shell attribute**: `loginShell` (e.g., `/bin/bash` for Linux clients).
    - Check **Enable LDAP cache** to improve performance (recommended for large user bases).
    - Check **Enable domain users to log in to DSM** to allow LDAP users to access DSM.
5. **Apply Settings**:
    - Click **Apply**.
    - DSM will attempt to connect to the LDAP server and retrieve user/group information.
    - If successful, you’ll see a confirmation message. If it fails, check the server address, port, Bind DN, password, and firewall settings.

## Step 3: Verify LDAP User and Group Integration

1. **Check User List**:
    - Go to **Control Panel &gt; User & Group &gt; User**.
    - Switch to the **Domain Users** tab.
    - Verify that LDAP users (e.g., `jdoe`) appear.
2. **Check Group List**:
    - Go to **Control Panel &gt; User & Group &gt; Group**.
    - Switch to the **Domain Groups** tab.
    - Verify that LDAP groups (e.g., `employees`) appear.
3. **Test DSM Login**:
    - Log out of DSM.
    - Log in using an LDAP user account (e.g., `jdoe` with their LDAP password).
    - Ensure access is granted based on assigned permissions.
4. **Test File Share Access**:
    - Create a shared folder (e.g., `SharedFolder`) in **Control Panel &gt; Shared Folder**.
    - Assign permissions to an LDAP group (e.g., `employees`) with read/write access.
    - From a client, mount the share via SMB or NFS and log in as an LDAP user (e.g., `jdoe`).
    - Verify access to the shared folder.

## Step 4: Enhance DNS Implementation

The DNS server should already be configured as per the previous guide. Below are steps to ensure it supports the LDAP client robustly and handles both DDNS addresses.

1. **Verify DNS Server Package**:
    - In **Package Center**, ensure the **DNS Server** package is installed and running.
2. **Check Existing Zones**:
    - Open **DNS Server** from the DSM desktop.
    - Verify zones for `domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com` exist:
        - **domain_name_1.com**:
            - A record: `ldap` → `<LDAP_SERVER_IP>` (e.g., `192.168.1.100`).
            - SRV record: `_ldap._tcp` → `ldap.domain_name_1.com`, port `636`.
        - **domain_name_2_prefix.domain_name_2.com**:
            - A record: `@` → `<LDAP_SERVER_IP>` (e.g., `192.168.1.100`).
            - SRV record: `_ldap._tcp` → `ldap.domain_name_1.com`, port `636`.
3. **Add Redundant Records**:
    - For `domain_name_1.com`, add a CNAME record:
        - **Name**: `ldap-alias`.
        - **Canonical Name**: `ldap.domain_name_1.com`.
        - This provides flexibility for future server migrations.
    - For `domain_name_2_prefix.domain_name_2.com`, add a CNAME record:
        - **Name**: `ldap`.
        - **Canonical Name**: `ldap.domain_name_1.com`.
        - This ensures consistency across DDNS addresses.
4. **Configure Reverse DNS (PTR)**:
    - Create a reverse zone for your local subnet (e.g., `1.168.192.in-addr.arpa` for `192.168.1.0/24`).
        - Click **Create &gt; Reverse Zone**.
        - **Network**: `192.168.1.0/24`.
        - **Master DNS Server**: `<NAS_IP>` (e.g., `192.168.1.100`).
        - Click **OK**.
    - Add a PTR record:
        - **IP**: `192.168.1.100`.
        - **Hostname**: `ldap.domain_name_1.com`.
        - This aids in troubleshooting and logging.
5. **Enable DNSSEC (Optional)**:
    - In **DNS Server &gt; Settings**, enable **DNSSEC** for `domain_name_1.com` if your clients support it.
    - Generate and publish DNSSEC keys:
        - Go to **DNS Server &gt; Zones &gt; domain_name_1.com &gt; DNSSEC**.
        - Click **Sign Zone** and follow the prompts.
        - Update your domain registrar with the DS record provided.
    - Note: DNSSEC is complex and may not be necessary for internal networks.
6. **Test DNS Resolution**:
    - From a client, verify forward and reverse lookups:

      ```bash
      nslookup ldap.domain_name_1.com 192.168.1.100
      nslookup 192.168.1.100 192.168.1.100
      ```
    - Verify SRV records:

      ```bash
      dig @192.168.1.100 -t SRV _ldap._tcp.domain_name_1.com
      ```

## Step 5: Configure DDNS for External Access

1. **Verify DDNS for** `domain_name_2_prefix.domain_name_2.com`:
    - Go to **Control Panel &gt; External Access &gt; DDNS**.
    - Ensure the entry for `domain_name_2_prefix.domain_name_2.com` is active and shows **Normal**.
    - Verify the external IP matches your router’s WAN IP.
2. **Verify DDNS for** `domain_name_1.com`:
    - If using a third-party DDNS provider (e.g., Cloudflare), check the A record for `ldap.domain_name_1.com` points to your external IP.
    - If using DSM’s DDNS, ensure the custom provider is configured:
        - **Hostname**: `ldap.domain_name_1.com`.
        - **Service Provider**: Your registrar’s DDNS service.
        - **API Key/URL**: As provided by your registrar.
3. **Port Forwarding**:
    - In your router, ensure the following ports are forwarded to `<NAS_IP>` (e.g., `192.168.1.100`):
        - **636 (LDAPS)**: For secure LDAP client connections.
        - **53 (DNS)**: If using the NAS as an external DNS server (optional, typically internal only).
        - **443 (HTTPS)**: For DSM access and certificate renewal.
    - Test external LDAPS connectivity:

      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "cn=admin,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```

## Step 6: Best Practices

1. **Use LDAPS Exclusively**:
    - Always use LDAPS (port 636) instead of LDAP (port 389) to encrypt credentials and data.
    - In **Control Panel &gt; Security &gt; Firewall**, block port 389:
        - Create a rule: Source `All`, Destination `<NAS_IP>`, Port `389`, Action `Deny`.
2. **Restrict Bind DN Access**:
    - Use a dedicated Bind DN (e.g., `cn=ldapclient,dc=domain_name_1,dc=com`) with read-only permissions instead of the Root DN.
    - Create this account in the LDAP server:
        - In **LDAP Server &gt; LDAP Users**, create `cn=ldapclient,ou=users,dc=domain_name_1,dc=com`.
        - Assign minimal permissions (e.g., read access to `ou=users` and `ou=groups`).
    - Update the Bind DN in **Control Panel &gt; Domain/LDAP** to use this account.
3. **Firewall Configuration**:
    - In **Control Panel &gt; Security &gt; Firewall**, create rules:
        - **Allow**: Source `Local Network` (e.g., `192.168.1.0/24`), Destination `<NAS_IP>`, Ports `53, 636`, Protocol `TCP`.
        - **Allow**: Source `Trusted IPs` (e.g., VPN or specific external IPs), Destination `<NAS_IP>`, Port `636`, Protocol `TCP`.
        - **Deny**: Source `All`, Destination `All` (place at the end).
    - Enable the firewall if not already active.
4. **Monitor Logs**:
    - In **Control Panel &gt; Log Center**, enable logging for **Domain/LDAP**.
    - Set up email notifications:
        - Go to **Control Panel &gt; Notification &gt; Email**.
        - Configure an SMTP server (e.g., Gmail Gmail with app-specific password.
        - Enable notifications for **Domain/LDAP Events** and **System Errors**.
5. **Backup LDAP Client Settings**:
    - Export the Domain/LDAP configuration:
        - In **Control Panel &gt; Domain/LDAP**, click **Export Configuration**.
        - Save the file to a secure location (e.g., `volume1/backup/ldap-client`).
    - Schedule regular exports using a script via **Task Scheduler**:

      ```bash
      synoscgi --export-ldap-config /volume1/backup/ldap-client/ldap-config-$(date +%F).json
      ```
6. **Enable Two-Factor Authentication (2FA)**:
    - In **Control Panel &gt; User & Group &gt; Advanced**, enable **2FA** for all DSM admin accounts.
    - Use an authenticator app (e.g., Google Authenticator).
7. **Regularly Update DSM**:
    - In **Control Panel &gt; Update & Restore**, enable automatic updates for DSM and packages.
    - Check for updates monthly to ensure security patches are applied.
8. **Limit LDAP User Permissions**:
    - In **Control Panel &gt; User & Group**, assign minimal permissions to LDAP users and groups for DSM and shared folders.
    - Example: Grant `employees` group read-only access to non-sensitive shares.
9. **Use VPN for External Access**:
    - Instead of exposing port 636 externally, set up a VPN (e.g., OpenVPN via Synology’s VPN Server package).
    - Configure clients to connect via VPN, then access `ldap.domain_name_1.com:636` internally.
    - This reduces the attack surface.

## Step 7: Test the Setup

1. **Internal Testing**:
    - Log in to DSM as an LDAP user (e.g., `jdoe`).
    - Access a shared folder via SMB/NFS as an LDAP user.
    - Verify group-based permissions (e.g., `employees` group access).
2. **External Testing (via VPN)**:
    - Connect to the NAS via VPN.
    - Test LDAPS connectivity:

      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "uid=jdoe,ou=users,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```
    - Access DSM or shares as an LDAP user.
3. **Application Integration**:
    - Configure an application (e.g., Synology Drive, File Station) to use LDAP authentication.
    - Example for Synology Drive:
        - In **Synology Drive Admin Console**, enable **LDAP authentication**.
        - Set server to `ldap.domain_name_1.com:636`, Base DN to `dc=domain_name_1,dc=com`, and Bind DN to `cn=ldapclient,dc=domain_name_1,dc=com`.
        - Test login with an LDAP user.
4. **DNS Testing**:
    - Verify resolution of `ldap.domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com`:

      ```bash
      dig @192.168.1.100 ldap.domain_name_1.com
      dig @192.168.1.100 domain_name_2_prefix.domain_name_2.com
      ```

## Troubleshooting

- **LDAP Connection Fails**:
    - Verify the server address, port, and Bind DN/password in **Control Panel &gt; Domain/LDAP**.
    - Check SSL certificate validity in **Control Panel &gt; Security &gt; Certificate**.
    - Ensure port 636 is open (`telnet ldap.domain_name_1.com 636`).
- **Users/Groups Not Appearing**:
    - Confirm the User/Group base DNs are correct.
    - Check the username/group name attributes match the LDAP server’s schema.
    - Refresh the user/group list in **Control Panel &gt; User & Group**.
- **DNS Issues**:
    - Verify DNS server zones and records in **DNS Server**.
    - Ensure the client’s DNS server is set to `<NAS_IP>` (e.g., `192.168.1.100`).
    - Check for conflicts with external DNS servers.
- **Permission Errors**:
    - Verify LDAP group memberships in **Control Panel &gt; User & Group**.
    - Check shared folder permissions in **Control Panel &gt; Shared Folder**.
- **Logs**:
    - Review **Control Panel &gt; Log Center** for Domain/LDAP and DNS errors.
    - Search for specific user or connection issues.

## References

- Synology Knowledge Center: [Join a Domain or LDAP](https://kb.synology.com/en-us/DSM/help/DSM/AdminCenter/system_domain)
- Synology Knowledge Center: [DNS Server](https://kb.synology.com/en-us/DSM/help/DNSServer/dnsserver)
- Synology Knowledge Center: [Security](https://kb.synology.com/en-us/DSM/help/DSM/AdminCenter/system_security)
- Marius Hosting: Synology [DSM 7 LDAP Integration](https://mariushosting.com/synology-how-to-configure-ldap-on-dsm-7/)
- OpenLDAP Documentation: [Client Configuration](https://www.openldap.org/doc/admin24/clients.html)
- Synology Release Notes for NAS Series Running DSM 7.2: [DSM 7.2](https://www.synology.com/en-us/releaseNote/DS1618+)
