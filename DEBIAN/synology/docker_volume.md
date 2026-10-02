# Docker Container Volume Usage

When creating a Docker volume using the local driver, the type option specifies the underlying filesystem type or protocol used to mount the storage.
Here are the most common and robust options for the type option in Docker Compose, along with examples for each.

------------------------------

## 1. none (Bind Mount via Driver)
The none type forces a standard host bind mount but structures it inside a named volume. This allows you to manage host paths using Docker volume commands (docker volume ls) and safely share absolute host paths across multiple services.

volumes:
  local_bind:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/mnt/user/app_data'

## 2. nfs (Network File System)
The nfs (or nfs4) type allows containers to connect directly to network-attached storage (NAS) without requiring the host operating system to mount the network share first.

volumes:
  nfs_share:
    driver: local
    driver_opts:
      type: 'nfs'
      o: 'addr=192.168.1.100,rw,nolock,hard,tcp'
      device: ':/volume1/nas_share'

## 3. tmpfs (In-Memory Storage)
The tmpfs type creates a volatile volume mounted directly into the host system's RAM. Files are written at memory speeds and are completely wiped when the container stops. This is excellent for high-velocity temporary scratch space or sensitive session keys.

volumes:
  ram_disk:
    driver: local
    driver_opts:
      type: 'tmpfs'
      o: 'size=1024m,mode=1777'

## 4. cifs (Common Internet File System / SMB)
The cifs type connects Docker containers directly to Windows File Shares or Samba shares hosted on Linux/NAS systems. It requires providing authentication credentials directly in the options string.

volumes:
  smb_share:
    driver: local
    driver_opts:
      type: 'cifs'
      o: 'username=smbuser,password=smbpass,domain=local,rw,file_mode=0777,dir_mode=0777'
      device: '//192.168.1.200/shared_folder'

## 5. Standard Filesystems (ext4, xfs, btrfs)
You can mount specific unmounted disk partitions or block storage volumes attached to the host system by declaring standard Linux filesystem types.

volumes:
  dedicated_disk:
    driver: local
    driver_opts:
      type: 'ext4'  # Can also be xfs, btrfs, vfat, etc.
      o: 'rw,noatime'
      device: '/dev/sdb1'

------------------------------

## Key Rules for Using driver_opts

* Host Prerequisites: For network types like nfs or cifs, the host OS must have the corresponding client packages installed (nfs-common or cifs-utils),
  even though Docker manages the mount handshake.
* The `o` Parameter: This stands for "options" and accepts a comma-separated list of standard Linux mount command flags relevant to that filesystem type.


