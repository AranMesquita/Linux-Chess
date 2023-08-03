#!/bin/bash

source valid-move.sh
source find-chess-piece.sh

is_king_in_check() {
piece_that_just_moved_position=$1

if [[ $player -eq 1 ]]
then
    king_piece="033[0;32mK"
else
    king_piece="033[0;36mK"
fi

opposite_players_kings_position=$( find_chess_piece $king_piece  )

if [[ $opposite_players_kings_position == "piece not found" ]]
then
    echo "King not found"
    return 1
fi

valid-move $piece_that_just_moved_position $opposite_players_kings_position

if [[ $valid_move == true ]]
then
    echo "King in check"
    king_in_check=true
    return 2
else
    king_in_check=false
    return 3
fi
}
