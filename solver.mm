//
//  solver.m
//  Sudokubot
//
//  Created by Haoest on 4/5/11.
//  Copyright 2011 none. All rights reserved.
//

#import "solver.hpp"

using namespace std;

@implementation solver

@synthesize board;

+(solver*) solverWithPartialBoard: (int[9][9]) partialBoard{
    solver *rv = [[solver alloc] init];
    rv.board = new int*[9];
    for (int i=0; i<9; i++){
        rv.board[i] = new int[9];
    }
    for (int i=0; i<9; i++){
        for (int j=0; j<9; j++){
            rv.board[i][j] = partialBoard[i][j];
        }
    }
    return rv;
}

//return null if no solution
-(int**) trySolve{
    set<int> boxSpace[9][9];
    for (int i=0; i<9; i++){
        for (int j=0; j<9; j++){
            boxSpace[i][j] = getBoxSampleSpace(board, i,j);
        }
    }
    if( trySolveRecursively(board, boxSpace, 0)){
        return board;
    }
    return nil;
}

bool trySolveRecursively(int** board, set<int> boxSpace[9][9], int boxIndex){
    if (boxIndex == 9*9){
        return true;
    }
    set<int> &curBox = boxSpace[boxIndex/9][boxIndex%9];
    if (curBox.size() ==0){ // is prefilled box value
        return trySolveRecursively(board, boxSpace, boxIndex+1);
    }
    for(set<int>::iterator it = curBox.begin(); it != curBox.end(); it++){
        if (isUniqueInRowAndColumn(board, *it, boxIndex)){
            board[boxIndex/9][boxIndex%9] = *it;
            if (trySolveRecursively(board, boxSpace, boxIndex+1)){
                return true;
            }
        }
    }
    board[boxIndex/9][boxIndex%9] = 0;
    return false;
}

bool isUniqueInRowAndColumn(int** board, int boxValue, int boxIndex){
    for (int i=0; i<9; i++){
        //row
        if (board[boxIndex/9][i] == boxValue){
            return false;
        }
        if (board[i][boxIndex%9] == boxValue){
            return false;
        }
    }
    return true;
}

set<int> getBoxSampleSpace(int **currentBoard, int rowPosition, int columnPosition){
    if (currentBoard[rowPosition][columnPosition]>0){
        set<int> empty;
        return empty;
    }
    set<int> rv = getBagOfNine();
    for(int i=0; i<9; i++){
        set<int>::iterator it;
        if ((it = rv.find(currentBoard[rowPosition][i])) != rv.end()){
            rv.erase( it );
        }
        if ((it = rv.find(currentBoard[i][columnPosition])) != rv.end()){
            rv.erase( it );
        }
    }
    return rv;
}

set<int> getBagOfNine(){
    set<int> rv;
    for(int i=1; i<10; i++){
        rv.insert(i);
    }
    return rv;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    for (int i=0; i<9; i++){
        delete board[i];
    }
    delete board;
}

@end