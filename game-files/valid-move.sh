#!/bin/bash

valid-move() {
    from=$1
    destination=$2
    piece=$3
    destination_piece=$4

    # check if the keys exist in the dictionary
    if [[ ! -v board_positions[$from] ]] || [[ ! -v board_positions[$destination] ]]
    then
        echo "key does not exist"
        valid_move=false
        return 1
    fi

    # check if the player is moving their own piece
    player1='36m'
    player2='32m'

    if [[ ${piece:7:3} == $player1 ]] && [[ $player -eq 2 ]]
    then
        echo "Trying to move Player 2's piece"
        valid_move=false
        return 2
    elif [[ ${piece:7:3} == $player2 ]] && [[ $player -eq 1 ]]
    then
        echo "Trying to move Player 1's piece"
        valid_move=false
        return 3
    elif [[ $piece == "\0" ]]
    then
        echo "trying to move an empty space"
        valid_move=false
        return 4
    fi

    # check if destination has the player's own piece on it or trying to take the King
    if [[ ${piece:7:3} == ${destination_piece:7:3} ]]
    then
        echo "Trying to take your own piece"
        valid_move=false
        return 5
    elif [[ ${destination_piece:10:1} == 'K' ]]
    then    
        echo "Trying to take the King"
        valid_move=false
        return 5
    fi

    # A list where the index corresonds to a letter for vertical position
    vertical_postions=("0" "A" "B" "C" "D" "E" "F" "G" "H")

    # A dictionary, where each letter is a key to a value that corresonds to the letters height
    declare -A valid_move_dict
    valid_move_dict[A]=1
    valid_move_dict[B]=2
    valid_move_dict[C]=3
    valid_move_dict[D]=4
    valid_move_dict[E]=5
    valid_move_dict[F]=6
    valid_move_dict[G]=7
    valid_move_dict[H]=8

    # Working out the horizontal distance that the piece travelled
    horizontal_from=${from:1:1}
    horizontal_destination=${destination:1:1}
    horizontal=$(( horizontal_from - horizontal_destination ))

    # Working out the vertical distance that the piece travelled
    vertical_from=${from:0:1}
    vertical_destination=${destination:0:1}
    vertical_from=${valid_move_dict[$vertical_from]}
    vertical_destination=${valid_move_dict[$vertical_destination]}
    vertical=$(( vertical_from - vertical_destination ))

    # If any of the values are negative set them to a positive, becasue postion is relative
    if [[ $horizontal -lt 0 ]]
    then
        horizontal=$(( -horizontal ))
    fi
    if [[ $vertical -lt 0 ]]
    then
        vertical=$(( -vertical ))
    fi

    Pawn="P"
    Rook='R'
    kNight='N'
    Bishop='B'
    Queen='Q'
    King='K'

    # using the piece check whether that piece's move is valid from the starting position to the destination
    case ${piece:10:1} in
        $Pawn)
            # if Pawn and moves a horizontal distance -1 <= x <= 1
            if [[ $horizontal -gt 1 ]]
            then
                echo "horizontal > 1"
                valid_move=false
                return 6
            # if the pawn moves sideways
            elif [[ $vertical_from == $vertical_destination ]]
            then
                echo "pawn moved sideways"
                valid_move=false
                return 7
            # if the Pawn moves vertically and there is another piece in the way
            elif [[ $horizontal -eq 0 ]] && [[ $destination_piece != "\0" ]]
            then
                echo "pawn moved vertically and theres was a piece in the way"
                valid_move=false
                return 8
            # if the Pawn moves horizontally and there is no piece to take
            elif [[ $horizontal -gt 0 ]] && [[ $destination_piece == "\0" ]]
            then 
                echo "pawn is moving horizontally with no piece to take"
                valid_move=false
                return 9
            # REMINDER!!! this elif below must always be the 2nd to last elif condition
            elif [[ ${piece:7:3} == $player1 ]]
            then
                # if your PLAYER 1 and the Pawn moves backwards
                if [[ $vertical_from -lt $vertical_destination ]]
                then
                    echo "player1 pawn moved backwards"
                    valid_move=false
                    return 10
                # if PLAYER 1 is at their starting postion and the Pawn moves a vertical distance > 2
                elif [[ ${from:0:1} == 'G' ]] && [[ $vertical -gt 2 ]]
                then 
                    echo "pawn is at its starting block and moved a horizontal distance > 1 or a vertical distance > 2"
                    valid_move=false
                    return 11
                # if PLAYER 1 is not at heir starting postion and the Pawn moves a vertical distance > 1
                elif [[ ${from:0:1} != 'G' ]] && [[ $vertical -gt 1 ]]
                then 
                    echo "pawn is not at its starting block and moved a vertical distance > 1"
                    valid_move=false
                    return 12
                # if PLAYER 1 is at their starting postion and the Pawn moves a vertical distance == 2 and  horizontal distance == 1
                elif [[ ${from:0:1} == 'G' ]] && [[ $vertical -eq 2 ]] && [[ $horizontal -eq 1 ]]
                then
                    echo "Pawn tried to move like a Knight not allowed!!!"
                    valid_move=false
                    return 13
                fi
            elif [[ ${piece:7:3} == $player2 ]]
            then
                 # if your PLAYER 2 and the Pawn moves backwards
                if [[ $vertical_from -gt $vertical_destination ]]
                then
                    echo "player2 pawn moved backwards"
                    valid_move=false
                    return 14
                # if PLAYER 2 is at their starting postion and the Pawn moves a vertical distance > 2
                elif [[ ${from:0:1} == 'B' ]] && [[ $vertical -gt 2 ]]
                then 
                    echo "pawn is at its starting block and moved a horizontal distance > 1 or a vertical distance > 2"
                    valid_move=false
                    return 15
                # if PLAYER 2 is not at heir starting postion and the Pawn moves a vertical distance > 1
                elif [[ ${from:0:1} != 'B' ]] && [[ $vertical -gt 1 ]]
                then 
                    echo "pawn is not at its starting block and moved a vertical distance > 1"
                    valid_move=false
                    return 16
                # if PLAYER 2 is at their starting postion and the Pawn moves a vertical distance == 2 and  horizontal distance == 1
                elif [[ ${from:0:1} == 'B' ]] && [[ $vertical -eq 2 ]] && [[ $horizontal -eq 1 ]]
                then
                    echo "Pawn tried to move like a Knight not allowed!!!"
                    valid_move=false
                    return 17
                fi
            fi
            ;;
        $Rook)
            # if the Rook moves a distance that is not completely horizontal or completely vertical
            if [[ $vertical_from != $vertical_destination ]] && [[ $horizontal_from -ne $horizontal_destination ]]
            then
                echo "the rook moved a distance that is not completely horizontal or completely vertical"
                valid_move=false
                return 18
            # else it is a valid move but need to check if there are pieces in the way
            else
                piece_in_the_way
                piece_in_way=$( piece_in_the_way )
                if [[ $piece_in_way == true ]]
                then
                    echo "piece in the way"
                    valid_move=false
                    return 19
                fi
            fi
            ;;
        $kNight)
            # if the Knight moves a vertical distance greater than 2
            if [[ $horizontal -gt 2 || $vertical -gt 2 ]]
            then
                echo "the Knight moved a vertical or horizontal distance > 2"
                valid_move=false
                return 20
            elif [[ $horizontal -eq 1 ]] && [[ $vertical -ne 2 ]]
            then
                echo "the Knight moved a horizontal distance of 1 and a vertical distance greater than 2"
                valid_move=false
                return 21
            elif [[ $horizontal -eq 2 ]] && [[ $vertical -ne 1 ]]
            then
                echo "the Knight moved a horizontal distance of 2 and a vertical distance greater than 1"
                valid_move=false
                return 22
            fi
            ;;
        $Bishop)
            # if the Bishop does not move diagonally
            if [[ $horizontal -ne $vertical ]]
            then
                echo "the bishop did not move diagonlly"
                valid_move=false
                return 23
            # else it is a valid move but need to check if there are pieces in the way
            else
                piece_in_the_way
                piece_in_way=$( piece_in_the_way )
                if [[ $piece_in_way == true ]]
                then
                    echo "piece in the way"
                    valid_move=false
                    return 24
                fi
            fi
            ;;
        $Queen)
            # if the Queen does not move diagonally
            if [[ $horizontal -ne $vertical ]]
            then
                # if the Queen moves a distance that is not completely horizontal or completely vertical
                if [[ $vertical_from != $vertical_destination ]] && [[ $horizontal_from -ne $horizontal_destination ]]
                then
                    echo "the queen did not move horizontally/vertically/diagonally"
                    valid_move=false
                    return 25
                # else it is a valid move but need to check if there are pieces in the way
                else
                    piece_in_the_way
                    piece_in_way=$( piece_in_the_way )
                    if [[ $piece_in_way == true ]]
                    then
                    echo "piece in the way"
                    valid_move=false
                    return 26
                    fi
                fi
            # else it is a valid move but need to check if there are pieces in the way
            else
                piece_in_the_way
                piece_in_way=$( piece_in_the_way )
                if [[ $piece_in_way == true ]]
                then
                    echo "piece in the way"
                    valid_move=false
                    return 27
                fi
            fi
            ;;
        $King)
            # if the King moves any distance (horizontal/vertical) greater than 1
            if [[ $horizontal -gt 1 || $vertical -gt 1 ]]
            then
                echo "the king moved a distance > 1"
                valid_move=false
                return 28
            fi
            ;;
        *)
            echo "Not a valid chess piece"
            valid_move=false
            return 29
            ;;
    esac

    echo "no if statements where triggered"
    valid_move=true
    return 0
}

function piece_in_the_way(){
    # vertical_postions=("0" "A" "B" "C" "D" "E" "F" "G" "H")
    # moving vertically check if there is a piece in the way of the destination piece
    if [[ $vertical -gt 1 ]] && [[ $horizontal -eq 0 ]]
    then
        #echo "moving vertically"
        horizontal_position=${from:1:1}
        if [[ $vertical_from -gt $vertical_destination ]]
        then
            temp_from=$vertical_destination
            temp_destination=$vertical_from
        else
            temp_from=$vertical_from
            temp_destination=$vertical_destination
        fi
        # if temp from > temp_destination swap them
        while [[ $temp_from -lt $temp_destination ]]
        do  
            temp_from=$(( temp_from + 1 ))
            temp_destination=$(( temp_destination - 1 ))
            alphabetical_letter_from=${vertical_postions[$temp_from]}
            alphabetical_letter_destination=${vertical_postions[$temp_destination]}
            string_position_1="$alphabetical_letter_from$horizontal_position"
            string_position_2="$alphabetical_letter_destination$horizontal_position"
            position_1=${board_positions[$string_position_1]}
            position_2=${board_positions[$string_position_2]}
            if [[ ! -v board_positions[$string_position_1] ]] || [[ ! -v board_positions[$string_position_2] ]]
            then
                echo true
                return 30
            elif [[ $position_1 != "\0 \0" ]] || [[ $position_2 != "\0 \0" ]]
            then
                echo true
                return 31
            fi
        done
        echo false
        return 0
    # else if moving horizontally check if there is a piece in the way of the destination piece
    elif [[ $vertical -eq 0 ]] && [[ $horizontal -gt 1 ]]
    then
        #echo "moving horizontally"
        vertical_position=${from:0:1}
        # basically if going backwards technically
        if [[ ${from:1:1} -lt ${destination:1:1} ]]
        then 
            temp_from=${from:1:1}
            temp_destination=${destination:1:1}
        else
            temp_from=${destination:1:1}
            temp_destination=${from:1:1}
        fi
        while [[ $temp_from -lt $temp_destination ]]
        do
            temp_from=$(( temp_from + 1 ))
            temp_destination=$(( temp_destination - 1 ))
            string_position_1="$vertical_position$temp_from"
            string_position_2="$vertical_position$temp_destination"
            position_1=${board_positions[$string_position_1]}
            position_2=${board_positions[$string_position_2]}
            if [[ ! -v board_positions[$string_position_1] ]] || [[ ! -v board_positions[$string_position_2] ]]
            then
                echo true
                return 1
            elif [[ $position_1 != "\0 \0" ]] || [[ $position_2 != "\0 \0" ]]
            then
                echo true
                return 1
            fi
        done

        echo false
        return 0
    # if the piece is moving diagonally
    elif [[ $vertical -eq $horizontal ]]
    then
        #echo "Moving diagonally"
        if [[ ${from:1:1} -lt ${destination:1:1} ]]
        then
            # starting-block
            temp_from=$from
            starting_vertical=${valid_move_dict[${from:0:1}]} # this is the one to increment
            #echo "$starting_vertical"
            starting_vertical_letter=${vertical_postions[$starting_vertical]}
            #echo "$starting_vertical_letter"
            starting_horizontal=${from:1:1}
            #echo "$starting_horizontal"

            # destination-block
            temp_destination=$destination
            destination_vertical=${valid_move_dict[${destination:0:1}]} # this is the one to increment
            #echo "$destination_vertical"
            destination_vertical_letter=${vertical_postions[$destination_vertical]}
            #echo "$destination_vertical_letter"
            destination_horizontal=${destination:1:1}
            #echo "$destination_horizontal"
        else
            # starting-block
            temp_from=$destination
            starting_vertical=${valid_move_dict[${destination:0:1}]} # this is the one to increment
            starting_vertical_letter=${vertical_postions[$starting_vertical]}
            starting_horizontal=${destination:1:1}

            # destination-block
            temp_destination=$from
            destination_vertical=${valid_move_dict[${from:0:1}]} # this is the one to increment
            destination_vertical_letter=${vertical_postions[$destination_vertical]}
            destination_horizontal=${from:1:1}
        fi

        while [[ $temp_from != $temp_destination ]]
        do
            if [[ $destination_vertical -gt $starting_vertical ]]
            then
                #echo "first if condition"
                starting_vertical=$(( starting_vertical + 1 ))
                #echo "$starting_vertical"
                starting_vertical_letter=${vertical_postions[$starting_vertical]}
                #echo "$starting_vertical_letter"
                starting_horizontal=$(( starting_horizontal + 1 ))
                #echo "$starting_horizontal"
                temp_from="$starting_vertical_letter$starting_horizontal"
                #echo "$temp_from"
                if [[ $temp_from == $from ]] || [[ $temp_from == $destination ]]
                then
                    break 32
                fi
                check=${board_positions[$temp_from]}
                if [[ $check != "\0 \0" ]]
                then
                    echo true
                    return 33
                fi
            else
                # triggering this one
                #echo "else condition"
                starting_vertical=$(( starting_vertical - 1 ))
                #echo "$starting_vertical"
                starting_vertical_letter=${vertical_postions[$starting_vertical]}
                #echo "$starting_vertical_letter"
                starting_horizontal=$(( starting_horizontal + 1 ))
                #echo "$starting_horizontal"
                temp_from="$starting_vertical_letter$starting_horizontal"
                if [[ $temp_from == $from ]] || [[ $temp_from == $destination ]]
                then
                    break 34
                fi
                #echo "$temp_from"
                check=${board_positions[$temp_from]}
                if [[ $check != "\0 \0" ]]
                then
                    echo true
                    return 35
                fi
            fi
        done

        echo false
        return 0
    fi
}