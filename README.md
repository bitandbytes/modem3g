# Sakis3g Godfather
sakis3g_godfather is a wrapper for the original sakis3g script which automates the connection and force mode switch when required

## sakis3g_godfather dependencies:
```sh
$ sudo apt-get install ppp
$ sudo apt-get install libusb-dev
```

Next it’s required to update the usb_modeswitch to the latest version in order to make the Sakis3G function properly. Please note that the Sakis3G will only work when the usb_modeswitch switches the usb-storage to GSM/3G interface automatically. The sakis3g_godfather.sh (Ver. 2.0) was improved to force ‘mode switch’ only for Huawei dongles. 
Download the latest usb_modeswitch and usb-modeswitch-data from [www.draisberghof.de/](http://www.draisberghof.de/usb_modeswitch/)
Installation instructions are given in the webpage itself. 

Note: Comment the udev rule to auto connect the Huawei dongles at /lib/udev/rules.d/40-usb_modeswitch.rules to shop hanging the Raspberry Pi when the modem was plugged in.
```sh
# Generic entry for most Huawei devices, excluding Android phones
#ATTRS{idVendor}=="12d1", ATTRS{manufacturer}!="Android", ATTR{bInterfaceNumber}=="00", ATTR{bInterfaceClass}=="08", RUN+="usb_modeswitch '%b/%k'"
```
