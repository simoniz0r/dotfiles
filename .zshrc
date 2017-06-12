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
    echo "{cyan}"
    ;;
  (/home/$USER/.config*)
    echo "{yellow}"
    ;;
  (/home/$USER/Documents*)
    echo "{blue}"
    ;;
  (/home/$USER/Downloads*)
    echo "{white}"
    ;;
  (/home/$USER/Pictures*)
    echo "{magenta}"
    ;;
  (/home/$USER*)
    echo "{green}"
    ;;
  (*)
    echo "{red}"
    ;;
  esac
  case $HOST in
  (toolbuntu)
    echo "{red}"
    ;;
  esac
}

EXSTATUS () {
    case $? in
        1)
            echo "%B%F$(FCLR)%S%K{black}✘ 1 %s%k%b%f"
            ;;
        2)
            echo "%B%F$(FCLR)%S%K{black}✘ 2 %s%k%b%f"
            ;;
        126)
            echo "%B%F$(FCLR)%S%K{black}✘ 126 %s%k%b%f"
            ;;
        127)
            echo "%B%F$(FCLR)%S%K{black}✘ 127 %s%k%b%f"
            ;;
        128*)
            echo "%B%F$(FCLR)%S%K{black}✘ 128 %s%k%b%f"
            ;;
        130)
            echo "%B%F$(FCLR)%S%K{black}✘ 130 %s%k%b%f"
            ;;
        165)
            echo "%B%F$(FCLR)%S%K{black}✘ 165 %s%k%b%f"
            ;;
        255)
            echo "%B%F$(FCLR)%S%K{black}✘ 255 %s%k%b%f"
            ;;
        0)
            GITSTATUS="$(git status >/dev/null 2>&1 | grep 'On branch' | sed -e 's/On branch//g' || echo)"
            if [ ! -z "$GITSTATUS" ]; then
                echo "%B%F$(FCLR)%S%K{black}$GITSTATUS%s%k%b%f"
            else
                echo ""
            fi
            ;;
        *)
            echo "%B%F$(FCLR)%S%K{black}✘ Unknown %s%k%b%f"
            ;;
    esac
}

PS1='$(EXSTATUS)%K{black}%F$(FCLR)%B %n@%m %S$(print_dir)%s%k%b%f '
# Without username and host: PS1='%F$(FCLR)%K{black}%S$(print_dir)%s%k%b%f '
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
export EDITOR=/usr/bin/mcedit
/usr/bin/numlockx on

if [ -f ~/.smapt_aliases ]; then
    . ~/.smapt_aliases
fi

if [ -f ~/.discord-install_alias ]; then
    . ~/.discord-install_alias
fi
