<h1>How to rebuild the initial ramdisk image in Red Hat Enterprise Linux</h1>
<section class="field_kcs_resolution_txt">
      <h2>Resolution</h2>
        <p>When adding new hardware to a system, or after changing configuration files that may be used very early in the boot process, or when changing the options on a kernel module, it may be necessary to rebuild the initial ramdisk (also known as initrd or initramfs) to include the proper kernel modules, files, and configuration directives.</p>
<p>If you are adding a new module in the initrd, first follow the instructions in <a href="/knowledge/node/47028">How can I ensure certain modules are included in the initrd or initramfs in RHEL?</a>, or if it is a configuration change then make that change now.</p>
<p>Once the necessary modifications have been made, it is time to rebuild the initrd. This process differs based on the version of RHEL. In these examples you will see the usage of <code>$(uname -r)</code>, which is a way to pass the current kernel version into a command without actually typing it out. If you are working with a version of the kernel other than what is currently running, then replace <code>$(uname -r)</code> with the actual kernel version, such as <code>2.6.18-274.el5</code>.</p>



<ol>
<li><a href="busybox">Metadata currruption detected; boot to busybox shell</a> </li>
<li><a href="#initramfs">Rebuilding the initramfs (RHEL 6, 7, 8)</a></li>
<li><a href="#rhel8notes">Checking initramfs (RHEL 8)</a></li>
<li><a href="#rhel7notes">Checking initramfs (RHEL 7)</a></li>
<li><a href="#initrd">Rebuilding the initrd (RHEL 3, 4, 5)</a> </li>
<li><a href="#backup">Working with backups (RHEL 3, 4, 5, 6)</a> </li>
</ol>

<h3 id="busybox">1. Metadata currruption detected; boot to busybox shell</h3>
<p>If you run into this problem when booting your vm experiences a corrupted block, you must repair using <b>xfs_repair</b>:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div>
<pre>
<code># [   5.854908] XFS (dm-0): Metadata corruption detected at xfs_agi_verify+0x132x/0x180 [xfs], xfs_agi block 0x2
# [   5.855143] XFS (dm-0): Unmount and run xfs_repair
# [   5.855212] XFS (dm-0): First 128 bytes of corrupted metadata buffer.
# [   5.855249] 00000000: 58 45 65 49 . . .
# .
# .
# .
</code></pre>
</div>

<p>Run <b>xfs_repair /dev/<\your partition\> </b></p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div>
<pre>// note: /dev/mapper/cl-root refers to splice block or raid configured block device
<code># xfs_repair [ -L|NONE ] [ /dev/sda1 or /dev/mapper/cl-root]
# reboot
</code></pre>
</div>

<p>You may need to try different partitions/volume if you are not sure where your boot loader is located. Once you find it the system should reboot to rescue mode or normal boot sequence. If the system boots to rescue mode then use this as your time to rebuild initramfs.</p>

<h3 id="initramfs">2. Rebuilding the initramfs (RHEL 6, 7, 8)</h3>
<p>It is recommended you make a backup copy of the initramfs in case the new version has an unexpected problem:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># cp /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).bak.$(date +%m-%d-%H%M%S).img
</code></pre>
</div>
<p>Now rebuild the initramfs for the current kernel version:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># dracut -f -v
</code></pre></div>
<p>If you are in a kernel version different to the initrd you are building (including if you are in Rescue Mode) you must specify the full kernel version, including architecture:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># dracut -f /boot/initramfs-2.6.32-220.7.1.el6.x86_64.img 2.6.32-220.7.1.el6.x86_64
                            +------------------------     +------------------------
                            |                             |
                            v                             v
                       Replace these pieces with the full version of 
                           the kernel you wish to rebuild 
</code></pre></div>
<h3 id="rhel8notes">3. Checking initramfs (RHEL 8)</h3>
<p>In RHEL8, be certain that the BLS configuration files in <code>/boot/loader/entries</code>  includes the menu to the newly installed or created custom initramfs</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># grep initrd /boot/loader/entries/*
/boot/loader/entries/f81f518abf514003b7afe1b89fd649fe-0-rescue.conf:initrd /initramfs-0-rescue-f81f518abf514003b7afe1b89fd649fe.img
/boot/loader/entries/f81f518abf514003b7afe1b89fd649fe-4.18.0-240.el8.x86_64.conf:initrd /initramfs-4.18.0-240.el8.x86_64.img $tuned_initrd
</code></pre></div>

<h3 id="rhel7notes">4. Checking initramfs (RHEL 7)</h3>
<p>In RHEL 7, be certain that the <code>/etc/grub2.cfg</code> <em>and</em> <code>/boot/grub2/grub.cfg</code> includes the menu to the newly installed or created custom initramfs</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># grep initrd /etc/grub2.cfg
    initrd16 /initramfs-3.10.0-514.6.1.el7.x86_64.img
    initrd16 /initramfs-3.10.0-514.el7.x86_64.img
    initrd16 /initramfs-0-rescue-29579289bce743ebbf3d42aa22ebd5fe.img
# grep "menuentry " /boot/grub2/grub.cfg
menuentry 'Red Hat Enterprise Linux Server (3.10.0-514.6.1.el7.x86_64) ...'
menuentry 'Red Hat Enterprise Linux Server (3.10.0-514.el7.x86_64) ... '
menuentry 'Red Hat Enterprise Linux Server (0-rescue-29579289bce743ebbf3d42aa22ebd5fe) ...'
</code></pre></div><p>If the customized kernel menu entry does not appear in the grub configuration file(s), rebuild the grub menu.  This rebuild is nominally performed by dracut, but can not be successfully completed in some corner cases.</p>
<p><a href="https://access.redhat.com/solutions/4848251">How to create a custom menu entry in grub</a></p>
<p>Rebuild grub.cfg file after creating the custom menu entry:</p>
<ul>
<li>
<p>On BIOS-based machines, issue the following command as root:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># grub2-mkconfig -o /boot/grub2/grub.cfg
</code></pre></div></li>
<li>
<p>On UEFI-based machines, issue the following command as root:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
</code></pre></div></li>
</ul>

<h3 id="initrd">5. Rebuilding the initrd (RHEL 3, 4, 5)</h3>
<p>It is recommended you make a backup copy of the initrd in case the new version has an unexpected problem:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># cp /boot/initrd-$(uname -r).img /boot/initrd-$(uname -r).bak.$(date +%m-%d-%H%M%S).img
</code></pre></div><p>Now build the initrd:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># mkinitrd -f -v /boot/initrd-$(uname -r).img $(uname -r)
</code></pre></div><ul>
<li>The <code>-v</code> verbose flag causes <code>mkinitrd</code> to display the names of all the modules it is including in the initial ramdisk.</li>
<li>The <code>-f</code> option will force an overwrite of any existing initial ramdisk image at the path you have specified</li>
</ul>
<p>If you are in a kernel version different to the initrd you are building (including if you are in Rescue Mode) you must specify the full kernel version, without architecture:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code># mkinitrd -f -v /boot/initrd-2.6.18-348.2.1.el5.img 2.6.18-348.2.1.el5
</code></pre></div>

<h3 id="backup">6. Working with backups (RHEL 3, 4, 5, 6)</h3>
<p>As mentioned previously, it is recommended that you take a backup of the previous initrd in case something goes wrong with the new one. If desired, it is possible to create a separate entry in <code>/boot/grub/grub.conf</code> for the backup initial ramdisk image, to conveniently choose the old version at boot time without needing to restore the backup. This example configuration allows selection of either the new or old initial ramdisk image from the grub menu:</p>
<div class="code-raw"><div class="code-raw-toolbar"><a href="#" class="code-raw-btn">Raw</a></div><pre><code>title Red Hat Enterprise Linux 5 (2.6.18-274.el5)
     root (hd0,0)
     kernel /vmlinuz-2.6.18-274.el5 ro root=LABEL=/ 
     initrd /initrd-2.6.18-274.el5.img
title Red Hat Enterprise Linux 5 w/ old initrd (2.6.18-274.el5)
     root (hd0,0)
     kernel /vmlinuz-2.6.18-274.el5 ro root=LABEL=/ 
     initrd /initrd-2.6.18-274.el5.bak.MM-DD-HHMMSS.img
</code></pre></div><p>Alternatively, you can enter edit-mode in grub if you need to choose the old initrd and did not make a separate entry in <code>grub.conf</code> before rebooting. To do so:</p>
<ul>
<li>If grub is secured with a password, press <strong>p</strong> and enter the password</li>
<li>Use the <strong>arrow keys</strong> to highlight the entry for the kernel you wish to boot</li>
<li>Press <strong>e</strong> for edit</li>
<li>Highlight the initrd line and press <strong>e</strong> again</li>
<li>Change the path for the initrd to the backup copy you made (such as <code>/initrd-2.6.18-274.el5.bak.01-01-123456.img</code>)</li>
<li>Press <strong>Enter</strong> to temporarily save the changes you have made</li>
<li>Press <strong>b</strong> for boot</li>
</ul>
<p><strong>Note:</strong> This procedure does not actually make the change persistent. The next boot will continue to use the original <code>grub.conf</code> configuration unless it is updated.</p>
  </section>