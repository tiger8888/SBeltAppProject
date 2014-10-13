//
//  ZLBluetoothLEManage.h
//  SBeltApp
//
//  Created by 王 维 on 6/20/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLESerialComManager.h"


@interface ZLBluetoothLEManage : UIView<BLESerialComManagerDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray      *foundSensors;
    UITableView         *itemlist;
    UIActivityIndicatorView *inProgressIndicator;
    BOOL                bMainThreadUsed;
    NSTimer             *updateTimer;
    NSTimer             *portOpenTimer;
    BLEPort             *openedPort;
}

@property (strong,atomic) NSData *streamBuffer;

+(ZLBluetoothLEManage *)sharedInstanceWithLandscape:(BOOL)bLand mode:(int)mode;
+(float)rollAverage:(float)value;
-(void)syncCurrentTime;
-(void)startEnumPortsProcedure;
@end
