/**
*
*
*
**/

#include <iostream>
#include <stdlib.h>
#include <bits/stdc++.h>
using namespace std;

const int width = 3;

int hor1[3] = {0, 1, 2};
int hor2[3] = {3, 4, 5};
int hor3[3] = {6, 7, 8};
int ver1[3] = {0, 3, 6};
int ver2[3] = {1, 4, 7};
int ver3[3] = {2, 5, 8};
int dia1[3] = {0, 4, 8};
int dia2[3] = {2, 4, 6};
int* winningsets[8] = {hor1, hor2, hor3, ver1, ver2, ver3, dia1, dia2};


char board[width][width] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'}
};

int slots[width * width] = {0};

int choice;
int row, column;

int player1[width * width] = {0};
int player2[width * width] = {0};

int turn = 1;

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

int scenario(int *player, int* opponent){
    int sample_slots[width * width] = {slots};
    int sample_player[width * width] = {player};
    int sample_opponent[width * width] = {opponent};

    int position;
    int max_score = INT_MIN;
    int temp;

    for(int i = 0; i < width * width; i++){
        if(sample_slots[i] == 0){
            temp = check_scenario(i, sample_slots, sample_player, sample_opponent);
        }
        if(temp > max_score){
                max_score = temp;
                position = i;
        }
    }

    return position;
}

void selection(){
    cout << "\n The choice: " << choice << "\n";

    switch(choice) {
        case 0: 
            row = 0;
            column = 0;
            break;
        case 1: 
            row = 0;
            column = 1;
            break;
        case 2: 
            row = 0;
            column = 2;
            break;
        case 3: 
            row = 1;
            column = 0;
            break;
        case 4: 
            row = 1;
            column = 1;
            break;
        case 5: 
            row = 1;
            column = 2;
            break;
        case 6: 
            row = 2;
            column = 0;
            break;
        case 7: 
            row = 2;
            column = 1;
            break;
        case 8: 
            row = 2;
            column = 2;
            break;
        default:
            cout << "\n Invalid Move \n";
            break;
    }

}

bool validation(int *player){
    cout << "\n Validation \n"; 

    for(auto v : winningsets){
        if(player[v[0]] == 1 && player[v[1]] == 1 && player[v[2]] == 1) {
            cout << "\n PLAYER " << " WONNNN \n";
             // game = false;
             // display_board();
            return true;
        }
    }

    return false;

}

int check_scenario(int i, int* given_slots, int* player, int* opponent){
    if(given_slots[i] == 0){
        given_slots[i] = 1;
        player[i] = 1;
        return score(player, opponent);
    } else {
        cout << "\n Slot is already filled! Invalid Move! Try again\n";
        selection(player);
        check_scenario(given_slots, player, opponent);
    }
}

void check_slot(int* given_slots, int* player, char sym){
    if(given_slots[width * row + column] == 0){
        board[row][column] = sym;
        given_slots[width * row + column] = 1;
        player[width * row + column] = 1;
        validation(player);
        turn = !turn;
    } else {
        cout << "\n Slot is already filled! Invalid Move! Try again\n";
        selection(player);
        check_slot(given_slots, player, sym);
    }
}

void player_turn(){
    if (turn == 1){
        cout << "\n Player 1 [X] play : \n";
        choice = scenario(player1, player2);
        selection();
        check_slot(slots, player1, 'X');
    }
    else if (turn == 0){
        cout << "\n PLayer 2 [O] play:  \n";
        choice = scenario(player2, player1);
        selection();
        check_slot(slots, player2, 'O');
            
    }
}

int score(int* player, int* opponent) {
    if(validation(player)){
        return 10;
    } else if(validation(opponent)) {
        return -10;
    }

    return 0;
}

int main(){
    cout << "\t\t\t TIC TAC TOE \t\t\t";

    // while(game == true){
    for(int i = 0; i < 9; i++){
        display_board();
        player_turn();
    }
}