#!/usr/bin/bash

STATE=$1

if [[ "$STATE" == 'on' ]]; then
    gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled &&
    echo 'Touchpad enabled.'
elif [[ "$STATE" == 'off' ]]; then
    gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled &&
    echo 'Touchpad disabled.'
else
    echo 'Invalid input. Please try again.'
fi
