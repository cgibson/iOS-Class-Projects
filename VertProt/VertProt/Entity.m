//
//  Entity.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

@interface Entity()
    @property (nonatomic) int objId;
    @property (nonatomic) int type;
@end

@implementation Entity

@synthesize objId = objId_;
@synthesize type = type_;
@synthesize location = location_;

- (void)dealloc
{
    [super dealloc];
}

- (id) initWithType:(int)type location:(CGRect)rect {
    static int nextId = 0;
    
    self = [super init];
    self.objId = nextId++;
    self.type = type;
    
    return self;
}

@end
