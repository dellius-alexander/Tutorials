# Create Secret for Docker Registry
***[Reference Documentation](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)***

## Create a secret for use with a Docker registry.

***Synopsis:***

Create a new secret for use with Docker registries.

A Kubernetes cluster uses the Secret of `kubernetes.io/dockerconfigjson` type to authenticate with a container registry to pull a private image.

Docker secrets are used to authenticate against Docker registries.

When using the Docker command line to push images, you can authenticate to a given registry by running: 

```bash
docker login DOCKER_REGISTRY_SERVER_URL \
--username=DOCKER_USER \
--password=DOCKER_PASSWORD \
--email=DOCKER_EMAIL
```

That produces a `~/.docker/config.json` file that is used by subsequent `docker push` and `docker pull` commands to authenticate to the registry.

In kubernetes when creating applications, you may have a Docker registry that requires authentication. In order for the nodes to pull images from your private registry, the credentials stored in `kubernetes.io/dockerconfigjson` is used to authenticate against the registry. You can use the information in the `~/.docker/config.json` file to hold the secret and attach it to a `kubernetes.io/dockerconfigjson` object and finally to your service account.

If you already ran docker login, you can copy that credential into Kubernetes with:

Since you already ran docker login, you can copy that credential into a `kubernetes.io/dockerconfigjson` file object by using the following command:

```bash
# create a docker-private registry secret, and test using [ --dry-run | --dry-run=client ]
$ kubectl create secret docker-registry NAME \
--docker-username=user \
--docker-password=password \
--docker-email=email \
[--docker-server=string] \
[--from-literal=key1=value1] \
[--dry-run]

# Or you can use the below syntax:
# If you need more control (for example, to set a namespace or a label on the new secret) then you can customise the Secret before storing it. Be sure to:
# - set the name of the data item to .dockerconfigjson
# - base64 encode the docker file and paste that string, unbroken as the value for field data[".dockerconfigjson"]
# - set type to kubernetes.io/dockerconfigjson
$ kubectl create secret generic NAME \
--from-file=.dockerconfigjson=<path/to/.docker/config.json> \
--type=kubernetes.io/dockerconfigjson

# To view your secret:
$ kubectl get secrets docker-hub-registry -o yaml

apiVersion: v1
data:
  .dockerconfigjson: <Redacted>
kind: Secret
metadata:
  creationTimestamp: "2021-08-14T17:24:32Z"
  name: docker-hub-registry
  namespace: default
  resourceVersion: "31918"
  uid: 9b6edd4f-1100-48c4-a157-18a07891ed0e
type: kubernetes.io/dockerconfigjson
```

***Options:*** 

- These are available for use with `kubectl create secret [ docker-registry ]` command.

```bash
# --docker-email="": Email for Docker registry
# --docker-password="": Password for Docker registry authentication
# --docker-server="https://index.docker.io/v1/": Server location for Docker registry
# --docker-username="": Username for Docker registry authentication
# --dry-run[=false]: If true, only print the object that would be sent, without sending it.
# --generator="secret-for-docker-registry/v1": The name of the API generator to use.
# --no-headers[=false]: When using the default output, don't print headers.
# -o, --output="": Output format. One of: json|yaml|wide|name|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=... See golang template [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template [http://releases.k8s.io/release-1.2/docs/user-guide/jsonpath.md].
# --output-version="": Output the formatted object with the given group version (for ex: 'extensions/v1beta1').
# --save-config[=false]: If true, the configuration of current object will be saved in its annotation. This is useful when you want to perform kubectl apply on this object in the future.
# --schema-cache-dir="~/.kube/schema": If non-empty, load/store cached API schemas in this directory, default is '$HOME/.kube/schema'
# -a, --show-all[=false]: When printing, show all resources (default hide terminated pods.)
# --show-labels[=false]: When printing, show all labels as the last column (default hide labels column)
# --sort-by="": If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath expression must be an integer or a string.
# --template="": Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates [http://golang.org/pkg/text/template/#pkg-overview].
# --validate[=true]: If true, use a schema to validate the input before sending it
```

***Options:*** 

- These options are inherited from the parent commands => `kubectl`.


```bash
# The following options can be passed to any command:

# --add-dir-header=false: If true, adds the file directory to the header of the log messages
# --alsologtostderr=false: log to standard error as well as files
# --as='': Username to impersonate for the operation
# --as-group=[]: Group to impersonate for the operation, this flag can be repeated to specify multiple groups.
# --cache-dir='/home/dalexander/.kube/cache': Default cache directory
# --certificate-authority='': Path to a cert file for the certificate authority
# --client-certificate='': Path to a client certificate file for TLS
# --client-key='': Path to a client key file for TLS
# --cluster='': The name of the kubeconfig cluster to use
# --context='': The name of the kubeconfig context to use
# --insecure-skip-tls-verify=false: If true, the server's certificate will not be checked for validity. This will
# make your HTTPS connections insecure
# --kubeconfig='': Path to the kubeconfig file to use for CLI requests.
# --log-backtrace-at=:0: when logging hits line file:N, emit a stack trace
# --log-dir='': If non-empty, write log files in this directory
# --log-file='': If non-empty, use this log file
# --log-file-max-size=1800: Defines the maximum size a log file can grow to. Unit is megabytes. If the value is 0,
# the maximum file size is unlimited.
# --log-flush-frequency=5s: Maximum number of seconds between log flushes
# --logtostderr=true: log to standard error instead of files
# --match-server-version=false: Require server version to match client version
# -n, --namespace='': If present, the namespace scope for this CLI request
# --one-output=false: If true, only write logs to their native severity level (vs also writing to each lower
# severity level)
# --password='': Password for basic authentication to the API server
# --profile='none': Name of profile to capture. One of (none|cpu|heap|goroutine|threadcreate|block|mutex)
# --profile-output='profile.pprof': Name of the file to write the profile to
# --request-timeout='0': The length of time to wait before giving up on a single server request. Non-zero values
# should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don't timeout requests.
# -s, --server='': The address and port of the Kubernetes API server
# --skip-headers=false: If true, avoid header prefixes in the log messages
# --skip-log-headers=false: If true, avoid headers when opening log files
# --stderrthreshold=2: logs at or above this threshold go to stderr
# --tls-server-name='': Server name to use for server certificate validation. If it is not provided, the hostname
# used to contact the server is used
# --token='': Bearer token for authentication to the API server
# --user='': The name of the kubeconfig user to use
# --username='': Username for basic authentication to the API server
# -v, --v=0: number for the log level verbosity
# --vmodule=: comma-separated list of pattern=N settings for file-filtered logging
# --warnings-as-errors=false: Treat warnings received from the server as errors and exit with a non-zero exit code

```

