//
//  ZLUserInfoViewController.h
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLUserInfoObject.h"
#import "ZLPopTextInputView.h"

typedef NS_ENUM(NSInteger, userInfoMode){
    userInfoNewMode,
    userInfoEditMode,
    userInfoModeEnd
};

@interface ZLUserInfoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ZLPopTextInputDelegate>
{
    UITableView *tableView;
    userInfoMode _mode;
    ZLUserInfoObject *currentUser;
}

-(id)initWithMode:(userInfoMode)mode withUser:(ZLUserInfoObject *)userInfo ;
@end
