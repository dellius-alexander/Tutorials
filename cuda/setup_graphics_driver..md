# Setup Graphics Driver

## Nvidia Graphics Driver

In some cases you may need to uninstall/remove the current driver if this is not a fresh install. This below commands will also help to reinstall and cure possible issues such as:

- Blank screen on wake after suspend
- HDMI or other secondary monitor not working

```bash
:~$ sudo apt-get remove --purge nvidia* && \
:~$ sudo ubuntu-drivers autoinstall
```sudo apt-get remove --purge nvidia* && sudo ubuntu-drivers autoinstall

