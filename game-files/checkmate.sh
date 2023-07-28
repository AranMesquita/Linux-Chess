#!/bin/bash

source valid-move.sh

checkmate(){
    players_king_position=$1

    all_positions_around_players_king=$( get_positions_blocks_around_king $players_king_position )

    for position in "${all_positions_around_players_king[@]}"
    do
        echo $position
        for from in "${!board_positions[@]}"
        do
            piece="${board_positions[$key]}"
            destination_piece=${board_positions[$position]}
            valid-move $from $position $piece $destination_piece
            if [[ $valid_move == true ]]
            then
                break;
            fi

        done

        if [[ $valid_move == false ]]
        then
            break;
        fi

    done

    if [[ $valid_move == true ]]
    then
        echo "checkmate"
        return 1
        exit
    fi

    echo "King can still move"
    return 2
}

function get_positions_blocks_around_king(){
    king_position=$1 # 'B2'
    
    verticalHeights_letters=("0" "A" "B" "C" "D" "E" "F" "G" "H")

    declare -A verticalHeights_indexes
    verticalHeights_indexes[A]=1
    verticalHeights_indexes[B]=2
    verticalHeights_indexes[C]=3
    verticalHeights_indexes[D]=4
    verticalHeights_indexes[E]=5
    verticalHeights_indexes[F]=6
    verticalHeights_indexes[G]=7
    verticalHeights_indexes[H]=8

    vertical_letter_postion=${king_position:0:1} # 'B'

    vertical_number_position=${verticalHeights_indexes[$vertical_letter_postion]} # 2

    1_block_up=$(( $vertical_number_position + 1 )) # 3
    1_block_down=$(( $vertical_number_position - 1 )) # 1

    1_block_up_letter=${verticalHeights_letters[$1_block_up]} # 'C'
    1_block_down_letter=${verticalHeights_letters[$1_block_down]} # 'A'

    horizontal_postion=${king_position:1:1} # 2

    1_block_right=$(( $horizontal_postion + 1 )) # 3
    1_block_left=$(( $horizontal_postion - 1 )) # 1

    TopLeftBlock="$1_block_up_letter$1_block_left" # 'C1'
    TopMiddleBlock="$1_block_up_letter$vertical_number_position" # 'C2'
    TopRightBlock="$1_block_up_letter$1_block_right" # 'C3'

    MiddleLeftBlock="$vertical_letter_postion$1_block_left" # 'B1'
    MiddleRightBlock="$vertical_letter_postion$1_block_right" # 'B3'

    BottomLeftBlock="$1_block_down_letter$1_block_left" # 'A1'
    BottomMiddleBlock="$1_block_down_letter$vertical_number_position" # 'A2'
    BottomRightBlock="$1_block_down_letter$1_block_right" # 'A3'

    array_of_positions_around_king=($TopLeftBlock $TopMiddleBlock $TopRightBlock $MiddleLeftBlock $MiddleRightBlock $BottomLeftBlock $BottomMiddleBlock $BottomRightBlock)

    echo ${array_of_positions_around_king[@]}
    return 0


}