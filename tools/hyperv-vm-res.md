# Setup Grub On Hyper-V VM's Resolution

The default file to edit screen resolution is located at: `/etc/default/grub`

Edit the two lines below:

```bash
GRUB_CMDLINE_LINUX_DEFAULT=video="hyperv_fb:1920x1080 quiet splash"
GRUB_CMDLINE_LINUX=video="hyperv_fb:1920x1080"
```

Next update grub and initramfs, then reboot for changes to take affect:

```bash
$ sudo update-grub
$ sudo update-initramfs
$ sudo reboot now
```
