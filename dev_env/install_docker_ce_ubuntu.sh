#!/usr/bin/env bash

# Script to configure Docker and nvidia-docker for Ubuntu 16.04.
#     Docker instructions pulled from https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#set-up-the-repository.
#     nvidia-docker instructions pulled from https://github.com/NVIDIA/nvidia-docker/wiki/Installation

## Docker CE setup
echo "Installing Docker Community Edition (CE)..."
sudo apt update
sudo apt install \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Testing Docker installation..."
require_sudo=0
docker run hello-world
if [ $? != 0 ]; then
    echo "It's possible Docker might require sudo permissions to run containers."
    echo "Try running hello-world container with sudo permissions..."
    sudo docker run hello-world
    if [ $? != 0 ]; then
        echo "Docker installation is broken. Exiting."
        exit 1
    else
        echo "Docker installation requires sudo permissions to execute containers."
        require_sudo=1
    fi
fi

## nvidia-docker setup
echo "Testing presence of nvidia driver..."
nvidia-smi

if [ $? != 0 ]; then
    echo "The nvidia driver is not loaded on this machine. Until the CUDA SDK" \
         "is installed, you will not be able to run GPU-accelerated Docker containers."
    exit 1
fi

NVIDIA_DOCKER_DEB_NAME="nvidia-docker_1.0.1-1_amd64.deb"
NVIDIA_DOCKER_DEB_URL="https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/${NVIDIA_DOCKER_DEB_NAME}"
wget -P ~/Downloads $NVIDIA_DOCKER_DEB_URL
sudo dpkg -i ~/Downloads/$NVIDIA_DOCKER_DEB_NAME; rm ~/Downloads/$NVIDIA_DOCKER_DEB_NAME

echo "Testing nvidia-docker..."
NVIDIA_DOCKER_CMD="nvidia-docker run --rm nvidia/cuda nvidia-smi"
if [ require_sudo == 0 ]; then
    sh -c "${NVIDIA_DOCKER_CMD}"
else
    sudo sh -c "${NVIDIA_DOCKER_CMD}"
fi

if [ $? != 0 ]; then
    echo "NVIDIA docker container failed to run."
    exit 1
fi

echo "Complete!"
