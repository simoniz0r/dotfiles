# Set up the prompt

setopt PROMPT_SUBST

print_dir () {
  case $PWD in
  (/home/$USER/github*)
    echo " /${PWD:23} " # 23 = length of /home/$USER/github/; adjust to your needs
    ;;
  (/home/$USER/.config*)
    echo "✎ /${PWD:24} " # 24 = length of /home/$USER/.config/; adjust to your needs
    ;;
  (/home/$USER*)
    echo "⾕/${PWD:16} " # 16 = length of /home/$USER/; adjust to your needs
    ;;
  (*)
    echo "💻 $PWD "
    ;;
  esac
}

FCLR () {
  case $PWD in
  (/home/$USER/github*)
    echo "%F{green}"
    ;;
  (/home/$USER/.config*)
    echo "%F{magenta}"
    ;;
  (/home/$USER*)
    echo "%F{blue}"
    ;;
  (*)
    echo "%F{yellow}"
    ;;
  esac
}

# with username and host on left: PROMPT='%K{black}%S%U%B$(FCLR)%n%u@%U%m%u:$(FCLR)$(print_dir)%s%k%f%b '
PS1='%K{black}%S%B$(FCLR)$(print_dir)%s%k%f%b '
# username and host on right: RPS1='%K{black}%S%B$(FCLR)%n@%m'

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
export SHELL=/bin/zsh

# Change/remove these to match your settings
export TERM=xterm-256color
export EDITOR=/usr/bin/code
/usr/bin/numlockx on

if [ -f ~/.smapt_aliases ]; then
    . ~/.smapt_aliases
fi
echo "$USER@$HOST"
