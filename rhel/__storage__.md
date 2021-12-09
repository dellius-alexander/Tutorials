
<style>
.orderedlist, .listitem {
  font-weight: 600;
}

  </style>

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

## <h2 href='#' id='enable-multipath-nvme-devices'>4. Enabling multipathing on NVMe devices</h2>

You can multipath NVMe devices that are connected to your system over a fabric transport, such as Fibre Channel (FC). You can select between multiple multipathing solutions.

<div class="titlepage"><div><div><h2 class="title">4.1. &nbsp;Enabling native NVMe multipathing</h2></div></div></div><p class="_abstract_abstract">
This procedure enables multipathing on connected NVMe devices using the native NVMe multipathing solution.
</p><div class="itemizedlist"><p class="title"><strong>Prerequisites</strong></p><ul class="itemizedlist" type="disc"><li class="listitem"><p class="simpara">
The NVMe devices are connected to your system.
</p><p class="simpara">
For more information on connecting NVMe over fabric transports, see <a class="link" href="https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/overview-of-nvme-over-fabric-devicesmanaging-storage-devices">Overview of NVMe over fabric devices</a>.
</p></li></ul></div><div class="orderedlist"><p class="title"><strong>Procedure</strong></p><ol class="orderedlist" type="1"><li class="listitem"><p class="simpara">
Check if native NVMe multipathing is enabled in the kernel:
</p><pre class="screen language-none"># cat /sys/module/nvme_core/parameters/multipath</pre><p class="simpara">
The command displays one of the following:
</p><div class="variablelist"><dl class="variablelist"><dt><span class="term"><code class="literal">N</code></span></dt><dd>
Native NVMe multipathing is disabled.
</dd><dt><span class="term"><code class="literal">Y</code></span></dt><dd>
Native NVMe multipathing is enabled.
</dd></dl></div></li><li class="listitem"><p class="simpara">
If native NVMe multipathing is disabled, enable it using one of the following methods:
</p><div class="itemizedlist"><ul class="itemizedlist" type="disc"><li class="listitem"><p class="simpara">
Using a kernel option:
</p><div class="orderedlist"><ol class="orderedlist" type="i"><li class="listitem"><p class="simpara">
Add the <code class="literal">nvme_core.multipath=Y</code> option on the kernel command line:
</p><pre class="screen language-none"># grubby --update-kernel=ALL --args="nvme_core.multipath=Y"</pre></li><li class="listitem"><p class="simpara">
On the 64-bit IBM Z architecture, update the boot menu:
</p><pre class="screen language-none"># zipl</pre></li><li class="listitem">
Reboot the system.
</li></ol></div></li><li class="listitem"><p class="simpara">
Using a kernel module configuration file:
</p><div class="orderedlist"><ol class="orderedlist" type="i"><li class="listitem"><p class="simpara">
Create the <code class="literal filename">/etc/modprobe.d/nvme_core.conf</code> configuration file with the following content:
</p><pre class="screen language-none">options nvme_core multipath=Y</pre></li><li class="listitem"><p class="simpara">
Back up the <code class="literal">initramfs</code> file system:
</p><pre class="screen language-none"># cp /boot/initramfs-$(uname -r).img \
/boot/initramfs-$(uname -r).bak.$(date +%m-%d-%H%M%S).img</pre></li><li class="listitem"><p class="simpara">
Rebuild the <code class="literal">initramfs</code> file system:
</p><pre class="screen language-none"># dracut --force --verbose</pre></li><li class="listitem">
Reboot the system.
</li></ol></div></li></ul></div></li><li class="listitem"><p class="simpara">
Optional: On the running system, change the I/O policy on NVMe devices to distribute the I/O on all available paths:
</p><pre class="screen language-none"># echo "round-robin" &gt; /sys/class/nvme-subsystem/nvme-subsys0/iopolicy</pre></li><li class="listitem"><p class="simpara">
Optional: Set the I/O policy persistently using <code class="literal">udev</code> rules. Create the <code class="literal filename">/etc/udev/rules.d/71-nvme-io-policy.rules</code> file with the following content:
</p><pre class="screen language-none">ACTION=="add|change", SUBSYSTEM=="nvme-subsystem", ATTR{iopolicy}="round-robin"</pre></li></ol></div><div class="orderedlist"><p class="title"><strong>Verification</strong></p><ol class="orderedlist" type="1"><li class="listitem"><p class="simpara">
Check that your system recognizes the NVMe devices:
</p><pre class="screen language-none"># nvme list

Node             SN                   Model                                    Namespace Usage                      Format           FW Rev
---------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1     a34c4f3a0d6f5cec     Linux                                    1         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme0n2     a34c4f3a0d6f5cec     Linux                                    2         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2</pre></li><li class="listitem"><p class="simpara">
List all connected NVMe subsystems:
</p><pre class="screen language-none"># nvme list-subsys

nvme-subsys0 - NQN=testnqn
\
+- nvme0 fc traddr=nn-0x20000090fadd597a:pn-0x10000090fadd597a host_traddr=nn-0x20000090fac7e1dd:pn-0x10000090fac7e1dd live
+- nvme1 fc traddr=nn-0x20000090fadd5979:pn-0x10000090fadd5979 host_traddr=nn-0x20000090fac7e1dd:pn-0x10000090fac7e1dd live
+- nvme2 fc traddr=nn-0x20000090fadd5979:pn-0x10000090fadd5979 host_traddr=nn-0x20000090fac7e1de:pn-0x10000090fac7e1de live
+- nvme3 fc traddr=nn-0x20000090fadd597a:pn-0x10000090fadd597a host_traddr=nn-0x20000090fac7e1de:pn-0x10000090fac7e1de live</pre><p class="simpara">
Check the active transport type. For example, <code class="literal">nvme0 fc</code> indicates that the device is connected over the Fibre Channel transport, and <code class="literal">nvme tcp</code> indicates that the device is connected over TCP.
</p></li><li class="listitem"><p class="simpara">
If you edited the kernel options, check that native NVMe multipathing is enabled on the kernel command line:
</p><pre class="screen language-none"># cat /proc/cmdline

BOOT_IMAGE=[...] nvme_core.multipath=Y</pre></li><li class="listitem"><p class="simpara">
Check that DM Multipath reports the NVMe namespaces as, for example, <code class="literal">nvme0c0n1</code> through <code class="literal">nvme0c3n1</code>, and <span class="emphasis"><em>not</em></span> as, for example, <code class="literal">nvme0n1</code> through <code class="literal">nvme3n1</code>:
</p><pre class="screen language-none"># multipath -ll | grep -i nvme

uuid.8ef20f70-f7d3-4f67-8d84-1bb16b2bfe03 [nvme]:nvme0n1 NVMe,Linux,4.18.0-2
| `- 0:0:1    nvme0c0n1 0:0     n/a   optimized live
|`- 0:1:1    nvme0c1n1 0:0     n/a   optimized live
| `- 0:2:1    nvme0c2n1 0:0     n/a   optimized live
`- 0:3:1    nvme0c3n1 0:0     n/a   optimized live

uuid.44c782b4-4e72-4d9e-bc39-c7be0a409f22 [nvme]:nvme0n2 NVMe,Linux,4.18.0-2
| `- 0:0:1    nvme0c0n1 0:0     n/a   optimized live
|`- 0:1:1    nvme0c1n1 0:0     n/a   optimized live
| `- 0:2:1    nvme0c2n1 0:0     n/a   optimized live
`- 0:3:1    nvme0c3n1 0:0     n/a   optimized live</pre></li><li class="listitem"><p class="simpara">
If you changed the I/O policy, check that <code class="literal">round-robin</code> is the active I/O policy on NVMe devices:
</p><pre class="screen language-none"># cat /sys/class/nvme-subsystem/nvme-subsys0/iopolicy

round-robin</pre></li></ol></div><div class="itemizedlist _additional-resources"><p class="title"><strong>Additional resources</strong></p><ul class="itemizedlist_additional-resources" type="disc"><li class="listitem">
For more information on editing kernel options, see <a class="link" href="https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel">Configuring kernel command-line parameters</a>.
</li></ul></div>

<div class="titlepage"><div><div><h2 class="title">4.2.&nbsp;Enabling DM Multipath on NVMe devices</h2></div></div></div><p class="_abstract_abstract">
This procedure enables multipathing on connected NVMe devices using the DM Multipath solution.
</p><div class="itemizedlist"><p class="title"><strong>Prerequisites</strong></p><ul class="itemizedlist" type="disc"><li class="listitem"><p class="simpara">
The NVMe devices are connected to your system.
</p><p class="simpara">
For more information on connecting NVMe over fabric transports, see <a class="link" href="https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_storage_devices/overview-of-nvme-over-fabric-devicesmanaging-storage-devices">Overview of NVMe over fabric devices</a>.
</p></li></ul></div><div class="orderedlist"><p class="title"><strong>Procedure</strong></p><ol class="orderedlist" type="1"><li class="listitem"><p class="simpara">
Check that native NVMe multipathing is disabled:
</p><pre class="screen language-none"># cat /sys/module/nvme_core/parameters/multipath</pre><p class="simpara">
The command displays one of the following:
</p><div class="variablelist"><dl class="variablelist"><dt><span class="term"><code class="literal">N</code></span></dt><dd>
Native NVMe multipathing is disabled.
</dd><dt><span class="term"><code class="literal">Y</code></span></dt><dd>
Native NVMe multipathing is enabled.
</dd></dl></div></li><li class="listitem"><p class="simpara">
If native NVMe multipathing is enabled, disable it:
</p><div class="orderedlist"><ol class="orderedlist" type="a"><li class="listitem"><p class="simpara">
Remove the <code class="literal">nvme_core.multipath=Y</code> option from the kernel command line:
</p><pre class="screen language-none"># grubby --update-kernel=ALL --remove-args="nvme_core.multipath=Y"</pre></li><li class="listitem"><p class="simpara">
On the 64-bit IBM Z architecture, update the boot menu:
</p><pre class="screen language-none"># zipl</pre></li><li class="listitem">
Remove the <code class="literal">options nvme_core multipath=Y</code> line from the <code class="literal filename">/etc/modprobe.d/nvme_core.conf</code> file, if it is present.
</li><li class="listitem">
Reboot the system.
</li></ol></div></li><li class="listitem"><p class="simpara">
Make sure that DM Multipath is enabled:
</p><pre class="screen language-none"># systemctl enable --now multipathd.service</pre></li><li class="listitem"><p class="simpara">
Distribute I/O on all available paths. Add the following content in the <code class="literal filename">/etc/multipath.conf</code> file:
</p><pre class="screen language-none">device {
vendor "NVME"
product ".*"
path_grouping_policy    group_by_prio
}</pre><div class="admonition note"><div class="admonition_header">Note</div><div><p>
The <code class="literal filename">/sys/class/nvme-subsystem/nvme-subsys0/iopolicy</code> configuration file has no effect on the I/O distribution when DM Multipath manages the NVMe devices.
</p></div></div></li><li class="listitem"><p class="simpara">
Reload the <code class="literal">multipathd</code> service to apply the configuration changes:
</p><pre class="screen language-none"># multipath -r</pre></li><li class="listitem"><p class="simpara">
Back up the <code class="literal">initramfs</code> file system:
</p><pre class="screen language-none"># cp /boot/initramfs-$(uname -r).img \
/boot/initramfs-$(uname -r).bak.$(date +%m-%d-%H%M%S).img</pre></li><li class="listitem"><p class="simpara">
Rebuild the <code class="literal">initramfs</code> file system:
</p><pre class="screen language-none"># dracut --force --verbose</pre></li></ol></div><div class="orderedlist"><p class="title"><strong>Verification</strong></p><ol class="orderedlist" type="1"><li class="listitem"><p class="simpara">
Check that your system recognizes the NVMe devices:
</p><pre class="screen language-none"># nvme list

Node             SN                   Model                                    Namespace Usage                      Format           FW Rev
---------------- -------------------- ---------------------------------------- --------- -------------------------- ---------------- --------
/dev/nvme0n1     a34c4f3a0d6f5cec     Linux                                    1         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme0n2     a34c4f3a0d6f5cec     Linux                                    2         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme1n1     a34c4f3a0d6f5cec     Linux                                    1         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme1n2     a34c4f3a0d6f5cec     Linux                                    2         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme2n1     a34c4f3a0d6f5cec     Linux                                    1         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme2n2     a34c4f3a0d6f5cec     Linux                                    2         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme3n1     a34c4f3a0d6f5cec     Linux                                    1         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2
/dev/nvme3n2     a34c4f3a0d6f5cec     Linux                                    2         250.06  GB / 250.06  GB    512   B +  0 B   4.18.0-2</pre></li><li class="listitem"><p class="simpara">
List all connected NVMe subsystems. Check that the command reports them as, for example, <code class="literal">nvme0n1</code> through <code class="literal">nvme3n2</code>, and <span class="emphasis"><em>not</em></span> as, for example, <code class="literal">nvme0c0n1</code> through <code class="literal">nvme0c3n1</code>:
</p><pre class="screen language-none"># nvme list-subsys

nvme-subsys0 - NQN=testnqn
\
+- nvme0 fc traddr=nn-0x20000090fadd5979:pn-0x10000090fadd5979 host_traddr=nn-0x20000090fac7e1dd:pn-0x10000090fac7e1dd live
+- nvme1 fc traddr=nn-0x20000090fadd597a:pn-0x10000090fadd597a host_traddr=nn-0x20000090fac7e1dd:pn-0x10000090fac7e1dd live
+- nvme2 fc traddr=nn-0x20000090fadd5979:pn-0x10000090fadd5979 host_traddr=nn-0x20000090fac7e1de:pn-0x10000090fac7e1de live
+- nvme3 fc traddr=nn-0x20000090fadd597a:pn-0x10000090fadd597a host_traddr=nn-0x20000090fac7e1de:pn-0x10000090fac7e1de live</pre><pre class="screen language-none"># multipath -ll

mpathae (uuid.8ef20f70-f7d3-4f67-8d84-1bb16b2bfe03) dm-36 NVME,Linux
size=233G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=50 status=active
|- 0:1:1:1  nvme0n1 259:0   active ready running
|- 1:2:1:1  nvme1n1 259:2   active ready running
|- 2:3:1:1  nvme2n1 259:4   active ready running
`- 3:4:1:1  nvme3n1 259:6   active ready running

mpathaf (uuid.44c782b4-4e72-4d9e-bc39-c7be0a409f22) dm-39 NVME,Linux
size=233G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=50 status=active
|- 0:1:2:2  nvme0n2 259:1   active ready running
|- 1:2:2:2  nvme1n2 259:3   active ready running
|- 2:3:2:2  nvme2n2 259:5   active ready running
`- 3:4:2:2  nvme3n2 259:7   active ready running</pre></li></ol></div><div class="itemizedlist_additional-resources"><p class="title"><strong>Additional resources</strong></p><ul class="itemizedlist _additional-resources" type="disc"><li class="listitem">
For more information on editing kernel options, see <a class="link" href="https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/managing_monitoring_and_updating_the_kernel/configuring-kernel-command-line-parameters_managing-monitoring-and-updating-the-kernel">Configuring kernel command-line parameters</a>.
</li><li class="listitem">
For more information on configuring DM Multipath, see <a class="xref" href="assembly_setting-up-dm-multipath-configuring-device-mapper-multipath" title="Chapter&nbsp;3.&nbsp;Setting up DM Multipath">Chapter&nbsp;3, <em>Setting up DM Multipath</em></a>.
</li></ul></div>
