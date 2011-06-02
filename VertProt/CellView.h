//
//  CellView.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shape.h"
#import "Entity.h"

@interface CellView : Shape {
    
}

@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) UIColor *secondaryColor;
@property (nonatomic) int level;

- (id)initWithFrame:(CGRect)frame CellType:(CellType_t) type Level:(int)level;

@end
