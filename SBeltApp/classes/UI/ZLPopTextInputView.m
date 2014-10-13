//
//  ZLPopTextInputView.m
//  SBeltApp
//
//  Created by 王 维 on 9/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLPopTextInputView.h"
#import "sharedHeader.h"
#import <QuartzCore/QuartzCore.h>


#define WIDTH_OF_SCREEN_HERE            HEIGHT_OF_SCREEN
#define HEIGTH_OF_SCREEN_HERE           WIDTH_OF_SCREEN

@implementation ZLPopTextInputView
@synthesize delegate;

+(ZLPopTextInputView *)popTextInputViewWithTarget:(id)target withTitle:(NSString *)title{
    ZLPopTextInputView *popTextInputView = [[ZLPopTextInputView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE) withTarget:target];
    
    [popTextInputView setTitle:title];
    
    return popTextInputView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];
        [self addSubview:bgView];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 180)];
        containerView.center = CGPointMake(WIDTH_OF_SCREEN_HERE/2, -100/2);
        containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        containerView.layer.borderColor = [UIColor cyanColor].CGColor;
        containerView.layer.borderWidth = 4;
        containerView.layer.shadowColor = [UIColor blackColor].CGColor;
        containerView.layer.shadowOffset = CGSizeMake(2, 2);
        containerView.layer.shadowOpacity = 1.0;
        [self addSubview:containerView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width - 40, 40)];
        titleLabel.textColor = [UIColor brownColor];
        titleLabel.center = CGPointMake(containerView.frame.size.width/2, 26);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [containerView addSubview:titleLabel];
        
        inputField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
        inputField.center = CGPointMake(containerView.frame.size.width/2, 70);
        inputField.backgroundColor = [UIColor grayColor];
        inputField.layer.cornerRadius = 4;
        inputField.delegate = self;
        inputField.textColor = [UIColor whiteColor];
        [containerView addSubview:inputField];
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmButton.frame = CGRectMake(0, 0, 80, 50);
        confirmButton.center = CGPointMake(containerView.frame.size.width *(0.25), containerView.frame.size.height - 40);
        
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        confirmButton.titleLabel.textColor = [UIColor cyanColor];
        confirmButton.layer.borderWidth = 4;
        confirmButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [confirmButton addTarget:self action:@selector(confirmPressedAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:confirmButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, 80, 50);
        cancelButton.center = CGPointMake(containerView.frame.size.width *(0.75), containerView.frame.size.height - 40);
        
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.textColor = [UIColor cyanColor];
        cancelButton.layer.borderWidth = 4;
        cancelButton.layer.borderColor = [UIColor cyanColor].CGColor;
        [cancelButton addTarget:self action:@selector(cancelPressedAction:) forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:cancelButton];
        
        
    
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withTarget:(id)target{
    _target = target;
    return [self initWithFrame:frame];
}
-(void)setTitle:(NSString *)title{
    titleLabel.text = title;
}

-(void)popOutToShow{
    
    UIView *vc = (UIView *)_target;
    [vc addSubview:self];
    
    [self animationOut];
    
}
-(void)animationOut{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        containerView.center = CGPointMake(WIDTH_OF_SCREEN_HERE/2, HEIGTH_OF_SCREEN_HERE/2 - 40);
    } completion:^(BOOL finished) {
        
    }];

}
-(void)dismissSelf{
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)confirmPressedAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didTextInputViewFinishTextInput:withText:)]) {
        [self.delegate didTextInputViewFinishTextInput:self withText:inputField.text];
    }
    [self dismissSelf];
}
-(void)cancelPressedAction:(id)sender{
    [self dismissSelf];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//-(void)showOut;


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
