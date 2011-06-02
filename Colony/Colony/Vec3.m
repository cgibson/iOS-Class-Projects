//
//  Vec3.m
//  Colony
//
//  Created by Gibson, Christopher on 6/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vec3.h"


@implementation Vec3
@synthesize x=_x;
@synthesize y=_y;
@synthesize z=_z;

- (id) initWithValsX:(float)x Y:(float)y Z:(float)z
{
    self = [super init];
    
    if(self)
    {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
}

@end