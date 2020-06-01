#!/bin/bash
if [ ! -d "/home/pi/org" ]; then
mkdir /home/pi/org
mkfs -q  /dev/ram1 2048
mount -y /dev/ram1 /home/pi/org
chown pi /home/pi/org
chown pi /dev/ram1
fi
