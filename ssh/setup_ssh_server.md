# Setup SSH Server on RHEL/CentOS and Ubuntu VM

SSH (Secure Shell) is a network protocol that allows secure communication between two systems. 
Setting up an SSH server on your RHEL/CentOS or Ubuntu VM enables you to remotely access and manage 
the server securely over the network. This guide provides detailed steps to install and configure 
an SSH server on RHEL/CentOS and Ubuntu, including setting up SSH key-based authentication and 
additional security measures.

- **RHEL/CentOS**: Red Hat Enterprise Linux (RHEL) and CentOS are popular Linux distributions used in 
  enterprise environments and servers.
- **Ubuntu**: Ubuntu is a widely used open-source Linux distribution known for its ease of use and 
  community support.
- **OpenSSH**: OpenSSH is the most common implementation of the SSH protocol and includes both the 
  server and client components.
- **SSH Key-Based Authentication**: SSH key-based authentication provides a more secure and convenient 
  way to log in to a server without entering a password.
- **Firewall Configuration**: Configuring the firewall to allow SSH traffic is essential to ensure 
  that the SSH server can accept incoming connections.
- **Additional Security Measures**: Disabling root login, limiting login attempts, and other security 
  configurations can enhance the security of your SSH server.
- **Troubleshooting**: Checking SSH logs and verifying SSH service status can help diagnose and resolve 
  issues with the SSH server.
- **SSH Keygen**: The `ssh-keygen` command is used to generate SSH key pairs for authentication.
- **SSH Askpass**: The `ssh-askpass` utility is used to prompt users for passwords when using SSH.
- **SSH Tunneling**: SSH tunneling allows you to create secure connections and forward ports over SSH.
- **SSH Config File**: The SSH configuration file (`sshd_config`) contains settings for the SSH server, 
  such as port number, authentication methods, and access control.
- **SSH Client**: The SSH client (`ssh`) is used to connect to SSH servers and execute commands remotely.

---

## Setting Up an SSH Server on RHEL/CentOS and Ubuntu

### Step 1: Install OpenSSH Server

1. **Log in** to your VM as a user with sudo privileges.

2. **Update the system packages**:
    - **RHEL/CentOS**:
      ```bash
      sudo yum update -y
      ```
    - **Ubuntu**:
      ```bash
      sudo apt update && sudo apt upgrade -y
      ```

3. **Install OpenSSH server**:
    - **RHEL/CentOS**:
      ```bash
      sudo yum install -y openssh-server
      ```
    - **Ubuntu**:
      ```bash
      sudo apt install -y openssh-server
      ```

### Step 2: Start and Enable the SSH Service

1. **Start the SSH service**:
    - **RHEL/CentOS**:
      ```bash
      sudo systemctl start sshd
      ```
    - **Ubuntu**:
      ```bash
      sudo systemctl start ssh
      ```

2. **Enable the service to start on boot**:
    - **RHEL/CentOS**:
      ```bash
      sudo systemctl enable sshd
      ```
    - **Ubuntu**:
      ```bash
      sudo systemctl enable ssh
      ```

3. **Check the status** of the SSH service:
    - **RHEL/CentOS**:
      ```bash
      sudo systemctl status sshd
      ```
    - **Ubuntu**:
      ```bash
      sudo systemctl status ssh
      ```

### Step 3: Configure the SSH Daemon (Optional but Recommended)

1. **Edit the SSH configuration file**:
    - **RHEL/CentOS**:
      ```bash
      sudo vi /etc/ssh/sshd_config
      ```
    - **Ubuntu**:
      ```bash
      sudo nano /etc/ssh/sshd_config
      ```

2. **Common Configurations** (uncomment and adjust these settings if necessary):
    - Change the default port (from `22` to something else for added security):
      ```text
      Port 2222
      ```
    - Disable root login for security:
      ```text
      PermitRootLogin no
      ```
    - Limit login to specific users:
      ```text
      AllowUsers dellius
      ```
    - Disable password authentication if you use SSH keys:
      ```text
      PasswordAuthentication no
      ```
    - Enable public key authentication:
      ```text
      PubkeyAuthentication yes
      ```

3. **Save and close** the file:
    - **RHEL/CentOS**: Press `:wq` in `vi`.
    - **Ubuntu**: Press `Ctrl + X`, then `Y`, and `Enter` in `nano`.

4. **Restart the SSH service** to apply changes:
    - **RHEL/CentOS**:
      ```bash
      sudo systemctl restart sshd
      ```
    - **Ubuntu**:
      ```bash
      sudo systemctl restart ssh
      ```

### Step 4: Configure the Firewall

1. **Check if the firewall is active**:
    - **RHEL/CentOS**:
      ```bash
      sudo firewall-cmd --state
      ```
    - **Ubuntu**:
      ```bash
      sudo ufw status
      ```

2. **Open the SSH port**:
    - **RHEL/CentOS** (default port `22`):
      ```bash
      sudo firewall-cmd --permanent --add-service=ssh
      ```
    - **Ubuntu** (default port `22`):
      ```bash
      sudo ufw allow ssh
      ```
    - If you changed the SSH port (e.g., to `2222`):
        - **RHEL/CentOS**:
          ```bash
          sudo firewall-cmd --permanent --add-port=2222/tcp
          ```
        - **Ubuntu**:
          ```bash
          sudo ufw allow 2222/tcp
          ```

3. **Reload the firewall** to apply the changes:
    - **RHEL/CentOS**:
      ```bash
      sudo firewall-cmd --reload
      ```
    - **Ubuntu**:
      ```bash
      sudo ufw reload
      ```

### Step 5: Test the SSH Server

1. **Check SSH status** on the VM:
    - **RHEL/CentOS**:
      ```bash
      sudo systemctl status sshd
      ```
    - **Ubuntu**:
      ```bash
      sudo systemctl status ssh
      ```

2. **Test SSH connection** from a remote machine:
    - Default port:
      ```bash
      ssh username@your-vm-ip
      ```
    - Custom port (e.g., `2222`):
      ```bash
      ssh -p 2222 username@your-vm-ip
      ```

### Step 6: Set Up SSH Key-Based Authentication (Optional but Recommended)

1. **Generate an SSH key pair** on your client machine:
   ```bash
   ssh-keygen -t rsa -b 4096
   ```

2. **Copy the public key** to your VM:
   ```bash
   ssh-copy-id username@your-vm-ip
   ```
    - For custom ports:
      ```bash
      ssh-copy-id -p 2222 username@your-vm-ip
      ```

3. **Verify** SSH key-based login:
   ```bash
   ssh username@your-vm-ip
   ```

### Step 7: Additional Security Measures

1. **Disable root login**:
    - Edit `/etc/ssh/sshd_config`:
      ```text
      PermitRootLogin no
      ```

2. **Disable password authentication** if using SSH keys:
    - Edit `/etc/ssh/sshd_config`:
      ```text
      PasswordAuthentication no
      ```
    - Restart SSH:
        - **RHEL/CentOS**:
          ```bash
          sudo systemctl restart sshd
          ```
        - **Ubuntu**:
          ```bash
          sudo systemctl restart ssh
          ```

3. **Limit login attempts**:
    - Edit `/etc/ssh/sshd_config`:
      ```text
      MaxAuthTries 3
      ```

### Step 8: Troubleshooting

- **Check SSH logs** if there are issues:
    - **RHEL/CentOS**:
      ```bash
      sudo journalctl -xe
      sudo tail -f /var/log/secure
      ```
    - **Ubuntu**:
      ```bash
      sudo journalctl -xe
      sudo tail -f /var/log/auth.log
      ```

- **Check if SSH is listening** on the right port:
  ```bash
  sudo netstat -tuln | grep ssh
  ```

