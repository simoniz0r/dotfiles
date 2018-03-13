# Set up the prompt

setopt PROMPT_SUBST

MAIN_COLOR () {
    case $PWD in
        /run/media/simonizor/0d208b29-3b29-4ffc-99be-1043b9f3c258*|$HOME/github*)
            echo "{green}"
            ;;
        $HOME/.config*)
            echo "{magenta}"
            ;;
        /opt*)
            echo "{white}"
            ;;
        /usr/local*)
            echo "{cyan}"
            ;;
        /usr*)
            echo "{yellow}"
            ;;
        $HOME*)
            echo "{blue}"
            ;;
        *)
            echo "{red}"
            ;;
    esac
}

DIR_SYMBOLS () {
    if [[ "$HOST" != "tumbleweed" ]]; then
        echo "ssh %~ "
    else
        case $PWD in
            $HOME*)
                if [ $(echo "$PWD" | tr -cd '/' | wc -c) -lt 5 ]; then
                    echo " %~ "
                else
                    if [ $(echo "$PWD" | cut -f6- -d'/' | wc -c) -gt 15 ]; then
                        DIR_ENDING="$(echo "$PWD" | rev | cut -f1-2 -d'/' | rev)"
                        echo " ~/.../$DIR_ENDING "
                    else
                        echo " %~ "
                    fi
                fi
                ;;
            /run/media/simonizor/0d208b29-3b29-4ffc-99be-1043b9f3c258*)
                echo " USB_HDD${PWD:57} "
                ;;
            /)
                echo " ⚠${PWD:1} "
                ;;
            *)
                if [ $(echo "$PWD" | tr -cd '/' | wc -c) -lt 3 ]; then
                    echo " ⚠ $PWD "
                else
                    if [ $(echo "$PWD" | cut -f4- -d'/' | wc -c) -gt 15 ]; then
                        DIR_ENDING="$(echo "$PWD" | rev | cut -f1-2 -d'/' | rev)"
                        echo " ⚠ /.../$DIR_ENDING "
                    else
                        echo " ⚠ $PWD "
                    fi
                fi
                ;;
        esac
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

PS1='%K{black}%F$(MAIN_COLOR) %n %S$(DIR_SYMBOLS)%s%k%f '
RPS1='$(EXIT_STATUS)$(GIT_STATUS)'

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
# zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ":completion:*:descriptions" format "%B%d%b"
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
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
export EDITOR=/usr/bin/mcedit
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

if [[ ! "$TTY" =~ "/dev/tty" ]]; then
    case $(ps -p $(ps -p $$ -o ppid=) o args=) in
        tmux*|*vscode*)
            sleep 0
            ;;
        *)
            tmux
            ;;
    esac
fi
