ifconfig wlan0 down
sleep 1
iwconfig wlan0 channel 1
iwconfig wlan0 mode ad-hoc
iwconfig wlan0 essid 'dk_net'
iwconfig wlan0 key 1234567890
ifconfig wlan0 10.0.1.4
