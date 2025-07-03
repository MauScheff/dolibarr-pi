#!/bin/bash
set -e

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "🐳 Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
sudo usermod -aG docker pi
sudo apt install docker-compose-plugin -y

echo "📁 Preparing Dolibarr stack directory..."
mkdir -p /home/pi/dolibarr-stack/db
mkdir -p /home/pi/dolibarr-stack/html
cd /home/pi/dolibarr-stack

echo "📦 Pulling Docker images..."
docker pull dolibarr/dolibarr
docker pull mariadb:10.5
docker pull cloudflare/cloudflared

echo "🔑 Fixing permissions..."
chown -R pi:pi /home/pi/dolibarr-stack

echo "✅ Setup complete. Run the stack with:"
echo "   cd ~/dolibarr-stack && docker compose up -d"
