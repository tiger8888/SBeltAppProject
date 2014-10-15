//
//  ZLFreezeManage.h
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLFreezeManage : UIView<UIAlertViewDelegate>
{
    UIImage *_img;
    UIImageView *freezeImgView;
}

+(ZLFreezeManage *)freezeManageWithImge:(UIImage *)img;
-(void)setImage:(UIImage *)img;

@end
