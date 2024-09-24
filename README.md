# Tutorials

This repository contains a collection of tutorials, scripts, and other useful 
information that I have found helpful. The content is organized by category 
and subcategory.

***Note:*** *This repository is a work in progress and will be updated regularly. 
Use at your own risk, as some implementations herein requires intermediate to expert 
level of understanding of the problem domain.*

## Table of Contents

### Debian
- [Install Cypress](DEBIAN/__install_cypress__.sh)
- [Install JDK](DEBIAN/__install_jdk__.sh)
- [Install XRDP (Original)](DEBIAN/__install_xrdp__.sh.orig)
- [NFS Mount](DEBIAN/__nfs__.sh)
- [Setup ExpressVPN](DEBIAN/setup_expressvpn.sh)

### Synology
- [Setup Git Repo](DEBIAN/synology/setup_git_repo.md)
- [Setup MailPlus Server](DEBIAN/synology/setup_mail_plus_server.md)

#### EOS
- [Install Docker](DEBIAN/eos/Hera_5.1.7/__install_docker__.sh)
- [Setup EOS](DEBIAN/eos/Hera_5.1.7/__setup_eos__.sh)
- [X11VNC](DEBIAN/eos/Hera_5.1.7/__x11vnc__.sh)
- [XRDP](DEBIAN/eos/Hera_5.1.7/__xrdp__.sh)
- [Post EOS Install](DEBIAN/eos/Hera_5.1.7/post-eos-install.sh)

#### Ubuntu
- [Remote Desktop](DEBIAN/ubuntu/20/amd64/__remote_desktop__.sh)
- [XRDP](DEBIAN/ubuntu/20/amd64/__xrdp__.sh)
- [Setup](DEBIAN/ubuntu/20/arm64/__setup__.sh)

### IDEs
- [Install VSCode](./IDEs/install_vscode.md)

### Logs
- [Logback Console](./Logs/config_files/logback/console.xml)
- [Logback File](./Logs/config_files/logback/file.md)

### PDFs
- [GCloud Cheat Sheet](./PDFs/gcloud-cheat-sheet.pdf)

### Bash Completion
- [Bash Auto Completion](./bash_completion/bash-auto-completion.md)
- [Custom Completion](./bash_completion/custom-completion.bash)
- [Xclip Completions](./bash_completion/xclip-completions.bash)

### CUDA
- [Install CUDA](./cuda/__install_cuda__.md)
- [Install CUDA Script](./cuda/install_cuda.sh)
- [NVIDIA Docker](./cuda/nvidia_docker.md)
- [NVIDIA Docker Runtime](./cuda/nvidia_docker_runtime.sh)
- [Setup Graphics Driver](./cuda/setup_graphics_driver..md)

### Database
- [Milvus Cluster](./db/vector/docker-compose.milvus-cluster.yaml)
- [Milvus Standalone](./db/vector/docker-compose.milvus-standalone.yml)

#### Devcontainer
- [ETCD Dockerfile](./db/vector/.devcontainer/etcd.Dockerfile)
- [Milvus Dockerfile](./db/vector/.devcontainer/milvus.Dockerfile)
- [Pulsar Dockerfile](./db/vector/.devcontainer/pulsar.Dockerfile)
- [Health Check](./db/vector/.devcontainer/healthcheck/healthcheck.js)
- [MySQL Init DB](./db/vector/.devcontainer/configs/mysql/entrypoint/init_db.sql)
- [Milvus Cluster Config](./db/vector/.devcontainer/configs/milvus/milvus-cluster.yaml)
- [Milvus Config](./db/vector/.devcontainer/configs/milvus/milvus.yaml)
- [Migration Config](./db/vector/.devcontainer/configs/milvus/migration.yaml)
- [Request CSR](./db/vector/.devcontainer/configs/etc/req_csr.json)

### Docker
- [Remote Docker Host](./docker/Remote-Docker-Host.md)
- [Connect Remote Docker Host](./docker/connect-remote-docker-host.md)
- [Context](./docker/context.md)
- [Docker Context TLS](./docker/docker_context_tls.md)
- [Install Docker Compose](./docker/install-docker-compose.sh)
- [Setup Docker Credential Store](./docker/setup-docker-cred-store.md)
- [View Private Registry](./docker/view-private-registry.sh)

### Git
- [Git](./git/git.md)
- [GitHub SSH Keygen](./git/github.ssh_keygen.sh)

### Go
- [Install Go](./go/__install_GO__.md)

### How-To
- [Assign Port](./how-to/__assign_port__.sh)
- [Install .NET](./how-to/__install_dotnet__.md)
- [Network Connection](./how-to/__net_con__.md)
- [Password Generator](./how-to/passwd_gen.sh)
- [URL Regex](./how-to/url_regex.md)

### HTTP
- [MIME Types](./http/__mime_types__.md)
- [Status Codes](./http/status_codes.md)

### Kubernetes
- [Create Registry Secret](./k8s/create_registry_secret.md)
- [Kubeadm](./k8s/kubeadm.md)
- [Kubeadm Config](./k8s/kubeadm_config.md)

### Key Management
- [Tools](./key-management/tools.md)
- [Gopass SSH Login](./key-management/gopass_ssh_login.md)
- [Gopass Command Reference](./key-management/gopass_command_reference.md)

### Media
- [Date and Time Zone](./media/images/dateAndTimeZone.png)
- [GCloud Cheat Sheet 1](./media/images/gcloud-cheat-sheet-1.png)
- [GCloud Cheat Sheet 2](./media/images/gcloud-cheat-sheet-2.png)

### Python
- [Kodi](./python/kodi.md)
- [Setup VPN](./python/setup-vpn.sh.md)
- [Setup Virtual Environment](./python/setup_venv.md)

### RHEL
- [Create Network Bridge](RHEL/__create_net_bridge__.sh)
- [Hypervisor](RHEL/__hypervisor__.sh)
- [Install Docker](RHEL/__install_docker__.sh)
- [NFS Mount](RHEL/__nfs__.sh)
- [NMCLI](RHEL/__nmcli__.md)
- [Rebuild Initramfs](RHEL/__rebuild_initrafms.md)
- [Remote Desktop](RHEL/__remote_desktop__.sh)
- [Resolve Yum Package Update Error](RHEL/__resolve_yum_package_update_error.sh)
- [Storage](RHEL/__storage__.md)
- [Version Lock](RHEL/__versionlock__.md)
- [VSCode](RHEL/__vscode__.sh)
- [XRDP](RHEL/__xrdp__.sh)
- [NVMe](RHEL/nvme.sh)

### SSH
- [SSH Askpass](./ssh/ssh_askpass.md)
- [SSH Keygen](./ssh/ssh_keygen.md)

### Tools
- [Rsync](./tools/__rsync__.sh)
- [ADB](./tools/adb.md)
- [Cloud SDK](./tools/cloud_sdk.md)
- [Google Service Account Credentials](./tools/google_sa_cred.md)
- [Hyper-V VM Resources](./tools/hyperv-vm-res.md)
- [Install WineHQ](./tools/install_winehq.sh)
- [MVFS Folder](./tools/mvfs_folder.sh)
- [PlayOnLinux](./tools/playonlinux.sh)
- [Private Registry](./tools/private_registry.py)
- [SCP](./tools/scp.md)
- [TightVNC Server](./tools/tightvncserver.md)
- [Wget Copy](./tools/wget_copy.sh)

### Windows
- [Setup Dev Environment](./windows/__setup_dev__.ps1)
- [Setup Environment](./windows/__setup_env__.ps1)
- [Install Docker](./windows/install-docker.ps1)
- [Install MSI](./windows/install-msi.ps1)
- [Set Environment](./windows/set-env.ps1)
- [Test CLI](./windows/test-cli.ps1)
- [Windows Server Password Reset](./windows/win-ser-pass-reset.md)
