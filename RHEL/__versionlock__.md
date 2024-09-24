# Version Lock A Package

The `yum-versionlock` is a Yum plugin that takes a set of name/versions for packages and excludes all other versions of those packages (including optionally following obsoletes).  This allows you to protect packages from being updated by newer versions.

The plugin provides a command "versionlock" which allows you to view and edit the list of locked packages easily.

- Install `yum-versionlock`; 
  - Install package named yum-plugin-versionlock(RHEL 6 and 7), yum-versionlock (RHEL 5) or python3-dnf-plugin-versionlock(RHEL 8)
  - The /etc/yum/pluginconf.d/versionlock.list will be created on the system.

    ```sh
    yum install -y python3-dnf-plugin-versionlock
    ```

- Add a versionlock for all of the packages in the rpmdb matching the given wildcards.
  
    ```sh
    yum versionlock add <package-wildcard>...
    ```

- Opposite; disallow currently available versions of the packages matching the given wildcards.

    ```sh
    yum versionlock exclude <package-wildcard>...
    ```

- List the current versionlock entries.

    ```sh
    yum versionlock list
    ```

- List any available updates that are currently blocked by
versionlock.  That is, for each entry in the lock list,
print the newest package available in the repos unless it
is the particular locked/excluded version.

    ```sh
    yum versionlock status
    ```

- Remove any matching versionlock entries.

    ```sh
    yum versionlock delete <entry-wildcard>...
    ```
- Remove all versionlock entries.

    ```sh
    yum versionlock clear
    ```


