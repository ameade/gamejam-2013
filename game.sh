#!/bin/bash

screen=()
keypress=''
playery=23
playerx=10

function set_screen_character(){
    character=$1
    row=$2
    col=$3

    string=${screen[$row]}
    first_part=${string:0:$col}
    second_part=${string:$col+1}

    screen[$row]="$first_part$character$second_part"
}

function draw_player_on_screen(){
        set_screen_character "x" $playery $playerx
}

function create_screen(){
    for i in {1..4}; do
        screen[$i]="Score"
    done

    # prints score divider on line 5
    div=$( printf "%100s" );
    screen[5]=${div// /-}

    for i in {6..24}; do
        # make empty
        #TODO: Wtf can't i do 100 spaces?
        div=$( printf "%100s" );
        screen[$i]=${div// /.}
    done
    # populate screen
    draw_player_on_screen
}

function draw_screen(){
    playery=$1

    create_screen
    clear
    for i in ${!screen[*]}; do
        echo ${screen[$i]}
    done
}

function check_input(){
    #reset keypress
    keypress=''
    read keypress
}

function update_player(){
    if [ "$keypress" = "n" ]; then
        playery=$[ $playery - 1 ]
    fi

}

#function update_enemies(){
#
#}

function update(){
    check_input
    update_player
#    update_enemies
    draw_screen $playery
}

while [ "$keypress" != "q" ]; do
    update
    sleep 0.05
done
