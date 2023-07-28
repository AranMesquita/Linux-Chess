#!/bin/bash

player1-promotion(){
    echo -e "\nYour pawn can be promoted, pick which chess piece you would like to promote your pawn to(enter the number of your choice): 
        \n1 - Queen
        \n2 - Bishop
        \n3 - Knight
        \n4 - Rook "

    read promotion

    case $promotion in 

        1) 
            piece="${CYAN}Q${NC}"
            ;;
        2)
            piece="${CYAN}B${NC}"
            ;;
        3)
            piece="${CYAN}N${NC}"
            ;;
        4)
            piece="${CYAN}R${NC}"
            ;;
    esac
}

player2-promotion(){
    echo -e "\nYour pawn can be promoted, pick which chess piece you would like to promote your pawn to(enter the number of your choice): 
        \n1 - Queen
        \n2 - Bishop
        \n3 - Knight
        \n4 - Rook "

    read promotion

    case $promotion in 

        1) 
            piece="${GREEN}Q${NC}"
            ;;
        2)
            piece="${GREEN}B${NC}"
            ;;
        3)
            piece="${GREEN}N${NC}"
            ;;
        4)
            piece="${GREEN}R${NC}"
            ;;
    esac
}

