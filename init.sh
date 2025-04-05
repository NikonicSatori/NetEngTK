#!/bin/bash

echo "Update system and install tools"

# Update system and install tools
sudo yum update -y
sudo yum install -y yum-utils curl git

echo "Install Docker"
# Install Docker
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

echo "Enable and start Docker"
#Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

echo "Install Docker Compose"
# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Confirm installation"
# Confirm installation
docker --version
docker-compose --version

# OPTIONAL: Clone your project from GitHub
# git clone https://github.com/your-username/your-lab-project.git
# cd your-lab-project

# OR: Upload docker-compose.yml manually if not using Git yet

echo "Docker and Compose installed."
echo "Fetch docker-compose.yml"
# Fetch docker-compose.yml
curl -o docker-compose.yml https://raw.githubusercontent.com/NikonicSatori/NetEngTK/da0e05af98652d8e1cded4f0a5e52e981e3b1a59/docker-compose.yml

echo "docker compose up -d"
