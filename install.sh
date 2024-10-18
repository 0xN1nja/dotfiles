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

# Install dependencies
echo "Installing dependencies"
sleep 2

dependencies=(alacritty base-devel bat brightnessctl bspwm dunst eza feh firefox geany git gvfs-mtp imagemagick jq
    jgmenu kitty libwebp lightdm lightdm-gtk-greeter lsd maim mpc mpd ncmpcpp neovim npm nm-connection-editor pamixer
    pacman-contrib papirus-icon-theme physlock picom playerctl polybar polkit-gnome python-gobject ranger redshift rofi
    rustup sxhkd thunar tmux tumbler ttf-dejavu ttf-inconsolata ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-joypixels
    ttf-liberation ttf-opensans ttf-terminus-nerd ttf-indic-otf ueberzug webp-pixbuf-loader xclip xdg-user-dirs xdo xdotool
    xsettingsd xorg-server xorg-xdpyinfo xorg-xinit xorg-xkill xorg-xprop xorg-xrandr xorg-xsetroot xorg-xwininfo zsh
    zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting)

sudo pacman -S --needed "${dependencies[@]}" --noconfirm
clear

# Add gh0stzk's custom repository to /etc/pacman.conf
echo "Adding gh0stzk's custom repository to /etc/pacman.conf"

REPO_CONTENT="[gh0stzk-dotfiles]
SigLevel = Optional TrustAll
Server = http://gh0stzk.github.io/pkgs/x86_64"

if ! grep -q "\[gh0stzk-dotfiles\]" /etc/pacman.conf; then
    if echo -e "\n$REPO_CONTENT" | sudo tee -a /etc/pacman.conf > /dev/null; then
        echo "Custom repository added"
        sudo pacman -Syy
        sleep 1
    else
        echo "Failed to add custom repository"
        sleep 1
    fi
else
    echo "Custom repository already exists in /etc/pacman.conf"
    sleep 1
fi
sleep 2
clear

# Install custom dependencies
echo "Installing custom dependencies"
sleep 2

custom_dependencies=(gh0stzk-gtk-themes gh0stzk-cursor-qogirr
    gh0stzk-icons-beautyline gh0stzk-icons-candy gh0stzk-icons-catppuccin-mocha gh0stzk-icons-dracula gh0stzk-icons-glassy
    gh0stzk-icons-gruvbox-plus-dark gh0stzk-icons-hack gh0stzk-icons-luv gh0stzk-icons-sweet-rainbow gh0stzk-icons-tokyo-night
    gh0stzk-icons-vimix-white gh0stzk-icons-zafiro gh0stzk-icons-zafiro-purple)

sudo pacman -S --needed "${custom_dependencies[@]}" --noconfirm
clear

# Update user dirs
echo "Updating user dirs"
sleep 2
if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
    xdg-user-dirs-update
fi
clear

# Backup existing config
echo "Backing up existing config to ~/.dotfiles_backup-*"
sleep 2
if [ -d ~/.config ]; then
    backup_folder=~/.dotfiles_backup-$(date +%Y-%m-%d_%H-%M-%S)
    mkdir -p $backup_folder
    mkdir -p $backup_folder/.config
    mkdir -p $backup_folder/home

    # Backup ~/.config/*
    for dir in alacritty bspwm geany gtk-3.0 kitty mpd ncmpcpp ranger tmux zsh; do
        if [ -d ~/.config/$dir ]; then
            mv ~/.config/$dir $backup_folder/.config
            echo "Backup of ~/.config/$dir created"
        else
            echo "Could not find ~/.config/$dir, skipping backup"
        fi
        sleep 1
    done

    # Backup ~/.icons, ~/.gtkrc-2.0 and ~/.zshrc
    for dir in .icons .gtkrc-2.0 .zshrc; do
        if [ -e ~/$dir ]; then
            mv ~/$dir $backup_folder/home
            echo "Backup of ~/$dir created"
        else
            echo "Could not find ~/$dir, skipping backup"
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
for dir in alacritty bspwm geany gtk-3.0 kitty mpd ncmpcpp ranger tmux zsh; do
    if cp -R .config/$dir ~/.config; then
        echo ".config/$dir copied to ~/.config/$dir"
    else
        echo "Failed to copy .config/$dir to ~/.config"
    fi
    sleep 1
done
sleep 2
clear

# Copy home/* to ~/
echo "Copying home/* to ~/"
sleep 2
for dir in .icons .gtkrc-2.0 .zshrc; do
    if cp -R home/$dir ~/; then
        echo "home/$dir copied to ~/"
    else
        echo "Failed to copy home/$dir to ~/"
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
if ! command -v paru > /dev/null 2>&1; then
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
if ! command -v eww > /dev/null 2>&1; then
    sudo pacman -S libdbusmenu-gtk3 --noconfirm
    paru -S eww-git --skipreview --noconfirm
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
