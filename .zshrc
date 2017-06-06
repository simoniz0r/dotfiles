# Set up the prompt

setopt PROMPT_SUBST

print_dir () {
  case $PWD in
  (/home/$USER/github*)
    echo " ${PWD:22}" # 22 = length of /home/$USER/github; adjust to your needs
    ;;
  (/home/$USER/.config*)
    echo "⚒ ${PWD:23}" # 23 = length of /home/$USER/.config; adjust to your needs
    ;;
  (/home/$USER/Documents*)
    echo "䷁ ${PWD:25}" # 25 = length of /home/$USER/Documents; adjust to your needs
    ;;
  (/home/$USER/Downloads*)
    echo "⛛ ${PWD:25}" # 25 = length of /home/$USER/Downloads; adjust to your needs
    ;;
  (/home/$USER/Pictures*)
    echo "💟 ${PWD:24}" # 24 = length of /home/$USER/Pictures; adjust to your needs
    ;;
  (/home/$USER*)
    echo "⾕${PWD:15}" # 15 = length of /home/$USER; adjust to your needs
    ;;
  (/)
    echo "💻 ${PWD:1}"
    ;;
  (*)
    echo "💻 $PWD"
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
}

EXSTATUS () {
    case $? in
        1)
            echo "%B%F$(FCLR)%S%K{black} Exit 1 %k%s%b"
            ;;
        2)
            echo "%B%F$(FCLR)%S%K{black} Exit 2 %k%s%b"
            ;;
        126)
            echo "%B%F$(FCLR)%S%K{black} Exit 126 %k%s%b"
            ;;
        127)
            echo "%B%F$(FCLR)%S%K{black} Exit 127 %k%s%b"
            ;;
        128*)
            echo "%B%F$(FCLR)%S%K{black} Exit 128 %k%s%b"
            ;;
        130)
            echo "%B%F$(FCLR)%S%K{black} Exit 130 %k%s%b"
            ;;
        165)
            echo "%B%F$(FCLR)%S%K{black} Exit 165 %k%s%b"
            ;;
        255)
            echo "%B%F$(FCLR)%S%K{black} Exit 255 %k%s%b"
            ;;
        0)
            echo ""
            ;;
        *)
            echo "%B%F$(FCLR)%S%K{black} Exit Unknown %k%s%b"
            ;;
    esac
}

PS1='%K{black}%F$(FCLR)%B %n@%m %S$(print_dir)%s%k%f%b '
# Without username and host: PS1='%F$(FCLR)%K{black}%S$(print_dir)%s%k%f '
RPS1='$(EXSTATUS)'


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
