# Dolibarr on Raspberry Pi with Cloudflare Tunnel

This repository provides scripts and Docker Compose configuration to run Dolibarr ERP on a Raspberry Pi 4 using an SSD, with secure remote access via Cloudflare Tunnel.

## Prerequisites
### Hardware
- USB 3.0 SSD Drive - Make sure it comes with a standard usb adapter (that used by RaspberryPi - the blue ports)
- RaspberryPi 4 (4GB) - With Case (Recommended)
- Lan Cable (or connect via WiFi).
  
### Software
Cloudflare Tunnel:
1. Sign up for a free Cloudflare account (you may need to verify with a credit card).
2. Go to **Zero Trust → Access → Tunnels**, and create a new tunnel (cloudflared).
3. Configure:
   - **Subdomain**: `dolibarr` (or your preferred subdomain).
   - **Domain**: one of your Cloudflare-managed domains (e.g., `example.com`).
   - **Service Type**: HTTP (the public endpoint will still use HTTPS).
   - **URL**: `http://dolibarr:80` (container name and port in Docker Compose).
4. Save the generated token — you'll need it later.

## Instructions
### 1. Flash Raspberry Pi OS (Lite 64-bit) to SSD
Open Raspberry Pi Imager on your Mac

Select:
1. OS: Raspberry Pi OS Lite (64-bit)
2. Storage: Your SSD
3. Click ⚙️ (or look for Advanced Options):
4. ✅ Enable SSH
5. Set hostname: raspberrypi.local
6. Set username: pi and a password
7. Configure Wi-Fi if not using Ethernet
8. Click Write and let it finish
9. Eject & replug the SSD to your Mac — two partitions should appear: boot and root

### 2. Turn on
1. Connect SSD to RaspberryPi
2. Connect to power adapter and to local router (via ethernet cable or configured when flashing to connect via wifi).

### 3. SSH, copy files, and setup
```sh
ssh pi@raspberrypi.local   # test connection first (optional)
scp -r setup.sh dolibarr-stack pi@raspberrypi.local:/home/pi/
ssh pi@raspberrypi.local
chmod +x setup.sh
./setup.sh  # may need to re-login due to permissions on first run
```

Setup the `.env` file with your tunnel token:

```sh
nano /home/pi/dolibarr-stack/.env
```

Add the following line:

```dotenv
TUNNEL_TOKEN=your-cloudflare-tunnel-token-here
```

Save and exit with Ctrl+X.

### 4. Run
```sh
cd ~/dolibarr-stack
docker compose up -d
```

### 5. Check connection
- **Locally**: http://raspberrypi.local:8080/
- **Remotely**: https://your.cloudflare.tunnel.url

---

## FAQ

### Does is keep running even if it goes off and on?
Yes, provided you ran `docker compose up -d` and you're able to access it from your browser.

## Troubleshooting
- `docker compose ps`
- `docker compose logs`
- `docker compose logs dolibarr`
- `docker compose logs db`
- `docker compose logs cloudflared`
- Reset:
  ```
  cd dolibarr-stack/
  docker compose down
  docker compose up -d
  ```

## Reference
- Official Dolibarr Docker Image: https://github.com/Dolibarr/dolibarr-docker https://hub.docker.com/r/dolibarr/dolibarr
- Official CloudFlare Tunnel Docker Image: https://hub.docker.com/r/cloudflare/cloudflared
- Official MariaDB Docker Image: https://hub.docker.com/_/mariadb
