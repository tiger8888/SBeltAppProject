//
//  ZLDragView.h
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Curled.h"

@class ZLBlockView;

@interface ZLDragView : UIView<UITableViewDataSource,UITableViewDelegate>{
    ZLBlockView *heartRateBlock;
    ZLBlockView *breathRateBlock;
    ZLBlockView *activityBlock;
    ZLBlockView *tskBlock;
    ZLBlockView *batteryBlock;
}


+(ZLDragView *)dragView;
-(void)updateDragViewWithHr:(float)_hr br:(float) _br activity:(float)_acti tsk:(float)_tsk;
-(void)setBatteryValue:(float)batt;
-(void)dismissSelf;


@end

@interface ZLBlockView : UIButton{
    UILabel *blockLabel;
    UILabel *blockContent;
}

-(void)setLabelText:(NSString *)text;
-(void)setContentText:(NSString *)content;
-(void)setContentColor:(UIColor *)color;

@end