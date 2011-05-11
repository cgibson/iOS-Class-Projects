//
//  Entity.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYPE_CELL 1

@interface Entity : NSObject {
    
}

@property (nonatomic, readonly) int objId;
@property (nonatomic, readonly) int type;
@property (nonatomic) CGRect location;

- (id) initWithType: (int) type location:(CGRect) rect;

@end
