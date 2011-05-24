//
//  RootViewController.h
//  GradeBookVI
//
//  Created by Gibson, Christopher on 5/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeData.h"

@interface GradeDataViewController : UITableViewController {

}

@property (nonatomic, retain) GradeData *gradeData;

- (void) loadURL;
- (void) saveURL:(NSString*)newUrl;

@end
