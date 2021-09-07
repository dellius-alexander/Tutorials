# Setup Docker To Use GPU

## Setup Nvidia Toolkit

[Click here for more platforms](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html), I only cover Debian installation below.

### Pre-Requisites

### NVIDIA Drivers

Before you get started, make sure you have installed the NVIDIA driver for your Linux distribution. The recommended way to install drivers is to use the package manager for your distribution but other installer mechanisms are also available (e.g. by downloading .run installers from NVIDIA Driver Downloads).

For instructions on using your package manager to install drivers from the official CUDA network repository, follow the steps in this guide.

### Platform Requirements

The list of prerequisites for running NVIDIA Container Toolkit is described below:

1. GNU/Linux x86_64 with kernel version > 3.10

2. Docker >= 19.03 (recommended, but some distributions may include older versions of Docker. The minimum supported version is 1.12)

3. NVIDIA GPU with Architecture >= Kepler (or compute capability 3.0)

4. NVIDIA Linux drivers >= 418.81.07 (Note that older driver releases or branches are unsupported.)

### Setting up NVIDIA Container Toolkit

Setup the stable repository and the GPG key:
```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
```

*Note: To get access to experimental features such as CUDA on WSL or the new MIG capability on A100, you may want to add the experimental branch to the repository listing:*

```bash
curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
```

Install the `nvidia-docker2` package (and dependencies) after updating the package listing:

```bash
sudo apt-get update
sudo apt-get install -y nvidia-docker2
```
Restart the Docker daemon to complete the installation after setting the default runtime:

sudo systemctl restart docker
At this point, a working setup can be tested by running a base CUDA container:

```bash
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
```

This should result in a console output shown below:

```bash
Tue Sep  7 18:15:04 2021       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 460.91.03    Driver Version: 460.91.03    CUDA Version: 11.2     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  GeForce GTX 670MX   Off  | 00000000:01:00.0 N/A |                  N/A |
| N/A   39C    P8    N/A /  N/A |    199MiB /  3010MiB |     N/A      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+

```
## [See Docker Docs for use cases](https://docs.docker.com/config/containers/resource_constraints/#access-an-nvidia-gpu)
