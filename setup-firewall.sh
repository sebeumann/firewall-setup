#!/bin/bash

# Stop and disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Reset UFW to default state
sudo ufw reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Home Profile
create_home_profile() {
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    sudo ufw allow 53/udp  # DNS
    sudo ufw allow 1900/udp  # DLNA
    sudo ufw allow 5353/udp  # mDNS
    sudo ufw allow 51820/udp  # Wireguard VPN
}

# Work Profile
create_work_profile() {
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    sudo ufw allow 3389/tcp  # RDP
    sudo ufw allow 5432/tcp  # PostgreSQL
    sudo ufw allow 27017/tcp  # MongoDB
}

# Public Profile
create_public_profile() {
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    sudo ufw deny incoming
}

# Profile management functions
save_profile() {
    local profile_name=$1
    sudo bash -c "ufw show raw > /etc/ufw/profiles/$profile_name.rules"
}

load_profile() {
    local profile_name=$1
    sudo ufw reset
    sudo bash -c "ufw-restore < /etc/ufw/profiles/$profile_name.rules"
}

# Setup
sudo mkdir -p /etc/ufw/profiles

create_home_profile
save_profile "home"

sudo ufw reset
create_work_profile
save_profile "work"

sudo ufw reset
create_public_profile
save_profile "public"

load_profile "home"
sudo ufw enable

# Create profile switch script
cat << 'EOF' | sudo tee /usr/local/bin/switch-firewall-profile
#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [home|work|public]"
    exit 1
fi

sudo ufw-restore < /etc/ufw/profiles/$1.rules
echo "Switched to $1 profile"
EOF

sudo chmod +x /usr/local/bin/switch-firewall-profile