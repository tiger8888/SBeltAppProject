//
//  ZLChatView.h
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLChartView : UIView{
    CGFloat _VInterval,_HInterval;
}

-(void)setHInterval:(CGFloat)interval;
-(void)setVInterval:(CGFloat)interval;


@end
