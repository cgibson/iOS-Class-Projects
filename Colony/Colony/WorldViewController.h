//
//  WorldViewController.h
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "World.h"


@interface WorldViewController : UIViewController {
    
}

@property (nonatomic, retain, readonly) World *world;

- (void) loadViewObjects;
- (void) removeListeners;
- (void) setWorld: (World*) world;
- (void) addFakeWorld;
@end
