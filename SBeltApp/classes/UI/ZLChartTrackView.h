//
//  ZLChartTrackView.h
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLChartTrackView : UIView{
    CGFloat locationX;
    CGFloat scaleToMoveX;
    NSMutableArray *pointsBuffer;
    float     _gain;
    int       _move;
    UIColor     *trackColor;
    int         widthOfLine;
}

-(void)addValueToBuffer:(CGFloat)value;
-(void)setScaleOfX:(CGFloat)scale;
-(void)setECGGain:(float)gain;
-(void)setRespGain:(float)gain;
-(void)clearToStart;
-(void)setTrackColor:(UIColor *)color;
-(void)setWidthOfLine:(int)width;

@end
