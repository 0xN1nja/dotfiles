#!/usr/bin/env bash
#  ██╗███████╗ █████╗ ██████╗ ███████╗██╗         ██████╗ ██╗ ██████╗███████╗
#  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██║         ██╔══██╗██║██╔════╝██╔════╝
#  ██║███████╗███████║██████╔╝█████╗  ██║         ██████╔╝██║██║     █████╗
#  ██║╚════██║██╔══██║██╔══██╗██╔══╝  ██║         ██╔══██╗██║██║     ██╔══╝
#  ██║███████║██║  ██║██████╔╝███████╗███████╗    ██║  ██║██║╚██████╗███████╗
#  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝    ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝
#  Author  :  z0mbi3
#  Url     :  https://github.com/gh0stzk/dotfiles
#  About   :  This file will configure and launch the rice.
#

# Set bspwm configuration for Isabel
set_bspwm_config() {
	bspc config border_width 0
	bspc config top_padding 2
	bspc config bottom_padding 42
	bspc config normal_border_color "#b8bfe5"
	bspc config active_border_color "#b8bfe5"
	bspc config focused_border_color "#7560d3"
	bspc config presel_feedback_color "#81ae5f"
	bspc config left_padding 2
	bspc config right_padding 2
	bspc config window_gap 6
}

# Reload terminal colors
set_term_config() {
	cat >"$HOME"/.config/alacritty/rice-colors.toml <<EOF
# (Onedark) Color scheme for Isabel Rice

# Default colors
[colors.primary]
background = "#14171c"
foreground = "#b8bfe5"

# Cursor colors
[colors.cursor]
cursor = "#abb2bf"
text = "#14171c"

# Normal colors
[colors.normal]
black = "#5c6370"
blue = "#4889be"
cyan = "#49919a"
green = "#81ae5f"
magenta = "#7560d3"
red = "#be5046"
white = "#c5cddb"
yellow = "#d19a66"

# Bright colors
[colors.bright]
black = "#5c6370"
blue = "#61afef"
cyan = "#56b6c2"
green = "#98c379"
magenta = "#8677cf"
red = "#e06c75"
white = "#abb2bf"
yellow = "#e5c07b"
EOF
}

# Set Rofi launcher config
set_launcher_config() {
	sed -i "$HOME/.config/bspwm/scripts/Launcher.rasi" \
		-e '22s/\(font: \).*/\1"Terminess Nerd Font Mono Bold 10";/' \
		-e 's/\(background: \).*/\1#14171c;/' \
		-e 's/\(background-alt: \).*/\1#14171cE0;/' \
		-e 's/\(foreground: \).*/\1#b8bfe5;/' \
		-e 's/\(selected: \).*/\1#7560d3;/' \
		-e 's/[^/]*-rofi/is-rofi/'
}

# Set compositor configuration
set_picom_config() {
	sed -i "$HOME"/.config/bspwm/picom.conf \
		-e "s/normal = .*/normal =  { fade = true; shadow = true; }/g" \
		-e "s/shadow-color = .*/shadow-color = \"#000000\"/g" \
		-e "s/corner-radius = .*/corner-radius = 6/g" \
		-e "s/\".*:class_g = 'Alacritty'\"/\"100:class_g = 'Alacritty'\"/g" \
		-e "s/\".*:class_g = 'FloaTerm'\"/\"100:class_g = 'FloaTerm'\"/g" \
		-e "s/shadow-offset-x = .*/shadow-offset-x = -23;/g" \
		-e "s/shadow-offset-y = .*/shadow-offset-y = -22;/g"
}

# Set dunst notification daemon config
set_dunst_config() {
	sed -i "$HOME"/.config/bspwm/dunstrc \
		-e "s/transparency = .*/transparency = 0/g" \
		-e "s/frame_color = .*/frame_color = \"#14171c\"/g" \
		-e "s/separator_color = .*/separator_color = \"#abb2bf\"/g" \
		-e "s/font = .*/font = JetBrainsMono NF Medium 9/g" \
		-e "s/foreground='.*'/foreground='#7560d3'/g"

	sed -i '/urgency_low/Q' "$HOME"/.config/bspwm/dunstrc
	cat >>"$HOME"/.config/bspwm/dunstrc <<-_EOF_
		[urgency_low]
		timeout = 3
		background = "#14171c"
		foreground = "#b8bfe5"

		[urgency_normal]
		timeout = 6
		background = "#14171c"
		foreground = "#b8bfe5"

		[urgency_critical]
		timeout = 0
		background = "#14171c"
		foreground = "#b8bfe5"
	_EOF_
}

# Launch the bar
launch_bars() {
	polybar -q isa-bar -c ${rice_dir}/config.ini &
}

### ---------- Apply Configurations ---------- ###

set_bspwm_config
set_term_config
set_launcher_config
set_picom_config
set_dunst_config
launch_bars
