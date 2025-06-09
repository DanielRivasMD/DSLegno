#!/bin/bash
####################################################################################################

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

####################################################################################################

# Reload the shell environment so that brew is available in the current session
eval "$(/opt/homebrew/bin/brew shellenv)"

####################################################################################################

# watchexec
brew install watchexec

# gui
brew install --cask db-browser-for-sqlite

# sqlite
brew install sqlite
brew install litecli

# diesel
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/diesel-rs/diesel/releases/latest/download/diesel_cli-installer.sh | sh

####################################################################################################

# Set up database
diesel setup

####################################################################################################

# Link database
ln -s $HOME/DSLegno/dallasanta.db $HOME

# Link launcher
ln -s $HOME/DSLegno/launch.command $HOME/Desktop

####################################################################################################

# Ensure directories $HOME/Desktop/Acquista and $HOME/Desktop/Vendita exist, create them if needed and log
DIR1="$HOME/Desktop/Acquista"
DIR2="$HOME/Desktop/Vendita"

for DIR in "$DIR1" "$DIR2"; do
    mkdir -p "$DIR"
done

####################################################################################################

# # TODO: not functioning properly. temporary work around
# # Create a soft link of $HOME/DSLegno/com.fabrizio.fattura-watchers.plist to /Users/fabrizio/Library/LaunchAgents/com.fabrizio.fattura-watchers.plist
# TARGET="$HOME/DSLegno/com.fabrizio.fattura-watchers.plist"
# LINK="/Users/fabrizio/Library/LaunchAgents/com.fabrizio.fattura-watchers.plist"

# # Ensure the LaunchAgents directory exists
# mkdir -p "$(dirname "$LINK")"

# if [ ! -L "$LINK" ]; then
#     ln -s "$TARGET" "$LINK"
#     echo "Symbolic link created: $LINK -> $TARGET"
# else
#     echo "Symbolic link $LINK already exists."
# fi

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
