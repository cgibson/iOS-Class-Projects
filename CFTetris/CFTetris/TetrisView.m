//
//  TetrisView.m
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TetrisView.h"

@interface TetrisView ()
@property (nonatomic) int columns;
@property (nonatomic) int rows;
@end

@implementation TetrisView


@synthesize grid = _grid;
@synthesize columns = _columns;
@synthesize rows = _rows;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) initWithRows: (int) rows columns:(int) columns
{
    NSLog(@"initWithRows");
	self = [super init];
    self.rows = rows;
    self.columns = columns;
	if (self) {
        for(int i = 0; i < rows * columns; i++)
        {
            [self.grid addObject: [UIColor colorWithRed:1.0
                                                  green:1.0 
                                                   blue:1.0 
                                                  alpha:1.0]];
        }
	}
	return self;
}

- (void) setColor: (UIColor*)color forRow: (int) row column:(int)col
{
    
    [self setNeedsDisplay];
}


- (void) drawRect:(CGRect)rect
{
    NSLog(@"Redrawing Rect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect box = self.bounds;
    CGContextBeginPath(context);
    CGContextAddRect(context, box);
    CGContextClosePath(context);
    [[UIColor blackColor] setStroke];
    [[UIColor blackColor] setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    float stepWidth = box.size.width / self.columns;
    
    float stepHeight = box.size.height / self.rows;
    
    
    for (int i = 0; i < self.rows; i++)
    {
        for (int j = 0; j < self.columns; j++)
        {
            CGRect block = CGRectMake(j * stepWidth+1, i * stepHeight+1, stepWidth-2, stepHeight-2);
            CGContextBeginPath(context);
            CGContextAddRect(context, block);
            CGContextClosePath(context);
            [[UIColor blackColor] setStroke];
            [[UIColor yellowColor] setFill];
            
            CGContextDrawPath(context, kCGPathFillStroke);
        }

    }
    
}

- (void) refreshGrid
{
    NSLog(@"Refreshing");
	if (self) {
        for(int i = 0; i < self.rows * self.columns; i++)
        {
            [self.grid addObject: [UIColor colorWithRed:1.0
                                                  green:1.0 
                                                   blue:1.0 
                                                  alpha:1.0]];
        }
	}
}

- (void) setRows:(int)rows
{
    _rows = rows;
    [self refreshGrid];
}

- (void) setColumns:(int)columns
{
    _columns = columns;
    [self refreshGrid];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}

@end
