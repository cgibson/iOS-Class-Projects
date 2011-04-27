//
//  UglyTetrisViewController.h
//  UglyTetris
//
//  Created by Gibson, Christopher on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "TetrisEngine.h"

@interface UglyTetrisViewController : UIViewController {
@private
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *scoreLabel;
    //UILabel **gridLabels;
    
}

- (IBAction) buttonPressed:(UIButton*)sender;
- (void) setEngine: (TetrisEngine*)eng;
- (void) refreshView;
- (void) refreshGrid;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context;

@property (readwrite, nonatomic, retain) TetrisEngine *engine;
@property (readwrite, retain) NSMutableArray *newGridLabels;

@end
