//
//  ZLPopTextInputView.h
//  SBeltApp
//
//  Created by 王 维 on 9/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLPopTextInputView;

@protocol ZLPopTextInputDelegate <NSObject>

-(void)didTextInputViewFinishTextInput:(ZLPopTextInputView *)popTextInputView withText:(NSString *)text;


@end


@interface ZLPopTextInputView : UIView<UITextFieldDelegate>{
    
    UIView *bgView;
    UIView *containerView;
    UILabel *titleLabel;
    UITextField *inputField;
    id      _target;
}

@property (strong,nonatomic) id<ZLPopTextInputDelegate> delegate;

+(ZLPopTextInputView *)popTextInputViewWithTarget:(id)target withTitle:(NSString *)title;
-(void)popOutToShow;
-(void)setTitle:(NSString *)title;
@end


