//
//  sharedHeader.h
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#ifndef SBeltApp_sharedHeader_h
#define SBeltApp_sharedHeader_h

#include "ZLMonitorViewController.h"
#import "BLESerialComManager.h"
#import "ZLUserManageViewController.h"
#import "ZLActivityViewController.h"
#import "ZLDataManageViewController.h"
#import "mainNavigationController.h"
#import "ZLConfigureManage.h"
#import "ZLUserInfoObject.h"
#import "TrainingProcedureManager.h"


UINavigationController *navigationController;


ZLMonitorViewController         *ZLMonitorVC;

ZLConfigureManage               *configureMnger;


ZLUserManageViewController      *ZLUserMngVC;
ZLActivityViewController        *ZLActivityVC;
ZLDataManageViewController      *ZLDataMngVC;


ZLUserInfoObject                *currentUser;

BLESerialComManager             *bleSerialComMgr;

TrainingProcedureManager        *trainingMgr;
                          
//FLAG变量
BOOL                            bDataStoring;

// 基本设备信息
unsigned int deviceId;
unsigned int deviceVersion;
unsigned int firmwareId;
unsigned int firmwareVersion;


#define WIDTH_OF_SCREEN         [UIScreen mainScreen].bounds.size.width
#define HEIGHT_OF_SCREEN        [UIScreen mainScreen].bounds.size.height



#endif
