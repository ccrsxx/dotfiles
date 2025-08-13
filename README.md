# Dotfiles

This repository contains my personal configuration files for macOS and Windows. It automates the setup of a new machine, ensuring a consistent development environment across platforms.

## Features

- **Cross-Platform:** Configurations for both macOS and Windows.
- **Automated Setup:** Scripts to sync configurations and install software.
- **Package Management:** Uses [Homebrew](https://brew.sh/) for macOS and [Scoop](https://scoop.sh/) for Windows.
- **Git Configuration:** Includes a global `.gitconfig` with aliases, default branch naming, and commit signing.
- **SSH Key Management:** Automates public key setup and provides templates for secure SSH configurations.
- **Custom Terminal Setup:** Includes themes and settings for Windows Terminal and [Oh My Posh](https://ohmyposh.dev/).

## Getting Started

### 1. Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/ccrsxx/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Handle Secrets

This repository uses a `.env.local` file to manage sensitive data like IP addresses and hostnames for SSH configurations. This file is ignored by Git and must be created manually:

```bash
cp .env.example .env.local
```

Edit `.env.local` with your actual secret information:

```bash
vim .env.local
```

### 3. Run the Installation Script

macOS

```bash
# Run the macOS installation script
./scripts/install-macos.sh
```

Windows

```powershell
# Allow the script to run for the current session
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# Run the Windows installation script
.\scripts\install-windows.ps1
```

### 4. Post-Installation Steps

After running the scripts, manually complete the following:

1. **Transfer Private Keys:** Securely copy your private SSH key files (e.g., `homelab_key`, `github_key`) to the `~/.ssh` directory.
2. **Load Keys into Agent:** Run `ssh-add ~/.ssh/your_private_key` to load your keys into the SSH agent.

## Repository Structure

The repository is organized as follows:

- **`os/`**: Contains OS-specific configurations (e.g., macOS, Windows).
- **`shared/`**: Contains shared configurations (e.g., `.gitconfig`, SSH templates).
- **`scripts/`**: Includes automation scripts for setup and installation.
