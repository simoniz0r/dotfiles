#!/bin/bash
# A script copies dotfiles and downloads them fron github
# Dependencies: 'git'
# Written by simonizor 5/27/2017 - http://www.simonizor.gq/scripts

DIR="$HOME/github/dotfiles"
dotfiles="
/home/simonizor/.zsh_aliases
/home/simonizor/.zshrc
/home/simonizor/.config/mc/ini
/home/simonizor/.config/mc/mc.keymap
/home/simonizor/.tmux.conf.local
/home/simonizor/packagelist.txt
"

dotrepo="https://github.com/simoniz0r/dotfiles.git"

symlink () {
    if [ -f "$2" ] || [ -d "$2" ]; then
        read -p "$2 exists; delete original? Y/N "
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            rm -rf "$2"
            echo "$2 removed!"
            ln -sr "$1" "$2" && echo "Symlink created to $2" || echo "Failed to create symlink for $2"
        else
            echo "$2 was not removed; skipping..."
        fi
    else
        ln -sr "$1" "$2" && echo "Symlink created to $2" || echo "Failed to create symlink for $2"
    fi
}

cpdotsmain () {
    case $1 in
        -g*|--g*)
            cd $DIR
            cd ..
            if [ ! -d "$DIR" ]; then
                git clone $dotrepo
            else
                git pull
            fi
            ;;
        -l*|--l*)
            echo "dotfiles:"
            echo "$dotfiles"
            ;;
        -h*|--h*)
            echo "cpdots usage:"
            echo "cpdots   : Copies dotfiles from their orignial locations to $DIR"
            echo "cpdots -h: Shows this help output"
            echo "cpdots -l: Lists managed dotfiles"
            echo "cpdots -s: Symlinks dotfiles from $DIR to their original locations"
            echo "cpdots -g: Downloads files from repos listed in dotrepos.conf to $DIR using git clone"
            ;;
        -s*|--s*)
            echo "Symlinking dotfiles from $DIR to their original locations..."
            symlink "$DIR/.zsh_aliases" "$HOME/.zsh_aliases"
            symlink "$DIR/.zshrc" "$HOME/.zshrc"
            symlink "$DIR/ini" "$HOME/.config/mc/ini"
            symlink "$DIR/mc.keymap" "$HOME/.config/mc/mc.keymap"
            symlink "$DIR/.tmux.conf.local" "$HOME/.tmux.conf.local"
            symlink "$DIR/packagelist.txt" "$HOME/packagelist.txt"
            ;;
        *)
            for file in $dotfiles; do
            echo "Copying $file..."
            cp $file $DIR/
            done
            ;;
    esac
}

BASEDIR="$(dirname "$DIR")"
if [ ! -d "$BASEDIR" ]; then
    mkdir $BASEDIR
    echo "$BASEDIR has been created."
fi
git --version >/dev/null 2>&1 || { echo "git is not installed; exiting..." ; exit 1 ; }
cpdotsmain "$@"