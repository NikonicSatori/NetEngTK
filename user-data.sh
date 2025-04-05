# User Data. Specify during EC2 instance creation. This code will run once on initial boot.

echo "Create NetEngTK directory"
mkdir ~/NetEngTK && cd ~/NetEngTK

echo "Fetch init.sh"
curl -O https://raw.githubusercontent.com/NikonicSatori/NetEngTK/refs/heads/main/init.sh
chmod +x init.sh

echo "Run init.sh"
./init.sh

echo "user-data.sh completed!"
