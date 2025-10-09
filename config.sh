#!/bin/bash
set -e

echo "[*] Updating system..."
sudo pacman -Syu --noconfirm

echo "[*] Installing official packages..."
sudo pacman -S --needed --noconfirm - < packages.txt

echo "[*] Checking for yay..."
if ! command -v yay &> /dev/null; then
    echo "[*] Installing yay..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

echo "[*] Installing AUR packages..."
yay -S --needed - < aur.txt

echo "[*] Setting up configuration files..."
mkdir -p ~/.config
ln -sf "$(pwd)/i3" ~/.config/i3
ln -sf "$(pwd)/kitty" ~/.config/kitty
ln -sf "$(pwd)/picom" ~/.config/picom

echo "[*] Setting up battery warning script..."
mkdir -p ~/.local/bin
ln -sf "$(pwd)/batteryL20.sh" ~/.local/bin/batteryL20.sh
chmod +x ~/.local/bin/batteryL20.sh

echo "[*] Enabling TLP power management service..."
sudo systemctl enable tlp.service
sudo systemctl start tlp.service

echo "[*] Setting up wallpaper..."
mkdir -p ~/Pictures
if [ ! -f ~/Pictures/wallpaper.jpg ]; then
    cp "$(pwd)/wallpaper.jpg" ~/Pictures/wallpaper.jpg
fi

echo "[*] Setting up X session..."
cat > ~/.xinitrc << 'EOF'
setxkbmap -model abnt2 -layout br -variant abnt2
exec i3
EOF
chmod +x ~/.xinitrc

echo "[*] Configuring Git user..."
git config --global user.name "mateusabrahao"
git config --global user.email "mateusabrahao290@gmail.com"

echo "[*] Configuration completed!"
