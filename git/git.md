# GIT Command Reference

1. ## Fixing missing origin remote

    - If you encounter an error trying to update/push to your head branch, preferably your main or master. You can do this to correct the issue.
  
    ```bash
    $ git push -u origin main
    fatal: 'origin' does not appear to be a git repository
    fatal: The remote end hung up unexpectedly
    ...

    # To fix thisverify current remotes
    git remote -v 
    # add reference to origin branch
    git remote add origin <url/to/repo>
    ```

2. ## Configure Git to use the exclude file ~/.gitignore_global for all or ~/.gitignore_local for local Git repositories.

    - You can also create a global .gitignore file to define a list of rules for ignoring files in every Git repository on your computer. For example, you might create the file at ~/.gitignore_global and add some rules to it.

    ```bash
    #create a global .gitignore file to define a list of rules for ignoring files in every Git repository on your computer
    $ git config --global core.excludesfile ~/.gitignore_global
    ```

    - You can also create a local .gitignore file to define a list of rules for ignoring files in local Git repository on your computer. For example, you might create the file at ~/.gitignore_local and add some rules to it.

    ```bash
    # create a local .gitignore file to define a list of rules for ignoring files in local Git repository
    $ git config --local core.excludesfile ~/.gitignore_local
    ```

3. ## Create a new repository or push an existing repository from the command line

    Get started by creating a new file or uploading an existing file. We recommend every repository include a README, LICENSE, and .gitignore.

    -  create a new repository on the command line

        ```bash
        echo "# <repo name/title>" >> README.md
        git init && \
        git add README.md && \
        git commit -m "first commit" && \
        git branch -M main && \
        git remote add origin https://github.com/<account username>/<repo name>.git && \
        git push -u origin main
        ```


    <!--   
    git branch -M main && \
    git remote add origin https://github.com/dellius-alexander/Alpha2Omega.git && \
    git push -u origin main    
    -->


    -  push an existing repository from the command line

        ```bash
        git remote add origin https://github.com/<account username>/<repo name>.git
        git branch -M main
        git push -u origin main
        ```
4. ## Generating a new SSH key:

    1. Generate the SSH key pair:

    ```bash
    ssh-keygen -a 128  -t ed25519 -f .ssh/id_ed25519_"<some unique identifier>" -C "your email@example.com"

    ssh-keygen -a 128 -t rsa -b 4096 -f .ssh/id_rsa_"<some unique identifier>" -C "your email@example.com"
    ```
    1. Adding your SSH key to the ssh-agent:

    ```bash
    $ eval "$(ssh-agent -s)"
    > Agent pid 59566

    ssh-add ~/.ssh/id_ed25519_"<some unique identifier>"
    ```

    1. Test your ssh key

    ```bash
    ssh -T git@github.com
    ```

5. ## Create a new repository on the command line

    ```bash
    echo "# <repo name>" >> README.md
    git init
    git add README.md
    git commit -m "first commit"
    git branch -M main
    git remote add origin git@github.com:<user.name>/<repo name>.git
    #git remote add origin https://github.com/<user.name>/<repo name>.git
    git push -u origin main
    ```


6. ## push an existing repository from the command line

    ```bash
    git remote add origin git@github.com:<user.name>/<repo name>.git
    #git remote add origin https://github.com/<user.name>/<repo name>.git
    git branch -M main
    git push -u origin main
    ```
