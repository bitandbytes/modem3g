#!/bin/bash
#APN may vary depending on the ISP and the dongle used
APN=internet

echo "sakis 3G Started"
/usr/bin/modem3g/sakis3g --sudo connect USBINTERFACE="0" APN="$APN" APN_USER="iCity" APN_PASS="1234" 

while [ 1 ]
do
ping 8.8.8.8 -c 4
val=$?

echo "PING END return: $val"

if [ $val -ne 0 ]
then

NOW=$(date +"%D %r")

#Make the 3G connection
 echo "Reconnecting on $NOW" >> sakis3g.log
 echo "Sakis3G Connecting ..."
 /usr/bin/modem3g/sakis3g --sudo connect USBINTERFACE="0" APN="$APN" APN_USER="iCity" APN_PASS="1234"

#Display the connection Result, reboot if not connected
 if [ $? -ne 0 ]
 then
  NOW=$(date +"%D %r")
  echo "Sakis3G Connection ERROR!"
  echo "Reboot by Sakis3G"
  echo "Rebooting at $NOW" >> sakis3g.log
  reboot
 else
  echo "Sakis3G Connected"
 fi
fi

echo "Sleeping"
sleep 5m
done
