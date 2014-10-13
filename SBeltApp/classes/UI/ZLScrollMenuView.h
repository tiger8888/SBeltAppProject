//
//  ZLScrollMenuView.h
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLScrollMenuView : UIView{
    NSMutableArray *itemsArray;
    UIImageView *texttureView;
    UIScrollView *scrollView;
}


-(void)addItemIntoMenuWithNormalImage:(UIImage *)nImg withHighLightImage:(UIImage *)hImg withTitle:(NSString *)title withTarget:(id)target withSel:(SEL)sel;
-(void)layoutAllButtons;

@end
