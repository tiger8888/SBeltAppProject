//
//  ZLChatView.m
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLChartView.h"

@implementation ZLChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        _VInterval = 0.0;
        _HInterval = 0.0;
    }
    return self;
}
-(void)setVInterval:(CGFloat)interval{
    _VInterval = interval;
}
-(void)setHInterval:(CGFloat)interval{
    _HInterval = interval;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
   
    CGPoint crossPoint;
    crossPoint.x = 10;
    crossPoint.y = self.frame.size.height - 10;
    
//画框
    CGFloat frameColor[4] = {1.0f,1.0f,1.0f,1.0f};
    
    CGContextSetStrokeColor(context, frameColor);
    
    CGContextSetLineWidth(context,1.0f);

    //竖线
    CGContextMoveToPoint(context, crossPoint.x, 0);
    
    CGContextAddLineToPoint(context, crossPoint.x, self.frame.size.height);
    
    //横线
    CGContextMoveToPoint(context, 0, crossPoint.y);
    
    CGContextAddLineToPoint(context, self.frame.size.width, crossPoint.y);
    
    
    CGContextStrokePath(context);
    
    
// 画虚线
    
    if (_VInterval != 0.0) {//垂直间隔
        for (CGFloat yLoc = crossPoint.y; yLoc  >= 0.0; yLoc -= _VInterval) {
            
            NSLog(@"yloc = %.2f",yLoc);
            
            CGContextMoveToPoint(context, crossPoint.x, yLoc);
            
            CGContextAddLineToPoint(context, self.frame.size.width, yLoc);
        }
    }
    
    if (_HInterval != 0.0) {//水平间隔
        for (CGFloat xLoc = crossPoint.x; xLoc  <= self.frame.size.width; xLoc += _HInterval) {
            
            NSLog(@"xloc = %.2f",xLoc);
            
            CGContextMoveToPoint(context, xLoc,0.0);
            
            CGContextAddLineToPoint(context,xLoc, crossPoint.y);
        }
    }
    
    float lengths[] = {2,2};
    
    CGContextSetLineDash(context, 0, lengths,2);
    
    CGContextStrokePath(context);
    
    /*虚线设置*/
    
//    float lengths[] = {2,2};
//    
//    CGContextSetLineDash(context, 0, lengths,2);
//    
//    CGContextMoveToPoint(context, 10.0, 20.0);
    
    /*虚线设置*/
    
    
    
    CGContextClosePath(context);
    
    CGContextStrokePath(context);

    
}


@end
