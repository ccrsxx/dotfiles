#!/bin/bash

# MODIFIED: Get the base filename from the first argument ($1).
# If $1 is not provided, default to "homelab-general".
FILENAME_BASE="${1:-homelab-general}"

# Check if curl is installed
if ! command -v curl &>/dev/null; then
    echo "Error: curl is not installed. Please install it first."
    exit 1
fi

# Define paths
SSH_DIR="$HOME/.ssh"
AUTH_KEYS_FILE="$SSH_DIR/authorized_keys"

# MODIFIED: Construct the full filename and URL from the base name
KEY_FILENAME="${FILENAME_BASE}.pub"
KEY_URL="https://raw.githubusercontent.com/ccrsxx/dotfiles/main/shared/ssh/public-keys/${KEY_FILENAME}"

echo "Setting up SSH key from '${KEY_FILENAME}' for user ($USER)..."

# Create the .ssh directory if it doesn't exist and set permissions
echo "Ensuring $SSH_DIR directory exists..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Fetch the key content into a variable
KEY_CONTENT=$(curl -fsSL "$KEY_URL")

# Check if the key was fetched successfully
if [[ -z "$KEY_CONTENT" || "$KEY_CONTENT" == "404: Not Found" ]]; then
    echo "Error: Failed to fetch the public key from $KEY_URL."
    echo "Please check that the file '${KEY_FILENAME}' exists in the repository."
    exit 1
fi

# Check if the key already exists in the file before appending
if grep -qF -- "$KEY_CONTENT" "$AUTH_KEYS_FILE" 2>/dev/null; then
    echo "Key from '${KEY_FILENAME}' already exists. No changes needed."
else
    echo "Key not found. Appending to $AUTH_KEYS_FILE..."
    echo "$KEY_CONTENT" >>"$AUTH_KEYS_FILE"
    echo "Public key from '${KEY_FILENAME}' successfully appended."
fi

# Set correct permissions for the authorized_keys file
echo "Setting final permissions..."
chmod 600 "$AUTH_KEYS_FILE"

echo "Success! SSH key setup is complete."
