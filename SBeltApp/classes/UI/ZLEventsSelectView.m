//
//  ZLEventsSelectView.m
//  SBeltApp
//
//  Created by 王 维 on 9/17/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLEventsSelectView.h"
#import "sharedHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "utilityComponentView.h"


#define WIDTH_OF_SCREEN_HERE            HEIGHT_OF_SCREEN
#define HEIGTH_OF_SCREEN_HERE           WIDTH_OF_SCREEN
#define COLOR_OF_FRAME                  [UIColor colorWithWhite:1.0 alpha:1.0]
#define COLOR_OF_BG                     [UIColor colorWithWhite:0.6 alpha:1.0]
#define TAG_OF_GRAPHICS                 11

#define COLOR_OF_BEHAVE                 [UIColor greenColor]
#define COLOR_OF_STATUS                 [UIColor purpleColor]
#define COLOR_OF_MEDICATE               [UIColor orangeColor]


NSString *behaveTypeStrings[] ={
    @"慢跑",
    @"快跑",
    @"走路",
    @"静坐休息",
    @"平躺",
    @"上下楼",
    @"电脑前办公",
    @"吃饭",
    @"大便",
    @"小便",
    @"看电视",
    @"睡觉",
    @"自定义输入:"
};

NSString *statusTypeStrings[] ={
    @"愉悦",
    @"悲伤",
    @"郁闷",
    @"紧张",
    @"焦虑",
    @"疲劳",
    @"烦躁",
    @"睡眠不足",
    @"生病",
    @"自定义输入:",

};
NSString *medicateTypeStrings[] ={
    @"疾病类型输入:",
    @"用药情况输入:"
};
@implementation ZLEventsSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, self.frame.size.height)];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
        [self addSubview:backgroundView];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE - 80, HEIGTH_OF_SCREEN_HERE - 40)];
        containerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        containerView.layer.borderColor = COLOR_OF_FRAME.CGColor;
        containerView.layer.borderWidth = 4;
        containerView.center = CGPointMake(WIDTH_OF_SCREEN_HERE/2, HEIGTH_OF_SCREEN_HERE/2);
        [self addSubview:containerView];
        
        behaveSelectTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, containerView.frame.size.width/3, containerView.frame.size.height) style:UITableViewStylePlain];
        behaveSelectTable.delegate = self;
        behaveSelectTable.dataSource = self;
        behaveSelectTable.layer.borderColor = COLOR_OF_FRAME.CGColor;
        behaveSelectTable.layer.borderWidth = 2;
        behaveSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        behaveSelectTable.backgroundColor = COLOR_OF_BG;
        
        [containerView addSubview:behaveSelectTable];
        
        
        statusSelectTable = [[UITableView alloc] initWithFrame:CGRectMake(behaveSelectTable.frame.size.width, 0, containerView.frame.size.width/3, containerView.frame.size.height) style:UITableViewStylePlain];
        statusSelectTable.delegate = self;
        statusSelectTable.dataSource = self;
        statusSelectTable.layer.borderColor = COLOR_OF_FRAME.CGColor;
        statusSelectTable.layer.borderWidth = 2;
        statusSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        statusSelectTable.backgroundColor = COLOR_OF_BG;
        [containerView addSubview:statusSelectTable];
        
        medicateSelectTable = [[UITableView alloc] initWithFrame:CGRectMake(behaveSelectTable.frame.size.width + statusSelectTable.frame.size.width, 0, containerView.frame.size.width/3, containerView.frame.size.height) style:UITableViewStylePlain];
        medicateSelectTable.delegate = self;
        medicateSelectTable.dataSource = self;
        medicateSelectTable.layer.borderColor = COLOR_OF_FRAME.CGColor;
        medicateSelectTable.layer.borderWidth = 2;
        medicateSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        medicateSelectTable.backgroundColor = COLOR_OF_BG;
        [containerView addSubview:medicateSelectTable];
        
        //数据库读取
        _behaveCurrent = [currentUser.behaveSelectIndex intValue];
        _statusCurrent = [currentUser.statusSelectIndex intValue];
        _medicateCurrent = [currentUser.medicateSelectIndex intValue];
        [self initSelectArray];
        
        
        
        
        behaveOthersLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 30)];
        statusOthersLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 30)];
        diseaseLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 30)];
        medicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 100, 30)];
    }
    return self;
}
-(void)initSelectArray{
    behaveSelectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_BEHAVE; i++) {
        NSNumber *selectedNum;
        if (_behaveCurrent == i) {
            selectedNum = [NSNumber numberWithBool:YES];
        }else{
            selectedNum = [NSNumber numberWithBool:NO];
        }
        [behaveSelectedArray addObject:selectedNum];
    }
    statusSelectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_STATUS; i++) {
        NSNumber *selectedNum;
        if (_statusCurrent == i) {
            selectedNum = [NSNumber numberWithBool:YES];
        }else{
            selectedNum = [NSNumber numberWithBool:NO];
        }
        [statusSelectedArray addObject:selectedNum];
    }
    medicateSelectedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUM_OF_MEDICATE; i++) {
        NSNumber *selectedNum;
        if (_medicateCurrent == i) {
            selectedNum = [NSNumber numberWithBool:YES];
        }else{
            selectedNum = [NSNumber numberWithBool:NO];
        }
        [medicateSelectedArray addObject:selectedNum];
    }
}
-(id)initWithTarget:(id)target{
    self = [self initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE)];
    if (self) {
        _target = target;
    }
    return self;
}

//table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == behaveSelectTable) {
        return NUM_OF_BEHAVE;
    }else if (tableView == statusSelectTable){
        return NUM_OF_STATUS;
    }else if (tableView == medicateSelectTable){
        return NUM_OF_MEDICATE;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == behaveSelectTable) {
        if (indexPath.row == NUM_OF_BEHAVE - 1) {
            return 80;
        }
    }else if (tableView == statusSelectTable){
        if (indexPath.row == NUM_OF_STATUS - 1) {
            return 80;
        }
    }else if (tableView == medicateSelectTable){
        return 80;
    }
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    header.backgroundColor = COLOR_OF_FRAME;
    
    UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerTitle.backgroundColor = [UIColor clearColor];
    [header addSubview:headerTitle];
    headerTitle.textAlignment = NSTextAlignmentCenter;
    
    if (tableView == behaveSelectTable) {
        headerTitle.text = @"身体活动情况";
        headerTitle.textColor = COLOR_OF_BEHAVE;
    }else if (tableView == statusSelectTable){
        headerTitle.text = @"身心状态";
        headerTitle.textColor = COLOR_OF_STATUS;
    }else if (tableView == medicateSelectTable){
        headerTitle.text = @"用药情况";
        headerTitle.textColor = COLOR_OF_MEDICATE;
    }
    
    
    
    return header;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZLEVENTSSELECTVIEW_CELL_ID"];
    
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.rowHeight)];
//    bgView.backgroundColor = COLOR_OF_BG;
//    [cell addSubview:bgView];
    
    ZLSelectGraphics *selectGraphics = [[ZLSelectGraphics alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    selectGraphics.center = CGPointMake(20, tableView.rowHeight/2);
    selectGraphics.tag = TAG_OF_GRAPHICS;
    [cell addSubview:selectGraphics];
    [selectGraphics setSelected:NO];
    
    UILabel *description = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 100, 30)];
    description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    description.font = [UIFont fontWithName:@"ArialMT" size:14];
    description.center = CGPointMake(description.center.x, tableView.rowHeight/2 - 2);
    [cell addSubview:description];
    
    UIColor *bgOfInput = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    if (tableView == behaveSelectTable) {
        [selectGraphics setSelectedColor:COLOR_OF_BEHAVE];
        NSNumber *selectedNum = [behaveSelectedArray objectAtIndex:indexPath.row];
        [selectGraphics setSelected:[selectedNum boolValue]];
        
        description.text = behaveTypeStrings[indexPath.row];
        
        if ([selectedNum boolValue]) {
            description.textColor =  COLOR_OF_BEHAVE;
        }else{
            description.textColor = [UIColor whiteColor];
        }
        
        
        if (indexPath.row == NUM_OF_BEHAVE - 1) {
            
            behaveOthersLabel.backgroundColor = bgOfInput;
            behaveOthersLabel.textColor = description.textColor;
            behaveOthersLabel.font = description.font;
            behaveOthersLabel.text = currentUser.strOthersBehaveType;
            [cell addSubview:behaveOthersLabel];
        }
        
        
    }else if (tableView == statusSelectTable){
        [selectGraphics setSelectedColor:COLOR_OF_STATUS];
        NSNumber *selectedNum = [statusSelectedArray objectAtIndex:indexPath.row];
        [selectGraphics setSelected:[selectedNum boolValue]];
        
        description.text = statusTypeStrings[indexPath.row];
        
        if ([selectedNum boolValue]) {
             description.textColor =  COLOR_OF_STATUS;
        }else{
            description.textColor = [UIColor whiteColor];
        }
        
        if (indexPath.row == NUM_OF_STATUS - 1) {
           
            statusOthersLabel.backgroundColor = bgOfInput;
            statusOthersLabel.textColor = description.textColor;
            statusOthersLabel.text = currentUser.strOthersStatusType;
            [cell addSubview:statusOthersLabel];
        }
        
        
    }else if (tableView == medicateSelectTable){
         [selectGraphics setSelectedColor:COLOR_OF_MEDICATE];
        NSNumber *selectedNum = [medicateSelectedArray objectAtIndex:indexPath.row];
        [selectGraphics setSelected:[selectedNum boolValue]];
        
         description.text = medicateTypeStrings[indexPath.row];
        
        if ([selectedNum boolValue]) {
            description.textColor =  COLOR_OF_MEDICATE;
        }else{
            description.textColor = [UIColor whiteColor];
        }
        
        if (indexPath.row == 0) {
            
            diseaseLabel.backgroundColor = bgOfInput;
            diseaseLabel.textColor = description.textColor;
            diseaseLabel.text = currentUser.strOthersDiseaseType;
            [cell addSubview:diseaseLabel];
        }else{
            
            medicateLabel.backgroundColor = bgOfInput;
            medicateLabel.textColor = description.textColor;
            medicateLabel.text = currentUser.strOthersMedicateType;
            [cell addSubview:medicateLabel];
        
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    ZLSeperator *seperator = [ZLSeperator seperatorWithWidth:tableView.frame.size.width - 2];
    seperator.center = CGPointMake(tableView.frame.size.width/2, tableView.rowHeight-5);
    
    [cell addSubview:seperator];
    
    
    //自我输入
    if (tableView == behaveSelectTable) {
        if (indexPath.row == NUM_OF_BEHAVE - 1) {
            seperator.center = CGPointMake(tableView.frame.size.width/2, tableView.rowHeight*2-5);
            selectGraphics.center = CGPointMake(20, tableView.rowHeight);
        }
    }else if (tableView == statusSelectTable){
        if (indexPath.row == NUM_OF_STATUS - 1) {
            seperator.center = CGPointMake(tableView.frame.size.width/2, tableView.rowHeight*2-5);
            selectGraphics.center = CGPointMake(20, tableView.rowHeight);
        }
    }else if (tableView == medicateSelectTable){
        seperator.center = CGPointMake(tableView.frame.size.width/2, tableView.rowHeight*2-5);
        selectGraphics.center = CGPointMake(20, tableView.rowHeight);
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectRowAtIndexPath");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (tableView == behaveSelectTable) {
         NSNumber *selectedNum = [NSNumber numberWithBool:YES];
        [behaveSelectedArray replaceObjectAtIndex:indexPath.row withObject:selectedNum];
        
        if (_behaveCurrent < behaveSelectedArray.count) {
            NSNumber *selectedNum = [NSNumber numberWithBool:NO];
            [behaveSelectedArray replaceObjectAtIndex:_behaveCurrent withObject:selectedNum];
        }
        
        _behaveCurrent = indexPath.row;
        
        //存储
        currentUser.behaveSelectIndex = [NSNumber numberWithInt:_behaveCurrent];
        [configureMnger updateUserInfo:currentUser];
        
        
        if (indexPath.row == NUM_OF_BEHAVE - 1) {
            currentTextInputMode = ZLBehaveTypeOthers;
            [self enterInputMode];
        }
        
    }else if (tableView == statusSelectTable){
        NSNumber *selectedNum = [NSNumber numberWithBool:YES];
        [statusSelectedArray replaceObjectAtIndex:indexPath.row withObject:selectedNum];
        
        if (_statusCurrent < statusSelectedArray.count) {
            NSNumber *selectedNum = [NSNumber numberWithBool:NO];
            [statusSelectedArray replaceObjectAtIndex:_statusCurrent withObject:selectedNum];
        }
        
        _statusCurrent = indexPath.row;
        //存储
        currentUser.statusSelectIndex = [NSNumber numberWithInt:_statusCurrent];
        [configureMnger updateUserInfo:currentUser];
        
        
        if (indexPath.row == NUM_OF_STATUS - 1) {
            currentTextInputMode = ZLStatusTypeOthers;
            [self enterInputMode];
        }
        
        
    }else if (tableView == medicateSelectTable){
        NSNumber *selectedNum = [NSNumber numberWithBool:YES];
        [medicateSelectedArray replaceObjectAtIndex:indexPath.row withObject:selectedNum];
        
        if (_medicateCurrent < medicateSelectedArray.count) {
            NSNumber *selectedNum = [NSNumber numberWithBool:NO];
            [medicateSelectedArray replaceObjectAtIndex:_medicateCurrent withObject:selectedNum];
        }
        
        _medicateCurrent = indexPath.row;
        //存储
        currentUser.medicateSelectIndex = [NSNumber numberWithInt:_medicateCurrent];
        [configureMnger updateUserInfo:currentUser];
        
        
        if (indexPath.row == 0) {
            currentTextInputMode = ZLMedicateTypeDiseaseType;
            [self enterInputMode];
        }else{
            currentTextInputMode = ZLMedicateTypeMedicateType;
            [self enterInputMode];
        }
        
    }
    
    [tableView reloadData];
    
    
    
}
-(void)didTextInputViewFinishTextInput:(ZLPopTextInputView *)popTextInputView withText:(NSString *)text{
    switch (currentTextInputMode) {
        case ZLBehaveTypeOthers:
            behaveOthersLabel.text = text;
            currentUser.strOthersBehaveType = text;
            break;
        case ZLStatusTypeOthers:
            statusOthersLabel.text = text;
            currentUser.strOthersStatusType = text;
            break;
            
        case ZLMedicateTypeDiseaseType:
            diseaseLabel.text = text;
            currentUser.strOthersDiseaseType = text;
            break;
        case ZLMedicateTypeMedicateType:
            medicateLabel.text = text;
            currentUser.strOthersMedicateType = text;
            break;
        default:
            break;
    }
    [configureMnger updateUserInfo:currentUser];

}
-(void)enterInputMode{
    NSString *title;
    switch (currentTextInputMode) {
        case ZLBehaveTypeOthers:
            title = @"自定义身体活动情况";
            break;
        case ZLStatusTypeOthers:
            title = @"自定义身心状态";
            break;
        case ZLMedicateTypeDiseaseType:
            title = @"疾病类型输入";
            break;
        case ZLMedicateTypeMedicateType:
            title = @"用药情况输入";
            break;

            
        default:
            break;
    }
    ZLPopTextInputView *popTextInput = [ZLPopTextInputView popTextInputViewWithTarget:self.superview withTitle:title];
    popTextInput.delegate = self;
    [popTextInput popOutToShow];
}
-(void)clearArray:(NSMutableArray *)array{
    for (NSNumber *num in array) {
        NSNumber *selectedNum = [NSNumber numberWithBool:NO];
        
    }
}
-(void)setCell:(UITableViewCell *)cell toSelect:(BOOL)selected{
    ZLSelectGraphics *selectG = (ZLSelectGraphics *)[cell viewWithTag:TAG_OF_GRAPHICS];
    [selectG setSelected:selected];
    
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

@end

@implementation ZLSelectGraphics

-(id)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _selected = NO;
        selectedColor = [UIColor greenColor];
    }
    return self;
}
-(void)setSelected:(BOOL)selected{
    _selected = selected;
    [self setNeedsDisplay];
}
-(void)setSelectedColor:(UIColor *)color{
    selectedColor = color;
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat widthOfLine = 2.0;
    CGFloat radius = 6;
    
    CGContextSetRGBStrokeColor(context, 255, 100, 100, 1);
    
    CGContextSetLineWidth(context, widthOfLine);
    CGContextAddEllipseInRect(context, CGRectMake(self.frame.size.width/2-(radius + widthOfLine), self.frame.size.height/2-(radius + widthOfLine), radius*2, radius*2));//在这个框中画圆
    CGContextStrokePath(context);
    if (_selected) {
        CGContextSetFillColorWithColor(context, selectedColor.CGColor);
        CGContextFillEllipseInRect(context, CGRectMake(self.frame.size.width/2-(radius + widthOfLine/2), self.frame.size.height/2-(radius + widthOfLine/2), radius*2-widthOfLine, radius*2-widthOfLine));
    }
    
}

@end
