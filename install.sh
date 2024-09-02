#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
  echo "This script should not be run as root"
  exit 1
fi

echo "This script will install necessary dependencies, create backup of ~/.config in ~/.config_backup-* and install the dotfiles."
while true; do
  read -rp "Proceed with the installation? [y/N]: " yn
  case $yn in
  [Yy]) break ;;
  [Nn])
    echo "Installation aborted. No changes made"
    exit
    ;;
  *)
    echo "Invalid option. Please try again"
    ;;
  esac
done
clear

dependencies=(alacritty base-devel bat brightnessctl bspwm dunst eza feh firefox geany git gvfs-mtp imagemagick jq
  jgmenu kitty libwebp lightdm lightdm-gtk-greeter lsd maim mpc mpd ncmpcpp neovim npm nm-connection-editor pamixer
  pacman-contrib papirus-icon-theme physlock picom playerctl polybar polkit-gnome python-gobject ranger redshift rofi
  rustup sxhkd thunar tmux tumbler ttf-dejavu ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-joypixels
  ttf-liberation ttf-opensans ttf-terminus-nerd ttf-indic-otf ueberzug webp-pixbuf-loader xclip xdg-user-dirs xdo xdotool
  xorg-server xorg-xdpyinfo xorg-xinit xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot xorg-xwininfo zsh zsh-autosuggestions
  zsh-history-substring-search zsh-syntax-highlighting)

# Install dependencies
echo "Installing dependencies"
sleep 2
sudo pacman -S --needed "${dependencies[@]}" --noconfirm
clear

# Update user dirs
echo "Updating user dirs"
sleep 2
xdg-user-dirs-update
clear

# Backup existing ~/.config directory
echo "Backing up ~/.config to ~/.config_backup-*"
sleep 2
if [ -d ~/.config ]; then
  backup_folder=~/.config_backup-$(date +%Y-%m-%d_%H-%M-%S)
  mkdir -p $backup_folder
  for dir in alacritty bspwm kitty mpd ncmpcpp ranger tmux zsh; do
    if [ -d ~/.config/$dir ]; then
      mv ~/.config/$dir $backup_folder
      echo "Backup of ~/.config/$dir created"
    else
      echo "Could not find ~/.config/$dir, skipping backup"
    fi
    sleep 1
  done
else
  echo "Could not find ~/.config directory, skipping backup"
  sleep 2
fi
sleep 2
clear

# Copy .config/* to ~/.config
echo "Copying .config/* to ~/.config"
sleep 2
[ ! -d ~/.config ] && mkdir -p ~/.config
for dir in alacritty bspwm kitty mpd ncmpcpp ranger tmux zsh; do
  if cp -R .config/$dir ~/.config; then
    echo ".config/$dir copied to ~/.config/$dir"
  else
    echo "Failed to copy .config/$dir to ~/.config/$dir"
  fi
  sleep 1
done
sleep 2
clear

# Copy .local/* to ~/.local
echo "Copying .local/* to ~/.local"
sleep 2
[ ! -d ~/.local ] && mkdir -p ~/.local
for dir in bin share; do
  if cp -R .local/$dir ~/.local; then
    echo ".local/$dir copied to ~/.local/$dir"
  else
    echo "Failed to copy .local/$dir to ~/.local/$dir"
  fi
  sleep 1
done
sleep 2
clear

# Update font cache
echo "Updating font cache"
sleep 2
fc-cache -rfv
clear

# Install paru
echo "Installing paru"
sleep 2
if ! command -v paru >/dev/null 2>&1; then
  if [ ! -d "paru-bin" ]; then
    git clone --depth 1 https://aur.archlinux.org/paru-bin.git
  else
    echo "paru-bin directory already exists. Skipping clone"
  fi
  cd paru-bin
  makepkg -si --noconfirm
  cd -
else
  echo "paru is already installed"
  sleep 2
fi
clear

# Install other dependencies
echo "Installing other dependencies"
sleep 2
paru -S --needed tdrop-git xqp rofi-greenclip ttf-maple simple-mtpfs --skipreview --noconfirm
clear

# Install eww
echo "Installing eww"
sleep 2
if ! command -v eww >/dev/null 2>&1; then
  if [ ! -d "eww" ]; then
    git clone --depth 1 https://github.com/elkowar/eww.git
  else
    echo "eww directory already exists. Skipping clone"
  fi
  cd eww
  sudo pacman -S libdbusmenu-gtk3 --noconfirm
  cargo build --release --no-default-features --features x11
  sudo install -m 755 "target/release/eww" -t /usr/local/bin
  cd -
else
  echo "eww is already installed"
  sleep 2
fi
clear

# Enable mpd
echo "Enabling mpd"
sleep 2
if ! systemctl --user is-enabled mpd.service | grep -q "enabled"; then
  systemctl --user enable mpd.service
  systemctl --user start mpd.service
else
  echo "mpd is already enabled"
fi
sleep 2

# Enable lightdm
echo "Enabling lightdm"
sleep 2
if ! systemctl is-enabled lightdm | grep -q "enabled"; then
  sudo systemctl enable lightdm
else
  echo "lightdm is already enabled"
fi
sleep 2

clear

# Set default shell to zsh
echo "Setting default shell to zsh"
sleep 2
cp .zshrc ~/
if [[ $SHELL != "/usr/bin/zsh" ]]; then
  chsh -s /usr/bin/zsh
else
  echo "Default shell is already zsh"
  sleep 2
fi
clear

# Clean up
echo "Cleaning up"
sleep 2
rm -rf paru-bin eww
cd $HOME
rm -rf .cargo .rustup

echo "Installation completed. You may now reboot"
