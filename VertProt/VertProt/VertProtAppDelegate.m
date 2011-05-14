//
//  VertProtAppDelegate.m
//  VertProt
//
//  Created by Gibson, Christopher on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VertProtAppDelegate.h"
#import "World.h"
#import "MemoryHound.h"

@interface VertProtAppDelegate()
@property (nonatomic, retain) World *world;
@end


@implementation VertProtAppDelegate

@synthesize window=_window;
@synthesize world =world_;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[MemoryHound startHound];
    
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    CGRect worldRect = CGRectMake(0, 0, 500, 500);
    
    if(!self.world) {
        self.world = [[[World alloc] initWithRect:worldRect] autorelease];
    }
    
    NSLog(@"References for World: %d", [self.world retainCount]);
    
    // Main Cell
    Entity *obj = [[[Entity alloc] initWithType:1 location:CGPointMake(0,0) size:CGPointMake(60, 60)] autorelease];
    [self.world addObject:obj];
    
    [self.world.camera useScreenSize:self.tabBarController.view.bounds];
    
    [[self.tabBarController.viewControllers objectAtIndex:0] setWorld:self.world];
    
    [[self.tabBarController.viewControllers objectAtIndex:1] setWorld:self.world];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
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

- (void)dealloc
{
    NSLog(@"Releasing delegate!");
    [world_ release];
    [_window release];
    [_tabBarController release];
    [super dealloc];
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
