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
