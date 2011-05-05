//
//  FirstViewController.h
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TetrisEngine.h"
#import "TetrisView.h"

@interface FirstViewController : UIViewController {
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    IBOutlet TetrisView *tetrisView;
}

- (void) setEngine: (TetrisEngine*)eng;

@property (readwrite, nonatomic, retain) TetrisEngine *engine;

@end
