//
//  ZLMainView.h
//  SBeltApp
//
//  Created by 王 维 on 9/16/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLChartTrackView.h"

@class ZLTimeBarView;
@class ZLTargetBreathRateView;

@interface ZLMainView : UIView
{
    UIView *headerView;
    ZLTimeBarView *timeBar;
    UIView      *firstViewInHeader;
    UIView      *secondViewInHeader;
    UIView      *thirdViewInHeader;
    ZLTargetBreathRateView  *targetBreathRateView;
    UIScrollView            *scrollView;
    ZLChartTrackView        *RespirationTrack;
    ZLChartTrackView        *heartRateView;
    ZLChartTrackView        *breathRateView;
    
    UILabel                 *pacerLabel;
    
    
    
}
-(void)updateRespirationTrack:(CGFloat)res;
-(void)updateBreatheRateTrack:(CGFloat)br;
-(void)updateHeartRateTrack:(CGFloat)hr;


-(void)changeTargetBreathRate:(int)targetBR;
-(void)reLayout;
//-(void)reLayoutShrink;
@end

//引导呼吸率
@interface ZLTargetBreathRateView : UIView
{
    int                     _br;
    float inhalation,exhalation;
}

-(void)setTargetBreathRate:(int)br;
@end


@interface ZLTimeBarView : UIView{
    NSInteger _totalTime;
    int   timeUnit;
    NSTimer     *timer;
    int     location;
}

-(void)setTotalTime:(NSInteger)time;
-(void)startTimeGoing;
@end

@interface ZLBreathRateView : UIView{


}



@end

