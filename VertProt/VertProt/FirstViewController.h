//
//  FirstViewController.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Shape.h"

@interface FirstViewController : GameViewController {

}


- (void) panShape: (Shape*) shape amount: (ShapePanData*)data;

@end
