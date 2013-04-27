#!/bin/bash
# Non-blocking input
if [ -t 0 ]; then stty -echo -icanon time 0 min 0; fi

source game.sh

echo "Ending the game"

# Back to blocking input
if [ -t 0 ]; then stty sane; fi
exit 0
