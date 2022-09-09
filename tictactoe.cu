/**
*
*
*
**/

#include <iostream>
#include <stdlib.h>
using namespace std;

int hor1[3] = {0, 1, 2};
int hor2[3] = {3, 4, 5};
int hor3[3] = {6, 7, 8};
int ver1[3] = {0, 3, 6};
int ver2[3] = {1, 4, 7};
int ver3[3] = {2, 5, 8};
int dia1[3] = {0, 4, 8};
int dia2[3] = {2, 4, 6};
int* winningsets[8] = {hor1, hor2, hor3, ver1, ver2, ver3, dia1, dia2};


char board[3][3] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'}
};

int choice;
int row, column;

int player1[9] = {0};
int player2[9] = {0};

char turn = 'X';

bool game = true;
bool draw = false;

void display_board(){
    cout << "\n\nPlayer 1 [X] \t Player 2 [O]\n\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[0][0] <<"   |   " << board[0][1] << "   |   " << board[0][2] << endl;
    cout << "\t\t_______|_______|_______\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[1][0] <<"   |   " << board[1][1] << "   |   " << board[1][2] << endl;
    cout << "\t\t_______|_______|_______\n";
    cout << "\t\t       |       |       \n";
    cout << "\t\t   " << board[2][0] <<"   |   " << board[2][1] << "   |   " << board[2][2] << endl;
    cout << "\t\t       |       |       \n";
}

void selection(){

    cout << "\n Enter your choice: \n";

    cin >> choice;

    switch(choice) {
        case 1: 
            row = 0;
            column = 0;
            break;
        case 2: 
            row = 0;
            column = 1;
            break;
        case 3: 
            row = 0;
            column = 2;
            break;
        case 4: 
            row = 1;
            column = 0;
            break;
        case 5: 
            row = 1;
            column = 1;
            break;
        case 6: 
            row = 1;
            column = 2;
            break;
        case 7: 
            row = 2;
            column = 0;
            break;
        case 8: 
            row = 2;
            column = 1;
            break;
        case 9: 
            row = 2;
            column = 2;
            break;
        default:
            cout << "\n Invalid Move \n";
    }

}

void validation(int *player, int num){
    cout << "\n Validation \n"; 
    for(auto v : winningsets){
        if(player[v[0]] == 1 && player[v[1]] == 1 && player[v[2]] == 1) {
            cout << "\n PLAYER " << num << " WONNNN \n";
            game = false;
            display_board();
        }
    }

}

void player_turn(){
    if (turn == 'X'){
        cout << "\n Player 1 [X] play : \n";
    }
    else if (turn == 'O'){
        cout << "\n PLayer 2 [O] play:  \n";
    }

    selection();
    if(turn == 'X' && board[row][column] != 'X' && board[row][column] != 'O'){
        board[row][column] = 'X';
        player1[choice - 1] = 1;
        for (int i = 0; i < sizeof(player1) / sizeof(int); i++){
            cout << player1[i] << "   ";
        }
        validation(player1, 1);
        turn = 'O';
    } else if (turn == 'O' && board[row][column] != 'X' && board[row][column] != 'O'){
        board[row][column] = 'O';
        player2[choice - 1] = 1;
        for (int i = 0; i < sizeof(player2) / sizeof(int); i++){
            cout << player2[i] << "   ";
        }
        validation(player2, 2);
        turn = 'X';
    } else {
        cout << "\n Slot is already filled! Invalid Move! Try again\n";
        selection();
    }
}


int main(){
    cout << "\t\t\t TIC TAC TOE \t\t\t";
    
for(int i = 0; i < 8; i++){
    cout << winningsets[i][1] <<"\n ";
}


    while(game == true){
        display_board();
        player_turn();
    }
}