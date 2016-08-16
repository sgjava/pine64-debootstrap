#!/bin/sh
#
# Created on Aug 15, 2016
#
# @author: sgoldsmith
#
# Install ubuntu-pine64-flavour-makers, cpufrequtils and usbutils
#
# Steven P. Goldsmith
# sgjava@gmail.com
# 
# Prerequisites:
#
# o You built rootfs from scripts
#

# Get start time
dateformat="+%a %b %-eth %Y %I:%M:%S %p %Z"
starttime=$(date "$dateformat")
starttimesec=$(date +%s)

# Get current directory
curdir=$(cd `dirname $0` && pwd)

# stdout and stderr for commands logged
logfile="$curdir/pine64.log"
rm -f $logfile

# Simple logger
log(){
	timestamp=$(date +"%m-%d-%Y %k:%M:%S")
	echo "\n$timestamp $1"
	echo "\n$timestamp $1" >> $logfile 2>&1
}

# Add ubuntu-pine64-flavour-makers ppa
cat << EOF >> /etc/apt/sources.list

deb http://ppa.launchpad.net/longsleep/ubuntu-pine64-flavour-makers/ubuntu xenial main
deb-src http://ppa.launchpad.net/longsleep/ubuntu-pine64-flavour-makers/ubuntu xenial main
EOF

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 56A3D45E

apt-get update >> $logfile 2>&1

# Install packages
apt-get -y install sunxi-disp-tool linux-firmware cpufrequtils usbutils
apt-get -y autoremove
apt-get clean

# Disable ondemand governor
update-rc.d ondemand disable

# Configure cpufrequtils (tweak as needed)
cat << EOF > /etc/default/cpufrequtils
ENABLE="true"
GOVERNOR="conservative"
MAX_SPEED=1632000
MIN_SPEED=96000
EOF

# Display udev rules
cat << EOF > /etc/udev/rules.d/90-sunxi-disp-permission.rules
KERNEL=="disp", MODE="0770", GROUP="video"
KERNEL=="cedar_dev", MODE="0770", GROUP="video"
KERNEL=="ion", MODE="0770", GROUP="video"
KERNEL=="mali", MODE="0770", GROUP="video"
EOF

# Get end time
endtime=$(date "$dateformat")
endtimesec=$(date +%s)

# Show elapse time
elapsedtimesec=$(expr $endtimesec - $starttimesec)
ds=$((elapsedtimesec % 60))
dm=$(((elapsedtimesec / 60) % 60))
dh=$((elapsedtimesec / 3600))
displaytime=$(printf "%02d:%02d:%02d" $dh $dm $ds)

log "Elapsed time: $displaytime\n"
exit 0
