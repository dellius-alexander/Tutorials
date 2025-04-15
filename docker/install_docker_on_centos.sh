#!/usr/bin/env bash

cat << 'EOF'
### How to Use the Script

1. **Save the Script**:
   - Copy the script into a file, e.g., `install_docker.sh`.
   - Make it executable: `chmod +x install_docker.sh`.

2. **Run the Script**:
   - Execute it with root privileges: `sudo ./install_docker.sh`.

3. **What to Expect**:
   - The script will display colored logs:
     - Yellow `[INFO]` for progress updates.
     - Green `[SUCCESS]` for successful steps.
     - Red `[ERROR]` if something goes wrong, followed by script termination.
   - If successful, Docker will be installed, started, and verified.

### Key Features

- **Comments**: Each section is explained with inline comments for clarity.
- **Color-Coded Logging**: Uses ANSI escape codes to differentiate info, success, and error messages.
- **Error Handling**: Checks the success of critical commands and exits with an error message if they fail.
- **Prerequisites Check**: Ensures the script runs as root and on CentOS 9 Stream.
- **Cleanup**: Removes old Docker packages to avoid conflicts.
- **Verification**: Runs the `hello-world` image to confirm Docker works.

### Notes

- **GPG Key**: The script assumes automatic acceptance of the GPG key during installation. If prompted, manually verify the fingerprint (`060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35`) matches.
- **Non-Root Usage**: Adding the user to the `docker` group is optional; log out and back in to apply this change.
- **CentOS Version**: Tailored for RHEL Centos release 9.x as specified in the document.

This script provides a reliable, user-friendly way to install Docker Engine on a CentOS VM while adhering to the official instructions.

EOF

# Color definitions for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print info messages
info() {
    local color="${YELLOW}"
    local message="$1"
    echo -e "${color}[INFO] ${message}${NC}"
}

# Function to print success messages
success() {
    local color="${GREEN}"
    local message="$1"
    echo -e "${color}[SUCCESS] ${message}${NC}"
}

# Function to print error messages and exit
error() {
    local color="${RED}"
    local message="$1"
    echo -e "${color}[ERROR] ${message}${NC}"
    exit 1
}

# Prompt user to continue
read -p "Do you want to continue? (yes/no): " response
if [[ ! "$response" =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    info "Exiting script."
    exit 0
else
    info """
    Continuing with the script...
    NOTE: This script must be run with root privileges.
"""
fi

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root. Please use sudo or run as root user."
fi

# Check CentOS version compatibility
info "Checking CentOS version..."
if ! grep -q "rhel centos fedora" /etc/os-release; then
    error "This script is designed for RHEL Centos release 9.x. Unsupported version detected."
fi

# Ensure centos-extras repository is enabled
info "Verifying centos-extras repository is enabled..."
if ! dnf repolist | grep -q "extras"; then
    info "Enabling centos-extras repository..."
    dnf config-manager --set-enabled extras || error "Failed to enable centos-extras repository."
fi

# Uninstall old Docker versions if they exist
info "Removing any old Docker packages..."
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest \
    docker-latest-logrotate docker-logrotate docker-engine || true
# Note: '|| true' ensures the script continues even if no packages are found

# Install dnf-plugins-core for repository management
info "Installing dnf-plugins-core..."
dnf install -y dnf-plugins-core || error "Failed to install dnf-plugins-core."

# Add the official Docker repository
info "Adding Docker repository..."
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || \
    error "Failed to add Docker repository."

# Install Docker Engine and related packages
info "Installing Docker Engine and dependencies..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || \
    error "Failed to install Docker packages."
# Note: If prompted for GPG key, the script assumes automatic acceptance; verify fingerprint manually if needed

# Start and enable Docker service
info "Starting and enabling Docker service..."
systemctl enable --now docker || error "Failed to start and enable Docker service."

# Verify Docker installation by running the hello-world image
info "Verifying Docker installation..."
if sudo docker run hello-world &> /dev/null; then
    success "Docker installed and verified successfully."
else
    error "Docker installation verification failed. Check Docker service status."
fi

# Optional: Add the current user to the docker group for non-root access
info "Adding current user to docker group (optional for non-root usage)..."
usermod -aG docker "$USER" || error "Failed to add user to docker group."
# Note: User must log out and back in for group changes to take effect
# or alternatively, run `newgrp docker` to apply changes immediately
newgrp docker || error "Failed to apply group changes."
success "User added to docker group. Log out and back in to apply changes."

# Final confirmation
success "Docker Engine installation completed successfully on CentOS 9 Stream."
