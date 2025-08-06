#!/bin/bash

# Define the MOTD file
MOTD_FILE="/etc/motd"

# Gather system information
# (Include your existing system information gathering here)

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

# Backup the existing MOTD
sudo cp $MOTD_FILE ${MOTD_FILE}.bak

# Remove existing '#' border lines and append new content
sudo sed -i '/^#.*$/d' $MOTD_FILE
echo "$NEW_CONTENT" | sudo tee -a $MOTD_FILE > /dev/null

# Apply correct permissions
sudo chmod 644 $MOTD_FILE

# Notify user
echo "MOTD successfully updated with 'JORDAN'S LAB' banner and system information."
