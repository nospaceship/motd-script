#!/bin/bash

# Define the MOTD file
MOTD_FILE="/etc/motd"

# Install figlet if not present
if ! command -v figlet &>/dev/null; then
    if command -v apt-get &>/dev/null; then
        sudo apt-get install -y figlet
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y figlet
    elif command -v yum &>/dev/null; then
        sudo yum install -y figlet
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm figlet
    else
        echo "Could not install figlet: no supported package manager found."
        exit 1
    fi
fi

# Fetch the last login details
last_login_info=$(last -n 2 -R | tail -n 1)
last_login_user=$(echo "$last_login_info" | awk '{print $1}')
last_login_ip=$(echo "$last_login_info" | awk '{print $3}')
last_login_time=$(echo "$last_login_info" | awk '{print $4, $5, $6, $7, $8}')
last_login_details="User: $last_login_user, IP: $last_login_ip, Time: $last_login_time"

# Create the new MOTD content
NEW_CONTENT=$(cat << EOF

$(figlet "JORDAN'S LAB")
Welcome to my Homelab!

System Information:
-------------------
# (Include your existing system information here)
Last Login       : $last_login_details

EOF
)

# Skip if already configured
if sudo grep -q "Welcome to my Homelab!" "$MOTD_FILE" 2>/dev/null; then
    echo "MOTD already configured. Exiting."
    exit 0
fi

# Backup the existing MOTD
sudo cp $MOTD_FILE ${MOTD_FILE}.bak

# Remove existing '#' border lines and append new content
sudo sed -i '/^#.*$/d' $MOTD_FILE
echo "$NEW_CONTENT" | sudo tee -a $MOTD_FILE > /dev/null

# Apply correct permissions
sudo chmod 644 $MOTD_FILE

# Notify user
echo "MOTD successfully updated with 'JORDAN'S LAB' banner and system information."
