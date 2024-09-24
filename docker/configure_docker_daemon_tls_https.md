# Use TLS (HTTPS) to protect the Docker daemon socket

## Create a CA, server and client keys with OpenSSL

If you need Docker to be reachable through HTTP rather than SSH in a safe manner, 
you can enable TLS (HTTPS) by specifying the `tlsverify` flag and pointing Docker's 
`tlscacert` flag to a trusted CA certificate.

1. First, on the Docker daemon's host machine, generate CA private key:

   - **Location of the certificate and key files: `/etc/docker/certs.d/`.**

   ```bash
   # Create a directory to store the certificates
   sudo mkdir -p /etc/docker/certs.d/
   # Generate the CA private key
   cd /etc/docker/certs.d/
   # Generate the CA private key
   openssl genrsa -aes256 -out ca-private-key.pem 4096
   Generating RSA private key, 4096 bit long modulus
   ..............................................................................++
   ........++
   e is 65537 (0x10001)
   Enter pass phrase for ca-private-key.pem:
   Verifying - Enter pass phrase for ca-private-key.pem:
   ```

2. Generate the CA public key: (set days for 5 years)

   ```bash
   # Generate the CA public key
   openssl req -new -x509 -key ca-private-key.pem -sha256 -out ca.pem -days 1825
   
   Enter pass phrase for ca-public-key.pem:
   You are about to be asked to enter information that will be incorporated
   into your certificate request.
   What you are about to enter is what is called a Distinguished Name or a DN.
   There are quite a few fields but you can leave some blank
   For some fields there will be a default value,
   If you enter '.', the field will be left blank.
   -----
   Country Name (2 letter code) [AU]:
   State or Province Name (full name) [Some-State]:Queensland
   Locality Name (eg, city) []:Brisbane
   Organization Name (eg, company) [Internet Widgits Pty Ltd]:Docker Inc
   Organizational Unit Name (eg, section) []:Sales
   Common Name (e.g. server FQDN or YOUR name) []:$HOST
   Email Address []:Sven@home.org.au
   ```

3. To create a configuration file for the certificate and update the command to 
use it, follow these steps: 

   - Create a configuration file named ca_config.cnf with the required fields.
   Update the openssl req command to use this configuration file.
   Here is the content for the `ca_config.cnf` file:

   ```bash
   HOST=$(hostname)
   cat > ca_config.cnf <<EOF
   [ req ]
   default_bits       = 4096
   default_md         = sha256
   default_keyfile    = ca-private-key.pem
   prompt             = no
   encrypt_key        = yes
   distinguished_name = req_distinguished_name
   x509_extensions    = v3_req
   
   [ req_distinguished_name ]
   # Country
   C  = US
   # State
   ST = Georgia
   # Locality
   L  = Atlanta
   # Organization
   O  = HYFI Solutions Inc.
   # Organizational Unit
   OU = Information Technology
   # Common Name
   CN = ${HOST}
   # Email Address
   emailAddress = ${EMAIL_ADDRESS}
   
   [ v3_req ]
   # Subject Alternative Name
   subjectAltName = @alt_names
   
   [ alt_names ]
   # DNS Names
   DNS.1 = example.com
   DNS.2 = www.example.com
   # IP Addresses
   IP.1 = 192.168.1.1
   IP.2 = 192.168.1.2
   EOF
   ```
   
   Next, update the openssl req command to use this configuration file:
   
   ```bash
   openssl req -new -x509 -key ca-private-key.pem -sha256 -out ca.pem -days 1825 -config ca_config.cnf
   ```
   
   This command will generate the CA public key using the values specified in the `ca_config.cnf` file.

4. Now that you have a CA (`ca.pem`), we can create a server key (`server-key.pem`) 
and certificate signing request (CSR) (`server.csr`). We will generate the CSR in step 4:

   ```bash
   openssl genrsa -out server-key.pem 4096
   Generating RSA private key, 4096 bit long modulus
   .....................................................................++
   ........................................................................................++
   e is 65537 (0x10001)
   ```
   
5. Generate the server certificate signing request (CSR) (`server.csr`). Make sure 
that "Common Name" matches the hostname you use to connect to Docker:

   - We can use the CSR to generate a self-signed certificate, or we can send the CSR 
   to a Certificate Authority (CA) to sign it. In this example, we will generate a 
   self-signed certificate.

   - **Note**: Replace all instances of `$HOST` in the following example with the DNS 
   name of your Docker daemon's host.

     ```bash
     # Get the hostname of the docker host machine
     HOST=$(hostname)
     # Generate the server certificate signing request (CSR)
     openssl req -subj "/CN=$HOST" -sha256 -new -key server-key.pem -out server.csr
     ```
   
6. Next, we're going to sign the public key with our CA:

   - Since TLS connections can be made through IP address as well as DNS name, the IP 
   addresses need to be specified when creating the certificate. For example, to allow 
   connections using `10.10.10.20` and `127.0.0.1`.
   
   - **Note**: In the above example, IP address `10.10.10.20` represents the IP address 
   of the Docker daemon's host machine and `127.0.0.1` represents the loopback address.

     ```bash
      # Create a file called extfile.cnf with the following content
      echo subjectAltName = DNS:$HOST,IP:10.10.10.20,IP:127.0.0.1 >> extfile.cnf
     ```
   
   - Set the Docker daemon key's extended usage attributes to be used only for server 
   authentication:
    
     ```bash
     echo extendedKeyUsage = serverAuth >> extfile.cnf
     ```
   
   - Now, generate the signed certificate:
   
     ```bash
     # Generate the signed certificate
     openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-private-key.pem \
     -CAcreateserial -out server-cert.pem -extfile extfile.cnf
     
     Signature ok
     subject=/CN=your.host.com
     Getting CA Private Key
     Enter pass phrase for ca-key.pem:
     ```

   - [Authorization plugins](https://docs.docker.com/engine/extend/plugins_authorization/) 
   offer more fine-grained control to supplement authentication from mutual TLS. In 
   addition to other information described in the above document, authorization plugins 
   running on a Docker daemon receive the certificate information for connecting Docker 
   clients.

## Configure Docker daemon to use TLS (HTTPS) with daemon.json

Now, we need to add the TLS configuration to the Docker daemon configuration 
file (`daemon.json`).

1. Add the following lines to the `/etc/docker/daemon.json` file:
    
     ```json
     {
     "hosts": ["unix:///var/run/docker.sock", "tcp://127.0.0.1:2376"],
     "tls": true,
     "tlscert": "/etc/docker/certs.d/server-cert.pem",
     "tlskey": "/etc/docker/certs.d/server-key.pem",
     "tlscacert": "/etc/docker/certs.d/ca.pem"
     }
     ```

2. Restart the Docker daemon to apply the changes:

     ```bash
     sudo systemctl restart docker
     ```

## For client authentication, create a client key and certificate signing request:

This step must be completed on the client machine that will connect to the Docker daemon.

1. Generate the client private key:

     ```bash
     openssl genrsa -out client-key.pem 4096
     Generating RSA private key, 4096 bit long modulus
     ..............................................................................++
     ........++
     e is 65537 (0x10001)
     ```

2. Generate the client certificate signing request (CSR):

     - **Note**: Replace all instances of `$CLIENT_HOST` in the following example with 
       the hostname of the client machine.
     - **Note**: The client certificate signing request (CSR) is generated on the client 
       machine that will connect to the Docker daemon.
     - **Note**: You may save these files in the user home `~/.docker/` directory or in 
       `/etc/docker/certs.d/client/` directory.

     ```bash
     # Create a directory to store the certificates on the client machine
     mkdir -p ~/.docker/certs.d/client/
     cd ~/.docker/certs.d/client/
     # Get the hostname of the client machine
     CLIENT_HOST=$(hostname)
     # Generate the client certificate signing request (CSR)
     openssl req -subj "/CN=${CLIENT_HOST}" -new -key client-key.pem -out client.csr
     ```
3. To make the key suitable for client authentication, create a new extensions config file
on the client machine:

     ```bash
     echo extendedKeyUsage = clientAuth > extfile-client.cnf
     ```
4. Next, we use the docker host machine's CA and the `extfile-client.cnf` file to 
sign the client certificate:

     ```bash
     # Create a directory to store the certificates on the client machine
     mkdir -p /etc/docker/certs.d/client/
     # Generate the client certificate
     cd /etc/docker/certs.d/client/
     # Generate the client certificate by signing the client certificate signing request (CSR)
     openssl x509 -req -days 365 -sha256 -in client.csr -CA ca-private-.pem \
     -CAkey ca-private-key.pem -CAcreateserial -out client-cert.pem \
     -extfile extfile-client.cnf
   
     Signature ok
     subject=/CN=CLIENT_HOST
     Getting CA Private Key
     Enter pass phrase for ca-private-key.pem:
     ```

    - After generating `client-cert.pem` and `server-cert.pem` you can safely remove the two 
   certificate signing requests and extensions config files:

     ```bash
     rm server.csr client.csr extfile.cnf extfile-client.cnf
     ```
   
   - With a default umask of 022, your secret keys are world-readable and writable for 
   you and your group.

5. To protect your keys from accidental damage, remove their write permissions. To make 
them only readable by you, change file modes as follows:

     ```bash
     chmod 0400 ca-private-key.pem server-key.pem client-key.pem
     ```

6. Certificates can be world-readable, but you might want to remove write access to 
prevent accidental damage:

    ```bash
     chmod 0444 ca.pem server-cert.pem client-cert.pem
    ```

7. Now you can make the Docker daemon only accept connections from clients providing a 
certificate trusted by your CA:
   
   - This must be done on the docker host machine.

   ```bash
   dockerd \
    --tlsverify \
    --tlscacert=ca.pem \
    --tlscert=server-cert.pem \
    --tlskey=server-key.pem \
    -H=0.0.0.0:2376
   ```
   
8. To connect to Docker and validate its certificate, provide your client keys, certificates 
and trusted CA:
   - Docker over TLS should run on TCP port 2376. If you want to use a different port,
    you can specify it with the `-H` flag.
   - *This must be done on the client machine.*
   - **Note**: Replace `$HOST` with the hostname of the Docker daemon's host machine.
   
    ```bash
    docker --tlsverify \
     --tlscacert=ca.pem \
     --tlscert=client-cert.pem \
     --tlskey=client-key.pem \
     -H=$HOST:2376 version
    ```

### Secure by default with Docker client ()

If you want to secure your Docker client connections by default, you can move the 
files to the `~/.docker/` directory in your home directory --- and set the `DOCKER_HOST` 
and `DOCKER_TLS_VERIFY` variables as well (instead of passing `-H=tcp://$HOST:2376` and 
`--tlsverify` on every call).

```bash
mkdir -pv ~/.docker/certs.d/client/
cp -v {ca,server-cert,server-key}.pem ~/.docker/certs.d/client/

export DOCKER_HOST=tcp://$HOST:2376 DOCKER_TLS_VERIFY=1
```

Docker now connects securely by default:

```bash
docker ps
```

### Other modes

If you don't want to have complete two-way authentication, you can run 
Docker in various other modes by mixing the flags.

#### Daemon modes

`tlsverify`, `tlscacert`, `tlscert`, `tlskey` set: Authenticate clients
`tls`, `tlscert`, `tlskey`: Do not authenticate clients

#### Client modes

`tls`: Authenticate server based on public/default CA pool
`tlsverify`, `tlscacert`: Authenticate server based on given CA
`tls`, `tlscert`, `tlskey`: Authenticate with client certificate, do not 
authenticate server based on given CA
`tlsverify`, `tlscacert`, `tlscert`, `tlskey`: Authenticate with client 
certificate and authenticate server based on given CA

If found, the client sends its client certificate, so you just need to drop your keys 
into `~/.docker/{ca,cert,key}.pem`. Alternatively, if you want to store your keys 
in another location, you can specify that location using the environment variable 
`DOCKER_CERT_PATH`.

```bash
export DOCKER_CERT_PATH=~/.docker/certs.d/client/
docker --tlsverify ps
```

### Connecting to the secure Docker port using `curl`

To use `curl` to make test API requests, you need to use three extra command line flags:

```bash
curl https://$HOST:2376/images/json \
  --cert ~/.docker/certs.d/client/client-cert.pem \
  --key ~/.docker/certs.d/client/client-key.pem \
  --cacert ~/.docker/certs.d/client/ca.pem
```

### Understand the configuration

A custom certificate is configured by creating a directory under `/etc/docker/certs.d` 
using the same name as the registry's hostname, such as localhost. All `*.crt` files are 
added to this directory as CA roots.

**Note**: On Linux any root certificates authorities are merged with the system 
defaults, including the host's root CA set. If you are running Docker on Windows 
Server, or Docker Desktop for Windows with Windows containers, the system default 
certificates are only used when no custom root certificates are configured.

The presence of one or more `<filename>.key/cert` pairs indicates to Docker that there 
are custom certificates required for access to the desired repository.
```
/etc/docker/certs.d/       <-- Certificate directory
|__ localhost:5000         <-- Hostname:port
   ├── client.cert          <-- Client certificate
   ├── client.key           <-- Client key
   └── ca.crt               <-- Root CA that signed the registry certificate, in PEM
```

### Troubleshooting tips

The Docker daemon interprets `.crt` files as CA certificates and `.cert` files as 
client certificates. If a CA certificate is accidentally given the extension `.cert` 
instead of the correct `.crt` extension, the Docker daemon logs the following error message:

```bash
Missing key KEY_NAME for client certificate CERT_NAME. CA certificates should use the extension .crt.
```




