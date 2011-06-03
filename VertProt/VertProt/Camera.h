//
//  Camera.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"


@interface Camera : NSObject {
    
}

@property (nonatomic) CGPoint lookAt;
@property (nonatomic) CGPoint screenOffset;

- (id) initWithLook: (CGPoint) look;
- (CGRect) applyToRect: (CGRect) rect;
- (CGPoint) applyToPoint: (CGPoint) point;
- (void) moveLookAt: (CGPoint)delta;
- (void) useScreenSize:(CGRect)screen;

@end
