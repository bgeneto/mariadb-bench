#!/bin/bash
sudo mount -t tmpfs -o size=4G tmpfs /mnt/ramdisk 
sudo mkdir -p /mnt/ramdisk/mariadb/data       
sudo mkdir -p /mnt/ramdisk/mariadb/config       
sudo cp ./server.cnf /mnt/ramdisk/mariadb/config/server.cnf
docker compose up -d
