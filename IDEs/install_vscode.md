# Installing Visual Studio Code on CentOS
<br/>

### 1. Start by importing the Microsoft GPG key:
<br/>

```bash
$ sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 
```

### 2. Create the following repo file to enable the Visual Studio Code repository:
<br/>

```bash
$ sudo cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo 
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF 
```

### 3. Install the latest version of Visual Studio Code by typing:
```bash
$ sudo yum install -y code
```

