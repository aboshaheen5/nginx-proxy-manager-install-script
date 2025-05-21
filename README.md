# Nginx Proxy Manager Installation Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=flat&logo=nginx&logoColor=white)](https://nginx.org/)
[![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=flat&logo=discord&logoColor=white)](https://discord.gg/UuasbmKqUh)

<div align="center">
  <img src="https://nginxproxymanager.com/github.png" alt="Nginx Proxy Manager" width="400"/>
</div>

## 📋 Table of Contents
- [Overview](#-overview)
- [Features](#-features)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
- [Usage](#-usage)
- [Security](#-security)
- [Maintenance](#-maintenance)
- [Troubleshooting](#-troubleshooting)
- [Support](#-support)
- [License](#-license)

## 🌟 Overview

A powerful and user-friendly script to automate the installation of Nginx Proxy Manager. This script provides a seamless setup experience for deploying a professional-grade reverse proxy solution with a beautiful web interface.

## 👨‍💻 Author
**Mohamed Shaheen** - [GitHub](https://github.com/aboshaheen5)

## 📝 License & Copyright
Copyright © 2025 Mohamed Shaheen. All rights reserved.

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Features

- **🚀 Easy Installation**: One-command installation process
- **🎨 Web Interface**: Beautiful and intuitive web-based management interface
- **🔒 SSL Management**: Automatic SSL certificate management with Let's Encrypt
- **🌐 Multiple Hosts**: Support for multiple proxy hosts and domains
- **⚡ Advanced Rules**: Easy configuration of redirection and proxy rules
- **🔄 Protocol Support**: Supports HTTP, HTTPS, WebSocket, and more
- **🐳 Docker-based**: Containerized deployment for better isolation and management
- **📊 Monitoring**: Built-in monitoring and statistics
- **🔐 Security**: Automatic security headers and best practices

## 🔧 System Requirements

### Supported Operating Systems
#### Linux Distributions
- **Ubuntu**
  - Ubuntu 22.04 LTS (Jammy Jellyfish)
  - Ubuntu 20.04 LTS (Focal Fossa)
  - Ubuntu 18.04 LTS (Bionic Beaver)

- **Debian**
  - Debian 12 (Bookworm)
  - Debian 11 (Bullseye)
  - Debian 10 (Buster)

- **CentOS/RHEL**
  - CentOS 8
  - CentOS 7
  - RHEL 8
  - RHEL 7

- **Other Linux Distributions**
  - Any Linux distribution that supports Docker
  - Must have systemd as init system
  - Must have a modern kernel (4.x or newer)

#### System Architecture
| Architecture | Description | Status | Notes |
|--------------|-------------|--------|-------|
| x86_64 | 64-bit Intel/AMD | ✅ Fully Supported | Recommended for production use |
| ARM64 | 64-bit ARM (AArch64) | ✅ Fully Supported | Compatible with most ARM servers |
| ARMv7 | 32-bit ARM | ⚠️ Limited Support | Basic functionality only |
| ARMv6 | 32-bit ARM (older) | ❌ Not Supported | Too old for Docker |
| i386 | 32-bit x86 | ❌ Not Supported | Too old for Docker |
| PowerPC | IBM Power | ❌ Not Supported | No Docker support |

**Architecture Notes:**
- ✅ **Fully Supported**: All features available, thoroughly tested
- ⚠️ **Limited Support**: Basic features only, may have limitations
- ❌ **Not Supported**: Will not work, incompatible with Docker

**Recommended Architecture:**
- For production use: x86_64
- For ARM-based servers: ARM64
- For development/testing: Any supported architecture

### Hardware Requirements
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 1 core | 2+ cores |
| RAM | 1GB | 2GB+ |
| Storage | 10GB | 20GB+ |
| Network | Stable connection | High-speed connection |

### Software Requirements
- Docker 20.10.0 or newer
- Docker Compose 2.0.0 or newer
- Git (for installation)
- curl (for installation)

## 📦 Installation

1. Clone the repository:
```bash
git clone https://github.com/aboshaheen5/nginx-proxy-manager-install-script.git
cd nginx-proxy-manager-install-script
```

2. Make the script executable:
```bash
chmod +x install.sh
```

3. Run the installation script:
```bash
sudo ./install.sh
```

## 🔐 Default Access

After installation, access the admin interface:
- URL: `http://YOUR_SERVER_IP:81`
- Default Email: `admin@example.com`
- Default Password: `changeme`

**Important**: Change these credentials immediately after first login!

## 🌐 Port Configuration

| Port | Purpose | Protocol | Required |
|------|---------|----------|----------|
| 80   | HTTP    | TCP      | Yes      |
| 81   | Admin UI| TCP      | Yes      |
| 443  | HTTPS   | TCP      | Yes      |

## 🔒 Security Recommendations

### 1. Credentials
- Change default admin credentials immediately
- Use strong, unique passwords
- Enable 2FA if available
- Regular password rotation

### 2. System Security
- Keep Docker and system packages updated
- Configure firewall rules
- Use SSL certificates for all domains
- Regular security audits
- Enable automatic updates

### 3. Backup
- Regular backups of configuration
- Export SSL certificates
- Document custom configurations
- Test backup restoration

## 🛠️ Maintenance

### Updating Nginx Proxy Manager
```bash
cd /opt/nginx-proxy-manager
docker-compose pull
docker-compose up -d
```

### Checking Logs
```bash
docker-compose logs -f
```

### Backup Configuration
```bash
cp -r /opt/nginx-proxy-manager/data /backup/
```

### Monitoring
- Check system resources regularly
- Monitor SSL certificate expiration
- Review access logs
- Set up alerts for critical events

## ❓ Troubleshooting

### Common Issues and Solutions

1. **Port Conflicts**
   - Ensure ports 80, 81, and 443 are not in use
   - Check with: `netstat -tulpn | grep LISTEN`
   - Solution: Stop conflicting services or change ports

2. **Docker Issues**
   - Verify Docker is running: `systemctl status docker`
   - Check Docker logs: `journalctl -u docker`
   - Solution: Restart Docker service if needed

3. **SSL Certificate Problems**
   - Verify DNS records
   - Check Let's Encrypt rate limits
   - Ensure ports 80/443 are accessible
   - Solution: Check DNS propagation and firewall rules

4. **Performance Issues**
   - Check system resources
   - Review Nginx configuration
   - Monitor Docker container stats
   - Solution: Optimize configuration or upgrade resources

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📞 Support

- GitHub Issues: [Open an issue](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/issues)
- Documentation: [Wiki](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/wiki)
- Community: [Discussions](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/discussions)
- Discord Server: [Join our community](https://discord.gg/UuasbmKqUh)

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aboshaheen5/nginx-proxy-manager-install-script&type=Date)](https://star-history.com/#aboshaheen5/nginx-proxy-manager-install-script&Date) 