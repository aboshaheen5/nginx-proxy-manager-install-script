#!/bin/bash

# =============================================
# Nginx Proxy Manager Installation Script
# Copyright (c) 2025 Mohamed Shaheen
# All rights reserved.
# =============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Default configuration
HTTP_PORT=80
ADMIN_PORT=81
HTTPS_PORT=443
AUTO_BACKUP=true
UPDATE_SYSTEM=true
INSTALL_PATH="/opt/nginx-proxy-manager"
NPM_VERSION="latest"
INSTALL_MONITORING=false
AUTO_UPDATE=true
BACKUP_SCHEDULE="0 0 * * *"  # Daily at midnight
SSL_EMAIL="admin@example.com"

# Text formatting
BOLD='\033[1m'

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to handle script interruption
handle_interrupt() {
    print_message "${YELLOW}" "\n\nInstallation cancelled by user."
    print_message "${YELLOW}" "If you want to try again, simply run the script again."
    exit 1
}

# Set up trap for Ctrl+C
trap handle_interrupt INT

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to confirm installation
confirm_installation() {
    print_message "${BOLD}" "\nNginx Proxy Manager Installation Configuration:"
    print_message "${BOLD}" "==========================================="
    print_message "Installation Path: $INSTALL_PATH" "$BLUE"
    print_message "NPM Version: $NPM_VERSION" "$BLUE"
    print_message "HTTP Port: $HTTP_PORT" "$BLUE"
    print_message "Admin Interface Port: $ADMIN_PORT" "$BLUE"
    print_message "HTTPS Port: $HTTPS_PORT" "$BLUE"
    print_message "Automatic Backup: $AUTO_BACKUP" "$BLUE"
    print_message "Update System: $UPDATE_SYSTEM" "$BLUE"
    print_message "Install Monitoring Tools: $INSTALL_MONITORING" "$BLUE"
    print_message "\nDo you want to proceed with the installation? (y/N) " "$YELLOW"
    read -r response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_message "${RED}" "Installation cancelled"
        exit 1
    fi
}

# Function to update system
update_system() {
    if [ "$UPDATE_SYSTEM" = true ]; then
        print_message "${BOLD}" "Updating system packages..."
        if command_exists apt-get; then
            apt-get update && apt-get upgrade -y
        elif command_exists yum; then
            yum update -y
        elif command_exists dnf; then
            dnf update -y
        fi
    fi
}

# Function to check system requirements
check_requirements() {
    print_message "${BOLD}" "Checking system requirements..."
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        print_message "${RED}" "Please run as root"
        exit 1
    fi

    # Check OS
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
        if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
            print_message "${RED}" "This script only supports Ubuntu and Debian systems"
            exit 1
        fi
        print_message "${GREEN}" "Detected OS: $OS $VERSION"
    else
        print_message "${RED}" "Could not detect OS"
        exit 1
    fi

    # Check architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" != "x86_64" && "$ARCH" != "aarch64" ]]; then
        print_message "${RED}" "Unsupported architecture: $ARCH"
        exit 1
    fi
    print_message "${GREEN}" "Detected architecture: $ARCH"

    # Check memory
    TOTAL_MEM=$(free -m | awk '/^Mem:/{print $2}')
    if [ "$TOTAL_MEM" -lt 1000 ]; then
        print_message "${RED}" "Warning: Less than 1GB RAM detected. Nginx Proxy Manager may not perform optimally."
        read -p "Do you want to continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_message "${YELLOW}" "Installation cancelled."
            exit 1
        fi
    else
        print_message "${GREEN}" "Memory: ${TOTAL_MEM}MB"
    fi

    # Check disk space
    FREE_DISK=$(df -m / | awk 'NR==2 {print $4}')
    if [ "$FREE_DISK" -lt 1000 ]; then
        print_message "${RED}" "Warning: Less than 1GB of free disk space. Please free up some space before continuing."
        exit 1
    else
        print_message "${GREEN}" "Free disk space: ${FREE_DISK}MB"
    fi
}

# Function to backup existing installation
backup_existing() {
    if [ -d "$INSTALL_PATH" ]; then
        print_message "${BOLD}" "Backing up existing installation..."
        BACKUP_DIR="/backup/nginx-proxy-manager-$(date +%Y%m%d-%H%M%S)"
        mkdir -p "$BACKUP_DIR"
        cp -r "$INSTALL_PATH"/* "$BACKUP_DIR/"
        print_message "${GREEN}" "Backup created at $BACKUP_DIR"
        
        # Create backup log
        echo "Backup created at $(date)" > "$BACKUP_DIR/backup.log"
        echo "Original location: $INSTALL_PATH" >> "$BACKUP_DIR/backup.log"
        echo "Backup size: $(du -sh "$BACKUP_DIR" | cut -f1)" >> "$BACKUP_DIR/backup.log"
    fi
}

# Function to check port availability
check_ports() {
    local ports=($HTTP_PORT $ADMIN_PORT $HTTPS_PORT)
    for port in "${ports[@]}"; do
        if netstat -tuln | grep -q ":$port "; then
            print_message "${RED}" "Port $port is already in use"
            print_message "${YELLOW}" "Please choose different ports or stop the service using port $port"
            exit 1
        fi
    done
}

# Function to install dependencies
install_dependencies() {
    print_message "${BOLD}" "Installing dependencies..."
    
    apt-get update
    apt-get install -y curl wget git ufw apt-transport-https lsb-release ca-certificates gnupg2
    
    # Install Node.js
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
    apt-get install -y nodejs
    
    # Install Docker
    curl -fsSL https://get.docker.com | sh
    
    print_message "${GREEN}" "Dependencies installed successfully!"
}

# Function to configure firewall
configure_firewall() {
    print_message "${BOLD}" "Configuring firewall..."
    
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 81/tcp
    
    print_message "${GREEN}" "Firewall configured successfully!"
}

# Function to install Nginx Proxy Manager
install_npm() {
    print_message "${BOLD}" "Installing Nginx Proxy Manager..."
    
    # Create installation directory
    mkdir -p "$INSTALL_PATH"
    cd "$INSTALL_PATH"
    
    # Download and extract NPM
    wget https://github.com/jc21/nginx-proxy-manager/archive/refs/heads/master.zip
    unzip master.zip
    mv nginx-proxy-manager-master/* .
    rm -rf nginx-proxy-manager-master master.zip
    
    # Start NPM
    docker-compose up -d
    
    print_message "${GREEN}" "Nginx Proxy Manager installed successfully!"
}

# Function to install monitoring tools
install_monitoring_tools() {
    if [ "$INSTALL_MONITORING" = true ]; then
        print_message "${BOLD}" "Installing monitoring tools..."
        
        # Install netdata
        if ! command_exists netdata; then
            print_message "${YELLOW}" "Installing Netdata..."
            bash <(curl -Ss https://my-netdata.io/kickstart.sh) --non-interactive
        fi
        
        # Install monitoring script
        cat > "$INSTALL_PATH/monitor.sh" << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to check container status
check_container() {
    if docker ps | grep -q "nginx-proxy-manager"; then
        echo -e "${GREEN}✓ Nginx Proxy Manager is running${NC}"
    else
        echo -e "${RED}✗ Nginx Proxy Manager is not running${NC}"
    fi
}

# Function to check disk usage
check_disk() {
    local usage=$(df -h "$INSTALL_PATH" | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$usage" -gt 90 ]; then
        echo -e "${RED}✗ High disk usage: ${usage}%${NC}"
    else
        echo -e "${GREEN}✓ Disk usage: ${usage}%${NC}"
    fi
}

# Function to check memory usage
check_memory() {
    local usage=$(free | awk '/Mem:/ {print int($3/$2 * 100)}')
    if [ "$usage" -gt 90 ]; then
        echo -e "${RED}✗ High memory usage: ${usage}%${NC}"
    else
        echo -e "${GREEN}✓ Memory usage: ${usage}%${NC}"
    fi
}

# Function to check SSL certificates
check_ssl() {
    local certs=$(find "$INSTALL_PATH/letsencrypt" -name "*.pem" 2>/dev/null | wc -l)
    if [ "$certs" -eq 0 ]; then
        echo -e "${YELLOW}⚠ No SSL certificates found${NC}"
    else
        echo -e "${GREEN}✓ Found ${certs} SSL certificates${NC}"
    fi
}

# Main monitoring function
main() {
    echo -e "\n${BLUE}Nginx Proxy Manager Status Check${NC}"
    echo -e "${BLUE}============================${NC}\n"
    
    check_container
    check_disk
    check_memory
    check_ssl
    
    echo -e "\n${BLUE}Last 5 Error Logs:${NC}"
    docker-compose -f "$INSTALL_PATH/docker-compose.yml" logs --tail=5 | grep -i error
    
    echo -e "\n${BLUE}System Uptime:${NC}"
    uptime
}

main
EOF
        
        chmod +x "$INSTALL_PATH/monitor.sh"
        print_message "${GREEN}" "Monitoring script installed at $INSTALL_PATH/monitor.sh"
    fi
}

# Function to create docker-compose.yml
create_docker_compose() {
    print_message "${BOLD}" "Creating docker-compose.yml..."
    
    cat > "$INSTALL_PATH/docker-compose.yml" << EOF
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:${NPM_VERSION}'
    restart: unless-stopped
    ports:
      - '${HTTP_PORT}:80'
      - '${ADMIN_PORT}:81'
      - '${HTTPS_PORT}:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    environment:
      - DB_SQLITE_FILE=/data/database.sqlite
      - DISABLE_IPV6=true
EOF
}

# Function to perform health check
health_check() {
    print_message "${BOLD}" "Performing health check..."
    
    # Check if containers are running
    if ! docker-compose -f "$INSTALL_PATH/docker-compose.yml" ps | grep -q "Up"; then
        print_message "${RED}" "Containers are not running properly"
        return 1
    fi

    # Check if admin interface is accessible
    if ! curl -s http://localhost:$ADMIN_PORT > /dev/null; then
        print_message "${RED}" "Admin interface is not accessible"
        return 1
    fi

    # Check container logs for errors
    if docker-compose -f "$INSTALL_PATH/docker-compose.yml" logs | grep -i "error"; then
        print_message "${YELLOW}" "Found errors in container logs"
    fi

    print_message "${GREEN}" "Health check passed"
    return 0
}

# Function to show installation summary
show_summary() {
    print_message "${BOLD}" "\nInstallation Summary:"
    print_message "${GREEN}" "==========================================="
    print_message "${GREEN}" "Admin Interface: http://$(hostname -I | awk '{print $1}'):$ADMIN_PORT"
    print_message "${GREEN}" "Default Email: admin@example.com"
    print_message "${GREEN}" "Default Password: changeme"
    print_message "\nPort Configuration:"
    print_message "HTTP Port: $HTTP_PORT"
    print_message "Admin Port: $ADMIN_PORT"
    print_message "HTTPS Port: $HTTPS_PORT"
    print_message "\nPlease change the default credentials immediately!"
    
    # Save configuration
    cat > "$INSTALL_PATH/install-config.txt" << EOF
Installation Date: $(date)
HTTP Port: $HTTP_PORT
Admin Port: $ADMIN_PORT
HTTPS Port: $HTTPS_PORT
Auto Backup: $AUTO_BACKUP
System Update: $UPDATE_SYSTEM
EOF

    # Show copyright information
    print_message "${BLUE}" "\n============================================="
    print_message "${BLUE}" "Nginx Proxy Manager Installation Script"
    print_message "${BLUE}" "Copyright (c) 2025 Mohamed Shaheen"
    print_message "${BLUE}" "All rights reserved."
    print_message "${BLUE}" "============================================="
    print_message "${GREEN}" "\nThank you for using our script!"
    print_message "${GREEN}" "For support, visit: https://github.com/aboshaheen5/nginx-proxy-manager-install-script"
    print_message "${GREEN}" "Join our Discord: https://discord.gg/UuasbmKqUh"
}

# Function to setup automatic updates
setup_auto_updates() {
    if [ "$AUTO_UPDATE" = true ]; then
        print_message "${BOLD}" "Setting up automatic updates..."
        
        # Create update script
        cat > "$INSTALL_PATH/update.sh" << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored messages
print_message() {
    echo -e "${2}${1}${NC}"
}

# Function to backup before update
backup() {
    BACKUP_DIR="/backup/nginx-proxy-manager-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$INSTALL_PATH"/* "$BACKUP_DIR/"
    print_message "Backup created at $BACKUP_DIR" "$GREEN"
}

# Function to update
update() {
    print_message "Updating Nginx Proxy Manager..." "$YELLOW"
    cd "$INSTALL_PATH"
    docker-compose pull
    docker-compose up -d
    print_message "Update completed" "$GREEN"
}

# Main update process
main() {
    print_message "Starting update process..." "$YELLOW"
    backup
    update
}

main
EOF
        
        chmod +x "$INSTALL_PATH/update.sh"
        
        # Add cron job for updates
        (crontab -l 2>/dev/null; echo "0 0 * * 0 $INSTALL_PATH/update.sh >> $INSTALL_PATH/update.log 2>&1") | crontab -
        print_message "${GREEN}" "Automatic updates configured (weekly)"
    fi
}

# Function to setup backup schedule
setup_backup_schedule() {
    if [ "$AUTO_BACKUP" = true ]; then
        print_message "${BOLD}" "Setting up backup schedule..."
        
        # Create backup script
        cat > "$INSTALL_PATH/backup.sh" << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored messages
print_message() {
    echo -e "${2}${1}${NC}"
}

# Function to cleanup old backups
cleanup_old_backups() {
    find /backup -name "nginx-proxy-manager-*" -type d -mtime +7 -exec rm -rf {} \;
}

# Function to backup
backup() {
    BACKUP_DIR="/backup/nginx-proxy-manager-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r "$INSTALL_PATH"/* "$BACKUP_DIR/"
    
    # Create backup log
    echo "Backup created at $(date)" > "$BACKUP_DIR/backup.log"
    echo "Original location: $INSTALL_PATH" >> "$BACKUP_DIR/backup.log"
    echo "Backup size: $(du -sh "$BACKUP_DIR" | cut -f1)" >> "$BACKUP_DIR/backup.log"
    
    print_message "Backup created at $BACKUP_DIR" "$GREEN"
}

# Main backup process
main() {
    print_message "Starting backup process..." "$YELLOW"
    backup
    cleanup_old_backups
}

main
EOF
        
        chmod +x "$INSTALL_PATH/backup.sh"
        
        # Add cron job for backups
        (crontab -l 2>/dev/null; echo "$BACKUP_SCHEDULE $INSTALL_PATH/backup.sh >> $INSTALL_PATH/backup.log 2>&1") | crontab -
        print_message "${GREEN}" "Backup schedule configured"
    fi
}

# Function to configure SSL
configure_ssl() {
    print_message "${BOLD}" "Configuring SSL settings..."
    
    # Create SSL configuration
    cat > "$INSTALL_PATH/ssl-config.sh" << EOF
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored messages
print_message() {
    echo -e "\${2}\${1}\${NC}"
}

# Function to check SSL certificates
check_ssl() {
    local domain=\$1
    if [ -f "$INSTALL_PATH/letsencrypt/live/\$domain/fullchain.pem" ]; then
        print_message "SSL certificate for \$domain is valid" "\$GREEN"
        return 0
    else
        print_message "No SSL certificate found for \$domain" "\$RED"
        return 1
    fi
}

# Function to renew SSL certificates
renew_ssl() {
    docker-compose -f "$INSTALL_PATH/docker-compose.yml" exec app nginx -s reload
    print_message "SSL certificates renewed" "\$GREEN"
}

# Main SSL process
main() {
    print_message "Checking SSL certificates..." "\$YELLOW"
    for domain in \$(ls "$INSTALL_PATH/letsencrypt/live/" 2>/dev/null); do
        check_ssl "\$domain"
    done
    renew_ssl
}

main
EOF
    
    chmod +x "$INSTALL_PATH/ssl-config.sh"
    
    # Add cron job for SSL renewal
    (crontab -l 2>/dev/null; echo "0 0 1 * * $INSTALL_PATH/ssl-config.sh >> $INSTALL_PATH/ssl.log 2>&1") | crontab -
    print_message "${GREEN}" "SSL configuration completed"
}

# Function to parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --http-port)
                HTTP_PORT="$2"
                shift 2
                ;;
            --admin-port)
                ADMIN_PORT="$2"
                shift 2
                ;;
            --https-port)
                HTTPS_PORT="$2"
                shift 2
                ;;
            --no-backup)
                AUTO_BACKUP=false
                shift
                ;;
            --no-update)
                UPDATE_SYSTEM=false
                shift
                ;;
            --install-path)
                INSTALL_PATH="$2"
                shift 2
                ;;
            --version)
                NPM_VERSION="$2"
                shift 2
                ;;
            --install-monitoring)
                INSTALL_MONITORING=true
                shift
                ;;
            --no-auto-update)
                AUTO_UPDATE=false
                shift
                ;;
            --backup-schedule)
                BACKUP_SCHEDULE="$2"
                shift 2
                ;;
            --ssl-email)
                SSL_EMAIL="$2"
                shift 2
                ;;
            *)
                print_message "${RED}" "Unknown option: $1"
                exit 1
                ;;
        esac
    done
}

# Main installation process
main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    print_message "${BOLD}" "Starting Nginx Proxy Manager installation..."
    
    # Confirm installation
    confirm_installation
    
    # Update system if requested
    update_system
    
    # Check requirements
    check_requirements
    
    # Backup existing installation
    if [ "$AUTO_BACKUP" = true ]; then
        backup_existing
    fi
    
    # Check port availability
    check_ports
    
    # Install dependencies
    install_dependencies
    
    # Configure firewall
    configure_firewall
    
    # Install NPM
    install_npm
    
    # Create docker-compose.yml
    create_docker_compose
    
    # Start the containers
    print_message "${YELLOW}" "Starting Nginx Proxy Manager..."
    cd "$INSTALL_PATH"
    docker-compose up -d
    
    # Wait for services to start
    sleep 10
    
    # Install monitoring tools if requested
    install_monitoring_tools
    
    # Setup automatic updates
    setup_auto_updates
    
    # Setup backup schedule
    setup_backup_schedule
    
    # Configure SSL
    configure_ssl
    
    # Perform health check
    if ! health_check; then
        print_message "${YELLOW}" "Installation completed with warnings"
    else
        print_message "${GREEN}" "Installation completed successfully"
    fi
    
    # Show summary
    show_summary
}

# Run main function with all arguments
main "$@"

# =============================================
# MIT License
# 
# Copyright (c) 2025 Mohamed Shaheen
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================
