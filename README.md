# Required
## Hardware
- USB 3.0 SSD Drive - Make sure it comes with a standard usb adapter (that used by RaspberryPi - the blue ports)
- RaspberryPi 4 (4GB) - With Case (Recommended)
- Lan Cable (or connect via WiFi).
  
## Software
- Set up a new CloudFlare Tunnel (needs you to have a domain managed with CloudFlare).
  - You may need to sign up to the free plan and verify with a credit card.
  - Then go to Zero Trust → Access → Tunnels - Creae Tunnel
  - Subdomain: dolibarr (or one you like)
  - Domain:  Choose from your Cloudflare-managed domains (e.g., example.com)
  - Service Type: HTTP
  - URL: http://dolibarr:80 (the container name and port in Docker Compose)
  - Copy paste the token or leave it open as you'll need it later.

# Instructions
## 1. Flash Raspberry Pi OS (Lite 64-bit) to SSD
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

## Turn on
1. Connect SSD to RaspberryPi
2. Connect to power adapter and to local router (via ethernet cable or configured when flashing to connect via wifi).

## SSH, copy files, and setup - from another computer in the same network:
1. `ssh pi@raspberrypi.local` (test connection first - optional).
2. `scp -r setup.sh dolibarr-stack pi@raspberrypi.local:/home/pi/`
3. `ssh pi@raspberrypi.local`
4. `chmod +x setup.sh`
5. `./setup.sh`
6. Setup .env file - add your tunnel token in `/home/pi/dolibarr-stack/.env`
7. eg. `nano /home/pi/dolibarr-stack/.env` -> `TUNNEL_TOKEN=your-cloudflare-tunnel-token-here`
8. Save and exit `^-X`

## 3. Run
1. `cd ~/dolibarr-stack`
2. `docker compose up -d`

## 4. Check connection
Locally: http://raspberrypi.local:8080/
Remotely: your.cloudflare.tunnel.url

---

## Diagnose
- `docker compose ps`
- `docker compose logs`
- `docker compose logs dolibarr`
- `docker compose logs db`
- `docker compose logs cloudflared`