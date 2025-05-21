#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print status messages
print_status() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_error() {
    echo -e "${RED}[!]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[*]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Function to get server IP
get_server_ip() {
    # Try to get public IP first
    public_ip=$(curl -s https://api.ipify.org)
    if [ $? -eq 0 ] && [ ! -z "$public_ip" ]; then
        echo "$public_ip"
    else
        # Fallback to local IP
        local_ip=$(hostname -I | awk '{print $1}')
        echo "$local_ip"
    fi
}

# Print copyright notice
echo -e "${BLUE}==================================================${NC}"
echo -e "${BLUE}    Nginx Proxy Manager Installation Script${NC}"
echo -e "${BLUE}    Copyright © 2025 Mohamed Shaheen${NC}"
echo -e "${BLUE}    All rights reserved${NC}"
echo -e "${BLUE}==================================================${NC}"
echo

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    exit 1
fi

# Ask for confirmation
print_warning "This script will install Nginx Proxy Manager on your system."
print_warning "The following changes will be made:"
print_info "1. Install Docker and Docker Compose (if not installed)"
print_info "2. Create necessary directories"
print_info "3. Configure and start Nginx Proxy Manager"
print_info "4. Open ports 80, 81, and 443"
echo
print_warning "Do you want to continue? (y/N) "
read -r response
if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_error "Installation cancelled by user"
    exit 1
fi

# Check system requirements
print_status "Checking system requirements..."

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    print_status "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
else
    print_status "Docker is already installed"
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_status "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
else
    print_status "Docker Compose is already installed"
fi

# Create directory for Nginx Proxy Manager
print_status "Creating directory for Nginx Proxy Manager..."
mkdir -p /opt/nginx-proxy-manager
cd /opt/nginx-proxy-manager

# Create docker-compose.yml
print_status "Creating docker-compose configuration..."
cat > docker-compose.yml << 'EOL'
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOL

# Start Nginx Proxy Manager
print_status "Starting Nginx Proxy Manager..."
docker-compose up -d

# Get server IP
SERVER_IP=$(get_server_ip)

print_status "Nginx Proxy Manager has been successfully installed!"
print_status "You can access the admin interface at: http://${SERVER_IP}:81"
print_warning "Default login credentials:"
print_warning "Email: admin@example.com"
print_warning "Password: changeme"
print_warning "Please change these credentials after your first login!" 