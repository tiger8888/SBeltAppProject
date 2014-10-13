//
//  ZLSettingView.h
//  SBeltApp
//
//  Created by 王 维 on 6/20/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLBluetoothLEManage.h"
//@protocol ZLSettingViewDelegate<NSObject>
//
//-(void)
//
//@end

@interface ZLSettingView : UIView<UITableViewDelegate,UITableViewDataSource>

+(ZLSettingView *)getSettingView;

@end
