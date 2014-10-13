//
//  ZLPopInfoView.m
//  SBeltApp
//
//  Created by 王 维 on 7/3/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLPopInfoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ZLPopInfoView


+(ZLPopInfoView *)popInfoViewWithContent:(NSString *)content withTargetView:(UIView *)targetView{
    ZLPopInfoView *popInfoView = [[ZLPopInfoView alloc] initWithFrame:CGRectMake(0, 0, 160, 160) withContent:content withTargetView:targetView];
    popInfoView.center = CGPointMake(targetView.frame.size.width/2, targetView.frame.size.height/2);
    
    return popInfoView;
}



- (id)initWithFrame:(CGRect)frame withContent:(NSString *)content withTargetView:(UIView *)targetVIew
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        self.layer.cornerRadius = 10;
        self.layer.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8].CGColor;
        
        
        
        _targetView = targetVIew;
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentLabel.text = content;
        _contentLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment= NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 4;
        _contentLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:_contentLabel];
        
    }
    return self;
}
-(void)showWitInterval:(CGFloat)interval{
    [_targetView addSubview:self];
    
    [self performSelector:@selector(dismissFromTarget) withObject:nil afterDelay:interval];
}
-(void)dismissFromTarget{
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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
