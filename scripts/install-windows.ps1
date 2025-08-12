# Get the directory of the script
$DotfilesDir = Split-Path -Path $PSScriptRoot -Parent

Write-Host "Symlinking shared dotfiles..."

# Remove existing file if it exists, then copy the shared .gitconfig
Remove-Item "$HOME\.gitconfig" -ErrorAction SilentlyContinue
Copy-Item -Path "$DotfilesDir\shared\.gitconfig" -Destination "$HOME\.gitconfig" -Force

# Windows-specific setup
Write-Host "Running Windows setup..."

$ProfilePath = $PROFILE
$ProfileDir = Split-Path -Path $ProfilePath -Parent

if (-not (Test-Path $ProfileDir)) { 
    New-Item -ItemType Directory -Path $ProfileDir -Force 
}

Remove-Item $ProfilePath -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $ProfilePath -Target "$DotfilesDir\os\windows\powershell-profile.ps1"

# --- Scoop Package Management ---
Write-Host "Setting up Scoop..."

if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop not found. Installing..."

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
} else {
    Write-Host "Scoop is already installed."
}

Write-Host "Installing packages from scoop_packages.json..."

$ScoopApps = "$DotfilesDir\os\windows\scoop-apps.json"

scoop update

scoop import $ScoopApps

# --- SSH Setup ---
$SshDir = "$HOME\.ssh"

Write-Host "Setting up SSH directory at $SshDir..."

if (-not (Test-Path $SshDir)) {
    New-Item -ItemType Directory -Path $SshDir -Force 
}

# --- Generate SSH Config from Template ---
Write-Host "Generating SSH config..."

$ConfigFile = "$SshDir\config"
$SecretsFile = "$DotfilesDir\.env.local"
$TemplateFile = "$DotfilesDir\shared\ssh\config.template"

if (Test-Path $SecretsFile) {
    # Read the entire template file into a single string
    $configContent = Get-Content -Path $TemplateFile -Raw

    # Read the secrets file and replace placeholders in the content
    Get-Content $SecretsFile | ForEach-Object {
        if ($_ -match '^(.*?)=(.*)$') {
            $key = $matches[1]
            $value = $matches[2]
            $configContent = $configContent.Replace("{{$key}}", $value)
        }
    }
    
    # Write the final, populated content to the config file
    Set-Content -Path $ConfigFile -Value $configContent
    Write-Host "SSH config created successfully."
} else {
    Write-Host "WARNING: Secrets file not found at $SecretsFile. SSH config not generated."
}

Write-Host "Setup complete!"
