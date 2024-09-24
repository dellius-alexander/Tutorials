# Using Synology NAS as a Git Server

### Setting Up a Git Repository on Synology NAS, Local Machine, and Synchronizing with Remote

Synology NAS provides a Git server package that allows you to host and manage Git repositories directly on the NAS. Here's a step-by-step guide on setting up the Git repository on the Synology NAS, setting it up on your local machine, and handling push/pull operations.

#### **1. Setting Up a Git Repository on Synology NAS**

##### **Step 1: Enable Git Server Package**
1. **Install Git Server**:
    - Open **Package Center** on your Synology NAS.
    - Search for "Git Server" and click **Install**.

2. **Enable Git Service**:
    - After installation, open the **Git Server** from the **Main Menu**.
    - In the Git Server window, ensure that the **Enable Git service** option is checked.

##### **Step 2: Create a Git Repository on Synology NAS**
1. **SSH Access (optional)**:
    - If you need to create repositories via SSH, enable **SSH** from **Control Panel > Terminal & SNMP > Terminal**.
    - You can use SSH to access the NAS remotely for repository management.

2. **Create a Git Repository**:
    - SSH into your Synology NAS or use the Synology File Station to create a new directory where you want the repository to be stored, e.g., `/volume1/git/myrepo.git`.
    - Initialize the repository as a bare Git repository:
      ```bash
      git init --bare /volume1/git/myrepo.git
      ```
    - A bare repository is necessary for remote access, meaning it doesn't contain a working directory, only the `.git` folder.

#### **2. Setting Up Repository on Local Machine**

##### **Step 1: Clone the Repository from Synology NAS to Local Machine**
1. **Obtain the NAS IP/Domain**:
    - Use your Synology NAS's IP address or hostname, e.g., `192.168.1.100` or `synology.local`.

2. **Clone the Repository**:
    - On your local machine, open a terminal and run the following command to clone the repository:
      ```bash
      git clone ssh://[username]@[NAS-IP]/volume1/git/myrepo.git
      ```
      Replace `[username]` with your Synology NAS username and `[NAS-IP]` with the NAS IP address or hostname.

   Example:
   ```bash
   git clone ssh://user@192.168.1.100/volume1/git/myrepo.git
   ```

##### **Step 2: Create or Modify Files Locally**
- Once the repository is cloned, you can add files or modify existing ones. For example, create a new `README.md` file:
  ```bash
  echo "# My New Repository" > README.md
  ```

#### **3. Pushing Changes to Synology NAS**

##### **Step 1: Add Files and Commit**
- After modifying or adding files, you can commit your changes:
  ```bash
  git add README.md
  git commit -m "Add README file"
  ```

##### **Step 2: Push Changes to Remote Synology Repository**
- Push your committed changes to the remote repository on the Synology NAS:
  ```bash
  git push origin master
  ```

#### **4. Pulling Updates from Synology NAS Repository**

##### **Step 1: Pull Changes from Remote Repository**
- If someone else made changes to the repository, you can pull the latest changes from the NAS repository:
  ```bash
  git pull origin master
  ```
  This will sync your local repository with the latest changes from the remote repository on Synology NAS.

#### **5. Setting Up a Mirror of the Synology Repository**

If you want to keep another remote repository (e.g., on GitHub or another server) in sync with your Synology repository, you can create a mirrored repository.

##### **Step 1: Add a Remote Mirror**
- To set up a mirror, add the remote repository as an additional remote:
  ```bash
  git remote add mirror https://github.com/yourusername/yourrepo.git
  ```

##### **Step 2: Push to Both Remotes (NAS and Mirror)**
- You can now push to both remotes, the Synology NAS and the GitHub repository:
  ```bash
  git push origin master
  git push mirror master
  ```

##### **Step 3: Pull from Both Remotes**
- If updates happen on both remotes, you can pull changes from both:
  ```bash
  git pull origin master
  git pull mirror master
  ```

##### **Step 4: Automating the Mirroring Process (Optional)**
- To automate the push to both remotes, you can create a custom Git alias or use Git hooks to ensure that pushing to one also pushes to the mirror. For example, create a post-commit hook to push to both:
    - In the `.git/hooks/` directory of your local repository, create a `post-commit` file:
      ```bash
      #!/bin/sh
      git push origin master
      git push mirror master
      ```
    - Make the hook executable:
      ```bash
      chmod +x .git/hooks/post-commit
      ```

Now, every time you commit changes, they will automatically be pushed to both the Synology NAS and the mirror repository.
