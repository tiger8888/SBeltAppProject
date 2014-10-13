//
//  utilityComponentView.m
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "utilityComponentView.h"

@implementation utilityComponentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
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


@implementation ZLSeperator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}
+(id)seperatorWithWidth:(CGFloat)width{
    ZLSeperator *seperator = [[ZLSeperator alloc] initWithFrame:CGRectMake(0, 0, width, 3)];
    
    return seperator;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat colorUp[4] ={0.4f, 0.4f, 0.4f, 0.4f};
    CGContextSetStrokeColor(context, colorUp);
    CGContextMoveToPoint(context, 0, 1 );
    CGContextAddLineToPoint(context,self.frame.size.width,1);
    CGContextStrokePath(context);
    
    
    CGFloat colorDown[4] = {0.8f, 0.8f, 0.8f, 0.8f};
    CGContextSetStrokeColor(context, colorDown);
    CGContextMoveToPoint(context, 0, 2);
    CGContextAddLineToPoint(context, self.frame.size.width, 2);
    
    CGContextStrokePath(context);
    
}

@end







