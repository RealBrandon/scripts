#!/usr/bin/bash

# Brandon Han
# Version 0.1.0
# 4 Sep 2024
# This is a helper script aiming to help set up a fresh Fedora installation.
# This is targeted at a non-ostree-based Fedora installation with the GNOME desktop environment.
# This has only been tested on a Fedora 40 system installed on my laptop,
# Razer Blade Advanced Model Early 2020, RZ09-033.
# CPU: Intel® Core™ i7-10875H × 16
# iGPU: Intel® UHD Graphics (CML GT2)
# dGPU: NVIDIA GeForce RTX™ 2080 Super with Max-Q Design



# Sleep time before each section starts.
SLEEP_TIME=2



######################################################################################################################################################
# Set up additional repositories.
# Credits
# https://docs.fedoraproject.org/en-US/quick-docs/rpmfusion-setup/
# https://docs.docker.com/engine/install/fedora/

echo
echo 'Setting up additional repositories...'
echo
sleep SLEEP_TIME

# Enable RPM Fusion repositories.
sudo dnf install \
https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install \
https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Enable RPM Fusion Tainted repositories.
# sudo dnf install rpmfusion-free-release-tainted
# sudo dnf install rpmfusion-nonfree-release-tainted

# Install RPM Fusion Appstream data.
sudo dnf group update core

# Set up Docker Engine repository.
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

######################################################################################################################################################



######################################################################################################################################################
# Install multimedia codecs and related firmwares.
# Credits:
# https://docs.fedoraproject.org/en-US/quick-docs/installing-plugins-for-playing-movies-and-music/
# https://rpmfusion.org/Howto/Multimedia

echo
echo 'Installing multimedia codecs and related firmwares...'
echo
sleep SLEEP_TIME

# Install plugins for playing movies and music.
sudo dnf group install Multimedia

# Switch to full ffmpeg.
sudo dnf swap ffmpeg-free ffmpeg --allowerasing

# Install additional codecs
sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin

# Install the sound-and-video complementary packages.
# This does not seem to do anything in Fedora 40.
# Thus, it is commented out for now.
# sudo dnf update @sound-and-video

# Install VAAPI codecs for Intel hardware.
# For recent Intel hardware.
sudo dnf install intel-media-driver
# For older Intel hardware.
# sudo dnf install libva-intel-driver

# Install VAAPI codecs for AMD hardware.
# The two lines below are needed for Fedora 37 and later.
# sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
# sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
# Install i686 compatibility packages for Steam and alikes.
# sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
# sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686

# The Nvidia proprietary driver doesn't support VAAPI natively,
# but there is a wrapper that can bridge NVDEC/NVENC with VAAPI
# Again, i686 package is installed as well for compatibility purposes.
sudo dnf install libva-nvidia-driver.{i686,x86_64}

# Install libdvdcss package to play DVDs.
# Require RPM Fusion Free Tainted repository.
# sudo dnf install libdvdcss

# Install various firmwares.
# Require RPM Fusion Non-Free Tainted repository.
# sudo dnf --repo=rpmfusion-nonfree-tainted install "*-firmware"

######################################################################################################################################################



######################################################################################################################################################
# Install additional packages.
# Credits:

echo
echo 'Installing additional packages...'
echo
sleep SLEEP_TIME

# Install necessary utilities.
sudo dnf install neovim tilix{,-nautilus} copyq





######################################################################################################################################################



######################################################################################################################################################
# Install the latest version of Docker Engine, containerd, and Docker Compose.
# Credits:
# https://docs.docker.com/engine/install/fedora/

echo
echo 'Installing the latest version of Docker Engine, containerd, and Docker Compose...'
echo
sleep SLEEP_TIME

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Make sure the GPG key fingerprint is
# 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35,
# before accepting it.

# Verify if the installation succeeded.
sudo systemctl start docker
sudo docker run hello-world

######################################################################################################################################################



######################################################################################################################################################
# An empty template section for easy copying.
# Credits:

# echo
# echo 'An empty template section for easy copying...'
# echo
# sleep SLEEP_TIME







######################################################################################################################################################



