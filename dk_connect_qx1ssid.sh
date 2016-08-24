# To create /etc/dk_wpa_supplicant.conf
# sudo -s
# wpa_passphrase DIRECT-tmQ1:ILCE-QX1 63uCGcBf

sudo wpa_supplicant -B -D wext -i wlan1 -c /home/camerarig/dk_wpa_supplicant.conf
