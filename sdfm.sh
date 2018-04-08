#!/bin/bash

function trywithoutsudo() {
    COMMAND="$@"
    $COMMAND 2> /dev/null || sudo $COMMAND || { echo "The following failed to execute:" "$COMMAND"; exit 1; }
}

function adddotfile() {
    [ -f "$DOTFILE_STORAGE_DIR/$1" ] || [ -d "$DOTFILE_STORAGE_DIR/$1" ] && echo "$DOTFILE_STORAGE_DIR/$1 already exists; exiting..." && exit 1
    [ ! -f "$2" ] && [ ! -d "$2" ] && echo "$2 not found; exiting..." && exit 1
    echo "Copying $2 to $DOTFILE_STORAGE_DIR/$1 and creating symlink..."
    cp -r "$2" "$DOTFILE_STORAGE_DIR"/$1 || { echo "Failed to copy $1; exiting..."; exit 1; }
    trywithoutsudo "rm -rf $2"
    trywithoutsudo "ln -s $DOTFILE_STORAGE_DIR/$1 $2"
    echo "name: $1" > "$DOTFILE_STORAGE_DIR"/stored/"$1".yml
    echo "location: $2" >> "$DOTFILE_STORAGE_DIR"/stored/"$1".yml
    echo "$1 has been added and symlink has been created"
    exit 0
}

function parsedotfileinfo() {
    if [ -f "$DOTFILE_STORAGE_DIR/stored/$1" ]; then
        DOTFILE_NAME="$(yq r $DOTFILE_STORAGE_DIR/stored/$1 name)"
        DOTFILE_LOCATION="$(yq r $DOTFILE_STORAGE_DIR/stored/$1 location)"
        case $DOTFILE_LOCATION in
            /home/*)
                DOTFILE_LOCATION="$HOME/$(echo $DOTFILE_LOCATION | cut -f4- -d'/')"
                ;;
        esac
    else
        echo "$1 not found!"
        exit 1
    fi
}

function symlinkdotfile() {
    if [ -f "$2" ] || [ -d "$2" ]; then
        echo "$2 exists!"
        read -p "Remove $2 and create symlink? Y/N " REMOVE_DOTFILE_ANSWER
        case $REMOVE_DOTFILE_ANSWER in
            Y|y)
                trywithoutsudo "rm -rf $2"
                SKIP_SYMLINK="FALSE"
                ;;
            *)
                echo "$2 was not removed; no symlink will be created"
                [ ! -f "/tmp/sdfmlist.tmp" ] && touch /tmp/sdfmlist.tmp
                SKIP_SYMLINK="TRUE"
                ;;
        esac
    fi
    if [ ! "$SKIP_SYMLINK" = "TRUE" ]; then
        echo "Creating symlink from $DOTFILE_STORAGE_DIR/$1 to $2 ..."
        [ ! -d "$(dirname $2)" ] && trywithoutsudo "mkdir -p $(dirname $2)"
        trywithoutsudo "ln -s $DOTFILE_STORAGE_DIR/$1 $2"
        echo "Symlink for $1 created"
        echo "$1" >> /tmp/sdfmlist.tmp
    fi
    unset SKIP_SYMLINK
}

function symlinkloop() {
    echo "Creating symlinks for all dotfiles in $DOTFILE_STORAGE_DIR ..."
    for dotfile in $(dir -a -C -w 1 "$DOTFILE_STORAGE_DIR"/stored | tail -n +3); do
        parsedotfileinfo "$dotfile"
        symlinkdotfile "$DOTFILE_NAME" "$DOTFILE_LOCATION"
    done
    echo "Created $(cat /tmp/sdfmlist.tmp | wc -l) symlinks"
    rm -f /tmp/sdfmlist.tmp
    exit 0
}

if [ -f "$HOME/.sdfm.yml" ]; then
    DOTFILE_STORAGE_DIR="$(yq r ~/.sdfm.yml storagedir)"
else
    read -p "Enter the directory to be used for storing dotfiles: " STORAGE_DIR_ANSWER
    echo
    DOTFILE_STORAGE_DIR="$(readlink -f $STORAGE_DIR_ANSWER)"
    echo "storagedir: $DOTFILE_STORAGE_DIR" > ~/.sdfm.yml
    [ ! -d "$DOTFILE_STORAGE_DIR/stored" ] && mkdir -p "$DOTFILE_STORAGE_DIR"/stored
fi

case $1 in
    -a|--add)
        [ -z "$3" ] && echo "Missing required input; exiting..." && exit 1
        adddotfile "$2" "$(readlink -f $3)"
        ;;
    -s|--symlink)
        if [ -z "$2" ]; then
            read -p "Create symlinks for all files in $DOTFILE_STORAGE_DIR ? Y/N " SYMLINK_LOOP_ANSWER
            case $SYMLINK_LOOP_ANSWER in
                Y*|y*)
                    symlinkloop
                    ;;
                *)
                    echo "No symlinks created; exiting..."
                    exit 0
                    ;;
            esac
        else
            parsedotfileinfo "$2.yml"
            symlinkdotfile "$DOTFILE_NAME" "$DOTFILE_LOCATION"
            rm -f /tmp/sdfmlist.tmp
            exit 0
        fi
        ;;
esac
