//
//  CFTetrisAppDelegate.h
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"

@interface CFTetrisAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

}

- (void) saveState;
- (void) restoreState;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) TetrisEngine *engine;

@property (nonatomic) bool backgrounded;

@end
