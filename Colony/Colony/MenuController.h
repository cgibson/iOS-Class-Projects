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

@interface MenuController : UIViewController {
    
}

@property (nonatomic, retain) GameState* state;
@property (nonatomic, retain) GameViewController* GVController;

- (IBAction) buttonPressed:(UIButton*)sender;

@end
