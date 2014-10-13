//
//  ZLPopInfoView.h
//  SBeltApp
//
//  Created by 王 维 on 7/3/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPopInfoView : UIView{
    UIView      *_targetView;
    UILabel     *_contentLabel;
}


+(ZLPopInfoView *)popInfoViewWithContent:(NSString *)content withTargetView:(UIView *)targetView;
-(void)showWitInterval:(CGFloat)interval;

@end
