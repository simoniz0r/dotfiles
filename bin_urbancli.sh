#!/bin/bash

rm -f /tmp/urbancli.json
curl -sSL "http://api.urbandictionary.com/v0/define?term=$1" -o /tmp/urbancli.json || exit 1

START_NUM=0
for definition in $(jq -r '.list[].word' /tmp/urbancli.json); do
    echo
    echo -e "Word: $(jq -r ".list[$START_NUM].word" /tmp/urbancli.json)"
    echo -e "Definition:\n$(jq -r ".list[$START_NUM].definition" /tmp/urbancli.json)\n"
    echo -e "Example:\n$(jq -r ".list[$START_NUM].example" /tmp/urbancli.json)\n"
    echo -e "Written On: $(jq -r ".list[$START_NUM].written_on" /tmp/urbancli.json)"
    echo -e "Author: $(jq -r ".list[$START_NUM].author" /tmp/urbancli.json)"
    echo -e "Link: $(jq -r ".list[$START_NUM].permalink" /tmp/urbancli.json)"
    echo -e "Thumbs Up: $(jq -r ".list[$START_NUM].thumbs_up" /tmp/urbancli.json)"
    echo -e "Thumbs Down: $(jq -r ".list[$START_NUM].thumbs_down" /tmp/urbancli.json)"
    START_NUM=$(($START_NUM+1))
done
rm -f /tmp/urbancli.json
exit 0
