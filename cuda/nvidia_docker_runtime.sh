#!/usr/bin/env bash
#####################################################################
# To register the nvidia runtime, use the method below that 
# is best suited to your environment. You might need to 
# merge the new argument with your existing configuration. 
# Three options are available:
#####################################################################
# 1. Systemd drop-in file
# -  add a new docker service for the nvidia-container-runtime
mkdir -p /etc/systemd/system/docker.service.d
# -  Add the docker service to use nvidia-container-runtime
tee /etc/systemd/system/docker.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd --host=fd:// --add-runtime=nvidia=/usr/bin/nvidia-container-runtime
EOF
# -  restart the docker daemon
systemctl daemon-reload \
    && systemctl restart docker
#####################################################################
# 2. Daemon configuration file
# -  The nvidia runtime can also be registered with Docker 
#    using the daemon.json configuration file: 
# -  You can optionally reconfigure the default runtime by adding the following to /etc/docker/daemon.json

tee /etc/docker/daemon.json <<EOF
{
    // "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
sudo pkill -SIGHUP dockerd
#####################################################################
# 3. Command Line
# -  Use dockerd to add the nvidia runtime:
dockerd --add-runtime=nvidia=/usr/bin/nvidia-container-runtime [...]

#####################################################################
# 4. Check so see how many GPUs are registrered with CUDA
# -  we have completed the setup of CUDA. ENJOY...
docker run --rm --gpus all nvidia/cuda:11.0-base  nvidia-smi --query-gpu=uuid --format=csv
