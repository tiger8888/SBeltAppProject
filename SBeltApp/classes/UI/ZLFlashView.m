//
//  ZLFlashView.m
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLFlashView.h"
#import <QuartzCore/QuartzCore.h>


#define radiusOfExternal        12
#define radiusOfInternal        12

#define interval_flash          0.2

@implementation ZLFlashView


+(ZLFlashView *)flashView{
    ZLFlashView *rFlashView = [[ZLFlashView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    return rFlashView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        externalCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*radiusOfExternal, 2*radiusOfExternal)];
        externalCircle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [externalCircle setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:100.0/255.0 blue:0.0/255.0 alpha:1.0]];
        externalCircle.layer.cornerRadius = radiusOfExternal;
        
        [self addSubview:externalCircle];
        
        
        internalCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2*radiusOfInternal, 2*radiusOfInternal)];
        internalCircle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [internalCircle setBackgroundColor:[UIColor colorWithRed:205.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]];
        internalCircle.layer.cornerRadius = radiusOfInternal;
        
        [self addSubview:internalCircle];
        
        self.hidden = YES;
        
        
    }
    return self;
}


-(void)startFlashAnimation{
    if (flashTimer) {
        [flashTimer invalidate];
        flashTimer = nil;
    }
    
    flashTimer = [NSTimer scheduledTimerWithTimeInterval:interval_flash target:self selector:@selector(flashAction) userInfo:nil repeats:YES];
    
}

-(void)flashAction{
    self.hidden = (self.isHidden)?NO:YES;
}

-(void)stopFlashAnimation{
    self.hidden = YES;
    if (flashTimer) {
        [flashTimer invalidate];
        flashTimer = nil;
    }
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
