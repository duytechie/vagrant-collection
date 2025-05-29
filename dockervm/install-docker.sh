#!/bin/bash

# Colors for output
INFO="[\e[1;36mINFO\e[0m]"
DONE="[\e[1;32mDONE\e[0m]"
ERROR="[\e[1;31mERROR\e[0m]"

# Exit on error
set -e

echo -e "$INFO Updating apt package index..."
sudo apt-get update -y

echo -e "$INFO Installing required packages..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

echo -e "$INFO Creating keyring directory..."
sudo install -m 0755 -d /etc/apt/keyrings

echo -e "$INFO Downloading Docker GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc >/dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Detect architecture and codename
ARCH=$(dpkg --print-architecture)
CODENAME=$(lsb_release -cs)

echo -e "$INFO Adding Docker APT repository..."
echo \
  "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $CODENAME stable" |
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

echo -e "$INFO Updating apt package index again..."
sudo apt-get update -y

echo -e "$INFO Installing Docker Engine and plugins..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "$INFO Verifying Docker installation with hello-world image..."
if sudo docker run hello-world; then
  echo -e "$DONE Docker installed and working correctly!"
else
  echo -e "$ERROR Docker installation failed!"
  exit 1
fi
