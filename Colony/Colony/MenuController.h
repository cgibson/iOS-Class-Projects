//
//  MenuController.h
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "WorldViewController.h"
#import "GameViewController.h"
#import "Running.h"

@interface MenuController : UIViewController <Running>{
    
}

@property (nonatomic, retain) GameState* state;
@property (nonatomic, retain) WorldViewController* GVController;

- (IBAction) buttonPressed:(UIButton*)sender;

- (void) stop;
- (void) start;

@end
