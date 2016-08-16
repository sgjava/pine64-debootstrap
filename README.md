```
______ _____ _   _  _____  ____    ___       _      _                 _       _                   
| ___ \_   _| \ | ||  ___|/ ___|  /   |     | |    | |               | |     | |                  
| |_/ / | | |  \| || |__ / /___  / /| |   __| | ___| |__   ___   ___ | |_ ___| |_ _ __ __ _ _ __  
|  __/  | | | . ` ||  __|| ___ \/ /_| |  / _` |/ _ \ '_ \ / _ \ / _ \| __/ __| __| '__/ _` | '_ \ 
| |    _| |_| |\  || |___| \_/ |\___  | | (_| |  __/ |_) | (_) | (_) | |_\__ \ |_| | | (_| | |_) |
\_|    \___/\_| \_/\____/\_____/    |_/  \__,_|\___|_.__/ \___/ \___/ \__|___/\__|_|  \__,_| .__/ 
                                                                                           | |    
                                                                                           |_|
```
If you want to build your own Ubuntu 16.04 rootfs from [Longsleep's](http://forum.pine64.org/showthread.php?tid=376) [image](https://www.stdin.xyz/downloads/people/longsleep/pine64-images/ubuntu) then you stopped by the right place. You just have to run a few scripts (only one is interactive)
and you will end up with a rootfs archive to copy to SD.

### Requirements
* [PINE64](https://www.pine64.com) (tested on 2GB version)
* SD card with [Longsleep's](https://www.stdin.xyz/downloads/people/longsleep/pine64-images/ubuntu) latest image
    * Use a second SD if you do not want to destroy the rootfs with Longsleep's image. It will need to contain the same image in order to boot.
* PINE64 has Internet access
* HDMI display
* USB keyboard to log in and get IP address after first boot
* PC/laptop to SSH into PINE64

### Provides
* Minimal Ubuntu 16.04 server for headless use
    * You can add a desktop later on if you wish
    * Weighs in at under 1 GB uncompressed (slightly larger than Longsleep's image)
* USB wifi enabled
    * Tested with ODROID Wifi Module 3
    
### Prepare PINE64
* If you already have an SD with Longsleep's image then skip to [Create rootfs](#create-rootfs)
* [Create](https://www.stdin.xyz/downloads/people/longsleep/pine64-images/ubuntu/README.txt) bootable SD from Longsleep's image
* Insert SD card into PINE64 along with network cable, USB keyboard and HDMI display
* Power on PINE64
* Login as ubuntu/ubuntu
* `ifconfig` and get IP address assigned by DHCP.
* Switch back to your PC and `ssh ubuntu@ipaddress`
* Resize SD card
    * `cd /usr/local/sbin`
    * `sudo ./resize_rootfs.sh`
* `sudo apt-get update`
* `sudo apt-get upgrade`
* `sudo apt-get install git-core`

### Create rootfs
* `git clone https://github.com/sgjava/pine64-debootstrap.git`
* `cd pine64-debootstrap`
* Pick your native language pack instead of en if desired
    * `sudo nano minimal.sh`
* `sudo ./start.sh`
* Answer prompts required by debootstrap second stage

### FreeBSD License
Copyright (c) Steven P. Goldsmith

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
