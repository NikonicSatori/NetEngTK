#!/bin/bash
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$(realpath "$0")
echo "$FILENAME: user-data.sh: SCRIPT START"

echo "$FILENAME: Create NetEngTK directory"
mkdir -p /home/ec2-user/NetEngTK && cd /home/ec2-user/NetEngTK || { echo "$FILENAME: CD failed"; exit 1; }

echo "$FILENAME: Fetch init.sh"
curl -O https://raw.githubusercontent.com/NikonicSatori/NetEngTK/refs/heads/main/init.sh || { echo "$FILENAME: Failed to download init.sh"; exit 1; }
chmod +x init.sh

echo "$FILENAME: Run init.sh"
./init.sh

echo "$FILENAME: user-data.sh: SCRIPT FINISH"
exit 0
