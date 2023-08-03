#!/bin/bash

display-chess-board() {
    clear
    echo -e $board
    if [[ $king_in_check == true ]]
    then
        echo "Your King is in check!"
    fi
    echo "PLAYER $player's turn"
}