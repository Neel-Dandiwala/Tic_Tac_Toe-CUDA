/**
*   Author: Neel Dandiwala
*   Date:   October 2022
**/

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <cuda_runtime_api.h>
#include <iostream>
#include <stdio.h>

#define WIDTH 3

__constant__ char player;
__constant__ char opponent;


#define cudaCHECK(res) { cudaASSERT((res), __FILE__, __LINE__);}
inline void cudaASSERT(cudaError_t err, const char *file, int line, bool abort=true){
    if(err != cudaSuccess) {
        fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(err), file, line);
        if (abort) exit(err);
    }
}

__device__ __host__ void display_board(char *d_board){
    printf("\n\nPlayer 1 [X] \t Player 2 [O]\n\n");
    printf("\t\t       |       |       \n");
    printf("\t\t   %c   |   %c   |   %c\n", d_board[0], d_board[1], d_board[2]);
    printf("\t\t_______|_______|_______\n");
    printf("\t\t       |       |       \n");
    printf("\t\t   %c   |   %c   |   %c\n", d_board[3], d_board[4], d_board[5]);
    printf("\t\t_______|_______|_______\n");
    printf("\t\t       |       |       \n");
    printf("\t\t   %c   |   %c   |   %c\n", d_board[6], d_board[7], d_board[8]);
    printf("\t\t       |       |       \n");
}

__device__ bool emptySlots(char *d_board){
    for(int i = 0; i < WIDTH * WIDTH; i++){
        if(d_board[i] == '_') return true;
    }

    return false;
}

__device__ bool validation(char *d_board){

    // Victories on Rows
    if(d_board[0] == d_board[1] && d_board[1] == d_board[2]){
        if(d_board[0] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }
    if(d_board[3] == d_board[4] && d_board[4] == d_board[5]){
        if(d_board[3] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }
    if(d_board[6] == d_board[7] && d_board[7] == d_board[8]){
        if(d_board[6] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }

    // Victories on Columns
    if(d_board[0] == d_board[3] && d_board[3] == d_board[6]){
        if(d_board[0] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }
    if(d_board[1] == d_board[4] && d_board[4] == d_board[7]){
        if(d_board[1] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }
    if(d_board[2] == d_board[5] && d_board[5] == d_board[8]){
        if(d_board[2] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }

    // Victories on Diagonals
    if(d_board[0] == d_board[4] && d_board[4] == d_board[8]){
        if(d_board[4] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }
    if(d_board[2] == d_board[4] && d_board[4] == d_board[6]){
        if(d_board[2] == player){
            display_board(d_board);
            printf("Player 1 [X] wins! \n\n");
            return false;
        } else {
            display_board(d_board);
            printf("Player 2 [O] wins! \n\n");
            return false;
        }
    }

    return true;
}

__device__ int score(char *d_board){

    // Victories on Rows
    if(d_board[0] == d_board[1] && d_board[1] == d_board[2]){
        if(d_board[0] == player){
            return 10;
        } else {
            return -10;
        }
    }
    if(d_board[3] == d_board[4] && d_board[4] == d_board[5]){
        if(d_board[3] == player){
            return 10;
        } else {
            return -10;
        }
    }
    if(d_board[6] == d_board[7] && d_board[7] == d_board[8]){
        if(d_board[6] == player){
            return 10;
        } else {
            return -10;
        }
    }

    // Victories on Columns
    if(d_board[0] == d_board[3] && d_board[3] == d_board[6]){
        if(d_board[0] == player){
            return 10;
        } else {
            return -10;
        }
    }
    if(d_board[1] == d_board[4] && d_board[4] == d_board[7]){
        if(d_board[1] == player){
            return 10;
        } else {
            return -10;
        }
    }
    if(d_board[2] == d_board[5] && d_board[5] == d_board[8]){
        if(d_board[2] == player){
            return 10;
        } else {
            return -10;
        }
    }

    // Victories on Diagonals
    if(d_board[0] == d_board[4] && d_board[4] == d_board[8]){
        if(d_board[4] == player){
            return 10;
        } else {
            return -10;
        }
    }
    if(d_board[2] == d_board[4] && d_board[4] == d_board[6]){
        if(d_board[2] == player){
            return 10;
        } else {
            return -10;
        }
    }

    return 0;
}

__device__ int minmax(char *d_board, int depth, bool isMax){
    int benefit = score(d_board);

    if(benefit == 10) return (benefit - depth);

    if(benefit == -10) return (depth - 10);

    if(emptySlots(d_board) == false) return 0;

    if(isMax){

        int maximumBenefit = -1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){
            if(d_board[i] == '_'){

                d_board[i] = player;

                int tempBenefit = minmax(d_board, depth + 1, !isMax);

                d_board[i] = '_';

                maximumBenefit = tempBenefit > maximumBenefit ? tempBenefit : maximumBenefit;
            }
        }

        return maximumBenefit;

    } else {
        
        int minimumBenefit = 1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){
            if(d_board[i] == '_'){

                d_board[i] = opponent;

                int tempBenefit = minmax(d_board, depth + 1, !isMax);

                d_board[i] = '_';

                minimumBenefit = minimumBenefit > tempBenefit ? tempBenefit : minimumBenefit;

            }
        }

        return minimumBenefit;

    }
}

__device__ void executeMove(char *d_board, bool isPlayer, int finalPosition){
    if(isPlayer) {
        d_board[finalPosition] = player;
    } else {
        d_board[finalPosition] = opponent;
    }
    display_board(d_board);
}

__device__ int nextMove(char *d_board, bool isPlayer){
    
    int initialBenefit;
    int position = -1;
    if(isPlayer){
        initialBenefit = -1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){
            
            if(d_board[i] == '_'){

                d_board[i] = player;
                int tempBenefit = minmax(d_board, 0, false);
                d_board[i] = '_';

                if(initialBenefit < tempBenefit){
                    initialBenefit = tempBenefit;
                    position = i;
                }

            }

        }

    } else {
        initialBenefit = 1000;

        for(int i = 0; i < WIDTH * WIDTH; i++){

            if(d_board[i] == '_'){

                d_board[i] = opponent;
                int tempBenefit = minmax(d_board, 0, true);
                d_board[i] = '_';

                if(initialBenefit > tempBenefit){
                    initialBenefit = tempBenefit;
                    position = i;
                }

            }

        }

    }

    return position;

}

// The MinMax implementation
__global__ void ticTacToe(char *d_board, int *d_isPlayer){

    // display_board(d_board);
    printf("Im here\n");
    printf("TRUE: %d\n", *d_isPlayer);
    printf("Player %c : Opponent %c \n", player, opponent);
    bool isPlayer = true;
    while(validation(d_board) && emptySlots(d_board)){
        int finalPosition = nextMove(d_board, isPlayer);
        executeMove(d_board, isPlayer, finalPosition);
        isPlayer = !isPlayer;
    }

}




int main(void) {

    printf("Tic Tac Toe\n");

    char playerSymbol = 'X';
    char opponentSymbol = 'O';

    cudaCHECK(cudaMemcpyToSymbol(player, &playerSymbol, sizeof(char)));
    cudaCHECK(cudaMemcpyToSymbol(opponent, &opponentSymbol, sizeof(char)));

    const unsigned int size = WIDTH * WIDTH;

    char h_board[size] = {
        '_', '_', '_',
        '_', '_', '_',
        '_', '_', '_'
    };

    char *d_board;

    cudaCHECK(cudaMalloc((void**)&d_board, size * sizeof(char)));
    cudaCHECK(cudaMemcpy(d_board, h_board, size * sizeof(char), cudaMemcpyHostToDevice));

    int h_isPlayer = 1;
    int *d_isPlayer;

    cudaCHECK(cudaMalloc(&d_isPlayer, sizeof(int)));
    cudaCHECK(cudaMemcpy(d_isPlayer, &h_isPlayer, sizeof(int),cudaMemcpyHostToDevice));

    printf("Done\n");

    std::cout << h_isPlayer << std::endl;

    ticTacToe<<<1,1>>>(d_board, d_isPlayer);
    cudaDeviceSynchronize();

    cudaCHECK(cudaMemcpy(h_board, d_board, size * sizeof(char), cudaMemcpyDeviceToHost));
    display_board(h_board);
    return 0;
}

