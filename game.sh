#!/bin/bash

# Non-blocking input
if [ -t 0 ]; then stty -echo -icanon time 0 min 0; fi

screen=()
function create_screen(){
    for i in {1..4}; do
        screen[$i]="Score"
    done

    # prints score divider on line 5
    div=$( printf "%100s" );
    screen[5]=${div// /-}

    for i in {6..24}; do
        if [ "$i" = "$playery" ]; then
            screen[$i]="x"
        else
            screen[$i]="blah"
        fi
    done
}

function draw_screen(){
    playery=$1

    create_screen
    clear
    for i in ${!screen[*]}; do
        echo ${screen[$i]}
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
