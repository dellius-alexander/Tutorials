# Linux User Management: Root and Admin Users

To create and manage root/admin users in a Linux system, it's 
important to understand Linux user permissions and how they relate 
to system management. Below is a detailed explanation and a bash 
shell script for adding and removing users with root permissions, 
along with a table of Linux user permissions.

### Linux User Permissions Overview

Linux user permissions are defined by three categories: **Owner**, **Group**, and **Others**. Permissions are applied at the file and directory level and include read (`r`), write (`w`), and execute (`x`) permissions.

| Permission Type | Symbol | Description                                                                 |
|-----------------|--------|-----------------------------------------------------------------------------|
| Read            | `r`    | Allows reading the contents of a file or listing a directory's contents.    |
| Write           | `w`    | Allows modifying a file or changing a directory's contents.                 |
| Execute         | `x`    | Allows running a file as a program or accessing a directory.                |

These permissions are combined into a **permission set** represented by three groups of these permissions (for example, `rwxr-xr-x`):

- **Owner permissions**: Permissions granted to the file's owner.
- **Group permissions**: Permissions granted to the group members.
- **Others permissions**: Permissions granted to everyone else.

### Linux User Management: Root and Admin Users

- The **root** user is the system administrator and has unrestricted access (`uid=0`), including all permissions (`rwx`) for all files and directories.
- **Admin users** are regular users with **sudo** privileges, granting them temporary elevated permissions to execute administrative tasks as root.

### Adding a New Admin/Root User

Below is a bash script to add a new admin user with root privileges. It creates a new user, sets a password, adds the user to the `sudo` group (or `wheel` group, depending on the system), and verifies the changes.

#### Script to Add a New Admin/Root User

```bash
#!/bin/bash

# Function to create a new admin user
create_admin_user() {
    read -p "Enter the username for the new admin user: " username
    read -s -p "Enter the password for the new admin user: " password
    echo

    # Create the user
    sudo useradd -m -s /bin/bash "$username"
    if [ $? -ne 0 ]; then
        echo "Error creating user $username."
        exit 1
    fi

    # Set the password for the user
    echo "$username:$password" | sudo chpasswd
    if [ $? -ne 0 ]; then
        echo "Error setting password for user $username."
        exit 1
    fi

    # Add the user to the sudo or wheel group for admin privileges
    if [ -f /etc/debian_version ]; then
        # Debian-based system (Proxmox, Ubuntu)
        sudo usermod -aG sudo "$username"
    elif [ -f /etc/redhat-release ]; then
        # Red Hat-based system (CentOS)
        sudo usermod -aG wheel "$username"
    else
        echo "Unsupported Linux distribution."
        exit 1
    fi

    echo "Admin user $username created and added to sudo/wheel group."
}

create_admin_user
```

### Explanation:

1. **Creating the User**: The script prompts for a username and password, then uses `useradd` to create the user with a home directory (`-m`) and default shell (`/bin/bash`).
2. **Setting the Password**: The `chpasswd` command sets the password for the new user.
3. **Adding to Admin Group**: The script checks the system type (Debian-based or Red Hat-based) and adds the user to the appropriate admin group (`sudo` or `wheel`).

### Removing an Admin/Root User

This script removes an admin user and their associated files:

#### Script to Remove an Admin/Root User

```bash
#!/bin/bash

# Function to remove an admin user
remove_admin_user() {
    read -p "Enter the username of the admin user to remove: " username

    # Check if the user exists
    if id "$username" &>/dev/null; then
        # Remove the user and their home directory
        sudo userdel -r "$username"
        if [ $? -ne 0 ]; then
            echo "Error removing user $username."
            exit 1
        fi
        echo "Admin user $username removed successfully."
    else
        echo "User $username does not exist."
    fi
}

remove_admin_user
```

### Explanation:

1. **Checking the User**: The script uses the `id` command to verify if the user exists.
2. **Removing the User**: If the user exists, `userdel -r` deletes the user and their home directory. If not, an error message is displayed.

### Comprehensive Permission Table for User Management

| Permission Type    | Symbol | Command(s)                 | Description                                               |
|--------------------|--------|----------------------------|-----------------------------------------------------------|
| Read (Owner)       | `r`    | `chmod u+r`                | Grants the owner read access.                             |
| Write (Owner)      | `w`    | `chmod u+w`                | Grants the owner write access.                            |
| Execute (Owner)    | `x`    | `chmod u+x`                | Grants the owner execute access.                          |
| Read (Group)       | `r`    | `chmod g+r`                | Grants the group read access.                             |
| Write (Group)      | `w`    | `chmod g+w`                | Grants the group write access.                            |
| Execute (Group)    | `x`    | `chmod g+x`                | Grants the group execute access.                          |
| Read (Others)      | `r`    | `chmod o+r`                | Grants others read access.                                |
| Write (Others)     | `w`    | `chmod o+w`                | Grants others write access.                               |
| Execute (Others)   | `x`    | `chmod o+x`                | Grants others execute access.                             |
| Add User           |        | `useradd`, `usermod`       | Creates or modifies users.                                |
| Delete User        |        | `userdel`                  | Deletes a user and optionally their home directory.       |
| Assign Group       |        | `usermod -aG <group>`      | Adds a user to a specific group (e.g., `sudo`, `wheel`).  |
| Switch User        |        | `su - <username>`          | Switches to another user account.                         |
| Grant Sudo Access  |        | `usermod -aG sudo <user>`  | Adds a user to the `sudo` group (Debian-based systems).   |
| Grant Wheel Access |        | `usermod -aG wheel <user>` | Adds a user to the `wheel` group (Red Hat-based systems). |

This explanation and the scripts provided allow for efficient 
management of admin/root users while ensuring proper permissions 
are set for secure system administration.
