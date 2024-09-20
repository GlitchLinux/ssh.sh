#!/bin/bash

# Function to check if OpenSSH server is installed
check_ssh_server() {
    if [[ $(which sshd) ]]; then
        echo "OpenSSH server is installed."
    else
        echo "OpenSSH server is not installed. Installing..."
        install_ssh_server
    fi
}

# Function to install OpenSSH server
install_ssh_server() {
    if [[ $(which apt-get) ]]; then
        sudo apt-get update
        sudo apt-get install -y openssh-server
    elif [[ $(which yum) ]]; then
        sudo yum install -y openssh-server
    elif [[ $(which pacman) ]]; then
        sudo pacman -Sy openssh --noconfirm
    else
        echo "Unsupported package manager. Please install OpenSSH server manually."
        exit 1
    fi
    echo "OpenSSH server installed."
}

# Function to start SSH service
start_ssh_service() {
    echo "Starting SSH service..."
    if [[ $(which systemctl) ]]; then
        sudo systemctl start ssh
    elif [[ $(which service) ]]; then
        sudo service ssh start
    else
        echo "Unable to start SSH service. Please start it manually."
        exit 1
    fi
    echo "SSH service started."
}

# Function to get the IP address of the machine
get_ip_address() {
    local ip_address=$(hostname -I | awk '{print $1}')
    echo "$ip_address"
}

# Main script starts here

echo "=== SSH Automation Script ==="

# Check if OpenSSH server is installed
check_ssh_server

# Start SSH service
start_ssh_service

# Prompt user for username
read -p "Enter your username: " username

# Get IP address of the machine
ip_address=$(get_ip_address)

# Provide SSH connection instructions
echo ""
echo "You can SSH into this machine using:"
echo "ssh $username@$ip_address"

# Pause and prompt user to hit enter to continue
read -p "Press Enter to view SSH instructions in nano..."

# Display SSH instructions in nano
echo "ssh $username@$ip_address" | nano -

echo ""
echo "SSH connection instructions displayed in nano."
echo "You can save the file or exit nano as needed."

echo "Script completed."
