//
//  AppDelegate.h
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rootMenuViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

@interface UINavigationController (autorotation)

-(BOOL)shouldAutorotate;
-(NSUInteger)supportedInterfaceOrientations;

@end