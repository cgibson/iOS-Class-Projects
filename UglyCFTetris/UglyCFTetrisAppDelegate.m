//
//  UglyCFTetrisAppDelegate.m
//  UglyCFTetris
//
//  Created by Gibson, Christopher on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UglyCFTetrisAppDelegate.h"

#import "UglyTetrisViewController.h"

@implementation UglyCFTetrisAppDelegate


@synthesize window=_window;
@synthesize engine=_engine;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    NSLog(@"Finished launching with options..");
    
    [self restoreState];
    if (!self.engine)
        self.engine = [[TetrisEngine alloc] initWithHeight:10];
    [self.viewController setEngine:self.engine];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self.viewController refreshGrid];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"WillResignActive");
    [self.engine stop];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"DidEnterBackground");
    [self.engine stop];
    [self saveState];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"WillEnterForeground");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"DidBecomeActive");
    bool runningVal = [self.engine running];
    
    if(!runningVal)
    [self restoreState];
    
    if(runningVal){
        NSLog(@"Something?");
        [self.engine start];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.engine.antigravity = [defaults boolForKey:@"Antigravity"];
    [defaults synchronize];
    
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"WillTerminate");
    [self.engine stop];
    [self saveState];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_engine release];
    [super dealloc];
}

- (void)saveState
{
    NSLog(@"Attempting to SAVE state");
    NSDictionary* state = [self.engine currentState];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:state forKey:@"gameState"];
    [defaults synchronize];
}

- (void)restoreState
{
    
    
    NSLog(@"Attempting to RESTORE state");
    //if(self.engine)
    //{
        //[self.engine removeObserver:self forKeyPath:@"score"];
        //[self.engine removeObserver:self forKeyPath:@"timeStep"];
        //[self.engine removeObserver:self forKeyPath:@"gridVersion"];
        //[self.engine release];
    //}
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* state = [defaults objectForKey:@"gameState"];
    if (state)
        [[self.engine initWithState:state] retain];

}

@end
