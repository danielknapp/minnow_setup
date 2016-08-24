#!/bin/bash
#
# Script run when the minnowboard boots. Should get up the WiFi adapters,
# attempt to connect to the qx1 camera, 

{
echo "Boot script starting"
date

# Get WiFi adapters up
# sudo ifconfig wlan0 up
# sudo ifconfig wlan1 up

# Connect to qx1 camera and get ip
# /home/camerarig/dk_connect_qx1ssid.sh
# sudo dhclient wlan0

# Start Ad-hoc network
# /home/camerarig/dk_adhoc.sh
#/home/camerarig/dk_adhoc2.sh

# Start hostapd for an access point
sudo hostapd -B /etc/hostapd/hostapd.conf

sudo service isc-dhcp-server start

sleep 2

sudo /home/camerarig/dk_connect_qx1ssid.sh
# sudo dhclient wlan1

sleep 10

sudo dhclient wlan1

sudo /home/camerarig/3d-visualization-system/qx1/qx100.py 2>&1 > /home/camerarig/logs/qx100_server.log &

echo "Boot script ending"
} >> /home/camerarig/logs/boot_log.txt 2>&1
