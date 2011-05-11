//
//  World.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface World : NSObject {
    @private
    CGRect bounds;
}
    
@property (nonatomic, retain, readonly) NSMutableArray *objects;

- (Entity*) objectwithID: (int) objId;
- (id) initWithRect: (CGRect) rect;
- (void) addObject: (Entity*) obj;


@end
