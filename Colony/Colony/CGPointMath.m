//
//  CGPointMath.m
//  Colony
//
//  Created by Gibson, Christopher on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CGPointMath.h"


@implementation CGPointMath


+ (CGPoint)  CGPointAddP1:(CGPoint)p1 P2:(CGPoint)p2
{
    
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

+ (CGPoint)  CGPointSubtractP1:(CGPoint)p1 P2:(CGPoint)p2
{
    
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

+ (float)    CGPointDistanceP1:(CGPoint)p1 P2:(CGPoint)p2
{
    
    return sqrt( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}

+ (CGPoint)  CGPointMult:(CGPoint)p Amount:(float)amt
{
    
    return CGPointMake(p.x * amt, p.y * amt);
}

+ (float)    CGPointMagnitude:(CGPoint)p
{
    
    return sqrt(pow(p.x, 2) + pow(p.y, 2));
}

+ (CGPoint)  CGPointMidpointP1:(CGPoint)p1 P2:(CGPoint) p2
{
    
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

+ (CGPoint)  CGPointBlendP1:(CGPoint)p1 P2:(CGPoint)p2 Amount:(float)amount
{
    
    return CGPointMake(p1.x * amount + p2.x * (1.0 - amount), p1.y * amount + p2.y * (1.0 - amount));
}


@end