#!/bin/bash

# Define directories and files
CA_DIR="~/k8s/certs/CA"
CONF_FILE="$CA_DIR/ca.conf"
CERTS_DIR="$CA_DIR/certsdb"
NEW_CERTS_DIR="$CA_DIR/newcerts"
PRIVATE_DIR="$CA_DIR/private"
CRL_DIR="$CA_DIR/crl"
CERTREQS_DIR="$CA_DIR/certreqs"

# Create necessary directories
mkdir -p $CERTS_DIR $NEW_CERTS_DIR $PRIVATE_DIR $CRL_DIR $CERTREQS_DIR

# Create index and serial files
touch $CA_DIR/index.txt
echo 1000 > $CA_DIR/serial
echo 1000 > $CA_DIR/crlnumber

# Create the CA configuration file
cat > $CONF_FILE <<EOL
[ ca ]
default_ca = CA_default

[ CA_default ]
dir             = $CA_DIR
certs           = $CERTS_DIR
new_certs_dir   = $NEW_CERTS_DIR
database        = $CA_DIR/index.txt
certificate     = $CA_DIR/cacert.pem
private_key     = $PRIVATE_DIR/cakey.pem
serial          = $CA_DIR/serial
crldir          = $CRL_DIR
crlnumber       = $CA_DIR/crlnumber
crl             = $CRL_DIR/crl.pem
RANDFILE        = $PRIVATE_DIR/.rand
default_days    = 365
default_crl_days= 30
default_md      = sha256
policy          = policy_match
x509_extensions = v3_ca
copy_extensions = copy

[ policy_match ]
countryName             = match
stateOrProvinceName     = match
localityName            = optional
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional

[ req ]
default_bits            = 2048
prompt                  = no
default_md              = sha256
distinguished_name      = req_distinguished_name
x509_extensions         = v3_ca
req_extensions          = req_ext

[ req_distinguished_name ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = IT
CN                      = master-01

# Named sections for each component
[kube-apiserver]
distinguished_name = req_distinguished_name_kube_apiserver
prompt             = no
req_extensions     = req_ext

[ req_distinguished_name_kube_apiserver ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = kube-apiserver

[etcd]
distinguished_name = req_distinguished_name_etcd
prompt             = no
req_extensions     = req_ext

[ req_distinguished_name_etcd ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = etcd

[kube-controller-manager]
distinguished_name = req_distinguished_name_kube_controller_manager
prompt             = no
req_extensions     = req_ext

[ req_distinguished_name_kube_controller_manager ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = kube-controller-manager

[kube-scheduler]
distinguished_name = req_distinguished_name_kube_scheduler
prompt             = no
req_extensions     = req_ext

[ req_distinguished_name_kube_scheduler ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = kube-scheduler

[worker-01]
distinguished_name = req_distinguished_name_worker_01
prompt             = no
req_extensions     = req_ext

[ req_distinguished_name_worker_01 ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = worker-01

[worker-02]
distinguished_name = req_distinguished_name_worker_02
prompt             = no
req_extensions     = req_ext


[ req_distinguished_name_worker_02 ]
C                       = US
ST                      = GA
L                       = Atlanta
O                       = HYFI Solutions, inc
OU                      = Kubernetes
CN                      = worker-02

# Extensions for CA certificate
[ v3_ca ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always,issuer:always
basicConstraints        = CA:true
keyUsage                = cRLSign, keyCertSign
subjectAltName          = @alt_names

# Extensions for server certificates (apiserver, etcd, kubelet)
[ v3_server ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
extendedKeyUsage        = serverAuth
subjectAltName          = @alt_names

# Extensions for client certificates (controller-manager, scheduler, kube-proxy)
[ v3_client ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid,issuer
basicConstraints        = CA:FALSE
keyUsage                = digitalSignature, keyEncipherment
extendedKeyUsage        = clientAuth

[ req_ext ]
subjectAltName          = @alt_names

[ alt_names ]
DNS.1 = kubernetes
DNS.2 = kubernetes.default
DNS.3 = kubernetes.default.svc
DNS.4 = kubernetes.default.svc.cluster
DNS.5 = kubernetes.default.svc.cluster.local
DNS.6 = master-01
DNS.7 = master-01.dalexander1618.synology.me
DNS.8 = etcd
DNS.9 = worker-01
DNS.10 = worker-02
IP.1 = 127.0.0.1
IP.2 = 10.1.0.30
IP.3 = 10.96.0.1  # Kubernetes API server ClusterIP
IP.4 = 10.1.0.40  # etcd node IP
IP.5 = 10.1.0.50  # worker-01 node IP
IP.6 = 10.1.0.51  # worker-02 node IP

EOL

# Generate the CA certificate
openssl req -new -x509 -days 365 -nodes -keyout $PRIVATE_DIR/cakey.pem -out $CA_DIR/cacert.pem -config $CONF_FILE

# Function to generate CSR and sign it
generate_and_sign_cert() {
  local component=$1
  local ext=$2
  local dn=$3
  openssl req -new -nodes -out $CERTREQS_DIR/$component.csr -keyout $PRIVATE_DIR/$component.key -config $CONF_FILE -reqexts $ext -subj $dn
  openssl ca -batch -config $CONF_FILE -extensions $ext -in $CERTREQS_DIR/$component.csr -out $CERTS_DIR/$component.pem
}

# Generate and sign certificates for components
generate_and_sign_cert "kube-apiserver" "v3_server" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=kube-apiserver"
generate_and_sign_cert "etcd" "v3_server" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=etcd"
generate_and_sign_cert "kube-controller-manager" "v3_client" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=kube-controller-manager"
generate_and_sign_cert "kube-scheduler" "v3_client" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=kube-scheduler"
generate_and_sign_cert "worker-01" "v3_server" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=worker-01"
generate_and_sign_cert "worker-02" "v3_server" "/C=US/ST=GA/L=Atlanta/O=HYFI Solutions, inc/OU=Kubernetes/CN=worker-02"

echo "Certificates generated successfully."
