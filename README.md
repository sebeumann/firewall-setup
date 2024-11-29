# UFW Profile Manager

A simple bash script to manage UFW (Uncomplicated Firewall) profiles on Linux systems.

## Prerequisites

```bash
sudo pacman -S ufw python-setuptools
```

## Installation

1. Clone the repository:
```bash
git clone [your-repo-url]
cd ufw-profile-manager
```

2. Make script executable:
```bash
chmod +x setup-firewall.sh
```

3. Run setup:
```bash
sudo ./setup-firewall.sh
```

## Usage

Switch between profiles:
```bash
sudo switch-firewall-profile [home|work|public]
```

## Profiles

- **Home**: Basic services + media streaming
- **Work**: Development services + remote access
- **Public**: Minimal services with enhanced security

## Note

Script will disable firewalld and switch to UFW.
