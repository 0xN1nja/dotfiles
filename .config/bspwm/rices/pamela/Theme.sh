#!/usr/bin/env bash
#  ██████╗  █████╗ ███╗   ███╗███████╗██╗      █████╗     ██████╗ ██╗ ██████╗███████╗
#  ██╔══██╗██╔══██╗████╗ ████║██╔════╝██║     ██╔══██╗    ██╔══██╗██║██╔════╝██╔════╝
#  ██████╔╝███████║██╔████╔██║█████╗  ██║     ███████║    ██████╔╝██║██║     █████╗
#  ██╔═══╝ ██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══██║    ██╔══██╗██║██║     ██╔══╝
#  ██║     ██║  ██║██║ ╚═╝ ██║███████╗███████╗██║  ██║    ██║  ██║██║╚██████╗███████╗
#  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝    ╚═╝  ╚═╝╚═╝ ╚═════╝╚══════╝
#  Author  :  z0mbi3
#  Url     :  https://github.com/gh0stzk/dotfiles
#  About   :  This file will configure and launch the rice.
#

# Set bspwm configuration for Pamela
set_bspwm_config() {
	bspc config border_width 0
	bspc config top_padding 59
	bspc config bottom_padding 2
	bspc config normal_border_color "#C574DD"
	bspc config active_border_color "#C574DD"
	bspc config focused_border_color "#8897F4"
	bspc config presel_feedback_color "#FF4971"
	bspc config left_padding 2
	bspc config right_padding 2
	bspc config window_gap 6
}

# Reload terminal colors
set_term_config() {
	cat >"$HOME"/.config/alacritty/rice-colors.toml <<EOF
# Color scheme for Pamela Rice

# Default colors
[colors.primary]
background = "#1D1F28"
foreground = "#FDFDFD"

# Cursor colors
[colors.cursor]
cursor = "#FF4971"
text = "#1D1F28"

# Normal colors
[colors.normal]
black = "#3D4C5F"
blue = "#8897F4"
cyan = "#79E6F3"
green = "#5ADECD"
magenta = "#C574DD"
red = "#F37F97"
white = "#FDFDFD"
yellow = "#F2A272"

# Bright colors
[colors.bright]
black = "#56687E"
blue = "#556FFF"
cyan = "#3FDCEE"
green = "#18E3C8"
magenta = "#B043D1"
red = "#FF4971"
white = "#BEBEC1"
yellow = "#FF8037"
EOF
}

# Set Rofi launcher config
set_launcher_config() {
	sed -i "$HOME/.config/bspwm/scripts/Launcher.rasi" \
		-e '22s/\(font: \).*/\1"Terminess Nerd Font Mono Bold 10";/' \
		-e 's/\(background: \).*/\1#1D1F28;/' \
		-e 's/\(background-alt: \).*/\1#1D1F28E0;/' \
		-e 's/\(foreground: \).*/\1#c0caf5;/' \
		-e 's/\(selected: \).*/\1#6C77BB;/' \
		-e 's/[^/]*-rofi/pa-rofi/'
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
		-e "s/transparency = .*/transparency = 9/g" \
		-e "s/frame_color = .*/frame_color = \"#1D1F28\"/g" \
		-e "s/separator_color = .*/separator_color = \"#8897F4\"/g" \
		-e "s/font = .*/font = JetBrainsMono NF Medium 9/g" \
		-e "s/foreground='.*'/foreground='#79E6F3'/g"

	sed -i '/urgency_low/Q' "$HOME"/.config/bspwm/dunstrc
	cat >>"$HOME"/.config/bspwm/dunstrc <<-_EOF_
		[urgency_low]
		timeout = 3
		background = "#1D1F28"
		foreground = "#FDFDFD"

		[urgency_normal]
		timeout = 6
		background = "#1D1F28"
		foreground = "#FDFDFD"

		[urgency_critical]
		timeout = 0
		background = "#1D1F28"
		foreground = "#FDFDFD"
	_EOF_
}

# Launch the bar
launch_bars() {
	eww -c ${rice_dir}/widgets daemon &
	polybar -q pam1 -c ${rice_dir}/config.ini &
	polybar -q pam2 -c ${rice_dir}/config.ini &
	polybar -q pam3 -c ${rice_dir}/config.ini &
	polybar -q pam4 -c ${rice_dir}/config.ini &
	polybar -q pam5 -c ${rice_dir}/config.ini &
	polybar -q pam6 -c ${rice_dir}/config.ini &
}

### ---------- Apply Configurations ---------- ###

set_bspwm_config
set_term_config
set_launcher_config
set_picom_config
set_dunst_config
launch_bars
