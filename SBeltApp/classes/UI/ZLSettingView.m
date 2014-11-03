//
//  ZLSettingView.m
//  SBeltApp
//
//  Created by 王 维 on 6/20/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLSettingView.h"
#import "sharedHeader.h"
#import <QuartzCore/QuartzCore.h>

#define  HEIGHT_OF_CELL       40.0
#define  HEIGHT_OF_HEADER     90.0

@implementation ZLSettingView

+(ZLSettingView *)getSettingView{
    ZLSettingView *settingView = [[ZLSettingView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    return settingView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];

        
        UITableView *itemlist = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 2*HEIGHT_OF_CELL+HEIGHT_OF_HEADER +20+20) style:UITableViewStyleGrouped];
        itemlist.layer.cornerRadius = 10;
        itemlist.layer.borderColor = [UIColor blackColor].CGColor;
        itemlist.layer.borderWidth = 2;
        itemlist.delegate = self;
        itemlist.dataSource = self;
        itemlist.center = CGPointMake(WIDTH_OF_SCREEN/2, HEIGHT_OF_SCREEN/2);
        [self addSubview:itemlist];
        
    }
    return self;
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
static bool lastValue = NO;
- (void)screenOffOnIdle:(id)sender
{
  UISwitch *switchBtn = sender;
  [UIApplication sharedApplication].idleTimerDisabled = (!switchBtn.on);
  lastValue = switchBtn.enabled;
}
#pragma mark tableview begin
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_OF_CELL;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return HEIGHT_OF_HEADER;
//    }else
    if (section == 0){
        return HEIGHT_OF_HEADER;
    }else if (section == 1){
        return 10;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_HEADER)];
    header.backgroundColor = [UIColor clearColor];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont fontWithName:@"" size:20];
    
    [header addSubview:text];
    
    
    UILabel *textDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 240, HEIGHT_OF_HEADER-30)];
    textDetail.backgroundColor = [UIColor clearColor];
    textDetail.font = [UIFont fontWithName:@"STHeitiJ-Light" size:12];
    textDetail.numberOfLines = 4;
    [header addSubview:textDetail];
    
    
//    if (section == 0) {
//             text.text = @"串口设置";
//             textDetail.text = @"波特率，串口号的设置，待定，如果不需要可以去掉";
//    }else
      if(section == 0){
            text.text = @"待机状态";
            textDetail.text = @"有两个选项，一是“一直开着”，二是“自动关屏”，注：“自动关屏”状态下，只是LCD黑屏，但如果此时正在存储中，则不停止存储";
    }
    
    return header;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    [footer setBackgroundColor:[UIColor clearColor]];
    return footer;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    if (indexPath.section == 0) {
//         
//    }
//    else
      if(indexPath.section == 0){
        UILabel *alwaysOpen = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, HEIGHT_OF_CELL)];
        alwaysOpen.backgroundColor = [UIColor clearColor];
        alwaysOpen.text = @"一直开着";
        [cell addSubview:alwaysOpen];
        
        UISwitch *onOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 200, HEIGHT_OF_CELL)];
        onOffSwitch.center = CGPointMake(300/2, HEIGHT_OF_CELL/2);
        onOffSwitch.on = lastValue;
        [onOffSwitch setBackgroundColor:[UIColor clearColor]];
        [onOffSwitch addTarget:self action:@selector(screenOffOnIdle:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:onOffSwitch];
        
        UILabel *autoClose = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, HEIGHT_OF_CELL)];
        autoClose.backgroundColor = [UIColor clearColor];
        autoClose.text = @"自动黑屏";
        [cell addSubview:autoClose];
    }
    else if (indexPath.section == 1){
        UILabel *synTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, HEIGHT_OF_CELL)];
        synTimeLabel.backgroundColor = [UIColor clearColor];
        synTimeLabel.text = @"点击同步时间";
        [cell addSubview:synTimeLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
  
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    printf("didSelectRowAtIndexPath\n");
    if (indexPath.section == 2) {
       ZLBluetoothLEManage *bleMgr = [ZLBluetoothLEManage sharedInstanceWithLandscape:NO mode:0];
        [bleMgr syncCurrentTime];
    }
    
}



@end
