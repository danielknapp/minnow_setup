#/bin/bash
#
# This script is designed to take a fresh version of debian
# and get it up to date with the debian packages, pip packages,
# the rt8192cu patched drivers, a modified hostapd, and some
# configuration. It IS interactive. Do NOT run this as root.

echo "What wireless interface do you want to use for talking \
to the keyboard?"
read wint1

echo "What wireless interface do you want to use for talking \
to the keyboard?"
read wint2

echo "What is your sudo password?"
read -s sudopass

SDIR=`dirname "$0"`

# Set up crontab to execute a boot script. While there are
# simpler ways to achieve this, I like the flexibility of
# crontab.
echo $sudopass | sudo -S crontab crontab.txt

# Fill the home directory with what should go there
cp *.sh *.conf *.deb *.tar.gz qx1_Spring2016 $HOME

# Before copying many of the files we want to overwrite in
# /etc/... we should install the desired packages first
echo $sudopass | sudo -S dpkg --set-selections < pkg_lst.txt

# Copy the package configuration files to their respective
# locations in /etc

