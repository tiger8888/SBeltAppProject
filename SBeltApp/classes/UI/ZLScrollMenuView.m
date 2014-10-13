//
//  ZLScrollMenuView.m
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLScrollMenuView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ZLScrollMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.4]];
        texttureView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textureBackground.png"]];
        texttureView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:texttureView];
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:scrollView];
        
        scrollView.showsHorizontalScrollIndicator = NO;
        itemsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addItemIntoMenuWithNormalImage:(UIImage *)nImg withHighLightImage:(UIImage *)hImg withTitle:(NSString *)title withTarget:(id)target withSel:(SEL)sel{
    UIButton *addedButton  =  [UIButton buttonWithType:UIButtonTypeCustom];
    addedButton.backgroundColor = [UIColor clearColor];
    addedButton.layer.shadowColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    addedButton.layer.shadowOffset = CGSizeMake(0, 1);
    addedButton.layer.shadowOpacity = 1.0;
    addedButton.layer.shadowRadius = 2;
    addedButton.showsTouchWhenHighlighted = YES;
//    addedButton.layer.borderColor = [UIColor grayColor].CGColor;
//    addedButton.layer.borderWidth = 2;
    [addedButton setTitle:title forState:UIControlStateNormal];
    addedButton.titleLabel.font = [UIFont fontWithName:@"ArialMT" size:20];
    [addedButton setImage:nImg forState:UIControlStateNormal];
    [addedButton setImage:hImg forState:UIControlStateHighlighted];
    [addedButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [itemsArray addObject:addedButton];
    
    
    
}

-(void)layoutAllButtons{
    CGFloat realWidth = itemsArray.count * 64 ;
    texttureView.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    [scrollView setContentSize:CGSizeMake(realWidth, 64)];
    
    for (int i = 0; i < itemsArray.count; i++) {
        UIButton *btn = [itemsArray objectAtIndex:i];
        btn.frame = CGRectMake(i*64, 0, 40, 40);
        btn.center = CGPointMake(i*64+64/2, 64/2);
        [scrollView addSubview:btn];
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
