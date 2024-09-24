# [Install GO](https://golang.org/doc/install)
1. Download G)

```bash
curl -fsSLo go1.17.linux-amd64.tar.gz https://golang.org/dl/go1.17.linux-amd64.tar.gz
```

1. Extract the archive you downloaded into /usr/local, creating a Go tree in /usr/local/go.

***Important:*** This step will remove a previous installation at /usr/local/go, if any, prior to extracting. Please back up any data before proceeding.

For example, run the following as root or through sudo:

```bash
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz
```

2. Add /usr/local/go/bin to the PATH environment variable.

You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):

```bash
export PATH=$PATH:/usr/local/go/bin
```

Note: Changes made to a profile file may not apply until the next time you log into your computer. To apply the changes immediately, just run the shell commands directly or execute them from the profile using a command such as source $HOME/.profile.

3. Verify that you've installed Go by opening a command prompt and typing the following command:

```bash
$ go version
```

4. Confirm that the command prints the installed version of Go.


5. Do it all in one shot.

```bash
curl -fsSLo go1.17.linux-amd64.tar.gz https://golang.org/dl/go1.17.linux-amd64.tar.gz && \
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.linux-amd64.tar.gz && \
export PATH=$PATH:/usr/local/go/bin && \
go version
```