!/bin/bash
# User Data. Specify during EC2 instance creation. This code will run once on initial boot.

echo "Create NetEngTK directory"
mkdir /home/ec2-user/NetEngTK && cd /home/ec2-user/NetEngTK

echo "Fetch init.sh"
curl -O https://raw.githubusercontent.com/NikonicSatori/NetEngTK/refs/heads/main/init.sh
chmod +x init.sh

echo "Run init.sh"
./init.sh

echo "user-data.sh completed!"
