/**
* Author: Neel Dandiwala
* Date: October 2022
**/

#include <iostream>
#include <stdlib.h>
#include <array>
using namespace std;

#define WIDTH 3

char board[WIDTH * WIDTH] = {
    '_', '_', '_',
    '_', '_', '_',
    '_', '_', '_'
};

char player = 'X';
char opponent = 'O';

int row1[3] = {0, 1, 2};
int row2[3] = {3, 4, 5};
int row3[3] = {6, 7, 8};
int col1[3] = {0, 3, 6};
int col2[3] = {1, 4, 7};
int col3[3] = {2, 5, 8};
int dia1[3] = {0, 4, 8};
int dia2[3] = {2, 4, 6};
int* winningsets[8] = {row1, row2, row3, col1, col2, col3, dia1, dia2};

bool emptySlots(char *board){
    for(int i = 0; i < WIDTH * WIDTH; i++){
        if(board[i] == '_') return true;
    }

    return false;
}

void display_board(){
    cout << "\n\nPlayer 1 [X] \t Player 2 [O]\n\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[0] <<"   |   " << board[1] << "   |   " << board[2] << endl;
    cout << "\t\t_______|_______|_______\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[3] <<"   |   " << board[4] << "   |   " << board[5] << endl;
    cout << "\t\t_______|_______|_______\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[6] <<"   |   " << board[7] << "   |   " << board[8] << endl;
    cout << "\t\t       |       |       \n";
}

bool validation(char *board){
    for(auto v : winningsets){
        if(board[v[0]] == board[v[1]] && board[v[1]] == board[v[2]]){
            if(board[v[0]] == player) {
                display_board();
                cout << "Player 1 [X] wins! \n\n";
                return false;
            } else if(board[v[0]] == opponent){
                display_board();
                cout << "Player 2 [O] wins! \n\n";
                return false;
            }
        }
    } 

    return true;
}

int score(char *board){
    for(auto v : winningsets){
        if(board[v[0]] == board[v[1]] && board[v[1]] == board[v[2]]){
            if(board[v[0]] == player) {
                return 10;
            } else if(board[v[0]] == opponent){
                return -10;
            }
        }
    } 

    return 0;
}

int minmax(char *board, int depth, bool isMax){

    int benefit = score(board);

    if(benefit == 10) return (benefit - depth);

    if(benefit == -10) return (depth - 10);

    if(emptySlots(board) == false) return 0;

    if(isMax){

        int maximumBenefit = -1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){
            if(board[i] == '_'){

                board[i] = player;

                int tempBenefit = minmax(board, depth + 1, !isMax);

                board[i] = '_';

                maximumBenefit = max(maximumBenefit, tempBenefit);

            }
        }

        return maximumBenefit;
    } else {

        int minimumBenefit = 1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){

            if(board[i] == '_'){

                board[i] = opponent;

                int tempBenefit = minmax(board, depth + 1, !isMax);

                board[i] = '_';

                minimumBenefit = min(minimumBenefit, tempBenefit);

            }
        }

        return minimumBenefit;
    }
}

int nextMove(char *board, bool isPlayer){

    int initialBenefit;
    int position = -1;
    if(isPlayer){
        initialBenefit = -1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){

            if(board[i] == '_'){

                board[i] = player;
                int tempBenefit = minmax(board, 0, false);
        
                board[i] = '_';

                if(initialBenefit < tempBenefit){
                    initialBenefit = tempBenefit;
                    position = i;
                }

            }
        }

        // return position;
    } else {
        initialBenefit = 1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){

            if(board[i] == '_'){

                board[i] = opponent;
                int tempBenefit = minmax(board, 0, true);
        
                board[i] = '_';

                if(initialBenefit > tempBenefit){
                    initialBenefit = tempBenefit;
                    position = i;
                }

            }
        }

        // return position;
    }
    

    return position;
}

void executeMove(char *board, bool isPlayer, int finalPosition){
    if(isPlayer) {
        board[finalPosition] = player;
    } else {
        board[finalPosition] = opponent;
    }
    display_board();
}

int main(){
    display_board();
    bool isPlayer = true;
    while(validation(board) && emptySlots(board)){
        int finalPosition = nextMove(board, isPlayer);
        executeMove(board, isPlayer, finalPosition);
        isPlayer = !isPlayer;
    }

}
