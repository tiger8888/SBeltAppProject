//
//  ZLMonitorViewController.h
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLChartView.h"
#import "FXLabel.h"
#import "ZLStorageFunctionManage.h"
#import "ZLTreeView.h"
#import "ZLChartFrameView.h"
#import "ZLSettingView.h"
#import "ZLBluetoothLEManage.h"
#import "ZLFlashView.h"
#import "ZLFreezeManage.h"
#import "ZLChartTrackView.h"
#import "UIButton+Curled.h"
#import "ZLDragView.h"




@interface ZLMonitorViewController : UIViewController<ZLTreeViewDelegate,BLESerialComManagerDelegate,UITableViewDataSource,UITableViewDelegate>{
    UIButton            *bgView;
    UITableView         *container;
    BOOL                bInStoring;
    ZLFlashView         *flashView;
    BOOL                bToolBarOpen;
    NSTimer             *ecgReplayTimer;
    NSTimer             *breathReplayTimer;
    NSTimer             *activityReplayTimer;
    NSTimer             *generalDataTimer;
    
    UIButton            *ecgGainButton;
    UIButton            *respGainButton;
    
    //ZLDragView          *dragView;
}

@property (strong, nonatomic) ZLChartFrameView *actiFrameView;
@property (strong,nonatomic) ZLChartFrameView *heartRateFrameView;
@property (strong,nonatomic) ZLChartFrameView *breatheRateFrameView;

@property (strong,nonatomic) ZLChartTrackView *ECGTrack;
@property (strong,nonatomic) ZLChartTrackView *RespirationTrack;
@property (strong,nonatomic) ZLChartTrackView *ActivityTrack;

@property (strong,nonatomic) ZLChartTrackView *heartRateTrack;
@property (strong,nonatomic) ZLChartTrackView *breathRateTrack;


@property (strong,nonatomic) ZLDragView       *dragView;

@end
