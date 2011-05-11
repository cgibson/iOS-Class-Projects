//
//  Shape.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shape.h"


@implementation Shape

@synthesize target = target_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
 {
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 CGRect box = self.bounds;
 CGContextBeginPath(context);
 CGContextAddRect(context, box);
 CGContextClosePath(context);
 [[UIColor blackColor] setStroke];
 [[UIColor blackColor] setFill];
 
 CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)dealloc
{
    [super dealloc];
}

@end
