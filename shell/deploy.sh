#!/bin/bash
#***************************************************************#
# Script setup Raspberry Pi IOT - Louis Boyaval                 #
#***************************************************************#

color=`tput setaf 2`
NC=`tput sgr0`

#***************************************************************#
# Setup Database                                                #
#***************************************************************#

read -p "${color}Install MariaDB $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  sudo apt install mariadb-server

  read -p "${color}Setup les droits $foo? [y/n]${NC}" answer
  if [[ $answer = y ]] ; then
      sudo mysql_secure_installation
  fi
fi

read -p "${color}Installer Wiringpi $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  sudo apt-get install wiringpi
fi

read -p "${color}Installer Pcscd $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  sudo apt-get install libusb-dev libusb++
  sudo apt-get install libccid
  sudo apt-get install pcscd
  sudo apt-get install libpcsclite1
  sudo apt-get install libpcsclite-dev
  sudo apt-get install libpcsc-perl
  sudo apt-get install pcsc-tools
fi


#***************************************************************#
# Raspi wifi access point                                       #
#***************************************************************#

read -p "${color}Installer hostapd $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  sudo apt-get install hostapd
fi

read -p "${color}Installer dnsmasq $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  sudo apt-get install dnsmasq
fi

# DHCP
echo -e "denyinterfaces wlan0 " > /etc/dhcpcd.conf

# WLAN0
read -p "${color}Configure interfaces $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  nano /etc/network/interfaces
fi

service dhcpcd restart
ifdown wlan0
ifup wlan0

# Hostapd
read -p "${color}Configure hostapd.conf $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  echo -e "interface=wlan0
           \n# Use the nl80211 driver with the brcmfmac driver
           \ndriver=nl80211
           \n# The name to use for the network
           \nssid=RPi-AP
           \n# Use the 2.4GHz band
           \nhw_mode=g
           \n# Use channel 6
           \nchannel=6
           \n# Enable 802.11n
           \nieee80211n=1
           \n# Enable WMM
           \nwmm_enabled=1
           \n# Enable 40MHz channels with 20ns guard interval
           \nht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
           \n# Accept all MAC addresses
           \nmacaddr_acl=0
           \n# Use WPA authentication
           \nauth_algs=1
           \n# Broadcast the network name
           \nignore_broadcast_ssid=0
           \n# Use WPA2
           \nwpa=2
           \n# Use a pre-shared key
           \nwpa_key_mgmt=WPA-PSK
           \n# The WPA2 passphrase (password)
           \nwpa_passphrase=raspberry
           \n# Use AES, instead of TKIP
           \nrsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf
  /usr/sbin/hostapd /etc/hostapd/hostapd.conf
  nano /etc/default/hostapd
fi

# DNSMASQ

read -p "${color}Configure dnsmasq.conf $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
  echo -e "\n# Use interface wlan0
           \ninterface=wlan0
           \n# Explicitly specify the address to listen on
           \nlisten-address=192.168.0.1
           \n# Bind to the interface to make sure we aren't sending things elsewhere
           \nbind-interfaces
           \n# Forward DNS requests to Google DNS
           \nserver=8.8.8.8
           \n# Don't forward short names
           \ndomain-needed
           \n# Never forward addresses in the non-routed address spaces.
           \nbogus-priv
           \n# Assign IP addresses between 192.168.0.5 and 192.168.0.250 with a 12 hour lease time
           \ndhcp-range=192.168.0.5,192.168.0.250,12h" > /etc/dnsmasq.conf
fi

# IPv4 Forwarding

read -p "${color}Edit sysctl.conf $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  nano /etc/sysctl.conf   #net.ipv4.ip_forward=1
  sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
fi

read -p "${color}Start Access Point $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then
  service hostapd start
  service dnsmasq start
fi
if [[ $answer = n ]]; then
  read -p "${color}Delete Acces Point $foo? [y/n]${NC}" answer
  if [[ $answer = y ]] ; then
        apt-get --purge remove dns-root-data
  fi
fi
