# Synology LDAP Server Setup Guide for DS1618+ on DSM 7.2

This guide provides step-by-step instructions to install and configure a robust LDAP server on a Synology DS1618+ running DSM 7.2, including DNS server setup for DDNS addresses (`domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com`), SSL configuration, and best practices.

## Prerequisites
- **Synology DS1618+** running **DSM 7.2** or later.
- Administrative access to DSM.
- Domain names: `domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com`.
- Access to your domain registrar’s DNS settings for `domain_name_1.com`.
- Static or dynamic external IP address from your ISP.
- Router with port forwarding capabilities.
- Basic understanding of LDAP, DNS, and SSL concepts.

## Step 1: Install LDAP Server Package
1. **Log in to DSM**:
    - Open a web browser and navigate to `https://<NAS_IP>:5001` or `http://<NAS_IP>:5000`.
    - Log in with an administrator account.
2. **Open Package Center**:
    - From the DSM desktop, click **Package Center**.
3. **Search for LDAP Server**:
    - In the search bar, type `LDAP Server`.
    - Locate the **LDAP Server** package (not Synology Directory Server, which is for Active Directory).
4. **Install LDAP Server**:
    - Click **Install** and wait for the installation to complete.
    - Verify the package is running by checking **Package Center > Installed**.

## Step 2: Configure LDAP Server
1. **Open LDAP Server**:
    - From the DSM desktop, click **LDAP Server** to launch the application.
2. **Set Up LDAP Server**:
    - **Enable LDAP Server**:
        - Check **Enable LDAP Server**.
    - **Base DN**:
        - Set the Base DN, e.g., `dc=domain_name_1,dc=com`.
        - Example: If your domain is `domain_name_1.com`, use `dc=domain_name_1,dc=com`.
        - For `domain_name_2_prefix.domain_name_2.com`, you could use `dc=domain_name_2_prefix,dc=domain_name_2,dc=com`, but it’s recommended to use the primary domain (`domain_name_1.com`) for consistency.
    - **Root DN**:
        - Set the Root DN, e.g., `cn=admin,dc=domain_name_1,dc=com`.
        - This is the administrator account for LDAP.
    - **Password**:
        - Enter a strong password for the Root DN (minimum 8 characters, including uppercase, lowercase, numbers, and special characters).
        - Example: `<YourStrongPassword123!>`
    - **Hostname**:
        - Set the hostname to your primary DDNS, e.g., `ldap.domain_name_1.com`.
        - This will be used for LDAP client connections.
    - **Enable LDAPS (LDAP over SSL)**:
        - Check **Enable LDAPS** to secure connections.
        - Default LDAPS port is 636; ensure this port is not blocked by your firewall.
3. **Apply Settings**:
    - Click **Apply** to save and start the LDAP server.
    - The server will restart to apply the configuration.

## Step 3: Configure SSL for LDAP Server
1. **Obtain a Let’s Encrypt Certificate**:
    - Go to **Control Panel > Security > Certificate**.
    - Click **Add > Add a new certificate > Get a certificate from Let’s Encrypt**.
    - **Domain Name**:
        - Enter `ldap.domain_name_1.com` and `domain_name_2_prefix.domain_name_2.com` as subject alternative names (SANs).
        - If you want a wildcard certificate for `*.domain_name_1.com`, ensure your DNS provider supports Let’s Encrypt DNS challenges (see Step 4).
    - **Email**:
        - Enter your email address, e.g., `<admin@domain_name_1.com>`.
    - Check **Set as default certificate**.
    - Click **OK** and wait for the certificate to be issued.
    - Note: Ports 80 and 443 must be temporarily open for HTTP-01 validation unless using DNS-01 validation.
2. **Assign Certificate to LDAP Server**:
    - In **Control Panel > Security > Certificate**, select the new certificate.
    - Click **Configure**.
    - Assign the certificate to **LDAP Server** and **WebDAV** (if used).
    - Click **OK**.
3. **Verify LDAPS**:
    - Test LDAPS connectivity using an LDAP client (e.g., `ldapsearch` on Linux):
      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "cn=admin,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```
    - Enter the Root DN password when prompted.
    - Ensure no SSL errors occur.

## Step 4: Set Up DNS Server for DDNS
1. **Install DNS Server Package**:
    - In **Package Center**, search for `DNS Server`.
    - Install the **DNS Server** package.
    - Verify it’s running in **Package Center > Installed**.
2. **Configure DNS Server**:
    - Open **DNS Server** from the DSM desktop.
    - **Create a Master Zone**:
        - Click **Create > Master Zone**.
        - **Domain Name**: `domain_name_1.com`.
        - **Master DNS Server**: Set to your NAS’s internal IP, e.g., `192.168.1.100`.
        - Leave other settings as default.
        - Click **OK**.
    - **Add Records for LDAP**:
        - In the zone for `domain_name_1.com`, click **Create > A Record**.
            - **Name**: `ldap`.
            - **IP Address**: Your NAS’s internal IP, e.g., `192.168.1.100`.
        - Create an SRV record for LDAP:
            - Click **Create > SRV Record**.
            - **Service**: `_ldap`.
            - **Protocol**: `_tcp`.
            - **Port**: `389` (or `636` for LDAPS).
            - **Target**: `ldap.domain_name_1.com`.
            - **Priority**: `0`.
            - **Weight**: `100`.
        - Click **OK**.
    - **Create a Master Zone for Synology DDNS**:
        - Repeat the process for `domain_name_2_prefix.domain_name_2.com`.
        - Add an A record:
            - **Name**: `@` (root of the domain).
            - **IP Address**: Your NAS’s internal IP, e.g., `192.168.1.100`.
        - Add an SRV record for LDAP as above.
3. **Configure DNS Forwarding**:
    - In **DNS Server**, go to **Settings > Resolution**.
    - Add public DNS servers for external resolution:
        - Primary: `8.8.8.8` (Google DNS).
        - Secondary: `1.1.1.1` (Cloudflare DNS).
    - Click **OK**.
4. **Update Router DNS**:
    - In your router’s DHCP settings, set the primary DNS server to your NAS’s IP (e.g., `192.168.1.100`).
    - This ensures local clients resolve `ldap.domain_name_1.com` to the NAS.

## Step 5: Configure DDNS
1. **Set Up DDNS for `domain_name_2_prefix.domain_name_2.com`**:
    - Go to **Control Panel > External Access > DDNS**.
    - Click **Add**.
    - **Service Provider**: Select `domain_name_2`.
    - **Hostname**: `domain_name_2_prefix.domain_name_2.com`.
    - **Email**: Your Synology account email, e.g., `<admin@domain_name_1.com>`.
    - **External Address (IPv4)**: Your current external IP (auto-detected or manually entered).
    - Check **Get a certificate from Let’s Encrypt** (already done in Step 3).
    - Check **Enable Heartbeat** for notifications.
    - Click **OK**.
    - Wait for the status to show **Normal**.
2. **Set Up DDNS for `domain_name_1.com`**:
    - If your external IP is dynamic, configure DDNS with your domain registrar (e.g., GoDaddy, Cloudflare).
    - Example for Cloudflare:
        - Log in to Cloudflare.
        - Add an A record for `ldap.domain_name_1.com` pointing to your external IP.
        - Enable **Cloudflare DDNS** using their API (requires `acme.sh` or similar for automation).
    - In DSM, add a custom DDNS provider:
        - Go to **Control Panel > External Access > DDNS > Add**.
        - **Service Provider**: Select your provider or `Custom`.
        - **Hostname**: `ldap.domain_name_1.com`.
        - Follow your provider’s instructions for API keys and update URLs.
        - Click **OK**.
3. **Port Forwarding**:
    - In your router, forward the following ports to your NAS’s internal IP (e.g., `192.168.1.100`):
        - **80 (HTTP)**: For Let’s Encrypt HTTP-01 validation (can be closed after certificate issuance).
        - **443 (HTTPS)**: For DSM access and certificate renewal.
        - **389 (LDAP)**: For non-secure LDAP (optional, prefer LDAPS).
        - **636 (LDAPS)**: For secure LDAP.
    - Verify ports are open using an online tool (e.g., `canyouseeme.org`).

## Step 6: Add LDAP Users and Groups
1. **Open LDAP Server**:
    - Go to **LDAP Server > LDAP Users**.
2. **Create Users**:
    - Click **Create**.
    - **Username**: e.g., `jdoe`.
    - **UID**: Auto-assigned or set manually (e.g., `1001`).
    - **Password**: Set a strong password, e.g., `<UserPassword123!>`).
    - **Base DN**: `ou=users,dc=domain_name_1,dc=com` (create `ou=users` if not present).
    - Fill in optional fields (e.g., email, full name).
    - Click **OK**.
3. **Create Groups**:
    - Go to **LDAP Server > LDAP Groups**.
    - Click **Create**.
    - **Group Name**: e.g., `employees`.
    - **GID**: Auto-assigned or set manually (e.g., `1001`).
    - **Base DN**: `ou=groups,dc=domain_name_1,dc=com` (create `ou=groups` if not present).
    - Add users to the group (e.g., `jdoe`).
    - Click **OK**.
4. **Test User Authentication**:
    - Use an LDAP client to verify:
      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "uid=jdoe,ou=users,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```

## Step 7: Best Practices and Additional Configurations
1. **Firewall Configuration**:
    - Go to **Control Panel > Security > Firewall**.
    - Create rules to allow LDAP and LDAPS:
        - **Allow**: Source `All`, Destination `NAS IP`, Ports `389, 636`, Protocol `TCP`.
        - **Allow**: Source `Local Network` (e.g., `192.168.1.0/24`), Destination `NAS IP`, Ports `80, 443, 5000, 5001`.
        - **Deny**: Source `All`, Destination `All` (place at the end).
    - Enable the firewall in **Control Panel > Security > Firewall > Enable Firewall**.
2. **Backup LDAP Data**:
    - Go to **LDAP Server > Backup**.
    - Enable **Scheduled Backup** to a shared folder (e.g., `volume1/backup/ldap`).
    - Set a daily backup schedule.
    - Test restoring a backup to ensure recoverability.
3. **Password Policy**:
    - In **LDAP Server > Settings**, enable a strong password policy:
        - Minimum length: 8 characters.
        - Require uppercase, lowercase, numbers, and special characters.
        - Exclude usernames in passwords.
    - Enable password expiration (e.g., 90 days) and notify users.
4. **Logging and Monitoring**:
    - Go to **Control Panel > Log Center**.
    - Enable logging for **LDAP Server**.
    - Set up email notifications for critical events:
        - Go to **Control Panel > Notification > Email**.
        - Configure an SMTP server (e.g., Gmail with app-specific password).
        - Enable notifications for **System Errors** and **LDAP Events**.
5. **Restrict Admin Access**:
    - Create a dedicated LDAP admin account (e.g., `cn=ldapadmin,dc=domain_name_1,dc=com`) with limited DSM access.
    - Disable the default `admin` account in **Control Panel > User & Group**.
6. **Use DNS-01 for Let’s Encrypt (Optional)**:
    - If ports 80/443 cannot be exposed, use `acme.sh` with DNS-01 validation:
        - SSH into the NAS as an admin user.
        - Install `acme.sh`:
          ```bash
          curl https://get.acme.sh | sh
          ```
        - Configure for your DNS provider (e.g., Cloudflare):
          ```bash
          export CF_Key="<YourCloudflareAPIKey>"
          export CF_Email="<YourCloudflareEmail>"
          ~/.acme.sh/acme.sh --issue --dns dns_cf -d ldap.domain_name_1.com -d domain_name_2_prefix.domain_name_2.com
          ```
        - Import the certificate to DSM:
          ```bash
          ~/.acme.sh/acme.sh --install-cert -d ldap.domain_name_1.com --key-file /path/to/key.pem --fullchain-file /path/to/fullchain.pem
          ```
        - Schedule renewal with a cron job.
7. **Enable Two-Factor Authentication (2FA)**:
    - Go to **Control Panel > User & Group > Advanced**.
    - Enable **2FA** for all admin accounts.
    - Use an authenticator app (e.g., Google Authenticator).
8. **Update DSM and Packages**:
    - Go to **Control Panel > Update & Restore**.
    - Ensure DSM and all packages (including LDAP Server and DNS Server) are updated to the latest versions.
    - Enable automatic updates for security patches.

## Step 8: Test the Setup
1. **Internal Testing**:
    - From a client on the same network, test LDAP connectivity:
      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "cn=admin,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```
    - Verify DNS resolution:
      ```bash
      nslookup ldap.domain_name_1.com 192.168.1.100
      ```
2. **External Testing**:
    - From an external network, test LDAPS:
      ```bash
      ldapsearch -x -H ldaps://ldap.domain_name_1.com:636 -D "cn=admin,dc=domain_name_1,dc=com" -W -b "dc=domain_name_1,dc=com"
      ```
    - Verify DDNS:
      ```bash
      ping domain_name_2_prefix.domain_name_2.com
      ```
3. **Application Integration**:
    - Configure an application (e.g., Nextcloud, OpenVPN) to use LDAP for authentication.
    - Example for Nextcloud:
        - Install the LDAP plugin.
        - Set LDAP server to `ldap.domain_name_1.com:636`.
        - Use Base DN `dc=domain_name_1,dc=com` and Root DN `cn=admin,dc=domain_name_1,dc=com`.

## Troubleshooting
- **LDAP Connection Fails**:
    - Check firewall rules and port forwarding.
    - Verify the certificate is valid and assigned to LDAP Server.
    - Ensure the Base DN and Root DN are correct.
- **DNS Resolution Fails**:
    - Verify the DNS Server zone configuration.
    - Check the router’s DNS settings.
    - Test with `nslookup` from a client.
- **Certificate Issues**:
    - Ensure ports 80/443 are open during Let’s Encrypt issuance.
    - Use DNS-01 validation if ports cannot be exposed.
    - Check certificate SANs include all domains.
- **Logs**:
    - Review logs in **Control Panel > Log Center** for LDAP and DNS errors.

## References
- Synology Knowledge Center: [Set Up LDAP Server](https://kb.synology.com/en-us/DSM/help/LDAPServer/ldapserver)[](https://kb.synology.com/en-af/DSM/help/DirectoryServer/ldap_server?version=7)
- Synology Knowledge Center: [DDNS](https://kb.synology.com/en-us/DSM/help/DSM/AdminCenter/connection_ddns)[](https://kb.synology.com/en-br/DSM/help/DSM/AdminCenter/connection_ddns)
- Marius Hosting: [How to Enable HTTPS on DSM 7](https://mariushosting.com/synology-how-to-enable-https-on-dsm-7/)[](https://mariushosting.com/synology-how-to-enable-https-on-dsm-7/)
- Synology Release Notes for DS1618+: [DSM 7.2](https://www.synology.com/en-us/releaseNote/DS1618+)[](https://www.synology.com/en-me/releaseNote/DSM?model=DS1618%252B)
