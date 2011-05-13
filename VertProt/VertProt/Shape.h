//
//  Shape.h
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShapePanData : NSObject {
}
@property (nonatomic) CGPoint distance, velocity;
@property (nonatomic) UIGestureRecognizerState state;
@end

@interface Shape : UIView {
    
}

@property (nonatomic) SEL panAction;
@property (nonatomic) CGPoint lastPan;
@property (nonatomic, assign) id target;

- (void) setupGestures;
- (void) handlePanGesture: (UIPanGestureRecognizer*)sender;
- (id) initWithFrame:(CGRect)frame;
@end
