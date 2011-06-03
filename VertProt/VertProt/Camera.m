//
//  Camera.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Camera.h"


@implementation Camera

@synthesize lookAt = lookAt_;
@synthesize screenOffset = screenOffset_;

- (id) initWithLook:(CGPoint)look
{
    self = [super init];
    
    self.lookAt = look;
    
    return self;
}

- (CGRect) applyToRect:(CGRect)rect
{
    rect.origin = [self applyToPoint:rect.origin];
    
    return rect;
}

- (CGPoint) applyToPoint: (CGPoint) point
{
    point.x += self.lookAt.x + self.screenOffset.x;
    point.y += self.lookAt.y + self.screenOffset.y;
    
    return point;
}

- (void) moveLookAt:(CGPoint)delta
{
    self.lookAt = CGPointMake(self.lookAt.x + delta.x, self.lookAt.y + delta.y);
}

- (void) useScreenSize:(CGRect)screen
{
    self.screenOffset = CGPointMake(screen.size.width / 2, screen.size.height / 2);
}

- (void) dealloc
{
    NSLog(@"Camera dealloc'd");
    [super dealloc];
}

@end
