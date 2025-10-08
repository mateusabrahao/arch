#!/bin/bash
set -e

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing official packages..."
sudo pacman -S --needed - < packages.txt

echo "Checking..."
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

echo "Installing AUR packages..."
yay -S --needed - < aur.txt

echo "Setting up configuration files..."
mkdir -p ~/.config
cp -r i3 ~/.config/
cp -r kitty ~/.config/
cp -r picom ~/.config/

echo "Setting up battery warning script..."
mkdir -p ~/.local/bin
cp batteryL20.sh ~/.local/bin/
chmod +x ~/.local/bin/batteryL20.sh

echo "Enabling TLP power management service..."
sudo systemctl enable tlp.service
sudo systemctl start tlp.service

echo "Configuration completed!"
