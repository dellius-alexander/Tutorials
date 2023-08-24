# Kodi installation

## Install Kodi base package with minimal dependencies

### Base Install

```bash
$ sudo apt-get install -y kodi
```

### Base and Minimal Dependencies

```bash
# see Dependency list for details
sudo apt-get install -y \
kodi \
kodi-inputstream-adaptive \
kodi-inputstream-ffmpegdirect \
kodi-inputstream-rtmp \
kodi-pvr-iptvsimple

```

## Install Kodi dependencies

### List Dependencies

```bash
# List dependencies
apt search 'kodi-*'
```

### Install Dependencies

```bash
kodi-addons-dev/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (addon development package)

kodi-addons-dev-common/lunar 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (architecture-independent addon development package)

kodi-audiodecoder-fluidsynth/lunar 
    # 20.2.1+ds1-2 arm64
    # Fluidsynth audio decoder for Kodi

kodi-audiodecoder-openmpt/lunar 
    # 20.2.0+ds1-2 arm64
    # OpenMPT audio decoder for Kodi

kodi-audiodecoder-sidplay/lunar 
    # 20.2.0+ds1-2 arm64
    # SidPlay audio decoder for Kodi

kodi-audioencoder-flac/lunar 
    # 20.2.0+ds1-2 arm64
    # FLAC audio encoder add-on for Kodi

kodi-audioencoder-lame/lunar 
    # 20.3.0+ds1-2 arm64
    # LAME (mp3) audio encoder add-on for Kodi

kodi-audioencoder-vorbis/lunar 
    # 20.2.0+ds1-2 arm64
    # Vorbis audio encoder add-on for Kodi

kodi-audioencoder-wav/lunar 
    # 20.2.0-2 arm64
    # WAV audio encoder add-on for Kodi

kodi-bin/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (architecture-dependent files)

kodi-data/lunar 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (arch-independent data package)

kodi-eventclients-common/lunar 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (Event Client Common package)

kodi-eventclients-dev/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client virtual dev package)

kodi-eventclients-dev-common/lunar 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (Event Client common dev package)

kodi-eventclients-kodi-send/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client Kodi-SEND package)

kodi-eventclients-ps3/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client PS3 package)

kodi-eventclients-python/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client Python package)

kodi-eventclients-wiiremote/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client WII Remote support package)

kodi-eventclients-zeroconf/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client ZeroConf script package)

kodi-game-libretro/lunar 
    # 20.2.2-2 arm64
    # Libretro wrapper for Kodi's Game API

kodi-game-libretro-bsnes-mercury-accuracy/lunar 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury accuracy core

kodi-game-libretro-bsnes-mercury-balanced/lunar 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury balanced core

kodi-game-libretro-bsnes-mercury-performance/lunar 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury performance core

kodi-imagedecoder-heif/lunar 
    # 20.1.0+ds1-2 arm64
    # HEIF image decoder for Kodi

kodi-imagedecoder-raw/lunar 2
    # 0.1.0+ds1-2 arm64
    # RAW image decoder for Kodi
#####################################################################  
# Inputstreams Dependencies
kodi-inputstream-adaptive/lunar 
    # 20.3.2+ds-1 arm64
    # Adaptive inputstream addon for Kodi

kodi-inputstream-ffmpegdirect/lunar 
    # 20.5.0+ds1-1 arm64
    # FFmpegDirect inputstream addon for Kodi

kodi-inputstream-rtmp/lunar 
    # 20.3.0+ds1-1 arm64
    # Kodi input stream addon for RTMP
#####################################################################
kodi-peripheral-joystick/lunar 
    # 20.1.3+ds-1 arm64
    # Kodi Joystick Library

kodi-peripheral-xarcade/lunar 
    # 20.1.3-1 arm64
    # X-Arcade Tankstick driver for Kodi

kodi-pvr-argustv/lunar 
    # 20.5.0+ds1-1 arm64
    # ARGUS TV PVR addon for Kodi

kodi-pvr-dvblink/lunar 
    # 20.3.0+ds1-1 arm64
    # DVBLink PVR Client for Kodi

kodi-pvr-dvbviewer/lunar 
    # 20.4.0+ds1-1 arm64
    # DVBViewer Kodi PVR Addon

kodi-pvr-filmon/lunar 
    # 20.3.0+ds1-1 arm64
    # Filmon PVR client addon for Kodi

kodi-pvr-hdhomerun/lunar 
    # 20.4.0+ds1-1 arm64
    # HDHomeRun PVR Addon for Kodi

kodi-pvr-hts/lunar 
    # 20.6.0+ds1-1 arm64
    # Kodi PVR Addon TvHeadend Hts

kodi-pvr-iptvsimple/lunar 
    # 20.6.1+ds-1 arm64
    # IPTV Simple Client Kodi PVR Addon

kodi-pvr-mediaportal-tvserver/lunar 
    # 20.3.0+ds1-1 arm64
    # MediaPortal's TV-Server PVR addon for Kodi

kodi-pvr-mythtv/lunar 
    # 20.3.0+ds1-1 arm64
    # MythTV PVR Addon for Kodi

kodi-pvr-nextpvr/lunar 
    # 20.3.1+ds1-1 arm64
    # NextPVR PVR addon for Kodi

kodi-pvr-njoy/lunar 
    # 20.3.0+ds1-1 arm64
    # NJOY PVR Addon for Kodi

kodi-pvr-octonet/lunar 
    # 20.3.0+ds1-1 arm64
    # Digital Devices Octopus NET PVR for Kodi

kodi-pvr-pctv/lunar 
    # 20.4.0+ds1-1 arm64
    # PCTV PVR client addon for Kodi

kodi-pvr-sledovanitv-cz/lunar 
    # 20.3.0+ds1-1 arm64
    # sledovanitv.cz PVR for Kodi

kodi-pvr-stalker/lunar 
    # 20.3.1+ds1-1 arm64
    # Stalker Middleware PVR client addon for Kodi

kodi-pvr-teleboy/lunar 
    # 20.3.3+ds-1 arm64
    # Teleboy PVR for Kodi

kodi-pvr-vbox/lunar 
    # 20.3.0+ds1-1 arm64
    # VBox Home TV Gateway addon for Kodi

kodi-pvr-vdr-vnsi/lunar 
    # 20.4.0+ds1-1 arm64
    # Kodi PVR Addon VDR VNSI

kodi-pvr-vuplus/lunar 
    # 20.4.1+ds-1 arm64
    # Vu+/Enigma2 PVR Addon for Kodi

kodi-pvr-waipu/lunar 
    # 20.6.0+ds1-1 arm64
    # waipu PVR for Kodi

kodi-pvr-wmc/lunar 
    # 20.3.0-1 arm64
    # WMC PVR Addon for Kodi

kodi-pvr-zattoo/lunar 
    # 20.3.3+ds-1 arm64
    # Zattoo PVR for Kodi

kodi-repository-kodi/lunar 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (official addons repository feed)

kodi-screensaver-asteroids/lunar 
    # 20.1.0+ds1-2 arm64
    # Asteroids screensaver for Kodi

kodi-screensaver-biogenesis/lunar   
    # 20.1.0-2 arm64
    # BioGenesis screensaver for Kodi

kodi-screensaver-greynetic/lunar 
    # 20.1.0+ds1-2 arm64
    # Greynetic screensaver for Kodi

kodi-screensaver-pingpong/lunar 
    # 20.1.0+ds1-2 arm64
    # Pingpong screensaver for Kodi

kodi-screensaver-pyro/lunar 
    # 20.1.0-2 arm64
    # Pyro screensaver for Kodi

kodi-screensaver-shadertoy/lunar 
    # 20.1.0+ds1-2 arm64
    # Shadertoy screensaver for Kodi

kodi-tools-texturepacker/lunar 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (TexturePacker skin development tool)

kodi-vfs-libarchive/lunar   
    # 20.2.0+ds1-1 arm64
    # Libarchive VFS add-on for Kodi

kodi-vfs-sftp/lunar 
    # 20.1.0+ds1-2 arm64
    # SSH File Transfer Protocol for Kodi

kodi-visualization-fishbmc/lunar 
    # 20.2.0+ds1-1 arm64

    # Fishbmc audio visualization addon for Kodi

kodi-visualization-pictureit/lunar 
    # 20.2.0+ds1-1 arm64
    # pictureit visualizer for Kodi
kodi-visualization-shadertoy/lunar 
    # 20.3.0+ds1-1 arm64
    # Shadertoy audio visualization for Kodi

kodi-visualization-shadertoy-data/lunar 
    # 20.3.0+ds1-1 all
    # Shadertoy audio visualization for Kodi (common data)

kodi-visualization-spectrum/lunar 
    # 20.2.0+ds1-1 arm64
    # Spectrum visualizer addon for Kodi

kodi-visualization-waveform/lunar 
    # 20.2.1+ds1-1 arm64
    # Waveform audio visualization addon for Kodi

libudfread-dev/lunar 
    # 1.1.2-1 arm64
    # UDF reader library (development files)

libudfread0/lunar,now 
    # 1.1.2-1 arm64 [installed,automatic]
    # UDF reader library

minidlna/lunar 
    # 1.3.0+dfsg-2.2build2 arm64
    # lightweight DLNA/UPnP-AV server targeted at embedded systems

vdr-plugin-vnsiserver/lunar 
    # 1:1.8.0+git20211205-2 arm64
    # VDR plugin to provide PVR backend services for Kodi

```