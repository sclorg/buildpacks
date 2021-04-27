#!/bin/bash -eu

# Install and configure Docker CE
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce
sudo systemctl start docker
sudo systemctl enable docker
docker --version
sudo usermod -aG docker vagrant

# Install pack CLI tool
curl -LO https://github.com/buildpacks/pack/releases/download/v0.18.1/pack-v0.18.1-linux.tgz
tar zxf pack-v0.18.1-linux.tgz
sudo mv pack /usr/bin/
