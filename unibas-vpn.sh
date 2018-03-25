#!/bin/bash
#

ifconfig wlan0 up
iwconfig wlan0 essid "unibas-public"
dhclient wlan0

openvpn --mktun --dev tun1 && \
ifconfig tun1 up && \
/usr/sbin/openconnect vpn.mobile.unibas.ch --authgroup=UniBasel-Access -u gstant00 --interface=tun1 --os=android --csd-wrapper csd-wrap.sh

ifconfig tun1 down

exit 0
