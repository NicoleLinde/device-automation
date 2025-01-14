#!/bin/bash

#################
### Initial setup
#################

# Ask for sudo upfront.
echo "Some operations need sudo privileges. Please enter your password."
sudo -v
# Ask user for required information.
read -p "Enter your work company name: " company_name
# Define needed variables.
git_user_dir=~/dev/NicoleLinde
git_company_dir=~/dev/$company_name
git_dracula_dir=~/dev/dracula
# Create the directory to store git repos.
mkdir -p $git_user_dir
mkdir -p $git_company_dir
mkdir -p $git_dracula_dir

###################################
### Apply operating system settings
###################################

echo "Setting up operating system settings..."
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write com.apple.dock tilesize -integer 29
killall Dock
echo "Done."

###########################
### Install package manager
###########################

echo "Installing brew..."
xcode-select --install
which -s brew
if [[ $? != 0 ]]; then
    yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
fi
echo "Done."

##############################
### Install blocking packages.
##############################

echo "Installing blocking packages please stay here and enter credentials as needed..."
brew install --cask dotnet-sdk
brew install --cask microsoft-teams
brew install --cask microsoft-word
echo "Done. You can now go and let the script install the rest."

################
### Install git.
################

echo "Installing git..."
brew install git
echo "Done."

###############
### Install ZSH
###############

echo "Installing Zsh and Oh My Zsh..."
# Zsh
if ! brew list zsh &>/dev/null; then
    # Install Zsh.
    brew install zsh
    # Install Oh My Zsh.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Install the dracula theme.
    cd $git_dracula_dir && git clone https://github.com/dracula/zsh.git
    ln -s $git_dracula_dir/zsh/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
    # Activate the dracula theme.
    sed -i '' 's/robbyrussell/dracula/g' ~/.zshrc
fi
echo "Done."

###############
### Set aliases
###############

echo alias cls=clear >>~/.zshrc
echo alias cd..='cd ..' >>~/.zshrc
echo alias lsa='ls -la' >>~/.zshrc
echo alias md='mkdir' >>~/.zshrc
echo alias gc='git checkout' >>~/.zshrc
echo alias pod64="arch -x86_64 pod" >>~/.zshrc
echo alias yarn64="arch -x86_64 yarn" >>~/.zshrc

###########
### Browser
###########

echo "Installing browsers..."
brew install --cask firefox
brew install --cask google-chrome
echo "Done."

###########
### Utility
###########

echo "Installing utility packages..."
brew install --cask iterm2
brew install --cask 1password
# Download the dracula theme for iterm2.
cd $git_dracula_dir && git clone https://github.com/dracula/iterm.git
echo "Done."

###############
### Development
###############

echo "Installing development packages..."
# CLI
brew install --cask powershell
brew install nvm
# Add nvm path to shells.
echo "export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"" >>~/.zshrc
# Reload shells.
source ~/.zshrc
# Install latest LTS version of node.
nvm install --lts
brew install yarn
brew install --cask docker
brew install azure-cli
brew install nuget
brew tap azure/bicep
brew install bicep
brew install rbenv ruby-build
brew install cocoapods

# SDK
dotnet tool install --global dotnet-ef

# IDE / Editor
brew install --cask visual-studio-code
brew install --cask rider

# Tools
brew install --cask microsoft-azure-storage-explorer
brew install --cask postman
brew install --cask azure-data-studio
brew install --cask redisinsight
brew install --cask figma
brew install --cask notion
echo "Done."

#################
### Communication
#################

echo "Installing communication packages..."
brew install --cask discord
brew install --cask zoom
echo "Done."

################
### Office Tools
################

echo "Installing office tools..."
brew install --cask microsoft-excel
brew install --cask microsoft-powerpoint
brew install --cask onedrive
echo "Done."

###########
# App Store
###########

read -p "Sign in to App Store and press ENTER to continue..."

echo "Installing App Store packages..."
# Install command line tool for app store
brew install mas

# Install XCode from app store.
mas install 497799835
# Install ColorSlurp from app store.
mas install 1287239339
# Install better snap tool from app store.
mas install 417375580
# Install Outlook from app store.
mas install 985367838
echo "Done."

read -p "Please start iterm2 and set the dracula color theme."
read -p "Please set iterm2 as default terminal."
