//
//  World.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"
#import "Camera.h"
#import "Player.h"

@interface World : NSObject {
    @private
    CGRect bounds;
}

@property (nonatomic, retain, readonly) NSMutableArray *objects;
@property (nonatomic, retain, readonly) Player *player;
@property (nonatomic, retain, readonly) Camera *camera;
@property (nonatomic) bool objectsWrap;

- (Entity*) objectWithID: (int) objId;
- (id) initWithRect: (CGRect) rect;
- (void) setCamera: (Camera*) cam;
- (void) addObject: (Entity*) obj;
- (void) refreshAll;
- (void) frame: (CFTimeInterval)elapsed;
- (void) buildCamera:(CGPoint)point;

@end
