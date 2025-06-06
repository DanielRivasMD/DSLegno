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

# Verify if directories $HOME/Desktop/Acquista and $HOME/Desktop/Vendita exist, if not create them and log
DIR1="$HOME/Desktop/Acquista"
DIR2="$HOME/Desktop/Vendita"

for DIR in "$DIR1" "$DIR2"; do
    if [ ! -d "$DIR" ]; then
        echo "Directory $DIR does not exist. Creating it..."
        mkdir -p "$DIR"
        echo "Directory $DIR created."
    else
        echo "Directory $DIR already exists."
    fi
done

####################################################################################################
