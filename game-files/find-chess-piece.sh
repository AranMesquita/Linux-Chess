#!/bin/bash

find_chess_piece(){
    piece_to_find=$1

    for key in "${!board_positions[@]}"
    do
        value="${board_positions[$key]}"
        
        if [[ ${value:1:10} == $piece_to_find ]]
        then
            echo $key # return the position of the piece
            return 1
        fi

    done

    echo "piece not found"
    return 2
}