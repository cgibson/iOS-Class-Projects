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
    @property (nonatomic) int version;
@end

@implementation Entity

@synthesize objId = objId_;
@synthesize location = location_;
@synthesize size = size_;
@synthesize version = version_;
@synthesize cellType=_cellType;
@synthesize level=_level;
- (void)dealloc
{
    NSLog(@"Entity %d dealloc'd", objId_);
    [super dealloc];
}

- (id) initWithType:(CellType_t)type location:(CGPoint)loc size:(CGPoint)size level:(int)level {
    static int nextId = 0;
    self = [super init];
    
    self.objId = nextId++;
    self.cellType = type;
    self.location = loc;
    self.size = size;
    self.version = 0;
    self.level = level;
    
    NSLog(@"Entity created");
    
    return self;
}

- (void) refresh
{
    if(!self)
    {
        NSLog(@"Error, modifying object that doesn't exist");
    }
    self.version++;
}

- (CGRect) getFrame
{
    return CGRectMake(self.location.x - self.size.x / 2., self.location.y - self.size.y / 2., self.size.x, self.size.y);
}

@end
