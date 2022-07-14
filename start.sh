#!/bin/bash

# requires sudo to create directories and ramdisk
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (e.g. with sudo)"
  exit
fi
mount -t tmpfs -o size=4G tmpfs /mnt/ramdisk 
mkdir -p /mnt/ramdisk/mariadb/data       
mkdir -p /mnt/ramdisk/mariadb/config       
cp ./server.cnf /mnt/ramdisk/mariadb/config/server.cnf
docker compose up -d
