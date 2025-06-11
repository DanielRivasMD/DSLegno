#!/bin/bash
####################################################################################################

# Change directory
cd "$HOME/DSLegno/"

####################################################################################################

# Fetch latest git commit
git pull

####################################################################################################

# Backup database
cp "$HOME/DSLegno/dallasanta.db" "$HOME/DSLegno/backup_dallasanta.db"

mkdir -p "$HOME/Library/Mobile Documents/com~apple~CloudDocs/DSLegno"
cp "$HOME/DSLegno/dallasanta.db" "$HOME/Library/Mobile Documents/com~apple~CloudDocs/DSLegno/backup_dallasanta.db"

####################################################################################################

# Set up database
diesel migration run

####################################################################################################

# Download the latest release executable ("fattura") from GitHub (DanielRivasMD/DSLegno)
#
# This section fetches the latest release from the GitHub API, filters for an asset named "fattura",
# downloads it, places it in $HOME/bin, and sets the executable permission.

# Ensure the $HOME/bin directory exists
mkdir -p "$HOME/bin"

# Get the download URL for the latest release asset named "fattura"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/DanielRivasMD/DSLegno/releases/latest | grep 'browser_download_url' | grep 'fattura' | cut -d '"' -f 4)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find the download URL for 'fattura' binary in the latest release."
    exit 1
fi

echo "Downloading fattura from $DOWNLOAD_URL..."
curl -L "$DOWNLOAD_URL" -o "$HOME/bin/fattura"

# Make sure the downloaded file is executable
chmod +x "$HOME/bin/fattura"
echo "Downloaded and installed fattura to $HOME/bin/fattura"

####################################################################################################
