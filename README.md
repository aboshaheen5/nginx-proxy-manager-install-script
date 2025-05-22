# Nginx Proxy Manager Installation Script

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=flat&logo=nginx&logoColor=white)](https://nginx.org/)
[![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Discord](https://img.shields.io/badge/Discord-%235865F2.svg?style=flat&logo=discord&logoColor=white)](https://discord.gg/UuasbmKqUh)

<div align="center">
  <img src="https://nginxproxymanager.com/github.png" alt="Nginx Proxy Manager" width="400"/>
</div>

## 🚀 Quick Start

```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/aboshaheen5/nginx-proxy-manager-install-script/main/install.sh | sudo bash

# Installation with custom options
curl -sSL https://raw.githubusercontent.com/aboshaheen5/nginx-proxy-manager-install-script/main/install.sh | sudo bash -s -- --install-path /custom/path --version 2.9.22 --install-monitoring
```

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

### 🎯 Key Benefits
- **Time Saving**: Complete setup in under 5 minutes
- **Zero Configuration**: Works out of the box
- **Production Ready**: Follows security best practices
- **Easy Updates**: Simple update process
- **Community Support**: Active community and regular updates
- **Automatic Maintenance**: Built-in backup and update scheduling
- **Monitoring Tools**: Integrated system monitoring
- **SSL Management**: Automatic SSL certificate handling

## 👨‍💻 Author
**Mohamed Shaheen** - [GitHub](https://github.com/aboshaheen5)

## 📝 License & Copyright
Copyright © 2025 Mohamed Shaheen. All rights reserved.

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Features

### Core Features
- **🚀 Easy Installation**: One-command installation process
- **🎨 Web Interface**: Beautiful and intuitive web-based management interface
- **🔒 SSL Management**: Automatic SSL certificate management with Let's Encrypt
- **🌐 Multiple Hosts**: Support for multiple proxy hosts and domains
- **⚡ Advanced Rules**: Easy configuration of redirection and proxy rules
- **🔄 Protocol Support**: Supports HTTP, HTTPS, WebSocket, and more
- **🐳 Docker-based**: Containerized deployment for better isolation and management

### Advanced Features
- **📊 Monitoring**: Built-in monitoring and statistics
- **🔐 Security**: Automatic security headers and best practices
- **🌍 Multi-Domain**: Support for multiple domains and subdomains
- **📱 Mobile Friendly**: Responsive web interface
- **🔍 Logging**: Detailed access and error logs
- **🛡️ DDoS Protection**: Basic DDoS protection included
- **📈 Performance**: Optimized for high performance
- **🔄 Auto-Renewal**: Automatic SSL certificate renewal

### Maintenance Features
- **🔄 Auto Updates**: Weekly automatic updates with backup
- **💾 Auto Backup**: Daily automatic backups with retention
- **🔍 Health Checks**: Regular system health monitoring
- **📊 Performance Monitoring**: Real-time performance metrics
- **🔐 SSL Monitoring**: Certificate expiration monitoring
- **📝 Log Management**: Automatic log rotation and cleanup

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

### Basic Installation
```bash
# One-line installation
curl -sSL https://raw.githubusercontent.com/aboshaheen5/nginx-proxy-manager-install-script/main/install.sh | sudo bash
```

### Advanced Installation
```bash
# Installation with custom options
curl -sSL https://raw.githubusercontent.com/aboshaheen5/nginx-proxy-manager-install-script/main/install.sh | sudo bash -s -- \
  --install-path /custom/path \
  --version 2.9.22 \
  --http-port 8080 \
  --admin-port 8081 \
  --https-port 8443 \
  --install-monitoring \
  --backup-schedule "0 0 * * *" \
  --ssl-email "your@email.com"
```

### Installation Options
| Option | Description | Default |
|--------|-------------|---------|
| `--install-path` | Custom installation path | `/opt/nginx-proxy-manager` |
| `--version` | NPM version to install | `latest` |
| `--http-port` | HTTP port | `80` |
| `--admin-port` | Admin interface port | `81` |
| `--https-port` | HTTPS port | `443` |
| `--no-backup` | Disable automatic backups | `false` |
| `--no-update` | Disable system updates | `false` |
| `--install-monitoring` | Install monitoring tools | `false` |
| `--no-auto-update` | Disable automatic updates | `false` |
| `--backup-schedule` | Custom backup schedule (cron) | `0 0 * * *` |
| `--ssl-email` | Email for SSL notifications | `admin@example.com` |

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

### Automatic Updates
```bash
# Check update status
cat /opt/nginx-proxy-manager/update.log

# Manual update
/opt/nginx-proxy-manager/update.sh
```

### Automatic Backups
```bash
# Check backup status
cat /opt/nginx-proxy-manager/backup.log

# Manual backup
/opt/nginx-proxy-manager/backup.sh
```

### SSL Management
```bash
# Check SSL status
/opt/nginx-proxy-manager/ssl-config.sh

# View SSL logs
cat /opt/nginx-proxy-manager/ssl.log
```

### Monitoring
```bash
# Check system status
/opt/nginx-proxy-manager/monitor.sh

# View monitoring logs
cat /opt/nginx-proxy-manager/monitor.log
```

## 🔍 Advanced Usage

### Custom SSL Certificates
```bash
# Place your certificates in
/opt/nginx-proxy-manager/data/custom_ssl/
```

### Custom Nginx Configuration
```bash
# Add custom configurations in
/opt/nginx-proxy-manager/data/nginx/custom/
```

### Performance Tuning
```bash
# Adjust worker processes
nano /opt/nginx-proxy-manager/data/nginx/nginx.conf
```

## 📈 Performance Tips

1. **System Optimization**
   - Enable HTTP/2
   - Enable Gzip compression
   - Use browser caching
   - Enable keepalive connections

2. **Security Enhancements**
   - Enable HSTS
   - Configure SSL parameters
   - Set up rate limiting
   - Enable ModSecurity

3. **Monitoring Setup**
   - Set up log rotation
   - Configure monitoring alerts
   - Regular backup schedule
   - Performance metrics collection

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### How to Contribute
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

- GitHub Issues: [Open an issue](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/issues)
- Documentation: [Wiki](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/wiki)
- Community: [Discussions](https://github.com/aboshaheen5/nginx-proxy-manager-install-script/discussions)
- Discord Server: [Join our community](https://discord.gg/UuasbmKqUh)

## ⭐ Star History

[![Star History Chart](https://api.star-history.com/svg?repos=aboshaheen5/nginx-proxy-manager-install-script&type=Date)](https://star-history.com/#aboshaheen5/nginx-proxy-manager-install-script&Date) 