#!/bin/bash
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$(realpath "$0")
echo "$FILENAME: init.sh: SCRIPT START"

# Update system and install tools
echo "$FILENAME: Update system and install tools"
timeout 300 yum update -y || echo "$FILENAME: yum update timed out"
timeout 300 yum install -y yum-utils curl git bind-utils ftp net-snmp-utils tcpdump || echo "$FILENAME: yum install tools timed out"

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

echo "$FILENAME: Curl docker-compose.yml raw from github"
cd /home/ec2-user/NetEngTK || { echo "$FILENAME: cd to NetEngTK failed"; exit 1; }
timeout 300 curl -O https://raw.githubusercontent.com/NikonicSatori/NetEngTK/refs/heads/main/docker-compose.yml || \
    echo "$FILENAME: curl docker-compose.yml raw from github timed out"
echo "$FILENAME: Downloaded docker-compose.yml raw from github"

# Allow traffic between public interface and Docker bridge
#iptables -I DOCKER -i eth0 -o br-c1ba7e3c3316 -j ACCEPT
#iptables -I DOCKER -i br-c1ba7e3c3316 -o eth0 -j ACCEPT

# Can remove this '-D' command if the following commented line does not exist on EC2 startup.
# -A DOCKER ! -i docker0 -o docker0 -j DROP
#iptables -D DOCKER ! -i docker0 -o docker0 -j DROP


echo "$FILENAME: Starting docker compose services"
sudo docker compose up -d || { echo "$FILENAME: docker compose up -d failed"; exit 1; }
echo "$FILENAME: docker compose up -d completed successfully"
# Optional: log running containers
sudo docker ps -a

echo "INIT SCRIPT FINISH"
exit 0
