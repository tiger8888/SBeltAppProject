//
//  ZLTreeView.m
//  SBeltApp
//
//  Created by 王 维 on 6/18/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLTreeView.h"
#import <QuartzCore/QuartzCore.h>
#import "utilityComponentView.h"

@implementation ZLTreeView
@synthesize delegate;

+(ZLTreeView *)getTree{
    ZLTreeView *_tree = [[ZLTreeView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    return _tree;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        
        mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 300, 300) style:UITableViewStylePlain];
        mainTable.center = CGPointMake(320/2, mainTable.center.y);
        mainTable.delegate = self;
        mainTable.dataSource = self;
        mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        mainTable.layer.borderColor = [UIColor orangeColor].CGColor;
        mainTable.layer.borderWidth = 2;
        
        [self addSubview:mainTable];
    }
    return self;
}

-(void)setContent:(NSDictionary *)content{
    _content = content;
    dirArray = [_content allKeys];
    //是否折叠
    foldedArray = [[NSMutableArray alloc] init];
    for (NSString *key in dirArray) {
        NSNumber *bFold = [NSNumber numberWithBool:YES];
        [foldedArray addObject:bFold];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
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
#pragma mark tableview begin
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == mainTable) {
        return dirArray.count;
    }
    return 7;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == mainTable) {
        NSNumber *foldNumber = [foldedArray objectAtIndex:indexPath.row];
        BOOL bFold = [foldNumber boolValue];
        if (bFold) {
            return 40.0;
        }else{
            return 30*7+40;
        }
    }
    return 30.0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    return footer;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cellForRowAtIndexPath %d",indexPath.row);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
    

    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

    
    
    if (tableView == mainTable) {
        
        NSNumber *foldNumber = [foldedArray objectAtIndex:indexPath.row];
        BOOL bFold = [foldNumber boolValue];
        NSString *dirName = [dirArray objectAtIndex:indexPath.row];
        
        
        UIButton *dirButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dirButton.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        dirButton.frame = CGRectMake(0, 0, 320, 40);
        dirButton.tag =  200+indexPath.row;
        dirButton.layer.borderColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0].CGColor;
        dirButton.layer.borderWidth = 2;
        [dirButton addTarget:self action:@selector(dirButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:dirButton];
        
        UILabel *dirLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        dirLabel.backgroundColor =[UIColor clearColor];
        dirLabel.text = dirName;
        dirLabel.tag = 5;
        dirLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        [dirButton addSubview:dirLabel];
        
        
        if (!bFold) {
            UITableView *subTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, 300, 30*7) style:UITableViewStylePlain];
            subTable.delegate = self;
            subTable.dataSource = self;
//            subTable.userInteractionEnabled = NO;
            subTable.scrollEnabled = NO;
            subTable.tag = 100+indexPath.row;
            [cell addSubview:subTable];
        }
        return cell;
    }
    
    NSString *keyDir = [dirArray objectAtIndex:tableView.tag - 100];
    NSArray *files = [_content valueForKey:keyDir];
    //NSLog(keyDir);
//    for (NSString *path in files) {
//        NSLog(path);
//    }
    NSString *filePath = [files objectAtIndex:indexPath.row];
    //NSLog(filePath);
    UILabel *fileLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 300, 40)];
    fileLabel.backgroundColor =[UIColor clearColor];
    fileLabel.text = filePath;//[files objectAtIndex:indexPath.row];
    fileLabel.font = [UIFont fontWithName:@"STHeitiTC-Medium" size:14];
    fileLabel.tag = 122;
    [cell.contentView addSubview:fileLabel];
//    
//    ZLSeperator *seperator = [ZLSeperator seperatorWithWidth:tableView.frame.size.width - 2];
//    seperator.frame = CGRectMake(0, 0, 300, 40);
//    seperator.center = CGPointMake(tableView.frame.size.width/2, 40);
//    [cell addSubview:seperator];
//    
    return  cell;
    
}
-(void)dirButtonHandler:(id)sender{
    UIButton *btn = (UIButton *)sender;
    unsigned int index = btn.tag - 200;

    NSNumber *foldNumber = [foldedArray objectAtIndex:index];
    BOOL bFold = [foldNumber boolValue];
    bFold = !bFold;
    
    [foldedArray replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:bFold]];
                            
    [mainTable reloadData];

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (tableView == mainTable) {
//        NSNumber *foldNumber = [foldedArray objectAtIndex:indexPath.row];
//        BOOL bFold = [foldNumber boolValue];
//        bFold = !bFold;
//        
//        [foldedArray replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:bFold]];
//        
//        [tableView reloadData];
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *dirLabel = (UILabel *)[tableView.superview viewWithTag:5];
        UILabel *fileLabel = (UILabel *)[cell.contentView viewWithTag:122];
        if ([self.delegate respondsToSelector:@selector(treeView:didSelectFile:inDir:)]) {
            [self.delegate treeView:self didSelectFile:fileLabel.text inDir:dirLabel.text];
        }
        [self removeFromSuperview];
        
    }

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark tableview end


@end
