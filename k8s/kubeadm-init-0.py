import argparse
import subprocess
import os
import sys
from pathlib import Path
from time import sleep

# Colors for output formatting
RED = '\033[0;31m'
NC = '\033[0m'

# Function to run shell commands
def run_command(cmd: str, **kwargs):
    """Run a shell command."""
    try:
        return subprocess.run(cmd, shell=True, check=True, **kwargs)
    except subprocess.CalledProcessError as e:
        print(f"Command '{cmd}' failed with error: {e}")
        sys.exit(1)

# Verify kubeadm and kubectl binaries
def verify_binaries():
    """Verify that kubeadm and kubectl binaries are installed."""
    kubeadm = subprocess.getoutput("command -v kubeadm")
    kubectl = subprocess.getoutput("command -v kubectl")
    
    if not kubeadm:
        print("kubeadm binary not found. Please install.")
        sys.exit(1)
    if not kubectl:
        print("kubectl binary not found. Please install.")
        sys.exit(1)
    return True

# Generate a self-signed certificate using custom CA
def generate_certificate(ca_key: str, ca_crt: str):
    """Generate certificates using provided CA key and CA certificate."""
    print(f"Generating self-signed certificates using {ca_key} and {ca_crt}")
    # Commands to generate necessary certificates
    commands = [
        f"openssl genrsa -out server.key 2048",
        f"openssl req -new -key server.key -out server.csr",
        f"openssl x509 -req -in server.csr -CA {ca_crt} -CAkey {ca_key} -CAcreateserial -out server.crt -days 365"
    ]
    for cmd in commands:
        run_command(cmd)

# SSL certificate creation
def generate_certificate_from_conf(cert_dir: Path):
    """Generate SSL certificates for the Kubernetes cluster."""
    cert_dir = Path(cert_dir)
    if not cert_dir.exists():
        cert_dir.mkdir(parents=True, exist_ok=True)
    
    openssl_conf = f"""
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[ dn ]
C = US
ST = GA
L = Atlanta
O = HYFI Solutions, inc
OU = IT
CN = master-01

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
DNS.6 = master-01
DNS.7 = master-01.hyfisolutions.com
DNS.8 = *.hyfisolutions.com
IP.1 = 127.0.0.1
IP.2 = 10.1.0.21

[ v3_ext ]
authorityKeyIdentifier=keyid,issuer:always
basicConstraints=CA:FALSE
keyUsage=keyEncipherment,dataEncipherment
extendedKeyUsage=serverAuth,clientAuth
subjectAltName=@alt_names
"""
    
    openssl_conf_path = cert_dir / "openssl.cnf"
    with open(openssl_conf_path, 'w') as f:
        f.write(openssl_conf)
    
    run_command(f"openssl genrsa -out {cert_dir}/ca.key 4096")
    run_command(f"openssl req -x509 -new -nodes -key {cert_dir}/ca.key -config {openssl_conf_path} -days 365 -out {cert_dir}/ca.crt")

def generate_kubeadm_config(output_dir: Path, advertise_address: str, pod_network_cidr: str):
    """Generate kubeadm-config.yaml for cluster initialization."""
    kubeadm_config = f"""
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "{advertise_address}:6443"
networking:
  podSubnet: "{pod_network_cidr}"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "{advertise_address}"
  bindPort: 6443
"""
    config_path = output_dir / "kubeadm-config.yaml"
    with open(config_path, 'w') as f:
        f.write(kubeadm_config)
    return config_path

def generate_ca_certificate(openssl_conf_path, output_dir):
    """Generate the CA key and certificate."""
    print("Generating CA certificate...")
    os.makedirs(output_dir, exist_ok=True)
    
    ca_key = os.path.join(output_dir, "ca.key")
    ca_crt = os.path.join(output_dir, "ca.crt")
    
    # Generate CA key and certificate
    run_command(f"openssl genpkey -algorithm RSA -out {ca_key} ")
    print(f"Generated: {ca_key}")
    print(f"Generating: {ca_crt} using config file: {openssl_conf_path}")
    run_command(
        f"openssl req -x509 -new -nodes -key {ca_key} -sha256 -config {openssl_conf_path} -days 3650 -out {ca_crt}")
    sleep(1)
    print(f"CA certificate generated: {ca_crt}")
    return ca_key, ca_crt

def generate_component_certificate(component, openssl_conf_path, output_dir, ca_key, ca_crt):
    """Generate certificates for a given Kubernetes component."""
    sleep(1)
    print(f"Generating certificate for {component}...")
    
    component_key = os.path.join(output_dir, f"{component}.key")
    component_csr = os.path.join(output_dir, f"{component}.csr")
    component_crt = os.path.join(output_dir, f"{component}.crt")
    
    try:
        # Generate the component's private key and CSR
        results = run_command(f"openssl genpkey -algorithm RSA -out {component_key}")
        print(f"Generating: {component_key}, \nResults: {results}")
        # Generate the CSR
        results = run_command(
            f"openssl req -new -key {component_key} -out {component_csr} -config {openssl_conf_path} -reqexts v3_req")
        print(f"Generating: {component_csr}, \nResults: {results}")
        # Sign the CSR with the CA
        results = run_command(
            f"openssl x509 -req -in {component_csr} -CA {ca_crt} -CAkey {ca_key} -CAcreateserial -out {component_crt} -days 365 -sha256 -extfile {openssl_conf_path} -extensions {component}")
        
        print(f"Certificate for {component} generated: {component_crt}, \nResults: {results}")
        return component_key, component_crt
    except Exception as e:
        print(f"{RED}{e},\n{results}{NC}")

def generate_kubernetes_certificates(openssl_conf_path, output_dir):
    """Generate certificates for all Kubernetes components."""
    # Generate the CA certificate
    ca_key, ca_crt = generate_ca_certificate(openssl_conf_path, output_dir)
    
    # List of Kubernetes components requiring certificates
    components = [
        "admin", "service-accounts", "kube-api-server",
        "kube-controller-manager", "kube-scheduler",
        "etcd", "kube-proxy"]
    
    # Generate certificates for each component
    for component in components:
        generate_component_certificate(component, openssl_conf_path, output_dir, ca_key, ca_crt)

# Firewall setup function
def setup_firewall():
    """Configure firewall rules for Kubernetes."""
    firewall_cmds = [
        "firewall-cmd --zone=public --add-port=6443/tcp --permanent",
        "firewall-cmd --zone=public --add-port=443/tcp --permanent",
        "firewall-cmd --zone=public --add-port=2379-2380/tcp --permanent",
        "firewall-cmd --zone=public --add-port=10250-10252/tcp --permanent",
        "firewall-cmd --zone=public --add-port=30000-32767/tcp --permanent",
        "firewall-cmd --zone=public --add-port=179/tcp --permanent",
        "firewall-cmd --zone=public --add-port=4/tcp --permanent",
        "firewall-cmd --zone=public --add-port=4789/udp --permanent",
        "firewall-cmd --zone=public --add-port=5473/tcp --permanent",
        "firewall-cmd --reload",
        "firewall-cmd --zone=public --permanent --list-ports"
    ]
    for cmd in firewall_cmds:
        run_command(cmd)
    
    print("Kubernetes Port Assignments: \n")

# Docker and Kubernetes components installation
def install_kubernetes_components():
    """Install Kubernetes components."""
    # Kubernetes installation
    with open('/etc/yum.repos.d/kubernetes.repo', 'w') as f:
        f.write("""
    [kubernetes]
    name=Kubernetes
    baseurl=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/
    enabled=1
    gpgcheck=1
    gpgkey=https://pkgs.k8s.io/core:/stable:/v1.31/rpm/repodata/repomd.xml.key
    exclude=kubelet kubeadm kubectl
    """)
    run_command("yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes")
    run_command("systemctl enable --now kubelet")

def install_containerd():
    """Install and configure containerd as the container runtime."""
    print("Installing containerd...")
    # Install containerd
    run_command("sudo apt-get update && sudo apt-get install -y containerd")
    
    # Configure containerd
    run_command("sudo mkdir -p /etc/containerd")
    run_command("sudo containerd config default | sudo tee /etc/containerd/config.toml")
    run_command("sudo systemctl restart containerd")
    print("containerd installed and configured successfully.")

def install_crio():
    """Install and configure cri-o as the container runtime."""
    print("Installing cri-o...")
    # Commands to install and configure cri-o (based on the OS version)
    run_command(
        "OS=Ubuntu VERSION=20.04 sudo -E sh -c 'echo \"deb [signed-by=/usr/share/keyrings/crio-archive-keyring.gpg] https://packages.crio.io/$(. /etc/os-release; echo $ID) $(lsb_release -cs) stable\" > /etc/apt/sources.list.d/crio.list'")
    run_command("sudo apt-get update && sudo apt-get install -y cri-o cri-o-runc")
    run_command("sudo systemctl daemon-reload")
    run_command("sudo systemctl enable crio --now")
    print("cri-o installed and configured successfully.")

def install_docker():
    """Install and configure Docker as the container runtime."""
    # Install Docker Engine
    print("Installing Docker Engine...")
    run_command("yum install -y yum-utils")
    run_command("yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo")
    run_command("yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin")
    # Configure Docker to use systemd as the cgroup driver
    run_command(
        'sudo mkdir -p /etc/docker && echo \'{"exec-opts": ["native.cgroupdriver=systemd"]}\' | sudo tee /etc/docker/daemon.json')
    run_command("systemctl daemon-reload")
    run_command("systemctl restart docker")
    run_command("systemctl enable docker")
    
    print("Docker Engine installed and configured successfully.")

def configure_kubeadm_runtime(runtime: str):
    """Configure kubeadm to use the selected container runtime."""
    print(f"Configuring kubeadm to use {runtime} as the container runtime...")
    
    kubeadm_config = {
        "containerd": "sudo kubeadm init --cri-socket /run/containerd/containerd.sock --pod-network-cidr=192.168.0.0/16",
        "cri-o": "sudo kubeadm init --cri-socket /var/run/crio/crio.sock --pod-network-cidr=192.168.0.0/16",
        "docker": "sudo kubeadm init --pod-network-cidr=192.168.0.0/16"  # Docker uses default socket
    }
    
    if runtime not in kubeadm_config:
        print(f"Unknown container runtime: {runtime}. Please use 'containerd', 'cri-o', or 'docker'.")
        sys.exit(1)
    
    # Run the appropriate kubeadm initialization command
    run_command(kubeadm_config[runtime])
    print(f"Kubeadm successfully configured with {runtime} runtime.")

# Setup Kubernetes cluster for single node
def setup_single_node_cluster(ca_key: str, ca_crt: str, advertise_address: str, pod_network_cidr: str):
    """Set up a single node Kubernetes cluster."""
    setup_firewall()
    generate_certificate(ca_key, ca_crt)
    
    print("Initializing Kubernetes single-node cluster...")
    kubeadm_config_path = generate_kubeadm_config(Path("/etc/kubernetes"), advertise_address, pod_network_cidr)
    run_command(f"kubeadm init --config {kubeadm_config_path}")
    
    # Set up kubectl configuration
    run_command("mkdir -p $HOME/.kube")
    run_command("sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config")
    run_command("sudo chown $(id -u):$(id -g) $HOME/.kube/config")
    
    print("Kubernetes single-node cluster set up successfully.")

# Setup Kubernetes multi-node cluster
def setup_multi_node_cluster(ca_key: str, ca_crt: str, num_nodes: int, advertise_address: str, pod_network_cidr: str):
    """Set up a multi-node Kubernetes cluster."""
    setup_single_node_cluster(ca_key, ca_crt, advertise_address, pod_network_cidr)
    
    print(f"Setting up {num_nodes - 1} additional nodes...")
    token = subprocess.getoutput("kubeadm token create --print-join-command")
    
    for node in range(1, num_nodes):
        print(f"Setting up node 0{node}")
        run_command(f"ssh worker-0{node} '{token}'")
    
    print("Multi-node cluster set up successfully.")

# Destroy Kubernetes cluster
def destroy_cluster():
    """Destroy the Kubernetes cluster."""
    print("Destroying Kubernetes cluster...")
    run_command("kubeadm reset -f")
    run_command("rm -rf $HOME/.kube")
    print("Kubernetes cluster destroyed successfully.")

# Command line arguments handling
def main(cli_args=None):
    """Main function to handle argument parsing and cluster setup."""
    parser = argparse.ArgumentParser(description="Kubernetes Cluster Setup Tool")
    parser.add_argument("--nodes", type=int, default=1,
                        help="Number of nodes in the cluster (default: 1 for single-node)")
    parser.add_argument("--ca-key", type=str, required=True, help="Path to CA key file (ca.key)")
    parser.add_argument("--ca-crt", type=str, required=True, help="Path to CA certificate file (ca.crt)")
    parser.add_argument("--advertise-address", type=str, default="0.0.0.0", help="API server advertise address")
    parser.add_argument("--pod-network-cidr", type=str, default="192.168.0.0/16", help="Pod network CIDR")
    parser.add_argument("--runtime", type=str, choices=["containerd", "cri-o", "docker"], default="containerd",
                        help="Specify the container runtime (default: containerd)")
    parser.add_argument("--destroy", action="store_true", help="Destroy the Kubernetes cluster")
    
    # Allow testing with predefined arguments if `cli_args` is passed
    if cli_args:
        args = parser.parse_args(cli_args)
    else:
        args = parser.parse_args()
    
    if args.destroy:
        destroy_cluster()
        return
    
    ca_key_path = Path("/".join(args.ca_key.split("/")[0:-1]))
    
    # Create the certificate directory if it does not exist
    if not ca_key_path.exists(follow_symlinks=True):
        print(f"Directory {ca_key_path} does not exists, creating directory now...")
        ca_key_path.mkdir(mode=0o765)
    
    # Verify kubeadm and kubectl binaries
    if not verify_binaries():
        install_kubernetes_components()
    
    # Install the specified container runtime
    if args.runtime == "containerd":
        install_containerd()
    elif args.runtime == "cri-o":
        install_crio()
    elif args.runtime == "docker":
        install_docker()
    
    # Configure kubeadm to use the selected container runtime
    configure_kubeadm_runtime(args.runtime)
    
    # Set up the cluster based on the number of nodes
    if args.nodes == 1:
        setup_single_node_cluster(args.ca_key, args.ca_crt, args.advertise_address, args.pod_network_cidr)
    else:
        setup_multi_node_cluster(args.ca_key, args.ca_crt, args.nodes, args.advertise_address, args.pod_network_cidr)

if __name__ == "__main__":
    main()
    
