#!/bin/bash

# Define the message
MOTD_MESSAGE="Welcome to Jordan's Homelab! Whatever you are creating please be mindful of the basic security practices. I'M WATCHING YOU :)."

echo "Updating MOTD on this system..."

# Detect the OS
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
else
    echo "Unsupported OS. Exiting."
    exit 1
fi

# Apply MOTD based on OS type
case "$ID" in
    ubuntu|debian)
        echo "$MOTD_MESSAGE" | sudo tee /etc/motd > /dev/null
        echo "MOTD updated for Debian/Ubuntu."
        ;;
    rhel|centos|fedora)
        echo "$MOTD_MESSAGE" | sudo tee /etc/issue.net > /dev/null
        sudo sed -i 's|#Banner.*|Banner /etc/issue.net|' /etc/ssh/sshd_config
        sudo systemctl restart sshd
        echo "MOTD updated for RHEL-based systems."
        ;;
    *)
        echo "OS not supported by this script."
        exit 1
        ;;
esac

echo "Done! Log out and log back in to see your new MOTD."
