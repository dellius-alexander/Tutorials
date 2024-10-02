# Setup xRDP on Elementary OS Horus


To set up remote desktop access on your **Elementary OS Horus VM**, you can 
use **xRDP**, a popular protocol that enables remote desktop access. Below are 
the steps to install and configure `xRDP` on Elementary OS and remotely access it.

### Step 1: Install xRDP and Required Packages

1. **Open a Terminal** and update your system:

   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install xRDP** along with the required desktop environment dependencies:

   ```bash
   sudo apt install xrdp -y
   ```

3. **Install a lightweight desktop environment**, such as Xfce (Elementary OS uses Pantheon, but it’s often better to use Xfce for remote sessions):

   ```bash
   sudo apt install xfce4 xfce4-goodies -y
   ```

4. After installation, create a session for Xfce when xRDP connects:

   ```bash
   echo xfce4-session > ~/.xsession
   ```

5. Restart the `xRDP` service:

   ```bash
   sudo systemctl restart xrdp
   ```

### Step 2: Configure Firewall for Remote Desktop Access

By default, xRDP uses port **3389**, so you need to allow this port in the firewall settings.

1. **Allow port 3389** through the firewall:

   ```bash
   sudo ufw allow 3389/tcp
   ```

2. Enable the firewall if it's not already active:

   ```bash
   sudo ufw enable
   ```

3. Check the firewall status to ensure the port is open:

   ```bash
   sudo ufw status
   ```

### Step 3: Start and Enable xRDP Service

To ensure that `xRDP` starts every time the system boots, enable it as a system service.

```bash
sudo systemctl enable xrdp
```

### Step 4: Configure xRDP Session

1. **Configure Polkit for xRDP Sessions** (optional, but may avoid some access issues):

   Create a new Polkit file for xRDP:

   ```bash
   sudo nano /etc/polkit-1/localauthority.conf.d/02-allow-colord.conf
   ```

   Add the following content to the file:

   ```bash
   [Allow Colord All Users]
   Identity=unix-user:*
   Action=org.freedesktop.color-manager.*
   ResultAny=yes
   ResultInactive=yes
   ResultActive=yes
   ```

2. Save and close the file (`Ctrl+O`, then `Ctrl+X`).

### Step 5: Connect via Remote Desktop

Once you have xRDP installed and configured, you can use a Remote Desktop client to connect to your Elementary OS VM:

1. **On Windows**:
    - Open the built-in **Remote Desktop Connection** app.
    - Enter the **IP address** of your Elementary OS VM (you can check the VM’s IP by running `ifconfig` or `ip a` in the terminal).

2. **On macOS**:
    - You can use **Microsoft Remote Desktop** (available in the Mac App Store).

3. **On Linux**:
    - You can use a remote desktop client like `Remmina`, which supports RDP.

### Step 6: Login to xRDP

When you connect, you should be presented with the `xRDP` login screen:

- **Session**: Select **Xfce** (if Pantheon doesn't work well for remote).
- **Username and Password**: Enter your regular system credentials (same as when you log into the desktop locally).

### Additional Notes:
- **Performance**: Xfce is lightweight, so it works better over xRDP. Pantheon (Elementary OS's default DE) might not provide an optimal experience when using remote desktop protocols.
- **Security**: RDP isn't the most secure protocol by default, so consider securing the connection using SSH tunneling or VPN to protect your remote desktop sessions.

