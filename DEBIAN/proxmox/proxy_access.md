# Proxy Access to Proxmox via Subdomain and Fixing Console Issue

## Problem Domain

Proxmox is a popular open-source virtualization platform that allows you to manage 
virtual machines and containers. When accessing Proxmox via a subdomain like 
`proxmox.mydomain.com`, you may encounter issues with the console not loading correctly 
due to JavaScript errors. This guide provides steps to configure Proxmox to use a subdomain 
and set up a reverse proxy to fix the console issue.

## Solution
 
> **Note:**
> - *This solution assumes you have a working Proxmox installation and are familiar 
> with basic Linux system administration, ACLs, Permissions, and DNS Host Resolution Protocol.*
> - *For the purpose of this example we use `Nginx`.*
> - *Make sure to replace placeholders like `proxmox.mydomain.com` and `YOUR_PROXMOX_IP`.*
> - *These instructions would apply to any proxy service, can work on any Linux distribution, 
> but the paths and commands may vary.*
> - *Ensure you have backups of your configuration files before making changes.*

To access Proxmox via a subdomain like `proxmox.mydomain.com` and fix the console 
issue, you typically need to ensure that the Proxmox web interface and console are 
properly configured to recognize and serve content from that subdomain. Here’s how 
you can set it up:

### 1. Configure Proxmox to Use the Subdomain

1. **Edit the Proxmox Host File**:
    - Edit the `/etc/hosts` file to ensure the subdomain is correctly resolved by the Proxmox server itself:
      ```bash
      sudo nano /etc/hosts
      ```
    - Add or update the line with your server’s IP and the subdomain:
      ```
      192.168.1.x proxmox.mydomain.com proxmox
      ```

2. **Edit the Proxmox Configuration**:
    - Update `/etc/default/pveproxy` to use the subdomain:
      ```bash
      sudo nano /etc/default/pveproxy
      ```
    - Ensure it reflects:
      ```
      PVE_PROXY_HOST="proxmox.mydomain.com"
      ```

### 2. Set Up a Reverse Proxy (e.g., Nginx)
Using a reverse proxy like Nginx can help route traffic to Proxmox while fixing any issues with JavaScript files:

1. **Install Nginx** (if not already installed):
   ```bash
   sudo apt update
   sudo apt install nginx
   ```

2. **Configure Nginx**:
    - Create a new configuration file for your subdomain:
      ```bash
      sudo nano /etc/nginx/sites-available/proxmox.mydomain.com.conf
      ```
    - Add the following configuration:
      ```nginx
      server {
          listen 80;
          server_name proxmox.mydomain.com;
 
          location / {
              proxy_pass https://YOUR_PROXMOX_IP:8006;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              proxy_http_version 1.1;
              proxy_buffering off;
          }
      }
      ```
    - Replace `YOUR_PROXMOX_IP` with the IP address of your Proxmox server.

3. **Enable the Nginx Configuration**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/proxmox.mydomain.com.conf /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

### 3. Configure SSL (Optional but Recommended)
If you’re using HTTPS:
- Set up SSL certificates using Let's Encrypt with Certbot or another tool.
- Update the Nginx config to listen on port `443` and point to your SSL certificates.

### 4. Allow WebSocket Traffic
Ensure that the reverse proxy configuration supports WebSocket traffic, which is needed for the console:

```nginx
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
proxy_http_version 1.1;
```

### 5. Restart Proxmox Services
Finally, restart the Proxmox services to apply the configuration changes:

```bash
sudo systemctl restart pveproxy
```

After these steps, try accessing `proxmox.mydomain.com` again, and the console should load correctly. If there are further issues, check the browser console for any error messages and confirm that the firewall settings allow traffic to and from the Proxmox server.
