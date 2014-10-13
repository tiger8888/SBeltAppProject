//
//  mainNavigationController.m
//  SBeltApp
//
//  Created by 王 维 on 9/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "mainNavigationController.h"

@interface mainNavigationController ()

@end

@implementation mainNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bActivityMode = NO;
	// Do any additional setup after loading the view.
}
-(void)setActivityMode{
    bActivityMode = YES;
}

-(BOOL)shouldAutorotate{
    NSLog(@"bActivityMode = %d",bActivityMode);
    if (bActivityMode == NO) {
        return NO;
    }else{
        return YES;
    }
}
-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"bActivityMode = %d",bActivityMode);
    if (bActivityMode == NO) {
        return UIInterfaceOrientationMaskLandscape|UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskLandscapeLeft;
    }
    
    
}
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    NSLog(@"bActivityMode = %d",bActivityMode);
//    if (bActivityMode == NO) {
//    return UIInterfaceOrientationLandscapeLeft|UIInterfaceOrientationLandscapeRight|UIInterfaceOrientationPortrait|UIInterfaceOrientationPortraitUpsideDown;
//    }else{
//        return UIInterfaceOrientationLandscapeLeft;
//    
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
