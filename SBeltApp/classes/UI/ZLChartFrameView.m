//
//  ZLChartTwoView.m
//  SBeltApp
//
//  Created by 王 维 on 6/19/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLChartFrameView.h"
#import <QuartzCore/QuartzCore.h>

#define _LENGTH_SHORT_UpDown           4.0
#define _LENGTH_LONG_UpDown            8.0

#define _LENGTH_SHORT_LeftRight           8.0
#define _LENGTH_LONG_LeftRight            10.0

#define _LONG_INDEX             5

typedef enum _dir{
    _dir_up,
    _dir_down,
    _dir_left,
    _dir_right
    
}directionType;

@implementation ZLChartFrameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _frameColor = [UIColor greenColor];
        [self initAll];
        titleBtnInLeftTop = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtnInLeftTop.frame = CGRectMake(2, 2, 36, 12);
        titleBtnInLeftTop.layer.cornerRadius = 4;
        titleBtnInLeftTop.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        titleBtnInLeftTop.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        [self addSubview:titleBtnInLeftTop];
    }
    return self;
}
-(void)initAll{

    self.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
    _width = self.frame.size.width;
    _height = self.frame.size.height;
    _V_Interval = 5;
    _H_Interval = 20;
}
-(void)setTitle:(NSString *)title{
    [titleBtnInLeftTop setTitle:title forState:UIControlStateNormal];
}
-(void)setFrameColor:(UIColor *)color{
    _frameColor = color;
}
-(void)setParams_VInterval:(CGFloat)vInter hInterval:(CGFloat)hInter{
    _V_Interval = vInter;
    _H_Interval = hInter;
}
-(float)getVInterval{
    return _V_Interval;
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
    
    self.layer.borderColor = _frameColor.CGColor;
    self.layer.borderWidth = 2;
    
    
    
    [super drawRect:rect];
    
    
    
    
    
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int longIndex = 1;
    CGFloat xMove = 0,yMove = 0;
    
    
    //画下面刻度
    longIndex = 1;
    xMove = 0;
    do{
        xMove += _H_Interval;
        if (longIndex%_LONG_INDEX != 0) {
            [self drawLineFromPoint:CGPointMake(xMove, _height) direction:_dir_up context:context withLength:_LENGTH_SHORT_UpDown];
        }else{
            [self drawLineFromPoint:CGPointMake(xMove, _height) direction:_dir_up context:context withLength:_LENGTH_LONG_UpDown];
        }
        
        
        longIndex++;
    }while (xMove < _width);
    
    //画上面刻度
    xMove = 0;
    longIndex = 1;
    do{
        xMove += _H_Interval;
        if (longIndex%_LONG_INDEX != 0) {
            [self drawLineFromPoint:CGPointMake(xMove, 0) direction:_dir_down context:context withLength:_LENGTH_SHORT_UpDown];
        }else{
            [self drawLineFromPoint:CGPointMake(xMove, 0) direction:_dir_down context:context withLength:_LENGTH_LONG_UpDown];
        }
        
        
        longIndex++;
    }while (xMove < _width);
    
    
    //画左面刻度
    yMove = self.frame.size.height;
    longIndex = 1;
    do{
        yMove -= _V_Interval;
        if (longIndex%_LONG_INDEX != 0) {
            [self drawLineFromPoint:CGPointMake(0, yMove) direction:_dir_right context:context withLength:_LENGTH_SHORT_LeftRight];
        }else{
            [self drawLineFromPoint:CGPointMake(0, yMove) direction:_dir_right context:context withLength:_LENGTH_LONG_LeftRight];
        }
        
        
        longIndex++;
    }while (yMove > 0);
    
    //画右面刻度
    yMove = self.frame.size.height;
    longIndex = 1;
    do{
        yMove -= _V_Interval;
        if (longIndex%_LONG_INDEX != 0) {
            [self drawLineFromPoint:CGPointMake(_width, yMove) direction:_dir_left context:context withLength:_LENGTH_SHORT_LeftRight];
        }else{
            [self drawLineFromPoint:CGPointMake(_width, yMove) direction:_dir_left context:context withLength:_LENGTH_LONG_LeftRight];
        }
        
        
        longIndex++;
    }while (yMove > 0);
    
}

-(void)drawLineFromPoint:(CGPoint)from direction:(directionType)dir context:(CGContextRef)ctx withLength:(CGFloat)length{
    CGContextSetStrokeColor(ctx, CGColorGetComponents(_frameColor.CGColor));
    CGContextMoveToPoint(ctx, from.x, from.y);
    
    CGPoint to;
    switch (dir) {
        case _dir_down:
            to.x = from.x;
            to.y = from.y + length;
            break;
        case _dir_up:
            to.x = from.x;
            to.y = from.y - length;
            break;
        case _dir_left:
            to.x = from.x - length;
            to.y = from.y;
            break;
        case _dir_right:
            to.x = from.x + length;
            to.y = from.y;
            break;
        default:
            break;
    }
    CGContextAddLineToPoint(ctx, to.x, to.y);
    CGContextStrokePath(ctx);
}
@end
