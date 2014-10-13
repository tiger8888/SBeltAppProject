//
//  ZLUserInfoObject.h
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLUserInfoObject : NSObject<NSCoding>{

}

@property (strong,nonatomic)    NSString        *name;
@property (strong,nonatomic)    NSString        *breathRate;

@property (strong,nonatomic)    NSNumber        *guideBreathRate;

@property (strong,nonatomic)    NSNumber        *behaveSelectIndex;
@property (strong,nonatomic)    NSNumber        *statusSelectIndex;
@property (strong,nonatomic)    NSNumber        *medicateSelectIndex;

@property (strong,nonatomic)    NSString        *strOthersBehaveType;
@property (strong,nonatomic)    NSString        *strOthersStatusType;
@property (strong,nonatomic)    NSString        *strOthersDiseaseType;
@property (strong,nonatomic)    NSString        *strOthersMedicateType;


@end
