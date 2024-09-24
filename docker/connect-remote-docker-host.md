# Connect to Remote Docker Host via SSH

***Important: in order for this to work, you must install `ssh-askpass` on both docker host and client***

```bash
# On DEBIAN system use
$ sudo apt install -y ssh-askpass
# On Rehl systems use
$ sudo yum install -y openssh-askpass
```

---

## Use SSH to protect the Docker daemon socket

A single `Docker CLi` can have multiple contexts. Each context contains all of the `endpoint and security` information required to manage a different cluster or node. The `docker context` command makes it easy to configure these contexts and switch between them. Once these contexts are configured, you can use the top-level `docker context use <context-name>` to easily switch between cluster or node.

### The anatomy of a Docker context

```TEXT
A context is a combination of several properties. These include:

- Name
- Endpoint configuration
- TLS info
- Orchestrator

```

*Note: The given `USERNAME` must have permissions to access the docker socket on the remote machine. Refer to [manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) to learn how to give a non-root user access to the docker socket.*

### Create a new context

You can create new contexts with the `docker context create` command.

```bash
$  docker context create \
    --docker host=ssh://< USERNAME >@docker-host.example.com \
    --description="Remote engine description" \
    --default-stack-orchestrator="swarm" \
    my-remote-engine
    
my-remote-engine-name
Successfully created context "my-remote-engine"
```

***The new context is stored in a `meta.json` file below `~/.docker/contexts/`. Each new context you create gets its own meta.json stored in a dedicated sub-directory of `~/.docker/contexts/`.***

After creating the context, use docker context use to switch the docker CLI to use it, and to connect to the remote engine:

```bash
$ docker context use my-remote-engine

my-remote-engine
Current context is now "my-remote-engine"

$ docker info
# Enter the password of your remote docker engine on the first context use
<prints output of the remote engine>
```

Access the details of `default` or `my-remote-engine` use the `docker context inspect <CONTEXT NAME>`. In this example, we’re inspecting the context called default.

```bash
$ docker context inspect my-remote-engine
[
    {
        "Name": "my-remote-engine",
        "Metadata": {
            "Description": "Remote Docker engine on centos7-server as USERNAME@docker-host.example.com, IP=10.0.0.131",
            "StackOrchestrator": "swarm"
        },
        "Endpoints": {
            "docker": {
                "Host": "ssh://USERNAME@docker-host.example.com",
                "SkipTLSVerify": false
            }
        },
        "TLSMaterial": {},
        "Storage": {
            "MetadataPath": "/path/to/.docker/contexts/meta/a8d7b69f9af8af322f5406a7ca22f8a4cca9d7729b6c277d9ab421d13d2cc11b",
            "TLSPath": "/path/to/.docker/contexts/tls/a8d7b69f9af8af322f5406a7ca22f8a4cca9d7729b6c277d9ab421d13d2cc11b"
        }
    }
]

```

### ***SSH Tips***

For the best user experience with SSH, configure ~/.ssh/config as follows to allow reusing a SSH connection for multiple invocations of the docker CLI:

***Create or add the below to your ~/.ssh/config file***

```config
ControlMaster     auto
ControlPath       ~/.ssh/control-%C
ControlPersist    yes
```

You should be able to query docker daemon on remote host

```bash
$ docker ps
<prints output from remote docker host>
```

---
