//
//  TetrisView.h
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TetrisView : UIView {
    
}

- (id) initWithRows: (int) rows columns:(int) columns;

- (void) setColor: (UIColor*)color forRow: (int) row column:(int)col;

- (void) drawRect:(CGRect)rect;

- (void) setRows:(int)rows;

- (void) setColumns:(int)columns;


@property (readonly, nonatomic) int rows;

@property (readonly, nonatomic) int columns;

@property (readwrite, retain) NSMutableArray *grid;

@end
