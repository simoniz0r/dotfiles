#!/bin/bash
# A wrapper script for 'zypper' and 'osc' that adds install and search for openSUSE Build Sevice packages

# Function to ask questions.  Automatically detects number of options inputted.
# Detects if user inputs valid option and passes text of selected option on as SELECTED_OPTION variable
# Exits if invalid selection is made
function askquestion() {
    local QUESTION_TITLE="$1" 
    local QUESTION_TEXT="$2"
    shift 2
    local NUM_OPTIONS=$#
    local QUESTION_NUMBER=1
    echo "$(tput smul)$QUESTION_TITLE$(tput rmul)"
    echo
    echo -e "$QUESTION_TEXT"
    echo
    for option in $@; do
        [ $QUESTION_NUMBER -lt 10 ] && QUESTION_NUMBER=" $QUESTION_NUMBER"
        echo "${QUESTION_NUMBER}. $(echo $option | tr '%' ' ')"
        echo "$(echo $option | tr '%' ' ')" >> /tmp/questionoptions
        local QUESTION_NUMBER=$(($QUESTION_NUMBER+1))
    done
    echo
    read -p "Option number: " -r QUESTION_SELECTION
    [ -z "$QUESTION_SELECTION" ] && exit 0
    if echo "$QUESTION_SELECTION" | grep -q '^[0-9]' && [ $QUESTION_SELECTION -gt 0 ] && [ $QUESTION_SELECTION -le $NUM_OPTIONS ]; then
        export SELECTED_OPTION="$QUESTION_SELECTION"
        rm -f /tmp/questionoptions
        echo
    else
        rm -f /tmp/questionoptions
        exit 0
    fi
}

# function to search for packages
function searchpackages() {
    . /etc/os-release
    local DISTRO="$(echo $NAME | cut -f2 -d' ')"
    case "$DISTRO" in
        *Tumbleweed*|*tumbleweed*)
            local SEARCH_RESULTS="$(osc bse --csv "$@" | tr '|' '\n' | grep "$(uname -m).rpm\|noarch.rpm" | grep -i "$DISTRO\|Factory")"
            ;;
        *)
            local SEARCH_RESULTS="$(osc bse --csv "$@" | tr '|' '\n' | grep "$(uname -m).rpm\|noarch.rpm" | grep -i "$DISTRO")"
            ;;
    esac
    [ ! -z "$SEARCH_RESULTS" ] && echo -e "$SEARCH_RESULTS" || echo "null"
}

function searchstart() {
    case "$1" in
        -O|--osc|--obs|--OBS)
            shift
            sleep 0
            ;;
        -s|[a-z]*|[A-Z]*|[0-9]*)
            zypper se "$@"
            local ZYPPER_EXIT=$?
            echo
            ;;
        *)
            [ "$1" = "-L" ] || [ "$1" = "--local" ] && shift
            zypper se "$@"
            exit 0
            ;;
    esac
    echo "openSUSE Build Service results:"
    echo
    local SEARCH_RESULTS="$(searchpackages "$@")"
    case "$SEARCH_RESULTS" in
        null)
            echo "No matching items found."
            exit $ZYPPER_EXIT
            ;;
        *)
            LINE_LENGTH=0
            for line in $SEARCH_RESULTS; do
                NEW_LINE_LENGTH=$(echo $line | rev | cut -f4- -d'/' | rev | wc -m)
                [ $NEW_LINE_LENGTH -gt $LINE_LENGTH ] && LINE_LENGTH=$(($NEW_LINE_LENGTH+2))
            done
            printf "%-11s %-${LINE_LENGTH}s %-12s %s\n" "Version" "Project" "Repo" "Package"
            printf "%-11s %-${LINE_LENGTH}s %-12s %s\n" "-------" "-------" "----" "-------"
            for result in $SEARCH_RESULTS; do
                printf "%-12s %-${LINE_LENGTH}s %-12s %s\n" "|$(echo $result | rev | cut -f1 -d'/' | cut -f2 -d'-' | rev | cut -c-10)" \
                "$(echo $result | rev | cut -f4- -d'/' | rev)" \
                "$(echo $result | rev | cut -f3 -d'/' | rev | cut -f2 -d'_')" "$(echo $result | rev | cut -f1 -d'/' | cut -f3- -d'-' | rev)" >> /tmp/zypresults
            done
            echo "$(cat /tmp/zypresults | sort -fbdir -t\|)" > /tmp/zypresults
            # echo "$(awk "BEGIN l = $LINE_LENGTH { printf "%-12s %-" l "s %-12s %s\n",$1,$2,$3,$4; }" /tmp/zypresults)" > /tmp/zypresults
            cat /tmp/zypresults | cut -f2 -d'|'
            ;;
    esac
}

function installstart() {
    case "$1" in
        -O|--osc|--obs|--OBS)
            shift
            case "$1" in
                -p|--priority)
                    shift
                    export REPO_PRIORITY=$1
                    shift
                    ;;
            esac
            sleep 0
            ;;
        -p|--priority)
            shift
            export REPO_PRIORITY=$1
            shift
            ;;
        *)
            sudo zypper in "$@" 
            ZYPPER_EXIT=$?
            case $ZYPPER_EXIT in
                104)
                    echo "Package not found in repo list; searching with osc..."
                    echo
                    ;;
                *)
                    exit $ZYPPER_EXIT
                    ;;
            esac
            ;;
    esac
    [ -z "$REPO_PRIORITY" ] && export REPO_PRIORITY=100
    searchpackages "$@" > /tmp/zypsearch 2>&1
    if [ ! "$(cat /tmp/zypsearch)" = "null" ]; then
        local START_NUM=11
        local LINE_LENGTH=0
        for line in $(cat /tmp/zypsearch); do
            NEW_LINE_LENGTH=$(echo $line | rev | cut -f4- -d'/' | rev | wc -m)
            [ $NEW_LINE_LENGTH -gt $LINE_LENGTH ] && LINE_LENGTH=$(($NEW_LINE_LENGTH+2))
        done
        for result in $(cat /tmp/zypsearch); do
            printf "%-14s %-${LINE_LENGTH}s %-12s %s\n" "$START_NUM|$(echo $result | rev | cut -f1 -d'/' | cut -f2 -d'-' | rev | cut -c-10)" \
            "$(echo $result | rev | cut -f4- -d'/' | rev)" \
            "$(echo $result | rev | cut -f3 -d'/' | rev | cut -f2 -d'_')" "$(echo $result | rev | cut -f1 -d'/' | cut -f3- -d'-' | rev)" >> /tmp/zypresults
            local START_NUM=$(($START_NUM+1))
        done
        echo "$(cat /tmp/zypresults | sort -fbdir -t\| -k2 | tr ' ' '%')" > /tmp/zypresults
        askquestion "Select a package to install or press ENTER to exit:" "$(printf "%-14s %-${LINE_LENGTH}s %-12s %s\n" \
        " Version" " Project" " Repo" " Package")\n$(printf "%-14s %-${LINE_LENGTH}s %-12s %s\n" " -------" " -------" " ----" " -------")" \
        $(cat /tmp/zypresults | cut -f2 -d'|' | tr '\n' ' ')
        SELECTED_RESULT="$(sed "${SELECTED_OPTION}q;d" /tmp/zypresults | cut -f1 -d'|')"
        SELECTED_RESULT=$(($SELECTED_RESULT-10))
        SELECTED_PACKAGE="$(sed "${SELECTED_RESULT}q;d" /tmp/zypsearch)"
        [ -z "$SELECTED_PACKAGE" ] && exit 0
        echo "Description:"
        local API_PACKAGE="$(echo $SELECTED_PACKAGE | sed 's%:/%:%g')"
        echo -e "$(osc api /published/$API_PACKAGE?view=ymp | tac | awk '/<\/metapackage/,/<\/repositories>/' | awk '/<\/description>/,/<description>/' | cut -f2 -d'>' | cut -f1 -d'<' | tac)\n"
        echo "Selection:"
        echo -e "$SELECTED_PACKAGE\n"
        read -p "$(tput bold)Add repository and install package? [y/n] (y):$(tput sgr0) " INSTALL_ANSWER
        echo
        case $INSTALL_ANSWER in
            N*|n*)
                exit 0
                ;;
            *)
                addobsrepo "$SELECTED_PACKAGE"
                ;;
        esac
    else
        echo "Package '$@' not found."
        exit 104
    fi
}

function addobsrepo() {
    local PACKAGE="$(echo $1 | rev | cut -f1 -d'/' | cut -f2- -d'-' | rev)"
    local REPO_URL="http://download.opensuse.org/repositories/$(echo $1 | rev | cut -f3- -d'/' | rev)"
    local REPO_RELEASE="$(echo $1 | rev | cut -f3 -d'/' | rev | cut -f2 -d'_')"
    local PROJECT_NAME="$(echo $1 | rev | cut -f4- -d'/' | rev | tr -d '/')"
    local REPO_NAME="$(echo $1 | rev | cut -f4- -d'/' | rev | tr -d '/' |tr ':' '_')"
    if rpm -qa | grep -qm1 "$PACKAGE"; then
        echo "'$PACKAGE' is already installed."
        echo "Nothing to do."
        exit 0
    fi
    if zypper lr -U | grep -qm1 "$REPO_URL"; then
        echo "$REPO_URL is already in the list of repositories."
        SKIP_REPOREM="TRUE"
    else
        SKIP_REPOREM="FALSE"
        sudo zypper ar -f -p $REPO_PRIORITY -n "$REPO_NAME/$REPO_RELEASE" ${REPO_URL}/${PROJECT_NAME}.repo
        local ZYPPER_EXIT=$?
        case $ZYPPER_EXIT in
            0)
                installpackage "$SKIP_REPOREM" "$REPO_NAME" "$PACKAGE"
                ;;
            *)
                exit $ZYPPER_EXIT
                ;;
        esac
    fi
}

function installpackage() {
    local SKIP_REPOREM="$1"
    local REPO_NAME="$2"
    local PACKAGE="$3"
    sudo zypper install "$PACKAGE"
    local ZYPPER_EXIT=$?
    case $ZYPPER_EXIT in
        0|4|104)
            [ "$SKIP_REPOREM" = "FALSE" ] && askremoverepo "$REPO_NAME" "$ZYPPER_EXIT"
            ;;
        *)
            exit $ZYPPER_EXIT
            ;;
    esac
}

function askremoverepo() {
    local REPO_NAME="$1"
    local ZYPPER_EXIT=$2
    read -p "$(tput bold)Keep '$REPO_NAME' in the list of repositories? [y/n] (y):$(tput sgr0) " ASKREMOVE_ANSWER
    case "$ASKREMOVE_ANSWER" in
        N*|n*)
            unset ZYPPER_EXIT
            sudo zypper rr "$REPO_NAME"
            local ZYPPER_EXIT=$?
            exit $ZYPPER_EXIT
            ;;
        *)
            exit $ZYPPER_EXIT
            ;;
    esac
}

function zypstart() {
    case "$1" in
        se|search)
            rm -f /tmp/zypsearch /tmp/zypresults
            shift
            searchstart "$@"
            rm -f /tmp/zypsearch /tmp/zypresults
            ;;
        in|install)
            rm -f /tmp/zypsearch /tmp/zypresults
            shift
            installstart "$@"
            rm -f /tmp/zypsearch /tmp/zypresults
            ;;
        ps)
            sudo zypper ps -s
            ;;
        *)
            zypper "$@" 2> /tmp/zyperrors
            local ZYPPER_EXIT=$?
            case $ZYPPER_EXIT in
                5)
                    rm -f /tmp/zyperrors
                    sudo zypper "$@"
                    ;;
                *)
                    cat /tmp/zyperrors
                    rm -f /tmp/zyperrors
                    exit $ZYPPER_EXIT
                    ;;
            esac
            ;;
    esac
}

if [ "$1" = "-R" ] || [ "$1" = "--root" ]; then
    shift
# elif [ "$ZYPALLOWROOT" = "TRUE" ]; then
#     sleep 0
elif [ $EUID -eq 0 ]; then
    echo "It is not recommended to run 'zyp' as root."
    echo "'zyp' will automatically escalate privileges when necessary."
    echo "Run 'zyp --root' to bypass this check."
    exit 1
fi

zypstart "$@" && exit 0
