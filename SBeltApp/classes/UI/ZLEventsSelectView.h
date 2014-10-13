//
//  ZLEventsSelectView.h
//  SBeltApp
//
//  Created by 王 维 on 9/17/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLPopTextInputView.h"


typedef NS_ENUM(NSInteger, behaveType) {
    ZLBehaveTypeRunSlowly               =   0x10,
    ZLBehaveTypeRunFast                 =   0x11,
    ZLBehaveTypeWalk                    =   0x12,
    ZLBehaveTypeSitStillToRest          =   0x13,
    ZLBehaveTypeLying                   =   0x14,
    ZLBehaveTypeUpOrDownStairs          =   0x15,
    ZLBehaveTypeWorkBesideComputer      =   0x16,
    ZLBehaveTypeEat                     =   0x17,
    ZLBehaveTypeDefecate                =   0x18,
    ZLBehaveTypePiss                    =   0x19,
    ZLBehaveTypeWatchTelevision         =   0x1A,
    ZLBehaveTypeSleep                   =   0x1B,
    ZLBehaveTypeOthers                  =   0x1C,
};
#define  NUM_OF_BEHAVE                  (ZLBehaveTypeOthers - ZLBehaveTypeRunSlowly + 1)


typedef NS_ENUM(NSInteger, statusType) {
    ZLStatusTypePleasure                =   0x20,
    ZLStatusTypeSadness                 =   0x21,
    ZLStatusTypeDepressed               =   0x22,
    ZLStatusTypeNervous                 =   0x23,
    ZLStatusTypeAnxiety                 =   0x24,
    ZLStatusTypeWeariness               =   0x25,
    ZLStatusTypeFretful                 =   0x26,
    ZLStatusTypeLackOfSleep             =   0x27,
    ZLStatusTypeSick                    =   0x28,
    ZLStatusTypeOthers                  =   0x29,
};
#define  NUM_OF_STATUS                  (ZLStatusTypeOthers - ZLStatusTypePleasure + 1)

typedef NS_ENUM(NSInteger, medicateType) {
    ZLMedicateTypeDiseaseType           =   0x30,
    ZLMedicateTypeMedicateType          =   0x31,
};

#define NUM_OF_MEDICATE                 (ZLMedicateTypeMedicateType - ZLMedicateTypeDiseaseType + 1)





@interface ZLEventsSelectView : UIView<UITableViewDataSource,UITableViewDelegate,ZLPopTextInputDelegate>
{
    UITableView *behaveSelectTable;
    UITableView *statusSelectTable;
    UITableView *medicateSelectTable;
    id _target;
    UIView      *backgroundView;
    UIView      *containerView;
    
    
    int      _behaveCurrent;
    int      _statusCurrent;
    int    _medicateCurrent;
    
    NSMutableArray  *behaveSelectedArray;
    NSMutableArray  *statusSelectedArray;
    NSMutableArray  *medicateSelectedArray;
    
    int             currentTextInputMode;
    UILabel         *behaveOthersLabel;
    UILabel         *statusOthersLabel;
    UILabel         *diseaseLabel;
    UILabel         *medicateLabel;
    
}

-(id)initWithTarget:(id)target;


@end



@protocol ZLEventSelectViewDelegate <NSObject>

-(void)didZLEventsSelectedResultWithBehave:(behaveType)_behave status:(statusType)_status medicate:(medicateType)_medicate;

@end



@interface ZLSelectGraphics : UIView{
    UIColor *selectedColor;
    BOOL    _selected;
}

-(void)setSelected:(BOOL)selected;
-(void)setSelectedColor:(UIColor *)color;
    
    
@end



