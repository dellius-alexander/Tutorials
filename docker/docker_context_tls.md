# Add Docker Context with TLS Verify

## CREATE a secure connection to a remote container runtime environment over TLS

Run the command to connect to a remote container runtime over TLS

```bash
# add new remote docker runtime
docker context create \
--description "a summary about this CNI" \
--docker "host=tcp://<ip address>:2376,\
ca=~/.docker/cert/qnap/ca.pem,\
cert=~/.docker/cert/qnap/cert.pem,\
key=~/.docker/cert/qnap/key.pem" \
<container runtime custom name>

# use the new remote docker runtime
docker context use <container runtime custom name>
```
