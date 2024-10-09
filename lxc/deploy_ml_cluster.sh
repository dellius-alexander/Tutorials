#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi

# Update and install necessary packages
echo "Updating system and installing required packages..."
apt update && apt upgrade -y
apt install lxc lxc-templates lxc-net nginx openssl -y

# Enable and start lxc-net service
echo "Starting LXC networking service..."
systemctl enable lxc-net
systemctl start lxc-net

# Create and configure LXC containers for each service
SERVICES=("postgres-service" "snowflake-service" "spark-service" "milvus-service" "python-service" "cert-manager" "nginx-proxy")

echo "Creating LXC containers for each service..."
for SERVICE in "${SERVICES[@]}"; do
  lxc-create -t ubuntu -n $SERVICE
  lxc-start -n $SERVICE
done

# Setting up LXC network configuration and default settings
echo "Setting up LXC default network configuration..."
cat <<EOT >> /etc/lxc/default.conf
lxc.net.0.type = veth
lxc.net.0.link = lxcbr0
lxc.net.0.flags = up
lxc.rootfs.backend = dir
EOT

# Network Configuration for nginx-proxy to connect to vmbr0
echo "Configuring nginx-proxy to connect to vmbr0..."
cat <<EOT >> /var/lib/lxc/nginx-proxy/config
lxc.net.1.type = veth
lxc.net.1.link = vmbr0
lxc.net.1.flags = up
lxc.net.1.hwaddr = 00:16:3e:xx:xx:xx
EOT

# Install and configure services in each container
echo "Deploying microservices..."
# Function to install software inside a container
deploy_service() {
  CONTAINER=$1
  SERVICE=$2
  echo "Deploying $SERVICE in $CONTAINER..."

  # Attach and run commands inside the container
  lxc-attach -n $CONTAINER -- bash -c "
    apt update && apt install -y $SERVICE
  "
}

# Deploy specific services inside their containers
deploy_service "postgres-service" "postgresql"
deploy_service "python-service" "python3.12"
# Additional services like snowflake, milvus, and spark may require custom setups or manual installations

# Set up nginx-proxy as the reverse proxy and load balancer
echo "Configuring Nginx proxy and load balancer..."
lxc-attach -n nginx-proxy -- bash -c "
  apt update && apt install -y nginx
  cat <<NGINX > /etc/nginx/nginx.conf
http {
    upstream microservices {
        server 10.0.3.10:5432;  # PostgreSQL
        server 10.0.3.11;        # Snowflake
        server 10.0.3.12;        # Apache Spark
        server 10.0.3.13;        # Milvus
        server 10.0.3.14;        # Python
    }

    server {
        listen 80;
        server_name nginx-proxy.mydomain.com;

        location / {
            proxy_pass http://microservices;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
NGINX
  systemctl restart nginx
"

# Shared directory for certificates
SHARED_CERT_DIR="/var/shared/certs"
echo "Setting up shared directory for certificates..."
mkdir -p $SHARED_CERT_DIR

# Mount the shared directory in each container
echo "Mounting shared certificates directory in each container..."
for SERVICE in "${SERVICES[@]}"; do
  lxc-attach -n $SERVICE -- bash -c "
    mkdir -p /certs
    mount --bind $SHARED_CERT_DIR /certs
  "
done

# Deploy certificate management service
echo "Deploying certificate management service..."
lxc-attach -n cert-manager -- bash -c "
  apt update && apt install -y certbot
  # Example command to create a certificate (replace with your domain and email)
  certbot certonly --standalone -d nginx-proxy.mydomain.com --agree-tos --email admin@mydomain.com --non-interactive
"

# Restart Nginx to apply the SSL certificates
echo "Restarting Nginx to apply SSL certificates..."
lxc-attach -n nginx-proxy -- bash -c "
  systemctl restart nginx
"

echo "Microservices setup and deployment complete."
