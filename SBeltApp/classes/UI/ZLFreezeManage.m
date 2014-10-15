//
//  ZLFreezeManage.m
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLFreezeManage.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+Curled.h"

@implementation ZLFreezeManage


+(ZLFreezeManage *)freezeManageWithImge:(UIImage *)img{
    ZLFreezeManage *freezeManage = [[ZLFreezeManage alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [freezeManage setImage:img];
    return freezeManage;
}

-(void)setImage:(UIImage *)img{
    _img = img;
    [freezeImgView setImage:_img borderWidth:4.0 shadowDepth:20.0 controlPointXOffset:400.0 controlPointYOffset:400.0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
        

        
    }
    freezeImgView = [[UIImageView alloc] initWithImage:nil];
    freezeImgView.frame = CGRectMake(5, 5, 320-10, 460-10);
    freezeImgView.layer.borderColor = [UIColor whiteColor].CGColor;
    freezeImgView.layer.borderWidth = 2;
    [self addSubview:freezeImgView];
    
    UIButton *storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeBtn.frame = CGRectMake(0, 0, 100, 40);
    storeBtn.center = CGPointMake(80, 340);
    [storeBtn setTitle:@"存储" forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [storeBtn setBackgroundColor:[UIColor blackColor]];
    storeBtn.layer.cornerRadius = 20;
    storeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    storeBtn.layer.shadowOffset = CGSizeMake(2, 2);
    storeBtn.layer.shadowOpacity = 0.8;
    [storeBtn addTarget:self action:@selector(storeImageIntoLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:storeBtn];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 40);
    backBtn.center = CGPointMake(320-80, 340);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [backBtn setBackgroundColor:[UIColor blackColor]];
    backBtn.layer.cornerRadius = 20;
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(2, 2);
    backBtn.layer.shadowOpacity = 0.8;
    [backBtn addTarget:self action:@selector(exitFromFreezeManage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self exitFromFreezeManage];
}
- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
  UIAlertView *alertView;
  if(error == nil)
  {
    alertView = [[UIAlertView alloc] initWithTitle:@"图片保存成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  }
  else
  {
    alertView = [[UIAlertView alloc] initWithTitle:@"图片保存失败" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
  }
  [alertView show];
}
-(void)storeImageIntoLibrary{
  
  UIImageWriteToSavedPhotosAlbum(_img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}
-(void)exitFromFreezeManage{
    [self removeFromSuperview];
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
