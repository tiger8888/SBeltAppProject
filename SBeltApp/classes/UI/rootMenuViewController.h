//
//  rootMenuViewController.h
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGLTransitionManager.h"
#import "RotateTransition.h"
#import "sharedHeader.h"
#import "menuViewController.h"

@interface rootMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *menuView;
}


@end
