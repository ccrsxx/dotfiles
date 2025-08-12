# My Dotfiles

These are my personal configuration files for macOS and Windows. This repository automates the setup of a new machine, ensuring a consistent development environment everywhere I work.

## Features

- **Cross-Platform:** Manages configurations for both macOS and Windows.
- **Automated Setup:** Uses simple installation scripts to symlink configs and install software.
- **Package Management:** Installs applications and tools via [Homebrew](https://brew.sh/) on macOS and [Scoop](https://scoop.sh/) on Windows.
- **Personalized Git:** Includes a global `.gitconfig` with aliases, a default branch name, and automated commit signing.
- **Secure SSH Config:** Uses a template system with a private `.env.local` file to manage sensitive host information securely.
- **Custom Terminal:** Includes settings and themes for Windows Terminal and [Oh My Posh](https://ohmyposh.dev/).

---

## Getting Started

Setting up a new machine involves cloning the repository, creating a local secrets file, and running the appropriate installation script:

1. Handle Your Secrets

   This repository uses a `.env.local` file to manage sensitive data like IP addresses and hostnames for the SSH configuration. This file is intentionally ignored by Git and **must never be committed**.

   First, copy the example file to create your local version:

   ```bash
   cp .env.example .env.local
   ```

   Next, open `.env.local` with a text editor and replace the placeholder values with your actual secret information.

1. Run the Installation Script

   ### On macOS

   ```bash
   # Clone the repository
   git clone https://github.com/your-username/dotfiles.git ~/dotfiles

   # Navigate into the directory
   cd ~/dotfiles

   # Create and populate your secrets file as described above
   # cp .env.example .env.local
   # nano .env.local

   # Run the installation script
   ./scripts/install-macos.sh
   ```

   ### On Windows

   ```powershell
   # Clone the repository
   git clone https://github.com/your-username/dotfiles.git $HOME\dotfiles

   # Navigate into the directory
   cd $HOME\dotfiles

   # Create and populate your secrets file as described above
   # copy .env.example .env.local
   # notepad .env.local

   # Allow the script to run for the current session
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

   # Run the installation script
   .\scripts\install-windows.ps1
   ```

1. Post-Installation

   The scripts automate configuration, but for security, you must manually:

   1. **Transfer Your Private Keys:** Securely copy your private SSH key files (e.g., `homelab_key`, `github_key`) to the `~/.ssh` directory on your new machine.
   2. **Load Keys into Agent:** Open a new terminal and run `ssh-add ~/.ssh/your_private_key` to load your keys into the SSH agent.

## Directory Structure

- **`.env.example`**: An example template for the private `.env.local` file.
- **`.gitignore`**: Critically important file that prevents secrets and private keys from being committed.
- **`os/`**: Contains all OS-specific configurations, separated by platform.
- **`scripts/`**: Holds all automation and setup scripts.
- **`shared/`**: Contains configurations that are shared across all operating systems, like `.gitconfig` and SSH templates.
