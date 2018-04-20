# Set up the prompt

setopt PROMPT_SUBST

MAIN_COLOR () {
    case $PWD in
        /usr*|/opt*)
            echo "{yellow}"
            ;;
        $HOME*|/run/media/simonizor*)
            echo "{blue}"
            ;;
        *)
            echo "{red}"
            ;;
    esac
}

DIR_TRUNICATED () {
    case $PWD in
        $HOME*)
            DIR_PREPEND="~/"
            TRUNICATE_NUM=5
            ;;
        *)
            DIR_PREPEND=""
            TRUNICATE_NUM=3
            ;;
    esac
    if [ $(echo "$PWD" | cut -f${TRUNICATE_NUM}- -d'/' | wc -c) -gt 20 ]; then
        DIR_ENDING="$(echo "$PWD" | rev | cut -f1-2 -d'/' | rev)"
        echo " $DIR_PREPEND.../$DIR_ENDING "
    else
        echo " %~ "
    fi
}

parse_git_branch () {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}
parse_git_state () {
    if [ -z "$(git status --porcelain)" ]; then
        GIT_STATE=""
    else
        GIT_STATE="$(git status --porcelain | wc -l) "
    fi
    if [ ! -z "$GIT_STATE" ]; then
        echo "$GIT_STATE"
    fi
}
GIT_STATUS () {
    local git_where="$(parse_git_branch)"
    [ -n "$git_where" ] && echo "%F$(MAIN_COLOR)%S%K{black} ʮ ${git_where#(refs/heads/|tags/)} $(parse_git_state)%s%k%f"
}

EXIT_STATUS () {
    EXIT="$?"
    case $EXIT in
        0)
            echo ""
            ;;
        *)
            echo "%F$(MAIN_COLOR)%S%K{black}✘ "$EXIT "%s%k%f"
            ;;
    esac
}

PS1='%K{black}%F$(MAIN_COLOR) %n %S$(DIR_TRUNICATED)%s%k%f '
RPS1='$(EXIT_STATUS)$(GIT_STATUS)'

setopt histignorealldups sharehistory menu_complete

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select
zstyle ':completion:*' menu select=5
zstyle ":completion:*:descriptions" format "%B%d%b"
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl true
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
export EDITOR=$HOME/bin/micro
export MPD_HOST=127.0.0.1

if [ -f ~/nohup.out ]; then
    rm ~/nohup.out
fi

if [ -f /home/simonizor/.config/spm/spm.comp ]; then
    source /home/simonizor/.config/spm/spm.comp
    compdef _spm spm
fi


if [ -f /home/simonizor/.todo/.todo.comp ]; then
    source /home/simonizor/.todo/.todo.comp
    compdef _todo todo
fi

if [ -f /home/simonizor/.config/appimagedl/appimagedl-completion.sh ]; then
    source /home/simonizor/.config/appimagedl/appimagedl-completion.sh
    compdef _appimagedlzsh appimagedl
fi

compdef zyp=zypper

if [[ ! "$TTY" =~ "/dev/tty" ]]; then
    case $(ps -p $(ps -p $$ -o ppid=) o args=) in
        tmux*|*vscode*|*xterm*)
            sleep 0
            ;;
        *)
            tmux
            ;;
    esac
fi
