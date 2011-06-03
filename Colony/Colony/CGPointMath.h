//
//  CGPointMath.h
//  Colony
//
//  Created by Gibson, Christopher on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

CGPoint CGPointSubtract(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

float CGPointDistance(CGPoint p1, CGPoint p2)
{
    return sqrt( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}

CGPoint CGPointMult(CGPoint p, float amt)
{
    return CGPointMake(p.x * amt, p.y * amt);
}

float CGPointMagnitude(CGPoint p)
{
    return sqrt(pow(p.x, 2) + pow(p.y, 2));
}

CGPoint CGPointMidpoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}