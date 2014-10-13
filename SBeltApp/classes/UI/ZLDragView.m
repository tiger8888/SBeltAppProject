//
//  ZLDragView.m
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLDragView.h"
#import <QuartzCore/QuartzCore.h>

#define interval_between_block      120

@implementation ZLDragView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:0.4 alpha:0.0]];
        

        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, 100, 460)];
        [contentView setBackgroundColor:[UIColor blueColor]];
        [self addSubview:contentView];
        
        contentView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:139/255.0 blue:30.0/255.0 alpha:1.0];
        contentView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1.0].CGColor;
        contentView.layer.borderWidth = 2;
        
        heartRateBlock = [[ZLBlockView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
        heartRateBlock.center = CGPointMake(contentView.frame.size.width/2, 46);
        [heartRateBlock setLabelText:@" HR(bmp)"];
        [heartRateBlock setContentText:@"86"];
        
        [contentView addSubview:heartRateBlock];
        
        breathRateBlock = [[ZLBlockView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
        breathRateBlock.center = CGPointMake(contentView.frame.size.width/2, 46+interval_between_block);
        [breathRateBlock setLabelText:@" BR(bmp)"];
        [breathRateBlock setContentText:@"15.4"];
        [breathRateBlock setContentColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:0.0/255.0 alpha:1.0]];
        
        [contentView addSubview:breathRateBlock];
        
        activityBlock = [[ZLBlockView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
        activityBlock.center = CGPointMake(contentView.frame.size.width/2, 46+interval_between_block*2);
        [activityBlock setLabelText:@" Activity(g)"];
        [activityBlock setContentText:@"0.7"];
        [activityBlock setContentColor:[UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:255.0/255.0 alpha:1.0]];
        
        [contentView addSubview:activityBlock];
        
//        tskBlock = [[ZLBlockView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
//        tskBlock.center = CGPointMake(contentView.frame.size.width/2, 46+interval_between_block*3);
//        [tskBlock setLabelText:@" Tsk(℃)"];
//        [tskBlock setContentText:@"36.7"];
//        [tskBlock setContentColor:[UIColor colorWithRed:224.0/255.0 green:102.0/255.0 blue:255.0/255.0 alpha:1.0]];
//        
//        [contentView addSubview:tskBlock];
        
        batteryBlock = [[ZLBlockView alloc] initWithFrame:CGRectMake(0, 0, 90, 70)];
        batteryBlock.center = CGPointMake(contentView.frame.size.width/2, 46+interval_between_block*3);
        [batteryBlock setLabelText:@" Battery(%)"];
        [batteryBlock setContentText:@"97"];
        [batteryBlock setContentColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:205.0/255.0 alpha:1.0]];
        
        [contentView addSubview:batteryBlock];
    }
    return self;
}

+(ZLDragView *)dragView{
    ZLDragView *newInstance = [[ZLDragView alloc] initWithFrame:CGRectMake(320-20, 0, 120, 460)];
    
    return newInstance;
}
-(void)updateDragViewWithHr:(float)_hr br:(float) _br activity:(float)_acti tsk:(float)_tsk{
    [heartRateBlock setContentText:[NSString stringWithFormat:@"%d",(int)_hr]];
    [breathRateBlock setContentText:[NSString stringWithFormat:@"%.1f",_br]];
    [activityBlock setContentText:[NSString stringWithFormat:@"%.1f",_acti]];
    [tskBlock setContentText:[NSString stringWithFormat:@"%.1f",_tsk]];
    
}
-(void)setBatteryValue:(float)batt{
    [batteryBlock setContentText:[NSString stringWithFormat:@"%.1f",batt]];
}
-(void)dismissSelf{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(320-20,0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        self.layer.shadowOpacity = 0.0;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
CGPoint oldCenter,beganLocation;
CGFloat distanceBetweenTouchAndCenter;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   // NSLog(@"touch began");
    oldCenter = self.center;
    UITouch *touch = [touches anyObject];
    beganLocation = [touch locationInView:self.superview];
    distanceBetweenTouchAndCenter =  oldCenter.x - beganLocation.x;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.superview];
    //NSLog(@"x = %.1f,y = %.1f",location.x,location.y);
    if (location.x <= 240) {
        return;
    }
    self.center = CGPointMake(location.x + distanceBetweenTouchAndCenter, oldCenter.y);
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.center.x > 310) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(320-20,0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.layer.shadowOpacity = 0.0;
        }];
    }else if(self.center.x < 310){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frame = CGRectMake(320-self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.layer.shadowOpacity = 0.0;
        }];
    }
}



@end

#define blockOneColor [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]
#define blockTwoColor [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:122.0/255.0 alpha:1.0]

@implementation ZLBlockView : UIButton

-(id)initWithFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        
        [self setImage:nil borderWidth:2.0 shadowDepth:10 controlPointXOffset:30 controlPointYOffset:30 forState:UIControlStateNormal];
        
        blockLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
        blockLabel.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
        //blockLabel.layer.borderWidth = 2.0;
        blockLabel.backgroundColor = blockOneColor;
        blockLabel.textColor = blockTwoColor;
        blockLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
        
        [self addSubview:blockLabel];
        
        
        
        blockContent = [[UILabel alloc] initWithFrame:CGRectMake(0, blockLabel.frame.size.height - 2, self.frame.size.width, self.frame.size.height - blockLabel.frame.size.height)];
        blockContent.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
        blockContent.layer.borderWidth = 2.0;
        blockContent.backgroundColor = blockTwoColor;
        blockContent.textColor = [UIColor colorWithRed:40.0/255.0 green:205.0/255.0 blue:40.0/255.0 alpha:1.0];
        blockContent.textAlignment = NSTextAlignmentCenter;
        blockContent.font = [UIFont fontWithName:@"Verdana-Bold" size:26];
        
        [self addSubview:blockContent];
        
        
        //blockContent;
    }
    return self;
}
-(void)setLabelText:(NSString *)text{
    blockLabel.text = text;
}
-(void)setContentText:(NSString *)content{
    blockContent.text = content;
}
-(void)setContentColor:(UIColor *)color{
    blockContent.textColor = color;
}

@end




