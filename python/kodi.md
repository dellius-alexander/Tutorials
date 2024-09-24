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
kodi-addons-dev 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (addon development package)

kodi-addons-dev-common 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (architecture-independent addon development package)

kodi-audiodecoder-fluidsynth 
    # 20.2.1+ds1-2 arm64
    # Fluidsynth audio decoder for Kodi

kodi-audiodecoder-openmpt 
    # 20.2.0+ds1-2 arm64
    # OpenMPT audio decoder for Kodi

kodi-audiodecoder-sidplay 
    # 20.2.0+ds1-2 arm64
    # SidPlay audio decoder for Kodi

kodi-audioencoder-flac 
    # 20.2.0+ds1-2 arm64
    # FLAC audio encoder add-on for Kodi

kodi-audioencoder-lame 
    # 20.3.0+ds1-2 arm64
    # LAME (mp3) audio encoder add-on for Kodi

kodi-audioencoder-vorbis 
    # 20.2.0+ds1-2 arm64
    # Vorbis audio encoder add-on for Kodi

kodi-audioencoder-wav 
    # 20.2.0-2 arm64
    # WAV audio encoder add-on for Kodi

kodi-bin 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (architecture-dependent files)

kodi-data 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (arch-independent data package)

kodi-eventclients-common 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (Event Client Common package)

kodi-eventclients-dev 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client virtual dev package)

kodi-eventclients-dev-common 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (Event Client common dev package)

kodi-eventclients-kodi-send 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client Kodi-SEND package)

kodi-eventclients-ps3 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client PS3 package)

kodi-eventclients-python 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client Python package)

kodi-eventclients-wiiremote 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client WII Remote support package)

kodi-eventclients-zeroconf 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (Event Client ZeroConf script package)

kodi-game-libretro 
    # 20.2.2-2 arm64
    # Libretro wrapper for Kodi's Game API

kodi-game-libretro-bsnes-mercury-accuracy 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury accuracy core

kodi-game-libretro-bsnes-mercury-balanced 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury balanced core

kodi-game-libretro-bsnes-mercury-performance 
    # 094+git20220807-6ubuntu1 arm64
    # Kodi integration for bsnes-mercury performance core

kodi-imagedecoder-heif 
    # 20.1.0+ds1-2 arm64
    # HEIF image decoder for Kodi

kodi-imagedecoder-raw 2
    # 0.1.0+ds1-2 arm64
    # RAW image decoder for Kodi
#####################################################################  
# Inputstreams Dependencies
kodi-inputstream-adaptive 
    # 20.3.2+ds-1 arm64
    # Adaptive inputstream addon for Kodi

kodi-inputstream-ffmpegdirect 
    # 20.5.0+ds1-1 arm64
    # FFmpegDirect inputstream addon for Kodi

kodi-inputstream-rtmp 
    # 20.3.0+ds1-1 arm64
    # Kodi input stream addon for RTMP
#####################################################################
kodi-peripheral-joystick 
    # 20.1.3+ds-1 arm64
    # Kodi Joystick Library

kodi-peripheral-xarcade 
    # 20.1.3-1 arm64
    # X-Arcade Tankstick driver for Kodi

kodi-pvr-argustv 
    # 20.5.0+ds1-1 arm64
    # ARGUS TV PVR addon for Kodi

kodi-pvr-dvblink 
    # 20.3.0+ds1-1 arm64
    # DVBLink PVR Client for Kodi

kodi-pvr-dvbviewer 
    # 20.4.0+ds1-1 arm64
    # DVBViewer Kodi PVR Addon

kodi-pvr-filmon 
    # 20.3.0+ds1-1 arm64
    # Filmon PVR client addon for Kodi

kodi-pvr-hdhomerun 
    # 20.4.0+ds1-1 arm64
    # HDHomeRun PVR Addon for Kodi

kodi-pvr-hts 
    # 20.6.0+ds1-1 arm64
    # Kodi PVR Addon TvHeadend Hts

kodi-pvr-iptvsimple 
    # 20.6.1+ds-1 arm64
    # IPTV Simple Client Kodi PVR Addon

kodi-pvr-mediaportal-tvserver 
    # 20.3.0+ds1-1 arm64
    # MediaPortal's TV-Server PVR addon for Kodi

kodi-pvr-mythtv 
    # 20.3.0+ds1-1 arm64
    # MythTV PVR Addon for Kodi

kodi-pvr-nextpvr 
    # 20.3.1+ds1-1 arm64
    # NextPVR PVR addon for Kodi

kodi-pvr-njoy 
    # 20.3.0+ds1-1 arm64
    # NJOY PVR Addon for Kodi

kodi-pvr-octonet 
    # 20.3.0+ds1-1 arm64
    # Digital Devices Octopus NET PVR for Kodi

kodi-pvr-pctv 
    # 20.4.0+ds1-1 arm64
    # PCTV PVR client addon for Kodi

kodi-pvr-sledovanitv-cz 
    # 20.3.0+ds1-1 arm64
    # sledovanitv.cz PVR for Kodi

kodi-pvr-stalker 
    # 20.3.1+ds1-1 arm64
    # Stalker Middleware PVR client addon for Kodi

kodi-pvr-teleboy 
    # 20.3.3+ds-1 arm64
    # Teleboy PVR for Kodi

kodi-pvr-vbox 
    # 20.3.0+ds1-1 arm64
    # VBox Home TV Gateway addon for Kodi

kodi-pvr-vdr-vnsi 
    # 20.4.0+ds1-1 arm64
    # Kodi PVR Addon VDR VNSI

kodi-pvr-vuplus 
    # 20.4.1+ds-1 arm64
    # Vu+/Enigma2 PVR Addon for Kodi

kodi-pvr-waipu 
    # 20.6.0+ds1-1 arm64
    # waipu PVR for Kodi

kodi-pvr-wmc 
    # 20.3.0-1 arm64
    # WMC PVR Addon for Kodi

kodi-pvr-zattoo 
    # 20.3.3+ds-1 arm64
    # Zattoo PVR for Kodi

kodi-repository-kodi 
    # 2:20.0+dfsg-2 all
    # Open Source Home Theatre (official addons repository feed)

kodi-screensaver-asteroids 
    # 20.1.0+ds1-2 arm64
    # Asteroids screensaver for Kodi

kodi-screensaver-biogenesis   
    # 20.1.0-2 arm64
    # BioGenesis screensaver for Kodi

kodi-screensaver-greynetic 
    # 20.1.0+ds1-2 arm64
    # Greynetic screensaver for Kodi

kodi-screensaver-pingpong 
    # 20.1.0+ds1-2 arm64
    # Pingpong screensaver for Kodi

kodi-screensaver-pyro 
    # 20.1.0-2 arm64
    # Pyro screensaver for Kodi

kodi-screensaver-shadertoy 
    # 20.1.0+ds1-2 arm64
    # Shadertoy screensaver for Kodi

kodi-tools-texturepacker 
    # 2:20.0+dfsg-2 arm64
    # Open Source Home Theatre (TexturePacker skin development tool)

kodi-vfs-libarchive   
    # 20.2.0+ds1-1 arm64
    # Libarchive VFS add-on for Kodi

kodi-vfs-sftp 
    # 20.1.0+ds1-2 arm64
    # SSH File Transfer Protocol for Kodi

kodi-visualization-fishbmc 
    # 20.2.0+ds1-1 arm64

    # Fishbmc audio visualization addon for Kodi

kodi-visualization-pictureit 
    # 20.2.0+ds1-1 arm64
    # pictureit visualizer for Kodi
kodi-visualization-shadertoy 
    # 20.3.0+ds1-1 arm64
    # Shadertoy audio visualization for Kodi

kodi-visualization-shadertoy-data 
    # 20.3.0+ds1-1 all
    # Shadertoy audio visualization for Kodi (common data)

kodi-visualization-spectrum 
    # 20.2.0+ds1-1 arm64
    # Spectrum visualizer addon for Kodi

kodi-visualization-waveform 
    # 20.2.1+ds1-1 arm64
    # Waveform audio visualization addon for Kodi

libudfread-dev 
    # 1.1.2-1 arm64
    # UDF reader library (development files)

libudfread0
    # 1.1.2-1 arm64 [installed,automatic]
    # UDF reader library

minidlna 
    # 1.3.0+dfsg-2.2build2 arm64
    # lightweight DLNA/UPnP-AV server targeted at embedded systems

vdr-plugin-vnsiserver 
    # 1:1.8.0+git20211205-2 arm64
    # VDR plugin to provide PVR backend services for Kodi

```
