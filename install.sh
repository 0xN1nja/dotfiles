#!/usr/bin/env bash

set -e

if [ "$(id -u)" -eq 0 ]; then
	echo "This script should not be run as root"
	exit 1
fi

while true; do
	read -rp $'This script will install necessary dependencies, create backup of ~/.config in ~/.config_backup-* and install the dotfiles.\nProceed with the installation? [y/N]: ' yn
	case $yn in
	[Yy]*) break ;;
	[Nn]*)
		echo "Installation aborted"
		exit
		;;
	*)
		echo "Invalid option"
		;;
	esac
done
clear

dependencies=(
	base-devel pacman-contrib rustup xorg-server bspwm lightdm lightdm-gtk-greeter
	alacritty sxhkd polybar dunst rofi brightnessctl lsd
	jq polkit-gnome git playerctl mpd xclip
	neovim geany thunar ranger mpc ncmpcpp picom
	feh ueberzug maim pamixer libwebp libnotify
	pulseaudio pavucontrol alsa-utils
	xorg-xinit xorg-xkill xorg-xprop xdg-user-dirs xdotool
	tumbler webp-pixbuf-loader physlock papirus-icon-theme
	ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd ttf-inconsolata ttf-joypixels ttf-dejavu ttf-liberation ttf-opensans ttf-indic-otf
	zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting xorg-xsetroot xorg-xwininfo xorg-xrandr
)

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
	for dir in alacritty bspwm mpd ncmpcpp nvim ranger zsh; do
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
for dir in alacritty bspwm mpd ncmpcpp nvim ranger zsh; do
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
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	makepkg -si --noconfirm
	cd -
else
	echo "paru is already installed"
	sleep 2
fi
clear

# Install tdrop
echo "Installing tdrop"
sleep 2
if ! command -v tdrop >/dev/null 2>&1; then
	paru -S tdrop-git --skipreview --noconfirm
else
	echo "tdrop is already installed"
	sleep 2
fi
clear

# Install eww
echo "Installing eww"
sleep 2
if ! command -v eww >/dev/null 2>&1; then
	if [ ! -d "eww" ]; then
		git clone --depth 1 https://github.com/elkowar/eww.git
	fi
	cd eww
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
if ! systemctl --user is-enabled mpd.service | grep -q 'enabled'; then
	systemctl --user enable mpd.service
	systemctl --user start mpd.service
else
	echo "mpd is already enabled"
fi
sleep 2

# Enable lightdm
echo "Enabling lightdm"
sleep 2
if ! systemctl is-enabled lightdm | grep -q 'enabled'; then
	sudo systemctl enable lightdm
else
	echo "lightdm is already enabled"
fi
sleep 2

clear

# Set default shell to zsh
echo "Setting default shell to zsh"
sleep 2
if [[ $SHELL != "/usr/bin/zsh" ]]; then
	chsh -s /usr/bin/zsh
	echo 'ZDOTDIR=~/.config/zsh' >~/.zshenv
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

echo "Installation complete!"
