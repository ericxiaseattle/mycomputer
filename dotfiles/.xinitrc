#!/bin/sh

# Define resource and modmap files
userresources="$HOME/.Xresources"
usermodmap="$HOME/.Xmodmap"
sysresources="/etc/X11/xinit/.Xresources"
sysmodmap="/etc/X11/xinit/.Xmodmap"

# Function to merge resources and apply modmaps
merge_resources() {
    [ -f "$1" ] && xrdb -merge "$1"
    [ -f "$2" ] && xmodmap "$2"
}

# Merge system and user resources
merge_resources "$sysresources" "$sysmodmap"
merge_resources "$userresources" "$usermodmap"

$ Source global Xinit scripts if available
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        [ -x "$f" ] && . "$f"
    done
fi

# fcitx for non-english language support
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx

# Compositor
picom &
# Startup with 60% screen brightness
xrandr --output eDP --brightness 0.6 &
# Background wallpaper
nitrogen --set-zoom-fill ~/pictures/wallpapers/2.jpg &
# Sound
gentoo-pipewire-launcher &
# Fix webcam bad res
v4l2-ctl -d /dev/video0 -vwidth=2592,height=1944,pixelformat=MJPG &
# Start fcitx input tool
fcitx &
# Moving polybar start to autostart with qtile conf instead
# Since polybar starts with xwindow module not loaded placed here
# polybar &
# Start qtile
exec dbus-launch --exit-with-session qtile start
