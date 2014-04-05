//
//  AppDelegate.m
//  IndyFoodTrucks
//
//  Created by sj singh on 4/1/14.
//  Copyright (c) 2014 AppDar. All rights reserved.
//

#import "AppDelegate.h"
#import "MSDynamicsDrawerViewController.h"
#import "MSDynamicsDrawerStyler.h"
#import "MenuViewController.h"
#import "MapViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate () <MSDynamicsDrawerViewControllerDelegate>

@property (nonatomic, strong) UIImageView *windowBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"haTczq6g3pIpm2icxtsnjlNOf8daXRXnXBEw1eOA"
                  clientKey:@"eEB7Vqj0JPtI7GnBLLOuTHGAeknefMDUROsoikXN"];
    
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], NSForegroundColorAttributeName,
                                      nil];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#6faea4"]];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // Override point for customization after application launch.
    self.dynamicsDrawerViewController = (MSDynamicsDrawerViewController *)self.window.rootViewController;
    self.dynamicsDrawerViewController.delegate = self;
    
    // Add some example stylers
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerResizeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self.dynamicsDrawerViewController addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];
    
    MenuViewController *menuViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    MapViewController *mapViewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    
    mapViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setDrawerViewController:menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    // Transition to the first view controller
    UINavigationController *paneNavigationViewController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    menuViewController.dynamicsDrawerViewController = self.dynamicsDrawerViewController;
    [self.dynamicsDrawerViewController setPaneViewController:paneNavigationViewController animated:nil completion:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.dynamicsDrawerViewController;
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.windowBackground];
    [self.window sendSubviewToBack:self.windowBackground];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - MSAppDelegate

- (UIImageView *)windowBackground
{
    if (!_windowBackground) {
        _windowBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage"]];
    }
    return _windowBackground;
}

@end
