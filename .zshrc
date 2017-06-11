# Set up the prompt

setopt PROMPT_SUBST

print_dir () {
  case $PWD in
  (/home/$USER/*)
    echo "⾕${PWD:15} " # 15 = length of /home/$USER; adjust to your needs
    ;;
  (/home/$USER*)
    echo "⾕${PWD:15}" # 15 = length of /home/$USER; adjust to your needs
    ;;
  (/)
    echo "💻 ${PWD:1}"
    ;;
  (*)
    echo "💻 $PWD "
    ;;
  esac
}

FCLR () {
  case $PWD in
  (/home/$USER/github*)
    echo "$(tput setaf 45)"
    ;;
  (/home/$USER/.config*)
    echo "$(tput setaf 11)"
    ;;
  (/home/$USER/Documents*)
    echo "$(tput setaf 24)"
    ;;
  (/home/$USER/Downloads*)
    echo "$(tput setaf 29)"
    ;;
  (/home/$USER/Pictures*)
    echo "$(tput setaf 110)"
    ;;
  (/home/$USER*)
    echo "$(tput setaf 10)"
    ;;
  (*)
    echo "$(tput setaf 1)"
    ;;
  esac
  case $HOST in
  (toolbuntu)
    echo "$(tput setaf 100)"
    ;;
  esac
}

EXSTATUS () {
    case $? in
        1)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 1 %s%k"
            ;;
        2)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 2 %s%k"
            ;;
        126)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 126 %s%k"
            ;;
        127)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 127 %s%k"
            ;;
        128*)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 128 %s%k"
            ;;
        130)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 130 %s%k"
            ;;
        165)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 165 %s%k"
            ;;
        255)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ 255 %s%k"
            ;;
        0)
            GITSTATUS="$(git status >/dev/null 2>&1 | grep 'On branch' | sed -e 's/On branch//g' || echo)"
            if [ ! -z "$GITSTATUS" ]; then
                echo "$(tput bold)$(FCLR)%S%K{black}$GITSTATUS%s%k"
            else
                echo ""
            fi
            ;;
        *)
            echo "$(tput bold)$(FCLR)%S%K{black} ✘ Unknown %s%k"
            ;;
    esac
}

PS1='$(EXSTATUS)%K{black}$(FCLR)$(tput bold) %n@%m %S$(print_dir)%s%k$(tput sgr0) '
# Without username and host: PS1='$(FCLR)%K{black}%S$(print_dir)%s%k$(tput sgr0) '
RPS1=''


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
export EDITOR=/usr/bin/code
/usr/bin/numlockx on

if [ -f ~/.smapt_aliases ]; then
    . ~/.smapt_aliases
fi

if [ -f ~/.discord-install_alias ]; then
    . ~/.discord-install_alias
fi
