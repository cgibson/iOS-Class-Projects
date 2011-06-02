//
//  GameViewController.h
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameState.h"
#import "DefaultGameViewController.h"

@interface GameViewController : DefaultGameViewController {
    
}

@property (nonatomic, retain) GameState* state;

- (IBAction) buttonPressed:(UIButton*)sender;

- (void) start;
- (void) stop;
@end
