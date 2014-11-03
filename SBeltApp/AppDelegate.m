//
//  AppDelegate.m
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "AppDelegate.h"
#import "common.h"
#import "mainNavigationController.h"
#import "TrainingProcedureManager.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
  
  
    rootMenuViewController *rootMenuVC = [[rootMenuViewController alloc] init];
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootMenuVC];
    navigationController.navigationItem.title = @"SBelt";
//    [navigationController setActivityMode];
//    ZLActivityVC = [[ZLActivityViewController alloc] init];
    
    self.window.rootViewController = navigationController;
    navigationController.navigationBar.translucent = NO;
    //[navigationController pushViewController:rootMenuVC animated:YES];
    [navigationController setNavigationBarHidden:NO];
    
    
    [self.window makeKeyAndVisible];
    
    
    [self OtherInit];
    
    return YES;
}
-(void)OtherInit{

    bleSerialComMgr = [BLESerialComManager sharedInstance];
    configureMnger = [[ZLConfigureManage alloc] init];
    currentUser = [configureMnger getUserInforByName:[configureMnger getCurrentUser]];
    trainingMgr = [TrainingProcedureManager sharedInstance];
    
    bDataStoring = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
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

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
  return UIInterfaceOrientationMaskPortrait;
}
@end

@implementation UINavigationController (autorotation)

-(BOOL)shouldAutorotate
{
    
    
    return [self.topViewController shouldAutorotate];
    
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
    
}

@end
