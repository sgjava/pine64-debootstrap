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
* 5V/2A PSU (make sure the PSU puts out stable power or it might not boot)
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
* Insert SD card into PINE64 along with 5V/2A PSU, network cable, USB keyboard and HDMI display
* Power on PINE64
* Login as ubuntu/ubuntu
* `ifconfig` and get IP address assigned by DHCP.
* Switch back to your PC and `ssh ubuntu@ipaddress`
* Resize SD card
    * `cd /usr/local/sbin`
    * `sudo ./resize_rootfs.sh`
* `sudo apt-get update`
* `sudo apt-get upgrade`

### Create rootfs
* `sudo apt-get install git-core`
* `git clone https://github.com/sgjava/pine64-debootstrap.git`
* `cd pine64-debootstrap`
* Pick your native language pack instead of en if desired
    * `sudo nano minimal.sh`
* `sudo ./start.sh`
    * Answer prompts required by debootstrap second stage
* `sudo ./finish.sh`
* Copy archive to your PC/laptop
    * `scp ubuntu@ipaddress:~/pine64-debootstrap/pine64-xenial-arm64.tar.gz .`

### Extract rootfs and boot
* Use a fresh SD Longsleep's image. We are going to delete the old rootfs, so insert the SD into your PC/laptop
* Mount SD and find path
    * Under Ubuntu 16.04 it mounted as `/media/username/rootfs` (change username as needed)
* Delete Longsleep's rootfs
    * `sudo rm -rf /media/username/rootfs`
    * `sync`
* Extract new rootfs to SD
    * `sudo tar -pzxf pine64-xenial-arm64.tar.gz -C /media/username/rootfs`
    * Wait a minute or so before sync (I waited for my SD writer activity light to stop blinking). I seem to have better luck this way producing a clean rootfs  
    * `sync`
    * Eject SD and boot in PINE64
    * Login as test (and password you assigned)
    
### After you can boot successfully
* Install linux-firmware cpufrequtils usbutils
    * `sudo su -`
    * `apt-get -y install linux-firmware cpufrequtils usbutils`
    * `update-rc.d ondemand disable`
    * <pre><code>cat << EOF > /etc/default/cpufrequtils
      ENABLE="true"
      GOVERNOR="conservative"
      MAX_SPEED=960000
      MIN_SPEED=480000
      EOF</code></pre>
    * `reboot -f`

### Configure wifi
* Plug in USB Wifi adapter and boot PINE64 (I used ODROID [Wifi Module 3](http://www.hardkernel.com/main/products/prdt_info.php?g_code=G137447734369))
* `lsusb`
    * `Bus 001 Device 002: ID 0bda:8176 Realtek Semiconductor Corp. RTL8188CUS 802.11n WLAN Adapter`
* `iwconfig`
    * <pre><code>wlx7cff80d3271f  IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:on</code></pre>
* Copy device name (wlx7cff80d3271f for example from above)
* `sudo nano /etc/network/interfaces.d/wlx7cff80d3271f`
    * For DHCP
    <pre><code>auto wlx7cff80d3271f
    iface wlx7cff80d3271f inet dhcp
    wpa-ssid ssid
    wpa-psk password</code></pre>    
    * For static
    <pre><code>auto wlx7cff80d3271f
    iface wlx7cff80d3271f inet static
    address 192.168.1.69
    netmask 255.255.255.0
    gateway 192.168.1.1
    dns-nameservers 192.168.1.1
    wpa-ssid ssid
    wpa-psk password</code></pre>
* `sudo reboot -f`
* `iwconfig`
    * <pre><code>wlx7cff80d3271f  IEEE 802.11bgn  ESSID:"cybertown"  
          Mode:Managed  Frequency:2.437 GHz  Access Point: FF:EE:FF:F2:FF:FE   
          Bit Rate=7.2 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr=2347 B   Fragment thr:off
          Power Management:off
          Link Quality=62/70  Signal level=-48 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:5   Missed beacon:0</code></pre>
* Wifi only
    *  Comment out all lines in eth0
    * `sudo nano /etc/network/interfaces.d/eth0`
    * Disconnect Ethernet cable
    * `sudo reboot -f`

### FreeBSD License
Copyright (c) Steven P. Goldsmith

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
