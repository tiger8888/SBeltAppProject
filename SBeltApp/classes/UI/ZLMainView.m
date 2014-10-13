//
//  ZLMainView.m
//  SBeltApp
//
//  Created by 王 维 on 9/16/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLMainView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ZLMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,30)];
        headerView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:250.0/255.0 blue:205.0/255.0 alpha:1.0];
        [self addSubview:headerView];
        
        
        CGFloat hTimeBar = 20;
        timeBar = [[ZLTimeBarView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - hTimeBar, self.frame.size.width, hTimeBar)];
        [self addSubview:timeBar];
        
        [timeBar setTotalTime:100];
        [timeBar startTimeGoing];
        
        
        CGFloat widthOfComponent = 100;
        firstViewInHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthOfComponent, headerView.frame.size.height)];
        UIView *pacerBlock = [self getBlockWithColor:[UIColor yellowColor]];
        pacerBlock.center = CGPointMake(12, headerView.frame.size.height/2);
        pacerLabel =[[UILabel alloc] initWithFrame:CGRectMake(24, 0, 80, headerView.frame.size.height)];
        pacerLabel.text = [NSString stringWithFormat:@"Pacer %.1f",6.0];
        pacerLabel.backgroundColor = [UIColor clearColor];
        pacerLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:12];
        [firstViewInHeader addSubview:pacerLabel];
        [firstViewInHeader addSubview:pacerBlock];
        
        secondViewInHeader = [[UIView alloc] initWithFrame:CGRectMake(headerView.frame.size.width/2 - widthOfComponent/2, 0, widthOfComponent, headerView.frame.size.height)];
        UIView *hrBlock = [self getBlockWithColor:[UIColor redColor]];
        hrBlock.center = CGPointMake(12, headerView.frame.size.height/2);
        UILabel *hrLabel =[[UILabel alloc] initWithFrame:CGRectMake(24, 0, 80, headerView.frame.size.height)];
        hrLabel.text = [NSString stringWithFormat:@"HR %.1f",52.3];
        hrLabel.backgroundColor = [UIColor clearColor];
        hrLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:12];
        [secondViewInHeader addSubview:hrLabel];
        [secondViewInHeader addSubview:hrBlock];
        
        thirdViewInHeader = [[UIView alloc] initWithFrame:CGRectMake(headerView.frame.size.width - widthOfComponent, 0, widthOfComponent, headerView.frame.size.height)];
        UIView *respBlock = [self getBlockWithColor:[UIColor cyanColor]];
        respBlock.center = CGPointMake(12, headerView.frame.size.height/2);
        UILabel *respLabel =[[UILabel alloc] initWithFrame:CGRectMake(24, 0, 80, headerView.frame.size.height)];
        respLabel.text = [NSString stringWithFormat:@"RESP %.1f",77.0];
        respLabel.backgroundColor = [UIColor clearColor];
        respLabel.font = [UIFont fontWithName:@"STHeitiJ-Medium" size:12];
        [thirdViewInHeader addSubview:respLabel];
        [thirdViewInHeader addSubview:respBlock];
        
        [headerView addSubview:firstViewInHeader];
        [headerView addSubview:secondViewInHeader];
        [headerView addSubview:thirdViewInHeader];
        
        targetBreathRateView = [[ZLTargetBreathRateView alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height, self.frame.size.width, 60)];
        [targetBreathRateView setTargetBreathRate:4];
        [targetBreathRateView setNeedsDisplay];
        [self addSubview:targetBreathRateView];
        
        
        
        

        
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  headerView.frame.size.height + targetBreathRateView.frame.size.height, self.frame.size.width, self.frame.size.height - timeBar.frame.size.height - targetBreathRateView.frame.size.height - headerView.frame.size.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:scrollView];
        
        RespirationTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        RespirationTrack.backgroundColor = [UIColor clearColor];
        [RespirationTrack setScaleOfX:2];
        [RespirationTrack setWidthOfLine:2];
        [RespirationTrack setTrackColor:[UIColor cyanColor]];
        [scrollView addSubview:RespirationTrack];
        
        heartRateView = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        heartRateView.backgroundColor = [UIColor clearColor];
        [heartRateView setScaleOfX:2];
        [heartRateView setWidthOfLine:2];
        [heartRateView setTrackColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0 blue:71.0/255.0 alpha:1.0]];
        [scrollView addSubview:heartRateView];
        
        breathRateView = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        breathRateView.backgroundColor = [UIColor clearColor];
        [breathRateView setScaleOfX:2];
        [breathRateView setWidthOfLine:2];
        [breathRateView setTrackColor:[UIColor colorWithRed:0.0/255.0 green:250.0/255.0 blue:154.0/255.0 alpha:1.0]];
        [scrollView addSubview:breathRateView];

        
    }
    return self;
}
-(UIView *)getBlockWithColor:(UIColor *)color{
    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 20)];
    block.backgroundColor = color;
    block.layer.borderColor = [UIColor blackColor].CGColor;
    block.layer.borderWidth = 2;
    
    return block;
}
-(void)updateRespirationTrack:(CGFloat)res{
    [RespirationTrack addValueToBuffer:res];
    [RespirationTrack setNeedsDisplay];
}
-(void)updateBreatheRateTrack:(CGFloat)br{
    [breathRateView addValueToBuffer:br];
    [breathRateView setNeedsDisplay];
}
-(void)updateHeartRateTrack:(CGFloat)hr{
    [heartRateView addValueToBuffer:hr];
    [heartRateView setNeedsDisplay];
}
-(void)changeTargetBreathRate:(int)targetBR{
    
    pacerLabel.text = [NSString stringWithFormat:@"Pacer %.1f",(float)targetBR];
    
    [targetBreathRateView setTargetBreathRate:targetBR];
    [targetBreathRateView setNeedsDisplay];
}
//-(void)reLayoutShrink{
//    [UIView animateWithDuration:0.2 animations:^{
//        scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height);
//        timeBar.frame = CGRectMake(timeBar.frame.origin.x, timeBar.frame.origin.y - 64, timeBar.frame.size.width, timeBar.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
//}
-(void)reLayout{
    [UIView animateWithDuration:0.0 animations:^{
        scrollView.frame = CGRectMake(0,  headerView.frame.size.height + targetBreathRateView.frame.size.height, self.frame.size.width, self.frame.size.height - timeBar.frame.size.height - targetBreathRateView.frame.size.height - headerView.frame.size.height);
        timeBar.frame = CGRectMake(0, self.frame.size.height - timeBar.frame.size.height, self.frame.size.width, timeBar.frame.size.height);
    } completion:^(BOOL finished) {
        
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

@end


@implementation ZLTargetBreathRateView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:136.0/255.0 blue:153.0/255.0 alpha:1.0];
    }
    return self;
}

-(void)setTargetBreathRate:(int)br{
    
    float breatheStep = self.frame.size.width/br;
    inhalation = breatheStep*1/3;
    exhalation = breatheStep*2/3;
    
    _br = br;
    
}

-(void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 2);
    
    
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    float startX = 0.0,secondX = inhalation,thirdX = inhalation+exhalation;
    float upY = 10.0,downY = height - 10.0;
    
    for (int i = 0; i < _br; i++) {
        CGPoint firstP = CGPointMake(startX, downY);
        CGPoint secondP = CGPointMake(secondX, upY);
        CGPoint thirdP = CGPointMake(thirdX, downY);
        
        CGContextMoveToPoint(context, firstP.x, firstP.y);
        CGContextAddLineToPoint(context, secondP.x, secondP.y);
        CGContextAddLineToPoint(context, thirdP.x, thirdP.y);
        CGContextStrokePath(context);
        
        startX = thirdX;
        secondX = startX + inhalation;
        thirdX = startX + inhalation + exhalation;
    }
    
    
    
    
    
    

}




@end







@implementation ZLTimeBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        
        self.layer.cornerRadius = 2;
        
        CGFloat hLine = 2;
        UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, hLine)];
        lineTop.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-hLine, self.frame.size.width, hLine)];
        lineBottom.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        
        [self addSubview:lineTop];
        [self addSubview:lineBottom];
        
    
        
    }
    return self;
}
-(void)setTotalTime:(NSInteger)time{
    _totalTime = time;
    
    timeUnit = self.frame.size.width / _totalTime;
    NSLog(@"timeUnit = %d",timeUnit);
    UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 12)];
    startTimeLabel.text = @"00:00";
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:10];
    startTimeLabel.center = CGPointMake(startTimeLabel.center.x, self.frame.size.height/2);
    [self addSubview:startTimeLabel];
    
    UILabel *endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 30, 0, 40, 12)];
    endTimeLabel.text = [NSString stringWithFormat:@"%d:00",_totalTime];
    endTimeLabel.backgroundColor = [UIColor clearColor];
    endTimeLabel.font = [UIFont fontWithName:@"STHeitiJ-Light" size:10];
    endTimeLabel.center = CGPointMake(endTimeLabel.center.x, self.frame.size.height/2);
    [self addSubview:endTimeLabel];
    
    location = 0;
    
}
-(void)startTimeGoing{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeBar) userInfo:nil repeats:YES];
}
-(void)updateTimeBar{
    
    location += timeUnit;
    NSLog(@"updateTimeBar location = %d",location);
    [self setNeedsDisplay];
    if (location >= self.frame.size.width) {
        [timer invalidate];
        timer = nil;
    }
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSLog(@"drawRect");
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, self.frame.size.height);
    
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.2);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, location, self.frame.size.height/2);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, 0, 150);
//    //设置下一个坐标点
//    CGContextAddLineToPoint(context, 50, 180);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
    
    
    
    
    
}

@end

@implementation ZLBreathRateView



@end






