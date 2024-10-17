#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Function to create a new admin user
# create_admin_user:
#
#   Takes a username and password as input.
#   Checks if the user already exists, and if not, creates
#   the user with a home directory and bash shell.
#   Adds the user to the sudo group for root privileges and
#   also sets up a specific sudoers file to give the user
#   full permissions without a password prompt.
create_admin_user() {
    local username="$1"
    local password="$2"

    # Check if user already exists
    if id "$username" &>/dev/null; then
        echo "User $username already exists."
        return
    fi

    # Create a new user and set their password
    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd

    # Add the user to the sudo group
    usermod -aG sudo "$username"

    # Provide root privileges via sudoers file (for Proxmox use pveadmin group if applicable)
    echo "$username ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/"$username"

    echo "User $username has been created and granted root privileges."
}

# Function to remove an admin user
# remove_admin_user:
#
#   Takes a username as input.
#   Checks if the user exists and, if so, deletes the user and
#   their home directory.
#   Removes any associated sudoers configuration file.
remove_admin_user() {
    local username="$1"

    # Check if the user exists
    if ! id "$username" &>/dev/null; then
        echo "User $username does not exist."
        return
    fi

    # Remove the user from the system
    userdel -r "$username"

    # Remove the user's sudo privileges if they exist
    if [ -f /etc/sudoers.d/"$username" ]; then
        rm -f /etc/sudoers.d/"$username"
    fi

    echo "User $username has been removed."
}

# Main menu
echo "Admin User Management Script"
echo "1. Create a new admin user"
echo "2. Remove an existing admin user"
read -rp "Choose an option (1 or 2): " option

case "$option" in
    1)
        read -rp "Enter the username for the new admin: " new_user
        read -rsp "Enter the password for the new admin: " new_password
        echo
        create_admin_user "$new_user" "$new_password"
        ;;
    2)
        read -rp "Enter the username of the admin to remove: " remove_user
        remove_admin_user "$remove_user"
        ;;
    *)
        echo "Invalid option. Please choose 1 or 2."
        ;;
esac
