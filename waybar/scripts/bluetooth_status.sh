#!/bin/bash

# Check Bluetooth status using bluetoothctl
if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
        echo " Connected"
    else
        echo " On"
    fi
else
    echo " Off"
fi

