#!/bin/bash

# Assume the script is in a subdirectory of the main dotfiles repo.
# This finds the root directory of the repository.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "Dotfiles repository located at: $DOTFILES_DIR"

# --- Git Configuration ---
echo "Setting up Git configuration..."
# Force-copy the .gitconfig file, overwriting any existing one.
cp -f "$DOTFILES_DIR/shared/.gitconfig" "$HOME/.gitconfig"

# --- Zsh (Shell) Configuration ---
echo "Setting up Zsh configuration..."
ZSHRC_FILE="$HOME/.zshrc"
ZSHRC_SOURCE="$DOTFILES_DIR/os/macos/.zshrc" # Path to your replacement zsh settings

# Directly replace the ~/.zshrc file with the one from the repo.
echo "Replacing $ZSHRC_FILE with the repository version..."
cp -f "$ZSHRC_SOURCE" "$ZSHRC_FILE"

# --- Homebrew Package Management ---
echo "Setting up Homebrew and packages..."

# Check if Homebrew is installed. If not, install it.
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Ensure Homebrew is up-to-date.
brew update

# Install all packages listed in the Brewfile.
BREWFILE="$DOTFILES_DIR/os/macos/Brewfile"

echo "Installing packages from Brewfile..."
brew bundle install --no-upgrade --file="$BREWFILE"

# --- SSH Setup ---
SSH_DIR="$HOME/.ssh"
echo "Setting up SSH directory at $SSH_DIR..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR" # Set correct, secure permissions.

# --- Generate SSH Config from Template ---
CONFIG_FILE="$SSH_DIR/config"
SECRETS_FILE="$DOTFILES_DIR/.env.local"
TEMPLATE_FILE="$DOTFILES_DIR/shared/ssh/config.template"

echo "Looking for secrets file at: $SECRETS_FILE"

if [[ -f "$SECRETS_FILE" ]]; then
    echo "Generating SSH config..."

    # Read the entire template
    CONFIG_CONTENT=$(<"$TEMPLATE_FILE")

    # Replace placeholders with values from .env.local
    while IFS='=' read -r KEY VALUE; do
        # Skip empty lines or comments
        [[ -z "$KEY" || "$KEY" == \#* ]] && continue
        CONFIG_CONTENT="${CONFIG_CONTENT//\{\{$KEY\}\}/$VALUE}"
    done <"$SECRETS_FILE"

    # Write the populated config
    echo "$CONFIG_CONTENT" >"$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE"

    echo "SSH config created successfully."
else
    echo "WARNING: Secrets file not found at $SECRETS_FILE. SSH config not generated."
fi

echo "Setup complete! Restart your terminal or run 'source ~/.zshrc' to apply changes."
