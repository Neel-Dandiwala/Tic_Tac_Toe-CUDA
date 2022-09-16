/**
* Author: Neel Dandiwala
* Date: September 2022
*
**/

#include <iostream>
#include <stdlib.h>
#include <bits/stdc++.h>
#include <array>
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

// int slots[width * width] = {0};
int slots[width * width] = {1, 0, 0, 0, 0, 0, 0, 0, 0};
int player1[width * width] = {1, 0, 0, 0, 0, 0, 0, 0, 0};

int choice;
int row, column;

// int player1[width * width] = {0};
int player2[width * width] = {0};

int turn = 1;

bool winning_move = false;
bool game = true;
bool draw = false;

void copy_array(int *temp, int *original){
    for(int i = 0; i < width * width; i++){
        temp[i] = original[i];
    }
}

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

bool validation(int *player, bool winning_move){
    // cout << "\n Validation \n"; 

    for(auto v : winningsets){
        if(player[v[0]] == 1 && player[v[1]] == 1 && player[v[2]] == 1) {
            if(winning_move)
            {
                cout << "\n PLAYER " << " WONNNN \n";
                game = false;
                display_board();
            }
            return true;
        }
    }

    winning_move = false;
    return false;

}


int score(int depth, int* player, int* opponent) {
    if(validation(player, false)){
        return 10 - depth;
    } else if(validation(opponent, false)) {
        return depth - 10;
    }

    return 0;
}

int check_scenario(int i, int depth, int* given_slots, int* player, int* opponent){
        given_slots[i] = 1;
        player[i] = 1;
        int max_score = INT_MIN;
        int temp;
        //bool toggle_turn = true;
        if(score(depth, player, opponent) == 0){
            depth += 1;
            set<int> s;
            set<int>::iterator it;
            for(int i = 0; i < width * width; i++){
                if(given_slots[i] == 0){
                    given_slots[i] = 1;
                    opponent[i] = 1;  
                    for(int j = 0; j < width * width; j++){
                        if (given_slots[j] == 0){
                            temp = check_scenario(j, depth, given_slots, player, opponent); 
                            s.insert(temp);
                        }
                    } 
                    cout << "\n TEMPPP: " << temp << "\n";

                }

            }

            for(auto it : s){
                if(it >= max_score){
                    max_score = it;
                }
            }
            return max_score;
        }
        return score(depth, player, opponent);
   
}

void check_slot(int* given_slots, int* player, char sym){
    if(given_slots[width * row + column] == 0){
        board[row][column] = sym;
        given_slots[width * row + column] = 1;
        player[width * row + column] = 1;
        validation(player, true);
        turn = !turn;
        return;
    } else {
        cout << "\n Slot is already filled! Invalid Move! Try again\n";
        turn = 1;
    }
}

int scenario(int *current_slots, int *player, int* opponent){
    int sample_slots[width * width];
    copy_array(sample_slots, current_slots);
    int sample_player[width * width];
    copy_array(sample_player, player);
    int sample_opponent[width * width];
    copy_array(sample_opponent, opponent);

    int position;
    int max_score = INT_MIN;
    int temp;
    map<int, int> m;
    map<int, int>::iterator iter;
    int depth = 0;
    int index = 0;
    int threshold = (width * width);
    while(index < threshold){
        if(current_slots[index] == 0){
            temp = check_scenario(index, depth, sample_slots, sample_player, sample_opponent);
            m.insert(pair<int, int>(index, temp));
        } 
        index += 1;
    }


    for(iter=m.begin(); iter!=m.end(); iter++){
        if(iter->second >= max_score){
            
            max_score = iter->second;
            position = iter->first;
        }
    }

    cout << "\nMAX SCORE: " << max_score <<" & POSITION: " << position <<endl;

    return position;
}

void player_turn(){
    if (turn == 1){
        cout << "\n Player 1 [X] play : \n";
        choice = scenario(slots, player1, player2);
        selection();
        check_slot(slots, player1, 'X');
    }
    else if (turn == 0){
        cout << "\n PLayer 2 [O] play:  \n";
        choice = scenario(slots, player2, player1);
        selection();
        check_slot(slots, player2, 'O');
            
    }
}



int main(){
    cout << "\t\t\t TIC TAC TOE \t\t\t";

    while(game == true){
    //for(int i = 0; i < 9; i++){
        display_board();
        player_turn();
    }
}