#!/usr/bin/env bash
if [ $UID -ne 0 ]; then
    echo "Error: must run as root..."
    echo "Usage: sudo $0 $*"
    exit 1
fi
# download the current stable release of Docker Compose:
curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Apply executable permissions to the binary:
chmod +x /usr/local/bin/docker-compose
# Note: If the command docker-compose fails after installation, 
#   check your path. You can also create a symbolic link to 
#   /usr/bin or any other directory in your path.
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
# Install bash_completion for docker-compose
curl \
    -L https://raw.githubusercontent.com/docker/compose/1.28.6/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose