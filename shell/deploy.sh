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
read -p "${color}Setup Access Point $foo? [y/n]${NC}" answer
if [[ $answer = y ]] ; then

  #Instal hostapd and dnmasq
  apt-get install hostapd dnsmasq
  systemctl stop hostapd dnsmasq

  #Configure the DHCP wlan0
  cd /etc
  cp dhcpcd.conf default_dhcpcd.conf
  echo -e "interface wlan0
  \nstatic ip_address=192.168.1.254
  \ndenyinterfaces eth0
  \ndenyinterfaces wlan0" > dhcpcd.conf

  #Configure dnsmasq.conf
  cp dnsmasq.conf default_dnsmasq.conf
  echo -e "\ninterface=wlan0
          \ndhcp-range=192.168.1.200,192.168.1.253,255.255.255.0,6h" > dnsmasq.conf

  #Configure hostapd conf
  cd /etc/hostapd
  echo -e "#wlan0 Access Point configuration\n
  \ninterface=wlan0
  \ndriver=nl80211
  \nssid=RPI_SERVER
  \nignore_broadcast_ssid=0
  \nhw_mode=g
  \nchannel=8
  \nauth_algs=1
  \nwpa=2
  \nwpa_passphrase=PASSWORD
  \nwpa_key_mgmt=WPA-PSK
  \nwpa_pairwise=TKIP
  \nrsn_pairwise=CCMP
  \nmacaddr_acl=0" > hostapd.conf

  cd /etc/default
  cp hostapd default_hostapd
  echo -e "DAEMON_CONF=/etc/hostapd/hostapd.conf
  \nDAEMON_RUN=YES" > hostapd

  #Setup rc.local to start the netconfig on reboot
  cd /etc
  cp rc.local default_rc.local
  echo "#!/bin/sh -e
  \nservice hostapd restart
  \nexit 0" > rc.local

  read -p "${color}Reboot $foo? [y/n]${NC}" answer
  if [[ $answer = y ]] ; then
    reboot
  fi
fi

