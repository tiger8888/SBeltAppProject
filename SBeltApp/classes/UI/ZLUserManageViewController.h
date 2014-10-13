//
//  ZLUserManageViewController.h
//  SBeltApp
//
//  Created by 王 维 on 9/4/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLUserInfoViewController.h"



@interface ZLUserManageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *allUsers;
    UITableView *_tableView;
    UIBarButtonItem *editBtn;
    int         currentSelected;
}

@end
