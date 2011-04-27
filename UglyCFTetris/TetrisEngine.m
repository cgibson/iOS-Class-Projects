//
//  TetrisEngine.m
//  R1
//
//  Created by John Bellardo on 3/8/11.
//  Copyright 2011 California State Polytechnic University, San Luis Obispo. All rights reserved.
//

#import "TetrisEngine.h"

#define TetrisPieceBlocks 4
#define TetrisPieceRotations 4
struct TetrisPiece {
	NSInteger name;
	struct {
		NSInteger colOff, rowOff;
	} offsets[TetrisPieceRotations][TetrisPieceBlocks];
};

// Static array that defines all rotations for every piece.
// Each <x,y> point is an offset from the center of the piece.
#define TetrisNumPieces 7
static struct TetrisPiece pieces[TetrisNumPieces] = {
	{ ITetromino,	{
						{ {-2, 0}, { -1, 0}, { 0, 0 }, {1, 0} },  // 0 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {0, 3} },  // 90 deg.
						{ {-2, 0}, { -1, 0}, { 0, 0 }, {1, 0} },  // 180 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {0, 3} },  // 270 deg.
					} },
	{ JTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {-1, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 0, 2 }, {1, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {1, 0} }, // 180 deg.
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {0, 2} }, // 270 deg.
					} },
	{ LTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {1, 1} }, // 0 deg.
						{ {0, 0}, { 1, 0}, { 0, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {-1, 0} }, // 180 deg.
						{ {-1, 2}, { 0, 2}, { 0, 1 }, {0, 0} }, // 270 deg.
					} },
	{ OTetromino,	{
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 0 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 90 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 180 deg.
						{ {-1, 0}, { 0, 0}, { -1, 1 }, {0, 1} }, // 270 deg.
					} },
	{ STetromino,	{
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {1, 1} }, // 0 deg.
						{ {1, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 0}, { 0, 0}, { 0, 1 }, {1, 1} }, // 180 deg.
						{ {1, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 270 deg.
					} },
	{ TTetromino,	{
						{ {-1, 0}, { 0, 0}, { 1, 0 }, {0, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {0, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 1}, { 1, 1 }, {0, 0} }, // 180 deg.
						{ {0, 1}, { 1, 0}, { 1, 1 }, {1, 2} }, // 270 deg.
					} },
	{ ZTetromino,	{
						{ {-1, 1}, { 0, 0}, { 1, 0 }, {0, 1} }, // 0 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {1, 2} }, // 90 deg.
						{ {-1, 1}, { 0, 0}, { 1, 0 }, {0, 1} }, // 180 deg.
						{ {0, 0}, { 0, 1}, { 1, 1 }, {1, 2} }, // 270 deg.
					} }
};

/* EXTENSION MAGIC */
@interface TetrisEngine ()
@property (nonatomic) int timeStep;
@property (nonatomic) int score;
@property (nonatomic) int height;
@property (nonatomic) int gridVersion;
@end

@implementation TetrisEngine

@synthesize height = _height;
@synthesize score = _score;
@synthesize timeStep = _timeStep;
@synthesize newGrid = _newGrid;
@synthesize gridVersion = _gridVersion;
@synthesize antigravity = _antigravity;

- (id) init
{
	return [self initWithHeight: 20];
}

- (id) initWithHeight: (int) h
{
	self = [super init];
	if (self) {
		srandom(time(0));
		self.height = h;
		//self->grid = malloc(sizeof(int) * TetrisArrSize(self->height));
        self.newGrid = [NSMutableArray arrayWithCapacity:TetrisArrSize(self.height)];
        for(int i = 0; i < TetrisArrSize(self.height); i++)
        {
            [self.newGrid addObject: [NSNumber numberWithInt:NoTetromino]];
        }
	}
    [self reset];
	return self;
}

- (id) initWithState:(NSDictionary *)state
{
    NSLog(@"State given, LOADING state");
    self = [self initWithHeight:10];
    //*
    self.timeStep = [(NSNumber*)[state objectForKey:@"timeStep"] intValue];
    NSLog(@"Set timestep to: %d", self.timeStep);
    self.score = [(NSNumber*)[state objectForKey:@"score"] intValue];
    self.height = [(NSNumber*)[state objectForKey:@"height"] intValue];
    self.gridVersion = [(NSNumber*)[state objectForKey:@"gridVersion"] intValue];
    self->pieceRow = [(NSNumber*)[state objectForKey:@"pieceRow"] intValue];
    self->pieceCol = [(NSNumber*)[state objectForKey:@"pieceCol"] intValue];
    self->pieceRotation = [(NSNumber*)[state objectForKey:@"pieceRotation"] intValue];
    self->gameOver = [(NSNumber*)[state objectForKey:@"gameOver"] boolValue];
    bool runningVal = [(NSNumber*)[state objectForKey:@"running"] boolValue];
    if(runningVal)
    {
        NSLog(@"RESTARTING");
        [self start];
    }
    self.newGrid = [NSMutableArray arrayWithArray:[state objectForKey:@"grid"]];
    
    int currentPiece = [(NSNumber*)[state objectForKey:@"current"] intValue];
    currPiece = &pieces[currentPiece-1];
     //*/
    return self;
}

- (void) dealloc
{
    [self.newGrid release];
    [super dealloc];
}

// Add the next floating piece to the game board
- (void) nextPiece
{
	currPiece = &pieces[ ((random() % (TetrisNumPieces * 113)) + 3) % TetrisNumPieces];
	pieceCol = [self width] / 2;
	pieceRow = self.height - 1;
	pieceRotation = 0;
}

// Returns YES if the current floating piece will colide with another game board object or
//  edge given a new row / column / rotation value
- (BOOL) currPieceWillCollideAtRow: (int) row col: (int) col rotation: (int) rot
{
	if (!currPiece)
		return NO;
	
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		int checkRow = row + currPiece->offsets[rot][blk].rowOff;
		int checkCol = col + currPiece->offsets[rot][blk].colOff;
		
		if (checkRow < 0 || checkCol < 0 || checkCol >= [self width])
			return YES;

		// Enables the board to extend upwards past the screen.  Useful
		// when rotating pieces very early in their fall.
		if (checkRow >= self.height)
			continue;
		
		//if (self->grid[TetrisArrIdx(checkRow, checkCol)] != NoTetromino)
		//	return YES;
        if ([[self.newGrid objectAtIndex:TetrisArrIdx(checkRow, checkCol)] intValue] != NoTetromino)
            return YES;
	}

	return NO;
}

// Returns YES if any part of the current piece is off the grid
- (BOOL) currPieceOffGrid
{
	if (!currPiece)
		return NO;
	
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		int checkRow = pieceRow + currPiece->offsets[pieceRotation][blk].rowOff;
		int checkCol = pieceCol + currPiece->offsets[pieceRotation][blk].colOff;
		
		if (checkRow < 0 || checkRow >= self.height ||
			checkCol < 0 || checkCol >= [self width])
			return YES;
	}
	
	return NO;
}

- (void) slideLeft
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol - 1 rotation: pieceRotation])
		pieceCol--;
    self.gridVersion++;
}

- (void) slideRight
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol + 1 rotation: pieceRotation])
		pieceCol++;
    self.gridVersion++;
}

- (void) rotateCW
{
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: (pieceRotation + 1) % TetrisPieceRotations])
		pieceRotation = (pieceRotation + 1) % TetrisPieceRotations;
    
    self.gridVersion++;
}

- (void) rotateCCW
{
	int newRot = pieceRotation - 1;
	while (newRot < 0)
		newRot += TetrisPieceRotations;
	if (![self currPieceWillCollideAtRow: pieceRow col: pieceCol
								rotation: newRot])
		pieceRotation = newRot;
    
    self.gridVersion++;
}

- (int) pieceAtRow: (int) row column: (int)col
{
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
		if (row == (currPiece->offsets[pieceRotation][blk].rowOff + pieceRow) &&
			col == (currPiece->offsets[pieceRotation][blk].colOff + pieceCol) )
			return currPiece->name;
	}
	//return self->grid[TetrisArrIdx(row, col)];
    return [[self.newGrid objectAtIndex:TetrisArrIdx(row, col)] intValue];
}

- (void) commitCurrPiece
{
	// Copy current floating piece into grid state
	for (int blk = 0; currPiece && blk < TetrisPieceBlocks; blk++) {
        [self.newGrid replaceObjectAtIndex:TetrisArrIdx(currPiece->offsets[pieceRotation][blk].rowOff + pieceRow,
                                                         currPiece->offsets[pieceRotation][blk].colOff + pieceCol) withObject:[NSNumber numberWithInt: currPiece->name]];
	}

	currPiece = NULL;
	
	// Check for lines that can be eliminated from grid
	int elimRowCnt = 0;
	for (int dstRow = 0; dstRow < self.height; dstRow++) {
		int checkCol = 0;
		for (; checkCol < TetrisNumCols &&
			 //self->grid[TetrisArrIdx(dstRow, checkCol)] != NoTetromino; checkCol++);
             [[self.newGrid objectAtIndex:TetrisArrIdx(dstRow, checkCol)] intValue] != NoTetromino; checkCol++);
		if (checkCol < TetrisNumCols)
			continue;
		
		// Copy grid state into board
		elimRowCnt++;
		for (int srcRow = dstRow + 1; srcRow < self.height; srcRow++)
			for (int srcCol = 0; srcCol < TetrisNumCols; srcCol++) {
				//self->newGrid[TetrisArrIdx(srcRow - 1, srcCol)] =
				//	self->grid[TetrisArrIdx(srcRow, srcCol)];
                
				[self.newGrid replaceObjectAtIndex:TetrisArrIdx(srcRow - 1, srcCol) withObject:[self.newGrid objectAtIndex:TetrisArrIdx(srcRow, srcCol)]];
            }

		for (int col = 0; col < TetrisNumCols; col++) {
			//self->grid[TetrisArrIdx(self->height - 1, col)] = NoTetromino;
            
            [[self.newGrid objectAtIndex:TetrisArrIdx(self.height-1, col)] release];
            
            [self.newGrid replaceObjectAtIndex:TetrisArrIdx(self.height-1, col) withObject:[NSNumber numberWithInt:NoTetromino]];
        }
        
        self.gridVersion++;
		dstRow--;
	}
    
    switch( elimRowCnt ) {
        case 0:
            break;
        case 1:
            self.score += 100;
            break;
        case 2:
            self.score += 250;
            break;
        case 3:
            self.score += 450;
            break;
        case 4:
            self.score += 700;
            break;
        default:
            self.score += 1000;
            break;
    }
}

- (int) width
{
	return TetrisNumCols;
}

- (void) advance
{
	if (gameOver)
		return;
	
	self.timeStep++;
	if (!currPiece)
		[self nextPiece];
	else if (![self currPieceWillCollideAtRow: pieceRow - 1 col: pieceCol  rotation: pieceRotation])
		pieceRow--;
	else if (![self currPieceOffGrid])
		[self commitCurrPiece];
	else
		gameOver = YES;
    self.gridVersion++;
}

- (void) reset
{
    self.score = 0;
    self.timeStep = 0;
    for( int block = 0; block < TetrisArrSize(self.height); block ++) {
        [self.newGrid replaceObjectAtIndex:block withObject:[NSNumber numberWithInt:NoTetromino]];
    }
    self.gridVersion++;
    [self nextPiece];
    pieceRow += 1;
    self.gridVersion++;
    gameOver = false;
}

- (void) gameStep
{
    NSLog(@"Advancing...");
    [self advance];
}

- (void) start
{
    timerRunning = true;
    if (!stepTimer) {
    NSLog(@"Something...");
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
        stepTimer = [[NSTimer alloc] initWithFireDate:fireDate
                                             interval:1.0
                                               target:self
                                             selector:@selector(gameStep)
                                             userInfo:nil
                                              repeats:YES];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:stepTimer forMode:NSDefaultRunLoopMode];
    }
    
}

- (void) stop
{
    timerRunning = false;
    if (stepTimer) {
        [stepTimer invalidate];
        stepTimer = nil;
    }
}

- (bool) running
{
    return timerRunning;
}

- (void) pieceDown
{
    if([self running])
    {
       //[self advance];
       while(![self currPieceWillCollideAtRow: pieceRow - 1 col: pieceCol  rotation: pieceRotation])
       {
           pieceRow--;
       }
       self.gridVersion++;
    }
}

- (void) pieceUp
{
    if([self running] && self.antigravity)
    {
        pieceRow++;
        if(pieceRow > self.height - 1)
            pieceRow = self.height - 1;
        self.gridVersion++;
    }
}

- (NSDictionary*) currentState
{
    
    NSDictionary* state = [[NSDictionary alloc] init];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     @"timeStep",
                     @"score",
                     @"height",
                     @"gridVersion",
                     @"pieceRow",
                     @"pieceCol",
                     @"pieceRotation",
                     @"gameOver",
                     @"running",
                     @"grid",
                     @"current",
                     nil];
    
    // A little sanity check
    if(!currPiece)
    {
        currPiece = &pieces[JTetromino];
    }
    
    NSArray *objects = [NSArray arrayWithObjects:
                        [NSNumber numberWithInt:self.timeStep],
                        [NSNumber numberWithInt:self.score],
                        [NSNumber numberWithInt:self.height],
                        [NSNumber numberWithInt:self.gridVersion],
                        [NSNumber numberWithInt:pieceRow],
                        [NSNumber numberWithInt:pieceCol],
                        [NSNumber numberWithInt:pieceRotation],
                        [NSNumber numberWithBool:gameOver],
                        [NSNumber numberWithBool:timerRunning],
                        self.newGrid,
                        [NSNumber numberWithInt:currPiece->name],
                        nil];
    
    state = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    
    return state;
}

@end
