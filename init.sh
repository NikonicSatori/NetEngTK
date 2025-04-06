#!/bin/bash
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$("$0")
echo "$FILENAME: init.sh: SCRIPT START"

echo > "$FILENAME: Update system and install tools"

# Update system and install tools
sudo yum update -y
sudo yum install -y yum-utils curl git

# Install Docker
echo "$FILENAME: Install Docker"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

#Enable and start Docker
echo "$FILENAME: Enable and start Docker"
sudo systemctl enable docker
sudo systemctl start docker

# Install Docker Compose
echo "$FILENAME: Install Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Confirm installation
echo "$FILENAME: Confirm installation"
docker --version
docker-compose --version

# OPTIONAL: Clone your project from GitHub
# git clone https://github.com/your-username/your-lab-project.git
# cd your-lab-project

# OR: Upload docker-compose.yml manually if not using Git yet

echo "$FILENAME: Docker and Compose installed."

echo "$FILENAME: Disable iptables in /etc/docker/daemon.json"
echo '{ "iptables": false }' | sudo tee /etc/docker/daemon.json
echo "$FILENAME: Restart docker"
sudo systemctl restart docker

echo "$FILENAME: docker compose up -d"

echo "$FILENAME: init.sh: SCRIPT FINISH"
