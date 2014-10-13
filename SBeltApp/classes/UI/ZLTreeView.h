//
//  ZLTreeView.h
//  SBeltApp
//
//  Created by 王 维 on 6/18/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLTreeView;

@protocol ZLTreeViewDelegate <NSObject>

-(void)treeView:(ZLTreeView *)tree didSelectFile:(NSString *)file inDir:(NSString *)dir;

@end

@interface ZLTreeView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *mainTable;
    NSDictionary *_content;
    
    NSArray *dirArray;
    NSMutableArray *foldedArray;
}
@property (assign,nonatomic) id<ZLTreeViewDelegate> delegate;
+(ZLTreeView *)getTree;
-(void)setContent:(NSDictionary *)content;


@end
