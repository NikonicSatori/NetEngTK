#!/bin/bash
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$(basename "$0")
echo "$FILENAME: init.sh: SCRIPT START"

# Update system and install tools
echo "$FILENAME: Update system and install tools"
timeout 300 yum update -y || echo "$FILENAME: yum update timed out"
timeout 300 yum install -y yum-utils curl git || echo "$FILENAME: yum install yum-utils curl git timed out"

# Install Docker
echo "$FILENAME: Install Docker"
timeout 300 sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || echo "$FILENAME: repo add timed out"
timeout 300 sudo yum install -y docker-ce docker-ce-cli containerd.io || echo "install docker-ce docker-ce-cli containerd.io failed"

#Enable and start Docker
echo "$FILENAME: Enable and start Docker"
sudo systemctl enable docker
sudo systemctl start docker

echo "starting docker... sleeping 10 seconds"
sleep 10

# Install Docker Compose
echo "$FILENAME: Install Docker Compose"
timeout 300 curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose || \
    echo "$FILENAME: curl docker-compose timed out"
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

echo "$FILENAME: Next, user should run docker compose up -d"

echo "$FILENAME: init.sh: SCRIPT FINISH"

exit 0
