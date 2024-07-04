#!/usr/bin/bash

NVIDIA_PCI_ID=0000:01:00.0
USER_ID="$(id --user)"
STATE=$1

if [[ "$USER_ID" -ne 0 ]]; then
    echo 'Please run the command again with sudo or as the root user.'
    exit 1
fi

if [[ "$STATE" == 'on' ]]; then
    nvidia-smi drain --pciid $NVIDIA_PCI_ID --modify 0 &&
    echo 'Nvidia dedicated graphics card enabled.'
elif [[ "$STATE" == 'off' ]]; then
    nvidia-smi drain --pciid $NVIDIA_PCI_ID --modify 1 &&
    echo 'Nvidia dedicated graphics card disabled.'
else
    echo 'Invalid input. Please try again.'
fi
