//
//  UglyCFTetrisAppDelegate.h
//  UglyCFTetris
//
//  Created by Gibson, Christopher on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"

@class UglyTetrisViewController;

@interface UglyCFTetrisAppDelegate : NSObject <UIApplicationDelegate> {
    
}

- (void) saveState;
- (void) restoreState;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) TetrisEngine *engine;

@property (nonatomic, retain) IBOutlet UglyTetrisViewController *viewController;



@end
