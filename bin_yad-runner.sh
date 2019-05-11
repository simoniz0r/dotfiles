#!/bin/bash

[ ! -f "$HOME/.cache/yad-runner.log" ] && echo "#" > ~/.cache/yad-runner.log

DIRECTORIES="$(echo -e $PATH | tr ':' '\n')"

mapfile -t APP_LIST < <(cat ~/.cache/yad-runner.log | tail -n +2; for directory in $DIRECTORIES; do ls -Cw1 "$directory"; done)

APP_LIST="$(printf '%s\n' "${APP_LIST[@]}" | sort -u | tr '\n' '!' | rev | cut -f2- -d'!' | rev)"

RUN_CMD="$(yad --align="center" --title="yad-runner" --window-icon="emblem-link" --close-on-unfocus --on-top --center \
--no-buttons --separator="" --undecorated --width=300 --height=15 --borders=5 --form --field="":CE "$APP_LIST" $@)"

if [ -n "$RUN_CMD" ]; then
    rm -rf ~/.cache/yad-runner-out.log
    if [ -x "$(readlink -f $(which $(echo -e $RUN_CMD | cut -f1 -d' ')))" ]; then
        bash -c "$RUN_CMD" > ~/.cache/yad-runner-out.log 2>&1 &
#         { yad --borders=15 --title="yad-runner" --window-icon="emblem-link" --close-on-unfocus --on-top --center \
#         --timeout=30 --no-buttons --separator="" --undecorated --width=300 --error --text="Failed to run '$RUN_CMD'\n\nError Message:\n$(cat ~/.cache/yad-runner-out.log)"; exit 1; } &
        disown
    else
        bash -c "xdg-open $RUN_CMD" > ~/.cache/yad-runner-out.log 2>&1 &
#         { yad --borders=15 --title="yad-runner" --window-icon="emblem-link" --close-on-unfocus --on-top --center \
#         --timeout=30 --no-buttons --separator="" --undecorated --width=300 --error --text="Failed to run '$RUN_CMD'\n\nError Message:\n$(cat ~/.cache/yad-runner-out.log)"; exit 1; } &
        disown
    fi
    echo -e "$RUN_CMD" >> ~/.cache/yad-runner.log
    echo -e "$(cat ~/.cache/yad-runner.log | sort -u)" > ~/.cache/yad-runner.log
fi
exit 0
