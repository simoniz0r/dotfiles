# Set up the prompt

setopt PROMPT_SUBST

print_dir () {
    if [[ "$HOST" != "OptiPlex" ]]; then
        echo "ssh %~ "
    else
        case $PWD in
            # $HOME/*)
                # echo "⾕${PWD:${#HOME}} "
            #     echo "⛺${PWD:${#HOME}} "
            #     ;;
            $HOME*)
                # echo  "⾕${PWD:${#HOME}}"
                # echo  "⛺${PWD:${#HOME}}"
                echo " %~ "
                ;;
            /)
                echo " ⚠${PWD:1} "
                ;;
            *)
                echo " ⚠ $PWD "
                ;;
        esac
    fi
}

FCLR () {
    case $PWD in
        $HOME/github*)
            echo "{cyan}"
            ;;
        $HOME/.config*)
            echo "{yellow}"
            ;;
        $HOME/Documents*)
            echo "{green}"
            ;;
        $HOME/Downloads*)
            echo "{white}"
            ;;
        $HOME/Pictures*)
            echo "{magenta}"
            ;;
        $HOME*)
            echo "{blue}"
            ;;
        *)
            echo "{red}"
            ;;
    esac
}

EXSTATUS () {
    EXIT="$?"
    case $EXIT in
        0)
            echo ""
            ;;
        *)
            echo "%F$(FCLR)%S%K{black}✘ "$EXIT "%s%k%f"
            ;;
    esac
}

GITSTATUS () {
    GITBRANCH="$(git status >/dev/null 2>&1 | grep 'On branch' | sed -e 's/On branch/ /g' || echo)"
    GITCOMMIT="$(git status >/dev/null 2>&1 | head -n 3 | grep 'commit:\|commit,\|commit.' || echo)"
    case $GITCOMMIT in
        Changes*)
            GITCHANGES=" $(git status >/dev/null 2>&1 | grep '	' | wc -l)"
            ;;
        *ahead*)
            GITCHANGES="$(git status >/dev/null 2>&1 | grep 'Your branch is ahead' | tr -d "'[:alpha:].[:space:]" | tr '/' '+')"
            ;;
        *behind*)
            GITCHANGES="$(git status >/dev/null 2>&1 | grep 'Your branch is behind' | tr -d '[:alpha:]' | tr -d "'.[:space:]" | tr '/' '-' )"
            ;;
        nothing*)
            GITCHANGES="$(echo "✔ ")"
            ;;
    esac
    if [ ! -z "$GITBRANCH" ]; then
        echo "%F$(FCLR)%S%K{black} $GITBRANCH $GITCHANGES %s%k%f"
    else
        echo ""
    fi
}

PS1='$(EXSTATUS)%K{black}%F$(FCLR) %n@%m %S$(print_dir)%s%k%f '
RPS1='$(GITSTATUS)'

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Adds check for zsh aliases file for separate loading of aliases like bash
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# Set zsh as SHELL
# export SHELL=/bin/zsh

# Change/remove these to match your settings
export TERM=xterm-256color
export EDITOR=/usr/bin/mcedit
export MPD_HOST=10.42.0.4

if [ -f ~/.smapt_aliases ]; then
    . ~/.smapt_aliases
fi

if [ -f ~/.discord-install_alias ]; then
    . ~/.discord-install_alias
fi

if [ -f ~/.config/spm/spm.comp ]; then
    source ~/.config/spm/spm.comp
    compdef _spm spm
fi

