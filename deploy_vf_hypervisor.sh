#!/usr/bin/bash

set -e

USER_ID=$(id --user)
if ! [[ $USER_ID -eq 0 ]]
then
  echo 'Please run the script again as root or with sudo.'
  exit 1
fi

CPU_ARCH=$(hostnamectl | grep 'Architecture' | cut -d ':' -f 2 | cut -d ' ' -f 2)
echo "CPU architecture is $CPU_ARCH."
if [[ "$CPU_ARCH" != 'x86-64' ]]
then
  echo 'Sorry, this script currenly only supports x86-64 system.'
  echo 'Aborted.'
  exit 1
fi

OS_NAME=$(grep -E '^ID' /etc/os-release | cut -d '=' -f 2)
if [[ "$OS_NAME" == 'debian' ]]
then
  echo 'OS is Debian GNU/Linux.'
else
  echo 'OS is Non-Debian Linux distribution.'
  echo 'Sorry, this script currently only supports Debian GNU/Linux.'
  echo 'Aborted.'
  exit 1
fi

OS_VERSION=$(grep -E '^VERSION_ID' /etc/os-release | cut -d '=' -f 2 | cut -d '"' -f 2)
echo "Debian version is $OS_VERSION."
if [[ $OS_VERSION -eq 11 ]] || [[ $OS_VERSION -eq 12 ]]
then
  echo "This version of Debian is supported by VirtFusion."
else
  echo "This version of Debian is not supported by VirtFusion."
  echo 'Aborted.'
  exit 1
fi

# Install nala if possible
NALA_INSTALLED=false
apt install -y nala && NALA_INSTALLED=true || true

# Install necessary packages.
PACKAGE_LIST=('ifenslave' 'vim' 'curl' 'tmux' 'htop' 'bash-completion')
$NALA_INSTALLED && nala install -y "${PACKAGE_LIST[@]}" || apt install -y "${PACKAGE_LIST[@]}"

# Download and set up configuration files.
GITHUB_CONFIG_REPO_URL='https://raw.githubusercontent.com/RealBrandon/configs/main'

cd "$HOME"
wget -O .vimrc "$GITHUB_CONFIG_REPO_URL/vimrc"
wget -O .tmux.conf "$GITHUB_CONFIG_REPO_URL/tmux.conf"
wget -O .bashrc "$GITHUB_CONFIG_REPO_URL/bashrc_debian"

# Install VirtFusion hypervisor.
VF_NETWORK_SETUP_DOCS_URL='https://docs.virtfusion.com/installation/hypervisor#network-setup'
curl https://install.virtfusion.net/install-hypervisor-kvm-debian-$OS_VERSION.sh | sh -s -- --verbose &&
  echo "Please refer to $VF_NETWORK_SETUP_DOCS_URL and configure the hypervisor network."
