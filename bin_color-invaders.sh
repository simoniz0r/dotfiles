#!/usr/bin/env bash

# ANSI color scheme script featuring Space Invaders

# Original: http://crunchbanglinux.org/forums/post/126921/#p126921
# Modified by simoniz0r to not rely on bold to set colors

cat << EOF

 $(tput setaf 1)  ▀▄   ▄▀     $(tput setaf 2) ▄▄▄████▄▄▄    $(tput setaf 3)  ▄██▄     $(tput setaf 4)  ▀▄   ▄▀     $(tput setaf 5) ▄▄▄████▄▄▄    $(tput setaf 6)  ▄██▄  $(tput sgr0)
 $(tput setaf 1) ▄█▀███▀█▄    $(tput setaf 2)███▀▀██▀▀███   $(tput setaf 3)▄█▀██▀█▄   $(tput setaf 4) ▄█▀███▀█▄    $(tput setaf 5)███▀▀██▀▀███   $(tput setaf 6)▄█▀██▀█▄$(tput sgr0)
 $(tput setaf 1)█▀███████▀█   $(tput setaf 2)▀▀███▀▀███▀▀   $(tput setaf 3)▀█▀██▀█▀   $(tput setaf 4)█▀███████▀█   $(tput setaf 5)▀▀███▀▀███▀▀   $(tput setaf 6)▀█▀██▀█▀$(tput sgr0)
 $(tput setaf 1)▀ ▀▄▄ ▄▄▀ ▀   $(tput setaf 2) ▀█▄ ▀▀ ▄█▀    $(tput setaf 3)▀▄    ▄▀   $(tput setaf 4)▀ ▀▄▄ ▄▄▀ ▀   $(tput setaf 5) ▀█▄ ▀▀ ▄█▀    $(tput setaf 6)▀▄    ▄▀$(tput sgr0)

 $(tput setaf 9)▄ ▀▄   ▄▀ ▄   $(tput setaf 10) ▄▄▄████▄▄▄    $(tput setaf 11)  ▄██▄     $(tput setaf 12)▄ ▀▄   ▄▀ ▄   $(tput setaf 13) ▄▄▄████▄▄▄    $(tput setaf 14)  ▄██▄  $(tput sgr0)
 $(tput setaf 9)█▄█▀███▀█▄█   $(tput setaf 10)███▀▀██▀▀███   $(tput setaf 11)▄█▀██▀█▄   $(tput setaf 12)█▄█▀███▀█▄█   $(tput setaf 13)███▀▀██▀▀███   $(tput setaf 14)▄█▀██▀█▄$(tput sgr0)
 $(tput setaf 9)▀█████████▀   $(tput setaf 10)▀▀▀██▀▀██▀▀▀   $(tput setaf 11)▀▀█▀▀█▀▀   $(tput setaf 12)▀█████████▀   $(tput setaf 13)▀▀▀██▀▀██▀▀▀   $(tput setaf 14)▀▀█▀▀█▀▀$(tput sgr0)
 $(tput setaf 9) ▄▀     ▀▄    $(tput setaf 10)▄▄▀▀ ▀▀ ▀▀▄▄   $(tput setaf 11)▄▀▄▀▀▄▀▄   $(tput setaf 12) ▄▀     ▀▄    $(tput setaf 13)▄▄▀▀ ▀▀ ▀▀▄▄   $(tput setaf 14)▄▀▄▀▀▄▀▄$(tput sgr0)


                                     $(tput setaf 7)▌$(tput sgr0)

                                   $(tput setaf 7)▌$(tput sgr0)

                              $(tput setaf 7)    ▄█▄    $(tput sgr0)
                              $(tput setaf 7)▄█████████▄$(tput sgr0)
                              $(tput setaf 7)▀▀▀▀▀▀▀▀▀▀▀$(tput sgr0)

EOF
