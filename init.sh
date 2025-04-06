#!/bin/bash
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$(realpath "$0")
echo "$FILENAME: init.sh: SCRIPT START"

# Update system and install tools
echo "$FILENAME: Update system and install tools"
timeout 300 yum update -y || echo "$FILENAME: yum update timed out"
timeout 300 yum install -y yum-utils curl git || echo "$FILENAME: yum install yum-utils curl git timed out"

# Install Docker
echo "$FILENAME: Install Docker"
timeout 300 sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || echo "$FILENAME: repo add timed out"
timeout 300 sudo yum install -y docker-ce docker-ce-cli containerd.io || echo "$FILENAME: install docker-ce stack failed"

# Enable and start Docker
echo "$FILENAME: Enable and start Docker"
sudo systemctl enable docker
sudo systemctl start docker

echo "$FILENAME: Sleeping 10 seconds to allow Docker to settle"
sleep 10

# Install Docker Compose
echo "$FILENAME: Install Docker Compose"
timeout 300 curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose || echo "$FILENAME: curl docker-compose timed out"
sudo chmod +x /usr/local/bin/docker-compose

# Confirm installation
echo "$FILENAME: Confirm Docker and Compose installation"
docker --version
docker-compose --version

# Docker daemon configuration
echo "$FILENAME: Disable iptables in /etc/docker/daemon.json"
echo '{ "iptables": false }' | sudo tee /etc/docker/daemon.json
echo "$FILENAME: Restart Docker"
sudo systemctl restart docker

echo "$FILENAME: Docker and Compose installed successfully"
echo "$FILENAME: Next, user should run docker compose up -d"

echo "$FILENAME: init.sh: SCRIPT FINISH"
exit 0
