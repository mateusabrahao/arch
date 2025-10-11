#!/bin/bash
set -e

echo "* updating system..."
sudo pacman -Syu --noconfirm

echo "* installing official packages..."
sudo pacman -S --needed --noconfirm - < packages.txt

echo "* checking for yay..."
if ! command -v yay &> /dev/null; then
    echo "* installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

echo "* installing AUR packages..."
yay -S --needed - < aur.txt

echo "* setting up configuration files..."
mkdir -p ~/.config
ln -sf "$(pwd)/i3" ~/.config/i3
ln -sf "$(pwd)/kitty" ~/.config/kitty
ln -sf "$(pwd)/picom" ~/.config/picom

echo "* setting up battery warning script..."
mkdir -p ~/.local/bin
ln -sf "$(pwd)/batteryL20.sh" ~/.local/bin/batteryL20.sh
chmod +x ~/.local/bin/batteryL20.sh

echo "* enabling TLP power management service..."
sudo systemctl enable tlp.service
sudo systemctl start tlp.service

echo "* setting up wallpaper..."
mkdir -p ~/Pictures
if [ ! -f ~/Pictures/wallpaper.jpg ]; then
    cp "$(pwd)/wallpaper.jpg" ~/Pictures/wallpaper.jpg
fi

echo "* setting up X session..."
echo "exec i3" > ~/.xinitrc
chmod +x ~/.xinitrc

echo "* configuration completed!"
