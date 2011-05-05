//
//  CFTetrisAppDelegate.m
//  CFTetris
//
//  Created by Gibson, Christopher on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CFTetrisAppDelegate.h"

#import "UglyTetrisViewController.h"

#import "MemoryHound.h"

@implementation CFTetrisAppDelegate

@synthesize engine=_engine;

@synthesize backgrounded=_backgrounded;

@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    [MemoryHound startHound];
    
    NSLog(@"Finished launching with options..");
    
    [self restoreState];
    if (!self.engine)
        self.engine = [[TetrisEngine alloc] initWithHeight:10];
    // [self.tabBarController setEngine:self.engine];
    [[self.tabBarController.viewControllers objectAtIndex:0] setEngine:self.engine];
    [[self.tabBarController.viewControllers objectAtIndex:1] setEngine:self.engine];
    
    [[self.tabBarController.viewControllers objectAtIndex:1] refreshGrid];
    
     
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"WillResignActive");
    [self.engine stopTentative];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"DidEnterBackground");
    [self.engine stop];
    self.backgrounded = true;
    [self saveState];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"WillEnterForeground");
    [[self.tabBarController.viewControllers objectAtIndex:1] refreshGrid];
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"DidBecomeActive");
    //bool runningVal = [self.engine running];
    
    if (self.backgrounded || ![self.engine running])
        [self restoreState];
    else if ([self.engine running]){
        [self.engine start];
    }else{
        
    }
    self.backgrounded = false;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    self.engine.antigravity = [defaults boolForKey:@"antigravity"];
    NSLog(@"Resulting Antigravity: %d", self.engine.antigravity);
    
    [[self.tabBarController.viewControllers objectAtIndex:1] refreshGrid];
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
    [_engine stop];
    [_engine release];
    [_window release];
    [_tabBarController release];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
