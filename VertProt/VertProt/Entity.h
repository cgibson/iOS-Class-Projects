//
//  Entity.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CellType_t{CELL_PLAYER, CELL_ENEMY} CellType_t;

#define TYPE_CELL 1

@interface Entity : NSObject {
}

@property (nonatomic, readonly) int objId;
@property (nonatomic, readonly) int version;
@property (nonatomic) CGPoint location;
@property (nonatomic) CGPoint size;
@property (nonatomic) CellType_t cellType;
@property (nonatomic) int level;

- (id) initWithType: (CellType_t) type location:(CGPoint)loc size:(CGPoint)size level:(int)level;
- (void) refresh;
- (CGRect) getFrame;

@end
