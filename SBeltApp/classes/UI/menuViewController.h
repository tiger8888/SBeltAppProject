//
//  menuViewController.h
//  SBeltApp
//
//  Created by 王 维 on 6/17/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "languageStringManage.h"
#import "utilityComponentView.h"
#import "ZLUserManageViewController.h"
#import "ZLActivityViewController.h"
#import "ZLDataManageViewController.h"
#import "sharedHeader.h"



@interface menuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *menuView;
    unsigned int currentSelect;
}

@end
