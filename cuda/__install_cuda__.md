# Install Cuda


## [Pre-installation Actions](https://docs.nvidia.com/cuda/archive/11.2.2/cuda-installation-guide-linux/index.html#pre-installation-actions):

Some actions must be taken before the CUDA Toolkit and Driver can be installed on Linux:

- Verify the system has a CUDA-capable GPU.
- Verify the system is running a supported version of Linux.
- Verify the system has gcc installed.
- Verify the system has the correct kernel headers and development packages installed.
- Download the NVIDIA CUDA Toolkit.
- Handle conflicting installation methods.

## [Install Cuda](https://docs.nvidia.com/cuda/archive/11.2.2/cuda-installation-guide-linux/index.html#ubuntu-installation):

***Note: [Cuda Tookit Download](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=18.04&target_type=deb_network) cuda here or get network installation guide.***
1. Install repository meta-data
    
    ```bash
    $ sudo dpkg -i cuda-repo-<distro>_<version>_<architecture>.deb
    ```

2. Installing the CUDA public GPG key

    When installing using the local repo:
    
    ```bash
    $ sudo apt-key add /var/cuda-repo-<distro>-<version>/7fa2af80.pub
    ```
    
    When installing using network repo on Ubuntu 20.04/18.04:
    
    ```bash
    $ sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<architecture>/7fa2af80.pub
    ```
    
    When installing using network repo on Ubuntu 16.04:
    
    ```bash
    $ sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/<distro>/<architecture>/7fa2af80.pub
    ```
    
    
    Pin file to prioritize CUDA repository:
    
    ```bash
    $ wget https://developer.download.nvidia.com/compute/cuda/repos/<distro>/<architecture>/cuda-<distro>.pin
    $ sudo mv cuda-<distro>.pin /etc/apt/preferences.d/cuda-repository-pin-600
    ```

3. Post-Installation Actions:

    The post-installation actions must be manually performed. These actions are split into mandatory, recommended, and optional sections. 

    1.  Mandatory Actions:
    
        The PATH variable needs to include `$ export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}`. Nsight Compute has moved to `/opt/nvidia/nsight-compute/` only in `rpm/deb` installation method. When using .run installer it is still located under `/usr/local/cuda-11.2/`.
    
        To add this path to the PATH variable:

        ```bash
        $ export PATH=/usr/local/cuda-11.2/bin${PATH:+:${PATH}}
        ```
        In addition, when using the runfile installation method, the `LD_LIBRARY_PATH` variable needs to contain `/usr/local/cuda-11.2/lib64` on a 64-bit system, or `/usr/local/cuda-11.2/lib` on a 32-bit system

        To change the environment variables for 64-bit operating systems:

        ```bash
        $ export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib64\
                             ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
        ```
    
        To change the environment variables for 32-bit operating systems:
    
        ```bash
        $ export LD_LIBRARY_PATH=/usr/local/cuda-11.2/lib\
                             ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
        ```
    

