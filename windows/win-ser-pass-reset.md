Method 1: Reset Windows Server 2012/2016 Password with Installation Disk/USB Flash Drive

If you have the original Windows installation disk/USB Flash Drive, you can reset forgotten Windows Server 2012/2016 password by following these steps:

1. Boot the server from the Windows Server 2012/2016 Installation DVD/USB Flash Drive. When the Setup screen appears, press [SHIFT + F10] keys to open Command Prompt.

2. At the Command Prompt, run the following commands:

```cmd
> d:
> cd Windows\System32
> ren Utilman.exe Utilman.exe.original
> copy cmd.exe Utilman.exe
> shutdown -r -t 0
```

3. The server should now reboot and present the logon screen. Press Windows Key + U or click the Ease of Access button, Command Prompt will pop up and type:<br/>
*the password for the Administrator to be P@ssword123 (case sensitive).*

```cmd
> net user Administrator P@ssword123
```

4. Close the Command Prompt and you should now be able to log back onto Windows Server 2016 using the password you have provided in the previous step. After logging in, browse to the directory C:\Windows\System32, delete Utilman.exe and rename Utilman.exe.original back to Utilman.exe.