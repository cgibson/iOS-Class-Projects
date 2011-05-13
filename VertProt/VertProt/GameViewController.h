//
//  GameViewController.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import "World.h"

@interface Vec3 : NSObject {
    
}

@property (nonatomic) float x;
@property (nonatomic) float y;
@property (nonatomic) float z;

- (id) initWithVals:(float)x y:(float)y z:(float) z;

@end



@interface GameViewController : UIViewController {
    
}

@property (nonatomic, retain, readonly) World *world;
@property (nonatomic, retain, readonly) CADisplayLink *dispLink;
@property (nonatomic, retain, readonly) CMMotionManager *motionManager;
@property (nonatomic, retain, readonly) Vec3 *gyroVec; 

- (void) frame: (CADisplayLink*)link;
- (void) start;
- (void) stop;
- (void) initializeGyro;

@end

