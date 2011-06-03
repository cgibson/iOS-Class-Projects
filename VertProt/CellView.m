//
//  CellView.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellView.h"
#include "Entity.h"
#import "DefaultGameViewController.h"
#import "WorldViewController.h"

@implementation CellView

@synthesize primaryColor=_primaryColor;
@synthesize secondaryColor=_secondaryColor;
@synthesize level=_level;

- (void) setColorByType:(CellType_t) type
{
    switch(type)
    {
        case CELL_PLAYER:
            self.secondaryColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.3 alpha:1.0];
            self.primaryColor = [UIColor colorWithRed:0.4 green:1.0 blue:0.6 alpha:1.0];
            break;
        case CELL_ENEMY:
            self.secondaryColor = [UIColor colorWithRed:0.6 green:0.1 blue:0.1 alpha:1.0];
            self.primaryColor = [UIColor colorWithRed:0.8 green:0.2 blue:0.2 alpha:1.0];
            break;
    }
}

- (id)initWithFrame:(CGRect)frame CellType:(CellType_t) type Level:(int)level
{
    self = [super initWithFrame:frame];
    if (self) {
        self.level = level;
        [self setColorByType:type];
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"Touches: %d", touch.tapCount);
    if (touch.tapCount == 3 && [self.target isKindOfClass:[DefaultGameViewController class]]) {
            NSLog(@"Recalibrate");
            [(DefaultGameViewController*)self.target callibrateGyro];
    }else if(touch.tapCount == 2 && [self.target isKindOfClass:[WorldViewController class]]) {
        [(DefaultGameViewController*)self.target strike:self.tag];
    }else if(touch.tapCount == 4) {
        
        ((WorldViewController*)self.target).world.gameMode = THUNDERDOME;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect box = self.bounds;
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 4.0f);
    CGRect sizedRect = CGRectMake(box.origin.x + 2.0, box.origin.y + 2.0, box.size.width - 4.0, box.size.height - 4.0);
    CGContextAddEllipseInRect(context, sizedRect);
    CGContextClosePath(context);
    //CGContextSetAlpha(context, (self.level == 0) ? 1.0 : 0.3);
    //CGContextSetAlpha(context, self.level == 0 ? 1.0 : (1.0f / abs(self.level)));
    [self.primaryColor setStroke];
    [self.secondaryColor setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)dealloc
{
    [_primaryColor release];
    [_secondaryColor release];
    [super dealloc];
}

@end
