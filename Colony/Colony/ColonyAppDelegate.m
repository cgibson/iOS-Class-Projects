//
//  ColonyAppDelegate.m
//  Colony
//
//  Created by Gibson, Christopher on 5/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColonyAppDelegate.h"
#import "RootViewController.h"
#import "MenuController.h"

@implementation ColonyAppDelegate


@synthesize window=_window;
@synthesize state=_state;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self restoreState];
    MenuController *root = [[MenuController alloc] initWithNibName:@"MainMenuView" bundle:nil];
    root.state = self.state;
    
    [self.navigationController pushViewController:root animated:NO];
    [root release];
    
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // TERRIBLE TERRIBLE CODE
    //int topControllerIndex = [self.navigationController.viewControllers count] - 1;
    //UIViewController *controller = [self.navigationController.viewControllers objectAtIndex: topControllerIndex-1];
    UIViewController *controller = self.navigationController.topViewController;
    if([controller conformsToProtocol:@protocol(Running)]) {
        [(UIViewController<Running>*) controller pause];
    }
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    UIViewController *controller = self.navigationController.topViewController;
    if([controller conformsToProtocol:@protocol(Running)]) {
        [(UIViewController<Running>*) controller unpause];
    }
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)printState
{
    NSLog(@"Game running: %@", self.state.running ? @"YES" : @"NO");
}

- (void)saveState
{
    NSLog(@"Attempting to SAVE state");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.state toDict] forKey:@"gameState"];
    [defaults synchronize];
}

- (void)restoreState
{
    
    NSLog(@"Attempting to RESTORE state");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.state = [[[GameState alloc] initWithDict:[defaults objectForKey:@"gameState"]] autorelease];
    NSLog(@"So far so good");

    [self printState];
    
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
