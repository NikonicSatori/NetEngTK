#!/bin/bash
# User Data. Specify during EC2 instance creation. This code will run once on initial boot.
exec > >(tee -a /var/log/init.log) 2>&1
FILENAME=$("$0")
echo "$FILENAME: Logging to /var/log/init.log"
echo "$FILENAME: user-data.sh: SCRIPT START"

echo "$FILENAME: Create NetEngTK directory"
mkdir /home/ec2-user/NetEngTK && cd /home/ec2-user/NetEngTK

echo "$FILENAME: Fetch init.sh"
curl -O https://raw.githubusercontent.com/NikonicSatori/NetEngTK/refs/heads/main/init.sh
chmod +x init.sh

echo "$FILENAME: Run init.sh"
./init.sh

echo "$FILENAME: user-data.sh: SCRIPT FINISH"
