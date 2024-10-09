# Proxy Access to Proxmox via Subdomain and Fixing Console Issue

> *Note:
> This is an advanced concept that requires a good understanding of networking, 
> NAT, DNS Resolution Protocol, and server configuration. It is recommended to have a backup of 
> your server configuration before making any changes. By server, I mean the public 
> facing proxy server. Keep in mind we can have as many proxies as we want, but as long 
> as our forwarding rules are correctly configured. We can also have, a single proxy server 
> that forwards all requests to the Proxmox-VE server.*

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
       # This block defines a server configuration for Nginx.
       # It specifies how Nginx should behave for the incoming requests that match this configuration.
      
           listen 80;
           # The 'listen' directive specifies the port Nginx listens on. 
           # Here, it's set to listen on port 80 (HTTP) for incoming traffic.
      
           server_name proxmox.mydomain.com;
           # 'server_name' specifies the domain name or IP address that this block should respond to.
           # It ensures that requests for 'proxmox.mydomain.com' will be handled by this configuration.
          
           location / {
               # The 'location' directive defines how requests to specific paths should be processed.
               # The '/' matches all requests, directing them according to the nested rules.
      
               proxy_pass https://YOUR_PROXMOX_IP:8006;
               # 'proxy_pass' tells Nginx to forward (proxy) the incoming request to the specified URL.
               # It passes the request to the Proxmox server using HTTPS on port 8006 (Proxmox's default web interface port).
              
               proxy_set_header Host $host;
               # This sets the 'Host' header in the proxied request to the value of the original host.
               # It preserves the host information as 'proxmox.mydomain.com' for consistency and proper handling on the backend.
             
               proxy_set_header X-Forwarded-Host $host;
               # Set the X-Forwarded-Host header to the host the client originally requested
        
               proxy_set_header X-Forwarded-Port $server_port;
               # Set the X-Forwarded-Port header to the port used in the original client request
               # If the external and internal ports are different, adjust the value accordingly
             
             
               proxy_set_header X-Real-IP $remote_addr;
               # Sets the 'X-Real-IP' header with the IP address of the client making the request.
               # This ensures the backend server knows the actual client IP address for logging or security purposes.
      
               proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
               # Adds or appends the client IP address to the 'X-Forwarded-For' header.
               # This header is used to track the original IP address of the client through proxy chains.
      
               proxy_set_header X-Forwarded-Proto $scheme;
               # This sets the 'X-Forwarded-Proto' header to the scheme of the original request (either 'http' or 'https').
               # It's used by the backend server to understand whether the original connection was secure (HTTPS) or not (HTTP).
      
               proxy_set_header Upgrade $http_upgrade;
               # This passes the 'Upgrade' header value from the client request to the proxied request.
               # It is important for WebSocket connections, allowing for connection upgrades between the client and server.
      
               proxy_set_header Connection "upgrade";
               # Sets the 'Connection' header to 'upgrade', which is necessary for establishing WebSocket connections.
               # It tells the server that the client wants to upgrade the connection type.
      
               proxy_http_version 1.1;
               # Forces the proxy connection to use HTTP/1.1 instead of the default HTTP/1.0.
               # HTTP/1.1 is needed for WebSocket and keep-alive connections, allowing efficient communication and protocol upgrades.
      
               proxy_buffering off;
               # Disables buffering for the proxied responses.
               # This is important for interactive applications like the Proxmox web console, as it reduces latency by not buffering the response.
           }
       }
       ```
     
   - Replace `YOUR_PROXMOX_IP` with the IP address of your Proxmox server.

3. **Enhanced Nginx Configuration**[Optional]:

   - To extend the Nginx configuration with features for authentication, streaming content, 
and handling a distributed backend cluster with its own sub-proxy, here’s a snippet that 
can be added or modified within the existing configuration. The snippet includes low-level 
explanations for each directive:
   
   ```nginx
   server {
   # Listen on port 80 for incoming HTTP traffic
   listen 80;
   # Server name used to match incoming requests for this specific virtual host
   server_name proxmox.mydomain.com;
   
       # Enable basic HTTP authentication to restrict access
       auth_basic "Restricted Access";  # Sets up basic auth with a realm prompt
       auth_basic_user_file /etc/nginx/.htpasswd;  # Path to the file containing username:password pairs
   
       location /stream {
           # This location block handles streaming content behind the proxy
   
           # Directs traffic to the backend streaming service (e.g., a video server)
           proxy_pass http://backend-streaming-service:8080;
   
           # WebSocket support for streaming: ensures the connection is upgraded when needed
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
   
           # Set high timeouts for read and send operations to keep streaming connections alive
           proxy_read_timeout 3600s;
           proxy_send_timeout 3600s;
   
           # Disable buffering to reduce latency and optimize real-time streaming
           proxy_buffering off;  # Disables response buffering
           proxy_request_buffering off;  # Disables request buffering
   
           # Ensures the MIME type for streaming content is set correctly
           add_header Content-Type video/mp4;
       }
   
       location /cluster {
           # This location block is for distributing traffic to a backend cluster with multiple servers
   
           # Directs traffic to the defined upstream block named 'backend-cluster'
           proxy_pass http://backend-cluster;
   
           # Sticky sessions based on client IP to keep the same client connected to the same backend server
           ip_hash;
   
           # Forward headers to maintain transparency and provide backend servers with client information
           proxy_set_header X-Forwarded-Host $host;  # The original host requested by the client
           proxy_set_header X-Forwarded-Port $server_port;  # The port the client used to access the service
           proxy_set_header X-Real-IP $remote_addr;  # The real IP address of the client
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;  # Adds client IP to the proxy chain
           proxy_set_header X-Forwarded-Proto $scheme;  # Protocol (http/https) used by the client
   
           # Health check settings (only available with Nginx Plus) to ensure backend servers are healthy
           # health_check interval=5 fails=3 passes=2;
   
           # Enable response buffering for optimized performance in high-traffic scenarios
           proxy_buffering on;
           proxy_buffers 16 16k;  # Number and size of buffers for the proxied responses
           proxy_busy_buffers_size 64k;  # Buffer size when all proxy buffers are in use
       }
   }
   
   location /api {
        # Load balancing for API server or proxy

        # Directs traffic to the defined upstream block named 'api-server'
        proxy_pass http://api-server;

        # Round-robin load balancing distributes requests evenly across all backend servers
        # This is the default method, so no extra configuration is required.

        # Forward headers for transparency
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Additional proxy settings for API requests
        proxy_http_version 1.1;
        proxy_set_header Connection "";  # Keeps connections alive with backend servers
   }
      
   # Upstream block definition for distributing traffic among multiple backend servers
   upstream backend-cluster {
   server backend1.mydomain.com:8000;  # First backend server in the cluster
   server backend2.mydomain.com:8000;  # Second backend server in the cluster
   server backend3.mydomain.com:8000;  # Third backend server in the cluster
   }
   
   # Upstream block for API server with round-robin load balancing
   upstream api-server {
   # No special directive is needed since round-robin is the default
   server api1.mydomain.com:9000;  # First API server
   server api2.mydomain.com:9000;  # Second API server
   server api3.mydomain.com:9000;  # Third API server
   }
   
    # Upstream block for streaming service
    upstream backend-streaming-service {
    server streaming1.mydomain.com:8080;  # Streaming server
    }

   ```

4. **Enable the Nginx Configuration**:
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

---
https://router.dalexander1618.synology.me/webman/3rdparty/sso/synoSSO-1.0.0.js
https://sso.dalexander1618.synology.me/webman/sso/synoSSO-1.0.0.js
