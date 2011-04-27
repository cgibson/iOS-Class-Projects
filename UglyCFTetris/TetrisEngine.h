//
//  TetrisEngine.h
//  R1
//
//  Created by John Bellardo on 3/8/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NoTetromino 0
#define ITetromino 1
#define JTetromino 2
#define LTetromino 3
#define OTetromino 4
#define STetromino 5
#define TTetromino 6
#define ZTetromino 7

#define TetrisNumCols 10
#define TetrisArrSize(rows) ( (rows) * TetrisNumCols )
#define TetrisArrIdx(row, col) ( (row) * TetrisNumCols + (col) )

@interface TetrisEngine : NSObject {
@private
	//int *grid;
	struct TetrisPiece *currPiece;
	int pieceRow, pieceCol, pieceRotation;
	BOOL gameOver;
    NSTimer *stepTimer;
    bool timerRunning;
}

- (id) init;
- (id) initWithHeight: (int) height;
- (id) initWithState: (NSDictionary*) state;
- (int) width;

- (void) slideLeft;
- (void) slideRight;
- (void) rotateCW;
- (void) rotateCCW;
- (void) advance;

- (int) pieceAtRow: (int) row column: (int)col;
- (void) nextPiece;
- (void) commitCurrPiece;
- (BOOL) currPieceWillCollideAtRow: (int) row col: (int) col rotation: (int) rot;
- (BOOL) currPieceOffGrid;
- (void) reset;

- (void) start;
- (void) stop;
- (bool) running;

- (void) pieceDown;
- (void) pieceUp;

- (NSDictionary*) currentState;

@property (readonly, nonatomic) int timeStep;
@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) int height;
@property (readwrite, retain) NSMutableArray *newGrid;
@property (readonly, nonatomic) int gridVersion;
@property (readwrite, nonatomic) bool antigravity;

@end