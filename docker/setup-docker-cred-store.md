# Setup Docker Credential Store w/ Pass

`Pass` provides commands for adding, removing, editing, and generating secure passwords.

Follow the steps to setup the standard unix password manager to be used by docker credentials helper. Select [Pass](https://www.passwordstore.org/#download) to see installation options.

1. Download [docker-credential-pass](https://github.com/docker/docker-credential-helpers/releases) latest release
2. Extract the `docker-credential-pass` binary to `/usr/local/bin` or `~/.local/bin`. You must add the binary to `$PATH`.

    ```bash
    # Download the latest binary
    $ curl -fsSL https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz -o docker-credential-pass-v0.6.3-amd64.tar.gz
    # Extract to PATH, in this case to ~/.local/bin/docker-credential-pass
    $ tar -xf docker-credential-pass-v0.6.3-amd64.tar.gz -C .local/bin
    # Assign executable permission to Owner & Group
    $ sudo chmod 550 ~/.local/bin/docker-credential-pass
    ```

3. Run `docker-credential-pass (store|get|erase|list|version)` to verify the binary is working correctly.  you should see:
    <br/>

    ```bash
    $ docker-credential-pass list
    {}
    ```

4. Install `gpg` and `pass`:

    *`Pass` isn’t in the default CentOS repositories, but it is in EPEL, which you can add with the following command on CentOS 7.*
    <br/>

    ```bash
    # Package manager will differ depending on your distribution
    $ sudo apt-get install -y gpg pass
    # On RHEL/CentOS enter:
    $ sudo yum install -y epel-release
    $ sudo yum install -y pass
    ```

    ***Note: To install from source see: [password-store.git](https://github.com/zx2c4/password-store.git)***

    ```bash
    # clone the git repo
    $ git clone https://github.com/zx2c4/password-store.git
    $ cd password-store 
    $ sudo make install
    # take note of the installation directories
    ‘man/pass.1’ -> ‘/usr/share/man/man1/pass.1’
    ‘src/completion/pass.bash-completion’ -> ‘/usr/share/bash-completion/completions/pass’
    ‘src/completion/pass.zsh-completion’ -> ‘/usr/share/zsh/site-functions/_pass’
    ‘src/completion/pass.fish-completion’ -> ‘/usr/share/fish/vendor_completions.d/pass.fish’
    install: creating directory ‘/usr/lib/password-store’
    install: creating directory ‘/usr/lib/password-store/extensions’
    ‘src/.pass’ -> ‘/usr/bin/pass’
    ```

5. Generate a gpg key:

    *`Pass` uses a GPG key pair to encrypt password files. If you don’t already have a suitable key pair, you can generate one by following these instructions to [Creating GPG Keys Using the Command Line](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security_guide/sect-security_guide-encryption-gpg-creating_gpg_keys_using_the_command_line) for `RHEL/CentOS` distro's. See [Unattended-GPG-key-generation](https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html) for unattented key generation.*

    Generate gpg key unattended:

    ```bash
    # Create a file gen-key-script below and
    # Run the command: "gpg --batch --gen-key gen-key-script"
    $ gpg --batch --gen-key <<EOF
    Key-Type: 1
    Key-Length: 2048
    Subkey-Type: 1
    Subkey-Length: 2048
    Name-Real: superuser name
    Name-Email: email.address@mail.server.com
    Expire-Date: 0
    EOF
    ```

    Generate gpg key manually:

    ```bash
    # On DEBIAN distro enter:
    $ gpg --generate-key
    Name: <Enter your name>
    Email: <Enter your email>
    # On Rhel/CentOS enter:
    $ gpg2 --gen-key
    $ gpg2 --list-keys
    # This line is your generated key ID from the ouput
    # Copy the key ID to clipboard
    gpg: key 8A1B3G63 marked as ultimately trusted
    ```

6. Initialize you password store on Clent and Server:

    You can optionally use `pass git...` to track password-store on a local client or remote server.

    ```bash
    $ pass init "8A1B3G63"
    mkdir: created directory '/home/user/.password-store/'
    Password store initialized for 8A1B3G63
    ```

    At this point you can use `pass` on each host and manually synch them with `pass git push` and `pass git pull`. To delete your password store, just `rm -rf ~/.password-store`.

6. Configure `docker-credential-pass` the docker credential helpers using `pass`.

    ```bash
    $ pass insert docker-credential-helpers/docker-pass-initialized-check
    mkdir: created directory '/home/dalexander/.password-store/docker-credential-helpers'
    Enter password for docker-credential-helpers/docker-pass-initialized-check: 
    Retype password for docker-credential-helpers/docker-pass-initialized-check: 
    [master f525798] Add given password for docker-credential-helpers/docker-pass-initialized-check to store.
     1 file changed, 0 insertions(+), 0 deletions(-)
     create mode 100644 docker-credential-helpers/docker-pass-initialized-check.gpg
    # Verify that your password was added to password store
    $ pass show docker-credential-helpers/docker-pass-initialized-check
    # Enter your store password when prompted
    <you decrypted password displays>
    ```

7. Add an entry to `~/.docker/config.json` for to use our new `credential store`.

    ```bash
    {
        "auths": {},
        "credsStore": "pass"
    }

    ```

8. Now `login to your private docker registry` or `docker registry`. Add as many registries as you want now.  Notice that the auth token is empty. This means we were successful.

    ```bash
    # Now login into your docker registry of choice
    $ docker login --username="<username>" https://index.docker.io/v2/
    Password:
    Login Succeeded
    # Now check your docker config.json file to verify your entry has been added
    $ cat ~/.docker/config.json
    {
    	"auths": {
    		"[your.private.registry.com]": {}
    	},
    	"credsStore": "pass"
    } 
    ```
    
    ***Thats it, now you can freely use your credential store with docker and for other resources***

9. Test your newly configured store on pull and push request

    ```bash
    # Login into your docker registry
    $ docker pull [your.private.registry.com]/<image>:tag
    11: Pulling from oracle/jdk
    Digest: sha256:4362d5e9afca3d165ef869a8aaf24d5e220d8ef6dfbd41f91c17cca713d53fb1
    Status: Image is up to date for [your.private.registry.com]/image:tag
    [your.private.registry.com]/image:tag
    ```

10. Track your `password-store` using `git` and sync multiple servers:

    ```bash
    # Initialize a git repo for your password-store and use git to track you password
    $ pass git init
    # To track a remote password-store on a server run this command on the server
    SERVER $ git init --bare ~/.password-store
    # Now login into your docker registry of choice
    $ docker login --username="<username>" https://index.docker.io/v2/
    Password:
    Login Succeeded
    # On Client, add the remote password-store and provide it a unique server name
    $ pass git remote add <server unique name>  [username]@[url/address]:~/.password-store
    # Add the changes and commit to the password-store repo
    $ pass git add -A && pass git commit -m "some meaningful message"
    # push to remote password-store
    $ pass git push
    # Or you may need to use
    $ pass git push --set-upstream <server unique name> master
    Counting objects: 6, done.
    Delta compression using up to 8 threads.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (6/6), 516 bytes | 516.00 KiB/s, done.
    Total 6 (delta 1), reused 0 (delta 0)
    To [username]@[url/address]:~/.password-store
     * [new branch]      master -> master
    Branch 'master' set up to track remote branch 'master' from '<server unique name>'.
    # Or you may clone a remote password-store to another host
    $ git clone <user>@<server>:~/.password-store
    ```
