#!/bin/bash
# A simple lock screen using yad and wmctrl
# Just put the background image you'd like to use in $HOME/.yadlock.png and run the script!

function yadlockscreen() {
    unset PASSWORD
    (sleep 1 && wmctrl -F -a "yadlock" -b add,above) &
    PASSWORD="$(yad --entry --hide-text --title="yadlock" --undecorated --text="Enter password for $USER" --no-escape --borders=15 --button=gtk-ok:0 --center --width=300 --height=100)"
    yadpasscheck "$PASSWORD" "$1"
}

function yadpasscheck() {
    if ! echo -n "$1" | su -c true "$USER"; then
        (sleep 1 && wmctrl -F -a "errorwindow" -b add,above) &
        yad --center --title="errorwindow" --width=200 --height=100 --borders=10 --timeout=10 --text="Wrong password for $USER"
        yadlockscreen "$2"
    else
        kill -SIGTERM $2
        exit 0
    fi
}

(sleep 1 && wmctrl -F -a "fullscreenimage" -b add,above) &
yad --image="$HOME/.yadlock.png" --title="fullscreenimage" --no-focus --no-escape --undecorated --skip-taskbar --no-buttons --fullscreen & 
YADLOCK_PID=$!
sleep 2
yadlockscreen "$YADLOCK_PID"
