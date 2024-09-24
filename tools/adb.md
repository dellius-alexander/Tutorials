
# ADB Debugging Commands

Source: http://manpages.ubuntu.com/manpages/bionic/man1/adb.1.html

## ADB Basics

```bash
adb connect <device ip address> # (connect to specific device via ip address)
adb devices # (lists connected devices)
adb root # (restarts adbd with root permissions)
adb start-server # (starts the adb server)
adb kill-server # (kills the adb server)
adb reboot # (reboots the device)
adb devices -l # (list of devices by product/model)
adb shell # (starts the backround terminal)
exit # (exits the background terminal)
adb help # (list all commands)
adb -s <deviceName> <command> # (redirect command to specific device)
adb –d <command> # (directs command to only attached USB device)
adb –e <command> # (directs command to only attached emulator)
```

## Package Installation & Info

* push package(s) to the device and install them

```bash
adb install <path-to-apk-file-on-client> # (install app from connected client path)
adb install -r <path-to-apk-file-on-client> # (re-install app from connected client path)
adb shell uninstall <name> # (remove the app)
adb shell list packages # (list package names)
adb shell list packages -r # (list package name + path to apks)
adb shell list packages -3 # (list third party package names)
adb shell list packages -s # (list only system packages)
adb shell list packages -u # (list package names + uninstalled)
adb shell dumpsys package packages # (list info on all apps)
adb shell dump <name> # (list info on one package)
adb shell path <package> # (path to the apk file)
adb shell pm list packages -f # (see a list of all the installed APKs and their package names)
```

## Running your App

```bash
adb shell am start -n <path-to-app-on-device | app-name> # (send a launch intent to your app on the device)
```

## Path's

```bash
/data/data/<package>/databases # (app databases)
/data/data/<package>/shared_prefs/ # (shared preferences)
/data/app # (apk installed by user)
/system/app # (pre-installed APK files)
/mmt/asec # (encrypted apps) (App2SD)
/mmt/emmc # (internal SD Card)
/mmt/adcard # (external/Internal SD Card)
/mmt/adcard/external_sd (external SD Card)

adb shell ls # (list directory contents)
adb shell ls -s # (print size of each file)
adb shell ls -R # (list subdirectories recursively)
```

## File Operations

```bash
adb push <local> <remote> # (copy file/dir to device)
adb pull <remote> <local> # (copy file/dir from device)
run-as <package> cat <file> # (access the private package files)
```

## Device Related Info

```bash
adb get-statе # (print device state)
adb get-serialno # (get the serial number)
adb shell dumpsys iphonesybinfo # (get the IMEI)
adb shell netstat # (list TCP connectivity)
adb shell pwd # (print current working directory)
adb shell dumpsys battery # (battery status)
adb shell pm list features # (list phone features)
adb shell service list # (list all services)
adb shell dumpsys activity <package>/<activity> # (activity info)
adb shell ps (print process status)
adb shell wm size # (displays the current screen resolution)
dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' # (print current app's opened activity)
```

## Configure Settings Commands

```bash
adb shell dumpsys battery set level <n> # (change the level from 0 to 100)
adb shell dumpsys battery set status<n> # (change the level to unknown, charging, discharging, not charging or full)
adb shell dumpsys battery reset # (reset the battery)
adb shell dumpsys battery set usb <n> # (change the status of USB connection. ON or OFF)
adb shell wm size WxH # (sets the resolution to WxH)
```

## Device Related Commands

```bash
adb reboot-recovery # (reboot device into recovery mode)
adb reboot fastboot # (reboot device into recovery mode)
adb shell screencap -p "/path/to/screenshot.png" # (capture screenshot)
adb shell screenrecord "/path/to/record.mp4" # (record device screen)
adb backup -apk -all -f backup.ab # (backup settings and apps)
adb backup -apk -shared -all -f backup.ab # (backup settings, apps and shared storage)
adb backup -apk -nosystem -all -f backup.ab # (backup only non-system apps)
adb restore backup.ab # (restore a previous backup)
adb shell am start|startservice|broadcast <INTENT>[<COMPONENT>]
-a <ACTION> e.g. android.intent.action.VIEW
-c <CATEGORY> e.g. android.intent.category.LAUNCHER # (start activity intent)

adb shell am start -a android.intent.action.VIEW -d URL # (open URL)
adb shell am start -t image/* -a android.intent.action.VIEW # (opens gallery)
```

## Logs

```bash
adb logcat [options] [filter] [filter] # (view device log)
adb bugreport # (print bug reports)
```

## Permissions

```bash
adb shell permissions groups # (list permission groups definitions)
adb shell list permissions -g -r # (list permissions details)
```

## Pull APK from Device

1.  Connect to your device and verify connection

    ```bash
    # Connect to device
    # adb connect <device ip address>:<port>
    $ adb connect 10.0.0.45:5555
    connected to 10.0.0.45:5555

    # Verify connection
    $  adb devices 
    List of devices attached
    10.0.0.45:5555	device
    ```

2.  Find the APK and Download

    ```bash
    # List packages and grep the APK name
    # adb shell pm list packages | grep -i '<you apk/app name'
    $ adb shell pm list packages | grep -i 'abcnews'
    com.abc.abcnews
    # Find the path of the APK
    # adb shell pm path <package name>
    $ adb shell pm path com.abc.abcnews
    package:/data/app/com.abc.abcnews/base.apk
    # Download the APK
    # adb pull /data/app/path to apk
    $ adb pull /data/app/com.abc.abcnews/base.apk
    /data/app/com.abc.abcnews/base.apk: 1 file pulled. 6.4 MB/s (75796367 bytes in 11.290s)
    ```

## ADB Manual

```bash
# NAME
#        adb - Android Debug Bridge

# SYNOPSIS
$        adb [-d|-e|-s serialNumber] command

# DESCRIPTION

#        Android Debug Bridge (adb) is a versatile command line tool that lets you communicate with
#        an emulator instance or connected Android-powered device.  It is a  client-server  program
#        that includes three components:

#        · A  client,  which sends commands.  The client runs on your development machine.  You can
#          invoke a client from a shell by issuing an adb command.  Other  Android  tools  such  as
#          DDMS also create adb clients.

#        · A  daemon,  which runs commands on a device.  The daemon runs as a background process on
#          each emulator or device instance.

#        · A server, which manages communication between the client and  the  daemon.   The  server
#          runs as a background process on your development machine.

#        If there's only one emulator running or only one device connected, the adb command is sent
#        to that device by default.  If multiple emulators are running and/or multiple devices  are
#        attached,  you  need to use the -d, -e, or -s option to specify the target device to which
#        the command should be directed.

# OPTIONS

#        -a     Directs adb to listen on all interfaces for a connection.

#        -d     Directs command to the only connected USB device.  Returns an error  if  more  than
#               one USB device is present.

#        -e     Directs  command  to  the only running emulator.  Returns an error if more than one
#               emulator is running.

#        -s specific device
#               Directs command to  the  device  or  emulator  with  the  given  serial  number  or
#               qualifier.  Overrides ANDROID_SERIAL environment variable.

#        -p product name or path
#               Simple  product  name  like  sooner,  or  a relative/absolute path to a product out
#               directory  like  out/target/product/sooner.   If   -p   is   not   specified,   the
#               ANDROID_PRODUCT_OUT environment variable is used, which must be an absolute path.

#        -H     Name of adb server host (default: localhost)

#        -P     Port of adb server (default: 5037)

# COMMANDS

#        adb devices [-l]
#               List all connected devices.  -l will also list device qualifiers.

#        adb connect host[:port]
#               Connect  to a device via TCP/IP.  Port 5555 is used by default if no port number is
#               specified.

#        adb disconnect [host[:port]]
#               Disconnect from a TCP/IP device.  Port 5555 is used by default if no port number is
#               specified.   Using  this  command with no additional arguments will disconnect from
#               all connected TCP/IP devices.

#    Device commands
#        adb push local... remote
#               Copy file/dir to device.

#        adb pull [-a] remote [local]
#               Copy file/dir from device.  -a means copy timestamp and mode.

#        adb sync [-l] [directory]
#               Copy host->device only if changed.  -l means list but don't copy.

#        If directory is not specified, /system, /vendor (if present), /oem (if present) and  /data
#        partitions will be updated.

#        If it is system, vendor, oem or data, only the corresponding partition is updated.

#        adb shell [-e escape] [-n] [-T|-t] [-x] [command]
#               Run remote shell command (interactive shell if no command given)

#        · -e: Choose escape character, or none; default ~

#        · -n: Don't read from stdin

#        · -T: Disable PTY allocation

#        · -t: Force PTY allocation

#        · -x: Disable remote exit codes and stdout/stderr separation

#        adb emu command
#          Run emulator console command

#        adb logcat [filter-spec]
#          View device log.

#        adb forward --list
#          List  all  forward socket connections.  The format is a list of lines with the following
#          format: serial " " local " " remote ""

#        adb forward local remote
#          Forward socket connections.

#        Forward specs are one of:

#        · tcp:port

#        · localabstract:unix domain socket name

#        · localreserved:unix domain socket name

#        · localfilesystem:unix domain socket name

#        · dev:character device name

#        · jdwp:process pid (remote only)

#        adb forward --no-rebind local remote
#          Same as "adb forward local remote" but fails if local is already forwarded

#        adb forward --remove local
#          Remove a specific forward socket connection.

#        adb forward --remove-all
#          Remove all forward socket connections.

#        adb reverse --list
#          List all reverse socket connections from device.

#        adb reverse remote local
#          Reverse socket connections.

#        Reverse specs are one of:

#        · tcp:port

#        · localabstract:unix domain socket name

#        · localreserved:unix domain socket name

#        · localfilesystem:unix domain socket name

#        adb reverse --no-rebind remote local
#          Same as 'adb reverse remote local' but fails if remote is already reversed.

#        adb reverse --remove remote
#          Remove a specific reversed socket connection.

#        adb reverse --remove-all
#          Remove all reversed socket connections from device.

#        adb jdwp
#          List PIDs of processes hosting a JDWP transport.

#        adb install [-lrtsdg] file
#          Push this package file to the device and install it.

#        · -l: Forward lock application.

#        · -r: Replace existing application.

#        · -t: Allow test packages.

#        · -s: Install application on sdcard.

#        · -d: Allow version code downgrade (debuggable packages only).

#        · -g: Grant all runtime permissions.

#        adb install-multiple [-lrtsdpg] file...
#          Push this package file to the device and install it.

#        · -l: Forward lock application.

#        · -r: Replace existing application.

#        · -t: Allow test packages.

#        · -s: Install application on sdcard.

#        · -d: Allow version code downgrade (debuggable packages only).

#        · -p: Partial application install.

#        · -g: Grant all runtime permissions.

#        adb uninstall [-k] package
#          Remove this app package from the device.  -k means keep the data and cache directories.

#        adb bugreport [zipfile]
#          Return all information from the device that should be included  in  a  bug  report  that
#          should be included in a bug report.

#        adb    backup   [-f   file]   [-apk|-noapk]   [-obb|-noobb]   [-shared|-noshared]   [-all]
#        [-system|-nosystem] [packages...]
#          Write an archive of the device's data to file.  If no -f option  is  supplied  then  the
#          data is written to backup.ab in the current directory.

#        -apk | -noapk enable/disable backup of the .apks themselves in the archive; the default is
#        noapk.

#        -obb | -noobb enable/disable backup of  any  installed  apk  expansion  (aka  .obb)  files
#        associated with each application; the default is noobb.

#        -shared  |  -noshared  enable/disable  backup  of  the  device's  shared storage / SD card
#        contents; the default is noshared.

#        -all means to back up all installed applications.

#        -system | -nosystem toggles whether -all automatically includes system  applications;  the
#        default is to include system apps.

#        packages... is the list of applications to be backed up.  If the -all or -shared flags are
#        passed, then the package list is optional.  Applications explicitly given on  the  command
#        line will be included even if -nosystem would ordinarily cause them to be omitted.

#        adb restore file
#               Restore device contents from the file backup archive.

#        adb disable-verity
#               Disable dm-verity checking on USERDEBUG builds.

#        adb enable-verity
#               Re-enable dm-verity checking on USERDEBUG builds.

#        adb keygen file
#               Generate adb public/private key.  The private key is stored in file, and the public
#               key is stored in file.pub.  Any existing files are overwritten.

#        adb help
#               Show help message.

#        adb version
#               Show version number.

#    Scripting
#        adb wait-for-[-transport]-state
#               Wait for  device  to  be  in  the  given  state:  device,  recovery,  sideload,  or
#               bootloader.  transport is: usb, local or any (default = any)

#        adb start-server
#               Ensure that there is a server running.

#        adb kill-server
#               Kill the server if it is running.

#        adb get-state
#               Prints: offline | bootloader | device

#        adb get-serialno
#               Prints: serial-number.

#        adb get-devpath
#               Prints: device-path.

#        adb remount
#               Remounts  the /system, /vendor (if present) and /oem (if present) partitions on the
#               device read-write.

#        adb reboot [bootloader|recovery]
#               Reboots the device, optionally into the bootloader or recovery program.

#        adb reboot sideload
#               Reboots the device into the sideload mode in recovery program (adb root required).

#        adb reboot sideload-auto-reboot
#               Reboots into the sideload mode,  then  reboots  automatically  after  the  sideload
#               regardless of the result.

#        adb sideload file
#               Sideloads the given package.

#        adb root
#               Restarts the adbd daemon with root permissions.

#        adb unroot
#               Restarts the adbd daemon without root permissions.

#        adb usb
#               Restarts the adbd daemon listening on USB.

#        adb tcpip port
#               Restarts the adbd daemon listening on TCP on the specified port.

#    Networking
#        adb ppp tty [parameters]
#               Run PPP over USB.

#        parameters: E.g.  defaultroute debug dump local notty usepeerdns

#        Note:  you should not automatically start a PPP connection.  tty refers to the tty for PPP
#        stream.  E.g.  dev:/dev/omap_csmi_tty1

# Internal Debugging

#        adb reconnect
#               Kick current connection from host side and make it reconnect.

#        adb reconnect device
#               Kick current connection from device side and make it reconnect.

# ENVIRONMENT VARIABLES

#        ADB_TRACE
#               Print debug information.  A comma separated list of the following values 1 or  all,
#               adb, sockets, packets, rwx, usb, sync, sysdeps, transport, jdwp

#        ANDROID_SERIAL
#               The serial number to connect to.  -s takes priority over this if given.

#        ANDROID_LOG_TAGS
#               When used with the logcat option, only these debug tags are printed.



```
