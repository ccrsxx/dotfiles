#!/bin/bash

# Check if curl is installed
if ! command -v curl &>/dev/null; then
    echo "❌ Error: curl is not installed. Please install it first (e.g., apt update && apt install curl)."
    exit 1
fi

# Define paths using the current user's home directory
SSH_DIR="$HOME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

# Construct the URL to the raw public key file
KEY_URL="https://raw.githubusercontent.com/ccrsxx/dotfiles/main/shared/ssh/public-keys/homelab-general.pub"

echo "Setting up SSH key for the current user ($USER)..."

# Create the .ssh directory if it doesn't exist and set permissions
echo "Ensuring $SSH_DIR directory exists..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Ensure authorized_keys file exists so grep doesn't error
touch "$AUTH_KEYS_FILE"

# Fetch the key content into a variable
KEY_CONTENT=$(curl -fsSL "$KEY_URL")

# Check if the key was fetched successfully
if [ -z "$KEY_CONTENT" ]; then
    echo "❌ Error: Failed to fetch the public key from $KEY_URL. Please check the URL and your internet connection."
    exit 1
fi

# Check if the key already exists in the file before appending
# grep -q (quiet mode) -F (fixed string)
if grep -qF -- "$KEY_CONTENT" "$AUTH_KEYS_FILE"; then
    echo "Key already exists in $AUTH_KEYS_FILE. No changes needed."
else
    echo "Key not found. Appending to $AUTH_KEYS_FILE..."
    echo "$KEY_CONTENT" >>"$AUTH_KEYS_FILE"
    echo "Public key successfully appended."
fi

# Set correct permissions for the authorized_keys file
echo "Setting final permissions..."
chmod 600 "$AUTH_KEYS_FILE"

echo "Success! SSH key setup is complete and verified."
