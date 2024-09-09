#!/usr/bin/bash

curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

apt-get update
apt-get install tailscale

tailscale up
tailscale ip -4

echo 'If the device you added is a server or remotely-accessed device, 
you may want to consider disabling key expiry to prevent the need to periodically re-authenticate.'
