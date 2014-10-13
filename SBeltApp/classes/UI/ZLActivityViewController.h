//
//  ZLActivityViewController.h
//  SBeltApp
//
//  Created by 王 维 on 9/4/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLScrollMenuView.h"
#import "ZLMainView.h"
#import "BLESerialComManager.h"
#import "ZLUserInfoObject.h"
#import "ZLChartView.h"


@interface ZLActivityViewController : UIViewController<BLESerialComManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    ZLMainView *mainView;
    ZLUserInfoObject *_userInfo;
    UIView      *fullScreenCoverView;
    NSArray     *brPickerLabels;
}



-(id)initWithUserInfo:(ZLUserInfoObject *)userInfo;
-(void)updateRespirationView:(CGFloat)br;
-(void)updateBreatheRate:(CGFloat)br;
-(void)updateHeartRate:(CGFloat)hr;

@end
