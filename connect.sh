#!/bin/bash
##################################################################################################
# Can use this script with the sakis script to connect non-Huwawi modems to work in Linux Ubuntu #
##################################################################################################
systemctl stop ModemManager.service
./sakis3g --sudo connect USBDRIVER=option OTHER=USBMODEM USBMODEM=19d2:1253 USBINTERFACE=0 APN=CUSTOM_APN CUSTOM_APN=ebb APN_USER=iCity APN_PASS=1234
