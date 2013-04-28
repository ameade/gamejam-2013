#!/bin/bash

SCREEN_WIDTH=100
SCREEN_HEIGHT=24
BACKGROUND_CHAR=' '

dead=0
on_ground=1
on_ceiling=0
#up (-1), down(1), or still(0)
moving=0

player_pic=('      ________'
            '     /  ||   \\'
            ' __ /___||____\\___'
            '|  |     |          \'
            '|/ \_____|______/ \_|'
            ' \_/            \_/'
           )

player_pic_alt=('| (  )---------(  )--|'
                '|  ||           ||   |'
                '|  | ----------- |   |'
                '|  | ----------- |   |'
                '|  ||           ||   |'
                '|_(__)_________(__)__|'
               )

player_pic_top=(' / \____________/ \__'
                '|\_/     |      \_/ |'
                '|__|____ |____  ___/'
                '   \    ||    //'
                '    \___||___//'
               )
player_width=21
player_hit_point_x=22
player_hit_point_y=3

bottom_enemy_pic=(' / \'
                  ' \_/'
                  '--|--'
                  '  |'
                  ' / \'
                  '/   \'
                 )
bottom_enemy_width=5

bottom_enemy_x=200
bottom_enemy_y=19

top_enemy_pic=(' -,     (\_/)     ,-'
               '  /`-`--(* *)--`-`\'
               ' /      (___)      \'
               '/.-.-.-/ " " \-.-.-.\'
              )
top_enemy_width=21

top_enemy_x=150
top_enemy_y=6

screen=()
keypress=''
playery=19
playerx=2

score=0

function set_screen_string(){
    character=$1
    row=$2
    col=$3

    if (($col < 0)); then
        offset=$[$col * -1]
        character=${character:$offset}
        col=0
    fi

    string=${screen[$row]}
    first_part=${string:0:$col}
    second_part=${string:$col+${#character}}
    total_string="$first_part$character$second_part"

    screen[$row]=${total_string:0:$SCREEN_WIDTH}
}

function put_pic_on_screen(){
    objectY=$1
    objectX=$2
    shift
    shift
    pic=("${@}")
    for i in ${!pic[*]}; do
        myY=$[ $objectY + $i ]
        line="${pic[$i]}"
        set_screen_string "$line" $myY $objectX
    done
}

function put_player_on_screen(){
    if [ $on_ground = 0 ] && [ $on_ceiling = 0 ]; then
        put_pic_on_screen $playery $playerx "${player_pic_alt[@]}"
    elif [ $on_ceiling = 1 ]; then
        put_pic_on_screen $playery $playerx "${player_pic_top[@]}"
    else
        put_pic_on_screen $playery $playerx "${player_pic[@]}"
    fi
}

function put_enemies_on_screen(){
    put_pic_on_screen $bottom_enemy_y $bottom_enemy_x "${bottom_enemy_pic[@]}"
    put_pic_on_screen $top_enemy_y $top_enemy_x "${top_enemy_pic[@]}"
}

function create_screen(){
    for ((i=1; i<=$SCREEN_HEIGHT; i++)); do
        # make empty
        #TODO: Wtf can't i do 100 spaces?
        div=$( printf "%*s" "$SCREEN_WIDTH");
        screen[$i]=${div// /$BACKGROUND_CHAR}
    done
    screen[4]="Score $score"

    # prints score divider on line 5
    div=$( printf "%*s" "$SCREEN_WIDTH" );
    screen[5]=${div// /-}

    # populate screen
    put_enemies_on_screen
    put_player_on_screen
}

function draw_screen(){
    playery=$1

    create_screen
    clear
    for i in ${!screen[*]}; do
        echo "${screen[$i]}"
    done
}

function check_input(){
    #reset keypress
    keypress=''
    read keypress
}

function update_player(){

    if [ $moving < 0 ] && [ $playery = 6 ]; then
       on_ceiling=1
       moving=0
    elif [ $moving > 0 ] && [ $[ $playery + ${#player_pic[*]} - 1 ] = $SCREEN_HEIGHT ]; then
        on_ground=1
        moving=0
    fi

    if [ "$keypress" = "n" ]; then
        if [ $on_ground == 1 ]; then
            moving=-2
            on_ground=0
        fi
        if [ $on_ceiling == 1 ]; then
            moving=2
            on_ceiling=0
        fi
    fi

    playery=$[ $playery + $moving ]

    if [ $playery -lt 6 ]; then
        playery=6
    fi

    if [ $playery -gt $[ $SCREEN_HEIGHT - ${#player_pic[*]}] ]; then
        playery=$[$SCREEN_HEIGHT - ${#player_pic[*]} + 1 ]
    fi


    #check for hit
    #if the hit spot on the player is not the bg character then a hit happened
    current_hit_y=$[$playery+$player_hit_point_y]
    current_hit_x=$[$playerx+$player_hit_point_x]
    line="${screen[$current_hit_y]}"
    hit_spot_char="${line:$current_hit_x:1}"

    if [ "$hit_spot_char" != "" ] && [ "$hit_spot_char" != "$BACKGROUND_CHAR" ]; then
        dead=1
    fi

}

function update_enemies(){
    #move bottom enemy
    bottom_enemy_x=$[ $bottom_enemy_x - 3 ]
    if [ $[ -1 * $bottom_enemy_width ] -gt $bottom_enemy_x ]; then
        bottom_enemy_x=$[$SCREEN_WIDTH + ( $RANDOM % 200)]
    fi

    #move top enemy
    top_enemy_x=$[ $top_enemy_x - 4 ]
    if [ $[ -1 * $top_enemy_width ] -gt $top_enemy_x ]; then
        top_enemy_x=$[$SCREEN_WIDTH + ( $RANDOM % 100)]
    fi
}

function update(){
    check_input
    update_player
    update_enemies

    draw_screen $playery
    if [ $dead != 1 ]; then
        score=$[$score + 1]
    fi
}

while [ "$keypress" != "q" ]; do
    update
    sleep 0.01
done
