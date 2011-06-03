//
//  CGPointMath.h
//  Colony
//
//  Created by Gibson, Christopher on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CGPointMath : NSObject {
    
}
+ (CGPoint)  CGPointAddP1:(CGPoint)p1 P2:(CGPoint)p2;

+ (CGPoint)  CGPointSubtractP1:(CGPoint)p1 P2:(CGPoint)p2;

+ (float)    CGPointDistanceP1:(CGPoint)p1 P2:(CGPoint)p2;

+ (CGPoint)  CGPointMult:(CGPoint)p Amount:(float)amt;

+ (float)    CGPointMagnitude:(CGPoint)p;

+ (CGPoint)  CGPointMidpointP1:(CGPoint)p1 P2:(CGPoint) p2;

+ (CGPoint)  CGPointBlendP1:(CGPoint)p1 P2:(CGPoint)p2 Amount:(float)amount;

@end
