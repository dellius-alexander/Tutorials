# MANAGING STORAGE FOR VIRTUAL MACHINES

A virtual machine (VM), just like a physical machine, requires storage for data, program, and system files. As a VM administrator, you can assign physical or network-based storage to your VMs as virtual storage. You can also modify how the storage is presented to a VM regardless of the underlying hardware.

## 1. Introduction to storage pools
A storage pool is a file, directory, or storage device, managed by ***`libvirt`*** to provide storage for virtual machines (VMs). You can divide storage pools into storage volumes, which store VM images or are attached to VMs as additional storage.

Furthermore, multiple VMs can share the same storage pool, allowing for better allocation of storage resources.

- Storage pools can be `persistent` or `transient`:

  - A persistent storage pool survives a system restart of the host machine. You can use the ***`virsh pool-define`*** to create a persistent storage pool.
  - A transient storage pool only exists until the host reboots. You can use the ***`virsh pool-create`*** command to create a transient storage pool.

- Storage pool storage types <br/>
    
  Storage pools can be either local or network-based (shared):

  - Local storage pools:

    - Local storage pools are attached directly to the host server. They include local directories, directly attached disks, physical partitions, and Logical Volume Management (LVM) volume groups on local devices.

    - Local storage pools are useful for development, testing, and small deployments that do not require migration or have a large number of VMs.

- Networked (shared) storage pools

  Networked storage pools include storage devices shared over a network using standard protocols.

## 2. Introduction to storage volumes

Storage pools are divided into `storage volumes`. Storage volumes are abstractions of physical partitions, LVM logical volumes, file-based disk images, and other storage types handled by ***`libvirt`***. Storage volumes are presented to VMs as local storage devices, such as disks, regardless of the underlying hardware.

On the host machine, a storage volume is referred to by its name and an identifier for the storage pool from which it derives. On the ***`virsh`*** command line, this takes the form ***`--pool storage_pool volume_name`***.

For example, to display information about a volume named firstimage in the guest_images pool.

```bash
$ virsh vol-info --pool guest_images firstimage
  Name:             firstimage
  Type:             block
  Capacity:         20.00 GB
  Allocation:       20.00 GB
```

## 3. Storage management using `libvirt`

Using the `libvirt` remote protocol, you can manage all aspects of VM storage. These operations can also be performed on a remote host. Consequently, a management application that uses `libvirt`, such as the RHEL web console, can be used to perform all the required tasks of configuring the storage of a VM.

You can use the `libvirt` API to query the list of volumes in a storage pool or to get information regarding the capacity, allocation, and available storage in that storage pool. For storage pools that support it, you can also use the `libvirt API` to create, clone, resize, and delete storage volumes. Furthermore, you can use the `libvirt API` to upload data to storage volumes, download data from storage volumes, or wipe data from storage volumes.

## TODO