#!/bin/bash
#Version 2.0
#APN may ary depending on the ISP and the dongle used
APN=sunsurf
#APN=internet
echo "Sakis3G Started"

#Getting the Number of interfaces and the Product ID
temp="$( lsusb -v -d 12d1: | grep bNumInterfaces | cut -c29-30 )"
bNumInterfaces=${temp:0:1}

#Connecting at the Boot-up
if [ $bNumInterfaces -eq 1 ]
then
 badFlag="up"
 echo "No GSM/3G interfaces were found"
 
 #Special case for the Huawei Dongles
 idProduct="$( lsusb -v -d 12d1: | grep idProduct | cut -d 'x' -f1 --complement | cut -d ' ' -f1 )"
 echo "Running usb_modeswitch to switch modes"
 usb_modeswitch -v 12d1 -p $idProduct -J
 usb_modeswitch -v 12d1 -p $idProduct -J
 sleep 2
 idProduct="$( lsusb -v -d 12d1: | grep idProduct | cut -d 'x' -f1 --complement | cut -d ' ' -f1 )"
 echo "Executing Sakis3G" 
 /usr/bin/modem3g/sakis3g "--sudo" "connect" "USBDRIVER=option" "OTHER=USBMODEM" "USBMODEM=12d1:"$idProduct "USBINTERFACE=0" "APN=CUSTOM_APN" "CUSTOM_APN="$APN "APN_USER=iCity" "APN_PASS=1234"
else
 badFlag="down"
 /usr/bin/modem3g/sakis3g --sudo connect USBINTERFACE="0" APN="$APN" APN_USER="iCity" APN_PASS="1234"
fi

while [ 1 ]
do
 ping 8.8.8.8 -c 4
 val=$?

 echo "PING END return: $val"

 if [ $val -ne 0 ]
 then

  NOW=$(date +"%D %r")

  #Make the 3G connection
  echo "Reconnecting on $NOW" >> /var/log/sakis3g.log
  echo "Sakis3G Connecting ..."

  #Getting the Number of interfaces and the Product ID
  temp="$( lsusb -v -d 12d1: | grep bNumInterfaces | cut -c29-30 )"
  bNumInterfaces=${temp:0:1}

 if [ $badFlag = "up" ]
 then 
  idProduct="$( lsusb -v -d 12d1: | grep idProduct | cut -d 'x' -f1 --complement | cut -d ' ' -f1 )"
  /usr/bin/modem3g/sakis3g "--sudo" "connect" "USBDRIVER=option" "OTHER=USBMODEM" "USBMODEM=12d1:"$idProduct "USBINTERFACE=0" "APN=CUSTOM_APN" "CUSTOM_APN="$APN   "APN_USER=iCity" "APN_PASS=1234"
  returnVal=$?
  #If not connected test the other way
  if [ $returnVal -ne 0 ]
  then
   /usr/bin/modem3g/sakis3g --sudo connect USBINTERFACE="0" APN="$APN" APN_USER="iCity" APN_PASS="1234"
   returnVal=$?
   if [ $returnVal -eq 0 ]
   then
    badFlag="down"
   fi
  fi
 
 elif [ $bNumInterfaces -eq 1 ] 
 then
  badFlag="up"
  echo "No GSM/3G interfaces were found"
 
  #For the case if the dongle was pluged after boothing
  #Getting the Number of interfaces and the Product ID 
  idProduct="$( lsusb -v -d 12d1: | grep idProduct | cut -d 'x' -f1 --complement | cut -d ' ' -f1 )"
  echo "Running usb_modeswitch to switch modes"
  usb_modeswitch -v 12d1 -p $idProduct -J
  usb_modeswitch -v 12d1 -p $idProduct -J
  sleep 2
  idProduct="$( lsusb -v -d 12d1: | grep idProduct | cut -d 'x' -f1 --complement | cut -d ' ' -f1 )"
  echo "Executing Sakis3G"
  /usr/bin/modem3g/sakis3g "--sudo" "connect" "USBDRIVER=option" "OTHER=USBMODEM" "USBMODEM=12d1:"$idProduct "USBINTERFACE=0" "APN=CUSTOM_APN" "CUSTOM_APN="$APN   "APN_USER=iCity" "APN_PASS=1234"
  returnVal=$?
 else
  /usr/bin/modem3g/sakis3g --sudo connect USBINTERFACE="0" APN="$APN" APN_USER="iCity" APN_PASS="1234" 
  returnVal=$?
 fi
 
 #Display the connection Result, reboot if not connected
 if [ $returnVal -ne 0 ]
 then
  NOW=$(date +"%D %r")
  echo "Sakis3G Connection ERROR!"
  echo "Reboot by Sakis3G"
  echo "Rebooting at $NOW" >> /var/log/sakis3g.log
  reboot
 else
  echo "Sakis3G Connected"
 fi
fi

echo "Sleeping"
sleep 5m
done
