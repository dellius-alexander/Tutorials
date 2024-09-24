# Docker Context Usage

---

## Docker Context import

The `docker context import` command is used to import Docker contexts from a JSON file. A Docker context 
allows you to define and manage multiple environments (local, remote, cloud, etc.) for Docker CLI commands. 
The `docker context import` command simplifies switching between these environments by using pre-configured settings.

Here's how you can use `docker context import` to import a context from a JSON file.

### Step-by-Step Process for Using `docker context import`

1. **Create a Context JSON File**
   First, you need a JSON file that defines the Docker context settings. This file includes details such as the Docker host (remote or local), certificates, TLS settings, and so on.

   Here’s an example of a `mycontext.json` file:

   ```json
   {
     "Name": "my-remote-context",
     "Metadata": {
       "Description": "This is a remote Docker context for development."
     },
     "Endpoints": {
       "docker": {
         "Host": "ssh://user@remote-server-ip",
         "SkipTLSVerify": false
       }
     },
     "TLSMaterial": {}
   }
   ```

   This file defines a context named `my-remote-context` that uses an SSH connection to a remote server with `user@remote-server-ip`.

2. **Import the JSON Context**
   Use the `docker context import` command to import the context from the JSON file:

   ```bash
   docker context import my-remote-context mycontext.json
   ```

   This command imports the context with the name `my-remote-context`, using the configuration from `mycontext.json`.

3. **Verify the Imported Context**
   Once the context is imported, you can verify that it was successfully added by listing all available contexts:

   ```bash
   docker context ls
   ```

   You should see your `my-remote-context` listed in the output.

4. **Use the Imported Context**
   To switch to the newly imported context, use the following command:

   ```bash
   docker context use my-remote-context
   ```

   This will switch Docker's CLI environment to the imported context.

5. **Test the Context**
   Run a simple Docker command to test if your context works:

   ```bash
   docker ps
   ```

   This should show the running containers on the remote host specified in the `mycontext.json` file.

### Full Example Workflow

Here’s an example workflow from start to finish:

1. **Create a `mycontext.json` file**:

   ```json
   {
     "Name": "my-remote-context",
     "Metadata": {
       "Description": "This is a remote Docker context for development."
     },
     "Endpoints": {
       "docker": {
         "Host": "ssh://user@192.168.1.100",
         "SkipTLSVerify": false
       }
     },
     "TLSMaterial": {}
   }
   ```

2. **Run the import command**:

   ```bash
   docker context import my-remote-context mycontext.json
   ```

3. **List available contexts**:

   ```bash
   docker context ls
   ```

   Output:

   ```
   NAME                  DESCRIPTION                            DOCKER ENDPOINT                     KUBERNETES ENDPOINT   ORCHESTRATOR
   default *             Current DOCKER_HOST based configuration unix:///var/run/docker.sock
   my-remote-context     This is a remote Docker context for development.  ssh://user@192.168.1.100
   ```

4. **Switch to the imported context**:

   ```bash
   docker context use my-remote-context
   ```

5. **Test the context**:

   ```bash
   docker ps
   ```

   This will list the running containers on the remote Docker host.

---

## Docker Context import Expanded TLS and SSH

To expand the `docker context import` workflow to include SSH with password-based authentication 
and TLS settings, we need to modify the JSON configuration to include the SSH authentication s
ettings and TLS material (certificates, keys, etc.).

Here's how you can set it up:

### Step 1: Create the JSON Context with SSH and TLS

The Docker context configuration can include TLS and SSH details like certificates for secure 
communication, and SSH credentials for authentication (using password or key-based authentication).

Here's an example of the `mycontext.json` file that includes both SSH with password authentication and TLS configuration.

#### Example `mycontext.json`:

```json
{
  "Name": "my-secure-remote-context",
  "Metadata": {
    "Description": "Docker context for remote server using SSH and TLS"
  },
  "Endpoints": {
    "docker": {
      "Host": "ssh://user@remote-server-ip",
      "SkipTLSVerify": false
    }
  },
  "TLSMaterial": {
    "docker": [
      {
        "cert.pem": "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----",
        "key.pem": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----",
        "ca.pem": "-----BEGIN CERTIFICATE-----\n...\n-----END CERTIFICATE-----"
      }
    ]
  },
  "Auth": {
    "ssh": {
      "Method": "password",
      "Password": "your_secure_password"
    }
  }
}
```

### Explanation of Key Fields:

- **`Host`**: This defines the Docker host where the remote Docker engine is running. In this case, it’s accessed via SSH (`ssh://user@remote-server-ip`).
- **`SkipTLSVerify`**: This indicates whether to skip TLS verification. Set it to `false` to enable TLS certificate verification.
- **`TLSMaterial`**: This contains the TLS certificates and keys. You can provide the certificate (`cert.pem`), key (`key.pem`), and the CA certificate (`ca.pem`) for secure communication between Docker clients and servers.
- **`Auth`**: This section defines the SSH authentication method. Here, `Method` is set to `password`, and the `Password` field holds the password for SSH login.

### Step 2: Import the Context with `docker context import`

Once the JSON configuration file (`mycontext.json`) is ready, import it using the `docker context import` command:

```bash
docker context import my-secure-remote-context mycontext.json
```

This will import the context into Docker.

### Step 3: Verify the Imported Context

After importing, you can verify that the context has been successfully added by listing all available Docker contexts:

```bash
docker context ls
```

You should see something like this:

```
NAME                    DESCRIPTION                           DOCKER ENDPOINT                     KUBERNETES ENDPOINT   ORCHESTRATOR
default *               Current DOCKER_HOST based configuration unix:///var/run/docker.sock
my-secure-remote-context Docker context for remote server using SSH and TLS  ssh://user@remote-server-ip
```

### Step 4: Switch to the Imported Context

To use the newly imported context, switch to it:

```bash
docker context use my-secure-remote-context
```

### Step 5: Test the Connection

You can test the connection to ensure that Docker commands are working over SSH and TLS. For example, list the running containers on the remote host:

```bash
docker ps
```

If everything is configured correctly, it will display the running containers on the remote server.

### Step 6: Secure the Password

Since the password is stored in plain text in the JSON file, it is essential to secure it, especially in production environments. Use one of the following alternatives:

- **Environment Variables**: Use environment variables to store sensitive information instead of hardcoding it in the JSON file.
  
  Update the JSON like this:
  
  ```json
  {
    "Auth": {
      "ssh": {
        "Method": "password",
        "Password": "$DOCKER_SSH_PASSWORD"
      }
    }
  }
  ```

  Then, set the environment variable before importing the context:

  ```bash
  export DOCKER_SSH_PASSWORD=your_secure_password
  ```

- **Secrets Management**: Use Docker secrets or external secrets management systems (e.g., HashiCorp Vault, AWS Secrets Manager) to store and retrieve the password securely.

### Using SSH Key-Based Authentication Instead of Password

It’s generally more secure to use SSH key-based authentication. To set that up, modify the `Auth` section in the JSON file to use the SSH private key.

Example:

```json
{
    "Name": "my-secure-remote-context",
    "Metadata": {
        "Description": "Docker context for remote server using SSH and TLS",
        "Author": "Context Creator or Admin ID",
        "Created": "2024-09-13T14:00:00Z",
        "Updated": "2024-09-13T14:00:00Z",
        "HostName": "remote-server-ip",
        "Port": 22
    },
    "Endpoints": {
        "docker": {
            "Host": "user@remote-server-ip:port | hostname | domain name | ssh hostname",
            "SkipTLSVerify": false
        }
    },
    "TLSMaterial": {},
    "Auth": {
      "ssh": {
        "Method": "privatekey",
        "PrivateKeyPath": "/path/to/your/privatekey",
        "Passphrase": "$DOCKER_SSH_PASSWORD"
      }
    }
}
```

In this configuration:
- **`PrivateKeyPath`**: Path to the SSH private key for authentication.
- **`Passphrase`**: (Optional) Passphrase for the SSH key.

### Example Workflow Recap

Here is the full workflow for setting up a Docker context with SSH and TLS, using password authentication:

1. **Create a `mycontext.json` file** with the correct configuration for SSH and TLS.
2. **Run the import command**:
   ```bash
   docker context import my-secure-remote-context mycontext.json
   ```
3. **Verify the context** with:
   ```bash
   docker context ls
   ```
4. **Switch to the context**:
   ```bash
   docker context use my-secure-remote-context
   ```
5. **Test the connection** by running:
   ```bash
   docker ps
   ```

By following these steps, you'll have a Docker context configured to securely connect to a remote Docker engine using SSH and TLS with password-based authentication.

---

## Running a Secondary Command on Remote Docker Host

To run a secondary command like `docker ps` that requires SSH access to a remote server and automatically insert a password, you can use the `sshpass` tool. This tool allows you to pass a password non-interactively for SSH commands. Here's how you can do it:


### Option 1: Run SSH with Password Automatically

You can run a command like `docker ps` on a remote Docker host using `sshpass` to provide the SSH password. Here’s an example command to run `docker ps` remotely:

```bash
sshpass -p 'your_password' ssh -o StrictHostKeyChecking=no user@remote-server docker ps
```

- Replace `your_password` with the actual password.
- Replace `user` with your SSH username.
- Replace `remote-server` with the remote Docker host address (e.g., `docker.example.com`).
  
The `-o StrictHostKeyChecking=no` option prevents SSH from prompting for confirmation to add the host to the list of known hosts.

### Option 2: Use with Docker Context

If you're using Docker contexts for remote management and want to run Docker commands like `docker ps` with password automation, you can also set it up with `sshpass` and Docker’s SSH context:

```bash
sshpass -p 'your_password' docker --context my-remote-context ps
```

### Example Use Case with Docker:

```bash
sshpass -p 'your_password' ssh -o StrictHostKeyChecking=no user@remote-server docker ps
```

This command will automatically insert the password and execute the `docker ps` command on the remote server without requiring user interaction.

### Security Warning

Using `sshpass` with a plaintext password in the command line is insecure because your password can be visible in the process list and shell history. For a more secure approach, consider:

- Using SSH key-based authentication.
- Storing passwords in environment variables or using a password manager tool.

If you still want to proceed with `sshpass`, consider wrapping the password in a script that is secured from exposure.
