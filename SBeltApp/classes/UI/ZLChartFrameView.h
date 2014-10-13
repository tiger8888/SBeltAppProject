//
//  ZLChartTwoView.h
//  SBeltApp
//
//  Created by 王 维 on 6/19/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLChartFrameView : UIView{
    UIColor *_frameColor;
    CGFloat _width,_height;
    CGFloat _H_Interval,_V_Interval;
    
    UIButton *titleBtnInLeftTop;
    
}

//参数设置
-(void)setTitle:(NSString *)title;
-(void)setFrameColor:(UIColor *)color;
-(void)setParams_VInterval:(CGFloat)vInter hInterval:(CGFloat)hInter;
-(float)getVInterval;


@end
