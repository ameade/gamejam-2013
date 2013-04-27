#!/bin/bash

# Non-blocking input
if [ -t 0 ]; then stty -echo -icanon time 0 min 0; fi

function create_screen(){
    clear

}

function draw_screen(){
    playery=$1

    clear
    for i in {1..4}; do
        echo "Score"
    done

    # prints score divider on line 5
    div=$( printf "%100s" );
    echo ${div// /-}

    for i in {6..24}; do
        if [ "$i" = "$playery" ]; then
            echo "x"
        fi
        echo ""
    done
}

keypress=''
playery=23
while [ "$keypress" != "q" ]; do
    #reset keypress
    keypress=''
    read keypress
    if [ "$keypress" = "n" ]; then
        playery=$[ $playery - 1 ]
    fi
    draw_screen $playery
    sleep 0.10
done

echo "Ending the game"

# Back to blocking input
if [ -t 0 ]; then stty sane; fi
exit 0
