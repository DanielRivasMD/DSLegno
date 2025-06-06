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

####################################################################################################

# Ensure directories $HOME/Desktop/Acquista and $HOME/Desktop/Vendita exist, create them if needed and log
DIR1="$HOME/Desktop/Acquista"
DIR2="$HOME/Desktop/Vendita"

for DIR in "$DIR1" "$DIR2"; do
    mkdir -p "$DIR"
done

####################################################################################################

# Create a soft link of $HOME/DSLegno/com.fabrizio.fattura-watchers.plist to /Users/fabrizio/Library/LaunchAgents/com.fabrizio.fattura-watchers.plist
TARGET="$HOME/DSLegno/com.fabrizio.fattura-watchers.plist"
LINK="/Users/fabrizio/Library/LaunchAgents/com.fabrizio.fattura-watchers.plist"

# Ensure the LaunchAgents directory exists
mkdir -p "$(dirname "$LINK")"

if [ ! -L "$LINK" ]; then
    ln -s "$TARGET" "$LINK"
    echo "Symbolic link created: $LINK -> $TARGET"
else
    echo "Symbolic link $LINK already exists."
fi

####################################################################################################
