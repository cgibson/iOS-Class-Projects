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
#import "WorldViewController.h"
#import "World.h"
#import "Vec3.h"

@interface DefaultGameViewController : WorldViewController {
    CMMotionManager *motionManager;
}

@property (nonatomic, retain, readonly) Vec3 *gyroVec; 
@property (nonatomic, readonly) BOOL gyroCalibrated;
@property (nonatomic, readonly) CGPoint gyroOffset;

@property (nonatomic, readonly) BOOL gyroEnabled;

- (void) initializeGyro;
- (void) callibrateGyro;

- (void) start;
- (void) stop;

@end


