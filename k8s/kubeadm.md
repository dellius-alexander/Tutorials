<!-- https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-config/ -->

# ***Kubeadm Command***
---

## ***Kubeadm init***
---

### ***To bootstrap a Kubernetes control-plane node use:***

```bash
kubeadm init [ flags | -h, --help ]
```

```bash
kubeadm init phase [command]

Available Commands:
    # Install required addons for passing conformance tests
    addon
    # Generates bootstrap tokens used to join a node to a cluster
    bootstrap-token
    # Certificate generation
    certs
    # Generate all static Pod manifest files necessary to establish the control plane
    control-plane
    # Generate static Pod manifest file for local etcd
    etcd
    # Generate all kubeconfig files necessary to establish the control plane and the admin kubeconfig file
    kubeconfig
    # Updates settings relevant to the kubelet after TLS bootstrap
    kubelet-finalize
    # Write kubelet settings and (re)start the kubelet
    kubelet-start
    # Mark a node as a control-plane
    mark-control-plane 
    # Run pre-flight checks
    preflight
    # Upload certificates to kubeadm-certs
    upload-certs
    # Upload the kubeadm and kubelet configuration to a ConfigMap
    upload-config

Flags:
    # help for phase
    -h, --help   

Global Flags:
    # If true, adds the file directory to the header of the log messages
    --add-dir-header
    # If non-empty, use this log file
    --log-file string
    # Defines the maximum size a log file can grow to. Unit is megabytes. 
    # If the value is 0, the maximum file size is unlimited. (default 1800)
    --log-file-max-size uint
    # If true, only write logs to their native severity level 
    # (vs also writing to each lower severity level)
    --one-output
    # [EXPERIMENTAL] The path to the 'real' host root filesystem.
    --rootfs string
    # If true, avoid header prefixes in the log messages
    --skip-headers
    # If true, avoid headers when opening log files
    --skip-log-headers
    # number for the log level verbosity
    -v, --v Level                  

Use "kubeadm init phase [command] --help" for more information about a command.
```

### ***Uploading control-plane certificates to the cluster***

By adding the flag --upload-certs to kubeadm init you can temporary upload the control-plane certificates to a Secret in the cluster. Please note that this Secret will expire automatically after 2 hours. The certificates are encrypted using a 32byte key that can be specified using --certificate-key. The same key can be used to download the certificates when additional control-plane nodes are joining, by passing --control-plane and --certificate-key to kubeadm join.
<br/><br/>
The following phase command can be used to re-upload the certificates after expiration:
<br/>
- If the flag --certificate-key is not passed to kubeadm init and kubeadm init phase upload-certs a new key will be generated automatically.
<br/>
```bash
kubeadm init phase upload-certs --upload-certs --certificate-key=SOME_VALUE --config=SOME_YAML_FILE
```

### ***Options***

```bash
# The IP address the API Server will advertise it's listening on. If not set the default network interface will be used.
--apiserver-advertise-address string
```

```bash
# Port for the API Server to bind to.
--apiserver-bind-port int32     Default: 6443
```

```bash
# Optional extra Subject Alternative Names (SANs) to use for the API Server serving certificate. Can be both IP addresses and DNS names.
--apiserver-cert-extra-sans strings
```

```bash
# The path where to save and store the certificates.
--cert-dir string     Default: "/etc/kubernetes/pki"
```

```bash
# Key used to encrypt the control-plane certificates in the kubeadm-certs Secret.
--certificate-key string
```

```bash
# Path to a kubeadm configuration file.
--config string
```

```bash
# Specify a stable IP address or DNS name for the control plane.
--control-plane-endpoint string
```

```bash
# Path to the CRI socket to connect. If empty kubeadm will try to auto-detect this value; use this option only if you have more than one CRI installed or if you have non-standard CRI socket.
--cri-socket string
```

```bash
# Don't apply any changes; just output what would be done.
--dry-run
```

```bash
# A set of key=value pairs that describe feature gates for various features. Options are:
# IPv6DualStack=true|false (BETA - default=true)
# PublicKeysECDSA=true|false (ALPHA - default=false)
# RootlessControlPlane=true|false (ALPHA - default=false)
--feature-gates string
```

```bash
# help for init
-h, --help
```

```bash
# A list of checks whose errors will be shown as warnings. Example: 'IsPrivilegedUser,Swap'. Value 'all' ignores errors from all checks.
--ignore-preflight-errors strings
```

```bash
# Choose a container registry to pull control plane images from
--image-repository string     Default: "k8s.gcr.io"
```

```bash
# Choose a specific Kubernetes version for the control plane.
--kubernetes-version string     Default: "stable-1"
```

```bash
# Specify the node name.
--node-name string
```

```bash
# Path to a directory that contains files named "target[suffix][+patchtype].extension". For example, "kube-apiserver0+merge.yaml" or just "etcd.json". "target" can be one of "kube-apiserver", "kube-controller-manager", "kube-scheduler", "etcd". "patchtype" can be one of "strategic", "merge" or "json" and they match the patch formats supported by kubectl. The default "patchtype" is "strategic". "extension" must be either "json" or "yaml". "suffix" is an optional string that can be used to determine which patches are applied first alpha-numerically.
--patches string
```

```bash
# Specify range of IP addresses for the pod network. If set, the control plane will automatically allocate CIDRs for every node.
--pod-network-cidr string
```

```bash
# Use alternative range of IP address for service VIPs.
--service-cidr string     Default: "10.96.0.0/12"
```

```bash
# Use alternative domain for services, e.g. "myorg.internal".
--service-dns-domain string     Default: "cluster.local"
```

```bash
# Don't print the key used to encrypt the control-plane certificates.
--skip-certificate-key-print
```

```bash
# List of phases to be skipped
--skip-phases strings
```

```bash
# Skip printing of the default bootstrap token generated by 'kubeadm init'.
--skip-token-print
```

```bash
# The token to use for establishing bidirectional trust between nodes and control-plane nodes. The format is [a-z0-9]{6}.[a-z0-9]{16} - e.g. abcdef.0123456789abcdef
--token string
```


```bash
# The duration before the token is automatically deleted (e.g. 1s, 2m, 3h). If set to '0', the token will never expire
--token-ttl duration     Default: 24h0m0s
```


```bash
# Upload control-plane certificates to the kubeadm-certs Secret.
--upload-certs
```


# kubeadm config

```bash
#################################################

#################################################
# to bootstrap a Kubernetes worker node and join it to the cluster
kubeadm join [ flags | -h, --help ]

#################################################
# to upgrade a Kubernetes cluster to a newer version
kubeadm upgrade [ flags | -h, --help ]

#################################################
# if you initialized your cluster using kubeadm v1.7.x or lower, to configure your cluster for kubeadm upgrade
kubeadm config [ flags | -h, --help ]

# print the default configuration
kubeadm config print [ flags | -h, --help ]

# This command prints objects such as the default init configuration that is used for 'kubeadm init'.  Options inherited from parent commands: --kubeconfig string     Default: "/etc/kubernetes/admin.conf"
kubeadm config print init-defaults [ flags | -h, --help ]

# This command prints objects such as the default join configuration that is used for 'kubeadm join'.  Options inherited from parent commands: --kubeconfig string     Default: "/etc/kubernetes/admin.conf"
kubeadm config print join-defaults [ flags | --component-configs strings | -h, --help ] 


# This command lets you convert configuration objects of older versions to the latest supported version, locally in the CLI tool without ever touching anything in the cluster. In this version of kubeadm, the following API versions are supported:
# kubeadm.k8s.io/v1beta3
#--new-config string
#Path to the resulting equivalent kubeadm config file using the new API version. Optional, if not specified output will be sent to STDOUT.
#--old-config string
#Path to the kubeadm config file that is using an old API version and should be converted. This flag is mandatory.
# Options inherited from parent commands
# --kubeconfig string     Default: "/etc/kubernetes/admin.conf"
# The kubeconfig file to use when talking to the cluster. If the flag is not set, a set of standard locations can be searched for an existing kubeconfig file.
# --rootfs string
#[EXPERIMENTAL] The path to the 'real' host root filesystem.
kubeadm config migrate [flags | --new-config string | --old-config string | -h, --help]

# Print a list of images kubeadm will use. The configuration file is used in case any images or image repositories are customized
# Options
# --allow-missing-template-keys     Default: true
# If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.
# --config string
#Path to a kubeadm configuration file.
# -o, --experimental-output string     Default: "text"
# Output format. One of: text|json|yaml|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-as-json|jsonpath-file.
# --feature-gates string
# A set of key=value pairs that describe feature gates for various features. Options are:
# IPv6DualStack=true|false (BETA - default=true)
#PublicKeysECDSA=true|false (ALPHA - default=false)
# RootlessControlPlane=true|false (ALPHA - default=false)
# --image-repository string     Default: "k8s.gcr.io"
# Choose a container registry to pull control plane images from
# --kubernetes-version string     Default: "stable-1"
# Choose a specific Kubernetes version for the control plane.
# --show-managed-fields
# If true, keep the managedFields when printing objects in JSON or YAML format.
kubeadm config images list [ flags | -h, --help  ]


# Pull images used by kubeadm
# Options
# --config string
# Path to a kubeadm configuration file.
# --cri-socket string
# Path to the CRI socket to connect. If empty kubeadm will try to auto-detect this value; use this option only if you have more than one CRI installed or if you have non-standard CRI socket.
# --feature-gates string
# A set of key=value pairs that describe feature gates for various features. Options are:
# IPv6DualStack=true|false (BETA - default=true)
# PublicKeysECDSA=true|false (ALPHA - default=false)
# RootlessControlPlane=true|false (ALPHA - default=false)
# --image-repository string     Default: "k8s.gcr.io"
# Choose a container registry to pull control plane images from
# --kubernetes-version string     Default: "stable-1"
# Choose a specific Kubernetes version for the control plane.
# Options inherited from parent commands
# --kubeconfig string     Default: "/etc/kubernetes/admin.conf"
# The kubeconfig file to use when talking to the cluster. If the flag is not set, a set of standard locations can be searched for an existing kubeconfig file.
# --rootfs string
# [EXPERIMENTAL] The path to the 'real' host root filesystem.
kubeadm config images pull [flags]
#################################################
# Uploading control-plane certificates to the cluster
# By adding the flag --upload-certs to kubeadm init you can temporary upload the control-plane certificates to a Secret in the cluster. Please note that this Secret will expire automatically after 2 hours. The certificates are encrypted using a 32byte key that can be specified using --certificate-key. The same key can be used to download the certificates when additional control-plane nodes are joining, by passing --control-plane and --certificate-key to kubeadm join.
# The following phase command can be used to re-upload the certificates after expiration.  
# Setting the node name 
# By default, kubeadm assigns a node name based on a machine's host address. You can override this setting with the --node-name flag. The flag passes the appropriate --hostname-override value to the kubelet.

#################################################
# to manage tokens for kubeadm join
kubeadm token [ flags | -h, --help ]

# Generate a token. This token must have the form <6 character string>.<16 character string>. More formally, it must match the regex: [a-z0-9]{6}\.[a-z0-9]{16}.
# kubeadm can generate a token for you:
kubeadm token generate

#################################################
# to revert any changes made to this host by kubeadm init or kubeadm join
kubeadm reset [ flags | -h, --help ]

#################################################
# to manage Kubernetes certificates
kubeadm certs [ flags | -h, --help ]

# The following command can be used to generate a new key on demand:
kubeadm certs certificate-key

#################################################
# to manage kubeconfig files
kubeadm kubeconfig [ flags | -h, --help ]

#################################################
# to print the kubeadm version
kubeadm version

#################################################
# to preview a set of features made available for gathering feedback from the community
kubeadm alpha [ flags | -h, --help ]

#################################################

#


# Setting the node name 
# By default, kubeadm assigns a node name based on a machine's host address. You can override this setting with the --node-name flag. The flag passes the appropriate --hostname-override value to the kubelet.
```


