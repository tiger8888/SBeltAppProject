//
//  ZLFlashView.h
//  SBeltApp
//
//  Created by 王 维 on 6/21/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLFlashView : UIView{
    UIView      *externalCircle;
    UIView      *internalCircle;
    NSTimer     *flashTimer;
}

+(ZLFlashView *)flashView;
-(void)startFlashAnimation;
-(void)stopFlashAnimation;


@end
