#/bin/bash
#
# This script is designed to take a fresh version of debian
# and get it up to date with the debian packages, pip packages,
# the rt8192cu patched drivers, a modified hostapd, and some
# configuration.
# Do NOT run this as root.
# This script IS interactive at the beginning.
# Internet connectivity IS REQUIRED.

echo "Starting setup script"
date
echo ""

echo "What wireless interface do you want to use for connecting \
to the minnowboard?"
read wint1

echo "What wireless interface do you want to use for connecting \
to the camera?"
read wint2

echo "What is your sudo password?"
read -s sudopass

SDIR=`dirname "$0"`

echo "first interface is $wint1"
echo "second interface is $wint2"
#echo "password is $sudopass"
echo "directory of script is $SDIR"

echo "Finished interactive portion of the setup script"
echo ""

# Set initial PATH to what it should be and put in /etc/profile
source $SDIR/profile
echo "$sudopass" | sudo -S cp $SDIR/profile /etc/profile

# Get the needed debian packages
dpkg --clear-selections
sudo dpkg --set-selections < $SDIR/pkg_lst.txt

# Set up crontab to call boot_script.sh @reboot
# This can probably be done without crontab, but putting some
# commands that behave incorrectly in crontab is more safe than
# putting them in an important startup script
echo "$sudopass" | sudo -S crontab $SDIR/crontab.txt

# Now put the boot script in the correct place for crontab to find it
cp $SDIR/boot_script.sh ~/

# Make the logs folder that the boot script puts it's output into
mkdir -p ~/logs

# Do other prep to make the boot_script ready
git clone https://github.com/UCSD-E4E/3d-visualization-system.git \
  ~/3d-visualization-system


# TODO: make sure all these paths for configuration are correct
# TODO: need to modify certain scripts with the input wlan interfaces

# Dhcpd config
echo "$sudopass" | sudo -S mv $SDIR/dhcpd.conf /etc/dhcp/

# Connect to qx1 script
mv $SDIR/dk_connect_qx1ssid.sh ~/

# Wpa_supplicant configuration
mv $SDIR/dk_wpa_supplicant.conf ~/

# Update grub
echo "$sudopass" | sudo -S mv $SDIR/grub /etc/default/
echo "$sudopass" | sudo -S update-grub

# Install modified hostapd
echo "$sudopass" | sudo -S dpkg -i $SDIR/hostapd_2.3-1+deb8u3_amd64.deb
echo "$sudopass" | sudo -S mv $SDIR/hostapd.conf /etc/hostapd/

# Copy over inittab which is only useful on another minnowboard
#echo "$sudopass" | sudo -S mv $SDIR/inittab /etc/

# Setup interfaces at boot
echo "$sudopass" | sudo -S mv $SDIR/interfaces /etc/network/

# Setup dhcp server stuff
echo "$sudopass" | sudo -S mv $SDIR/isc-dhcp-server /etc/default/
echo "$sudopass" | sudo -S mv $SDIR/isc-dhcp-server2 /etc/init.d/isc-dhcp-server

# Setup python packages
echo "$sudopass" | sudo -S su <<'EOF'
sed "s/==.*//g" $SDIR/pip_pkgs.txt | xargs pip install
EOF

# Install patched drivers
# TODO: need to test this one for sure
tar -xzf $SDIR/rt8192cu_patched_drivers.tar.gz
CURRDIR=$PWD
cd $SDIR/rt8192cu
echo "$sudopass" | sudo -S make dkms
cd $CURRDIR

# Modified sshd config for faster ssh connection
echo "$sudopass" | sudo -S mv $SDIR/sshd_config /etc/ssh/

# wpa-2.3_rtl871xdrv_patch.tar.gz contains patched source if needed
# to create the modified hostapd or wpa_supplicant, but the normal
# wpa_supplicant tends to work fine with the wext driver

echo "Setup script finished."


