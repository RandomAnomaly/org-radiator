#!/bin/bash

mkdir ~/org
mkfs -q /dev/ram1 2048
mount /dev/ram1 /home/pi/org
chown pi /home/pi/org
chown pi /dev/ram1
