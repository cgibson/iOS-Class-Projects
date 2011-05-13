//
//  Shape.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Shape.h"


@implementation ShapePanData
@synthesize distance = distance_, velocity = velocity_;
@synthesize state = state_;
@end

@implementation Shape

@synthesize target = target_;
@synthesize panAction = panAction_;
@synthesize lastPan = lastPan_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGestures];
    }
    return self;
}

- (void) setupGestures
{
    UIPanGestureRecognizer * pgn =
    [[UIPanGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handlePanGesture:)];
    
    pgn.minimumNumberOfTouches = 1;
    pgn.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pgn];
    [pgn release];
}

- (void) handlePanGesture: (UIPanGestureRecognizer*)sender
{
    if (!self.target)
        return;
    
    CGPoint translate = [sender translationInView:self];    
    if (sender.state == UIGestureRecognizerStateBegan)
        self.lastPan = translate;
    
    if (sender.state != UIGestureRecognizerStateBegan &&
        sender.state != UIGestureRecognizerStateChanged &&
        sender.state != UIGestureRecognizerStateEnded)
        return;
    
    // Do the conversion into an <x,y> delta
    CGPoint delta = translate;
    delta.x -= self.lastPan.x;
    delta.y -= self.lastPan.y;
    
    // Populate an object to pass all the data into our target-action
    ShapePanData * data = [[ShapePanData alloc] init];
    data.distance = delta;
    data.state = sender.state;
    data.velocity = [sender velocityInView:self];
    
    // Call the target-action
    [self.target performSelector:self.panAction
                      withObject:self
                      withObject:data];
    
    [data release];
    self.lastPan = translate;
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
