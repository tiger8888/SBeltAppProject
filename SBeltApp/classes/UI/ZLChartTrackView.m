//
//  ZLChartTrackView.m
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLChartTrackView.h"

// from "ZLChartFrameView.h" 上下刻度值
//#define _LENGTH_SHORT_UpDown           4.0
//#define _LENGTH_LONG_UpDown            8.0
//
//#define _LENGTH_SHORT_LeftRight           8.0
//#define _LENGTH_LONG_LeftRight            10.0



@implementation ZLChartTrackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        pointsBuffer = [[NSMutableArray alloc] init];
        locationX = 0.0;
        scaleToMoveX = 2.0;
        widthOfLine = 1.0;
        trackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self setECGGain:1.0];
        [self setRespGain:1.0];
    }
    return self;
}

-(void)addValueToBuffer:(CGFloat)value{
    locationX += scaleToMoveX;
  
    
    
    NSValue *valuePoint = [NSValue valueWithCGPoint:CGPointMake(locationX, value)];
  
    [pointsBuffer addObject:valuePoint];
    if (pointsBuffer.count >= (self.frame.size.width)/scaleToMoveX) {
        [pointsBuffer removeAllObjects];
        locationX = 0;
    }
    [self setNeedsDisplay];
}
-(void)setTrackColor:(UIColor *)color{
    trackColor = color;
}
-(void)setWidthOfLine:(int)width{
    widthOfLine = width;
}
-(void)setScaleOfX:(CGFloat)scale{
    scaleToMoveX = scale;
}
-(void)setECGGain:(float)gain{
    _gain = gain;
    
    //不同增益调整波形
    if (_gain == 0.5) {
        _move = 30;
    }else if (_gain == 1.0){
        _move = -10;
    }else if (_gain == 1.5){
        _gain = 2.0;
        _move = -86;
    }else if (_gain == 2.0){
        _gain = 3.0;
        _move = -160;
    }else{//nothing
        
    }
    
    [self setNeedsDisplay];
}
-(void)setRespGain:(float)gain{
    _gain = gain;
    
    //不同增益调整波形
    if (_gain == 0.5) {
        _move = 30;
    }else if (_gain == 1.0){
        _move = -10;
    }else if (_gain == 1.5){
        _gain = 2.0;
        _move = -60;
    }else if (_gain == 2.0){
        _gain = 3.0;
        _move = -80;
    }else{//nothing
        
    }
    
    [self setNeedsDisplay];
}
-(void)clearToStart{
    [pointsBuffer removeAllObjects];
    locationX = 0;
    [self setNeedsDisplay];
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
    
    CGContextSetStrokeColor(context, CGColorGetComponents(trackColor.CGColor));
    CGContextSetLineWidth(context, widthOfLine);
    CGPoint *pBuffer = malloc(pointsBuffer.count * sizeof(CGPoint));

    memset(pBuffer, 0x00, pointsBuffer.count * sizeof(CGPoint));
    
    
    //NSLog(@"count of point buffer %d",pointsBuffer.count);
    if (pointsBuffer.count == 0) {
        return;
    }
    for (int i = 0; i < pointsBuffer.count - 1; i++) {
        NSValue *pValue = [pointsBuffer objectAtIndex:i];
        CGPoint point = [pValue CGPointValue];
        
        
        NSValue *tValue = [pointsBuffer objectAtIndex:i+1];
        CGPoint t = [tValue CGPointValue];
        
        
        
        
        pBuffer[i].x = point.x;
        pBuffer[i].y = point.y;
        
        //范围内显示
        
        
        CGContextMoveToPoint(context, point.x, [self getFrameY:(point.y*_gain + _move)]);
        CGContextAddLineToPoint(context, t.x, [self getFrameY:t.y*_gain + _move]);
    }
    
    //CGContextMoveToPoint(context, 0, 0);
    

    
    //CGContextAddLines(context, pBuffer, pointsBuffer.count);
    
    
    
    CGContextStrokePath(context);
    
    free(pBuffer);
    
}

-(float)getFrameY:(float)y{
    float rangeY ;
    if (y <= 0) {
        rangeY = 2;
    }else if(y >= self.frame.size.height){
        rangeY = self.frame.size.height-2;
    }else{
        rangeY = y;
    }
    return rangeY;
}


@end
