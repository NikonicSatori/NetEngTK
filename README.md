# NetEngTK

NetEngTK (Network Engineering Toolkit) is a lightweight, self-contained Docker Compose lab environment designed for testing and validating network tools, protocols, and services. It spins up a simulated mini-datacenter on a single Linux machine (e.g., EC2) using containers.

## ⚡ What's Included

This toolkit launches the following services using Docker Compose:

| Service     | Description                       | Port(s)        |
|-------------|-----------------------------------|----------------|
| **Nginx**    | Web server (homepage test)        | 80             |
| **Speedtest**| Bandwidth measurement tool        | 8080           |
| **Syslog-NG**| Syslog listener                   | 514/udp        |
| **BIND**     | DNS server                        | 53/udp, 53/tcp |
| **vsftpd**   | FTP server                        | 21, 21100-21110 |
| **SNMPD**    | SNMP agent (public community)     | 161/udp        |
| **IPSec VPN**| L2TP/IPSec VPN server             | 500/udp, 4500/udp |

> Note: Ensure your EC2 security group allows inbound traffic on the required ports.

---

## 🚀 Quick Start on AWS EC2

1. Launch a **CentOS 7 or Amazon Linux 2** EC2 instance.
2. Paste the contents of `user-data.sh` into the **User Data** field at EC2 launch.
3. The script will:
   - Install Docker & Docker Compose
   - Download this repo’s `init.sh` and `docker-compose.yml`
   - Launch all services via Docker Compose

After boot, verify it's working:

```bash
curl http://localhost          # Nginx
docker ps                     # See running containers
docker compose logs           # Check logs
```
---

## 🛡 Security Note
This environment is exposed to the internet by default. For security:
* Limit your EC2 inbound rules
* Consider binding ports to 127.0.0.1
* Rotate passwords and secrets

---

## 📁 Files
* init.sh — Installer script for the environment
* user-data.sh — Bootstrap script for EC2 (runs init.sh)
* docker-compose.yml — Defines all container services. The Docker Compose stack contains a:
*    nginx web server
*    syslog-ng log collector
*    bind DNS server
*    librespeed speed test server
*    vsftpd FTP service
*    snmpd SNMP agent
*    IPSec VPN server

---

## 🧪 Contributions
PRs are welcome — especially for adding health checks, CLI tools, or routing logic!
Let me know if you want to add badges (Docker Hub pulls, GitHub actions, etc.), a diagram of the network, or quick testing commands!

---

## 📜 License
MIT
