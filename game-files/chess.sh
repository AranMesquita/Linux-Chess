#!/bin/bash

source board-positions-dictionary.sh
source set-chess-board.sh
source player1-chess-board.sh
source display-board.sh
source valid-move.sh
source pawn-promotion.sh
source is-king-in-check.sh
source checkmate.sh

player=1
player_1_king_position="H5"
player_2_king_position="A5"
display-chess-board


while true
do
    # check if the king is in checkmate
    if [[ $player -eq 1 ]]
    then 
        checkmate $player_2_king_position
    else
        checkmate $player_1_king_position
    fi

    king_in_check=false
    
    # first check if the move is valid
    valid_move=false
    while [[ $valid_move == false ]]
    do 
        read -p "Enter the postion of the piece you would like to move(letter and number e.g. G1): " from
        read -p "Enter the postion you would like to move that piece to(letter and number e.g. F1): " destination
        piece=${board_positions[$from]}
        destination_piece=${board_positions[$destination]}
        valid-move $from $destination $piece $destination_piece
        #clear
        if [[ $valid_move == false ]]
        then
            display-chess-board
            echo "Invalid move"
        fi
    done

    # check if the player is moving a pawn and it can be promoted
    player1_pawn='033[0;36mP'
    player2_pawn='033[0;32mP'
    # if PLAYER 1's pawn can be promoted
    if [[ ${piece:1:10} == $player1_pawn ]] && [[ ${from:0:1} == 'B' ]]
    then
        player1-promotion
    # if PLAYER 2' Pawn can be promted
    elif [[ ${piece:1:10} == $player2_pawn ]] && [[ ${from:0:1} == 'G' ]]
    then
        player2-promotion
    fi

    # move the chess peice
    board_positions[$destination]=$piece
    board_positions[$from]="\0 \0"

    # check if the king is in check
    is_king_in_check $destination $piece
    
    # check which player just played so that the board can be turned towards the current player that is playing
    case $player in

        1)
            if [[ ${piece:10:1} == "K" ]]
            then
                player_1_king_position=$destination
            fi
            source set-chess-board.sh
            source player2-chess-board.sh
            player=2
            ;;
        2)
            if [[ ${piece:10:1} == "K" ]]
            then
                player_2_king_position=$destination
            fi
            source set-chess-board.sh
            source player1-chess-board.sh
            player=1
            ;;

    esac

    #clear
    display-chess-board
done