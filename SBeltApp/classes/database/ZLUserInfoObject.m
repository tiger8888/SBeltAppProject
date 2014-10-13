//
//  ZLUserInfoObject.m
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLUserInfoObject.h"

@implementation ZLUserInfoObject
@synthesize name,breathRate,behaveSelectIndex,statusSelectIndex,medicateSelectIndex,strOthersBehaveType,strOthersDiseaseType,strOthersMedicateType,strOthersStatusType,guideBreathRate;

-(id)init{
    self = [super init];
    if (self) {
        self.name = @"empty";
        self.breathRate = @"breathRate";
        self.guideBreathRate = [NSNumber numberWithInt:6];
        self.behaveSelectIndex = [NSNumber numberWithInt:0];
        self.statusSelectIndex = [NSNumber numberWithInt:0];
        self.medicateSelectIndex = [NSNumber numberWithInt:0];
        self.strOthersBehaveType = @"----";
        self.strOthersStatusType = @"----";
        self.strOthersDiseaseType = @"----";
        self.strOthersMedicateType = @"----";
        
    }
    return self;
}

//对象解码 反序列化
#define kUserInfoObjectName                         @"keyUserInfoObjectName"
#define kUserInfoObjectBreathRate                   @"keyUserInfoObjectBreathRate"
#define kUserInfoObjectGuideBreathRate              @"keyUserInfoObjectGuideBreathRate"
#define kUserInfoObjectBehaveSelectIndex            @"keyUserInfoObjectBehaveSelectIndex"
#define kUserInfoObjectStatusSelectIndex            @"keyUserInfoObjectStatusSelectIndex"
#define kUserInfoObjectMedicateSelectIndex          @"keyUserInfoObjectMedicateSelectIndex"
#define kUserInfoObjectStrOthersBehaveType          @"keyUserInfoObjectStrOthersBehaveType"
#define kUserInfoObjectStrOthersStatusType          @"keyUserInfoObjectStrOthersStatusType"
#define kUserInfoObjectStrOthersDiseaseType         @"keyUserInfoObjectStrOthersDiseaseType"
#define kUserInfoObjectStrOthersMedicateType        @"keyUserInfoObjectStrOthersMedicateType"


-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.name               = [aDecoder decodeObjectForKey:kUserInfoObjectName];
        self.breathRate         = [aDecoder decodeObjectForKey:kUserInfoObjectBreathRate];
        self.guideBreathRate    = [aDecoder decodeObjectForKey:kUserInfoObjectGuideBreathRate];
        self.behaveSelectIndex  = [aDecoder decodeObjectForKey:kUserInfoObjectBehaveSelectIndex];
        self.statusSelectIndex  = [aDecoder decodeObjectForKey:kUserInfoObjectStatusSelectIndex];
        self.medicateSelectIndex= [aDecoder decodeObjectForKey:kUserInfoObjectMedicateSelectIndex];
        self.strOthersBehaveType= [aDecoder decodeObjectForKey:kUserInfoObjectStrOthersBehaveType];
        self.strOthersStatusType= [aDecoder decodeObjectForKey:kUserInfoObjectStrOthersStatusType];
        self.strOthersDiseaseType= [aDecoder decodeObjectForKey:kUserInfoObjectStrOthersDiseaseType];
        self.strOthersMedicateType=[aDecoder decodeObjectForKey:kUserInfoObjectStrOthersMedicateType];
        
    
    }
    return self;
}

//序列化
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:kUserInfoObjectName];
    [aCoder encodeObject:self.breathRate forKey:kUserInfoObjectBreathRate];
    [aCoder encodeObject:self.guideBreathRate forKey:kUserInfoObjectGuideBreathRate];
    [aCoder encodeObject:self.behaveSelectIndex forKey:kUserInfoObjectBehaveSelectIndex];
    [aCoder encodeObject:self.statusSelectIndex forKey:kUserInfoObjectStatusSelectIndex];
    [aCoder encodeObject:self.medicateSelectIndex forKey:kUserInfoObjectMedicateSelectIndex];
    [aCoder encodeObject:self.strOthersBehaveType forKey:kUserInfoObjectStrOthersBehaveType];
    [aCoder encodeObject:self.strOthersStatusType forKey:kUserInfoObjectStrOthersStatusType];
    [aCoder encodeObject:self.strOthersDiseaseType forKey:kUserInfoObjectStrOthersDiseaseType];
    [aCoder encodeObject:self.strOthersMedicateType forKey:kUserInfoObjectStrOthersMedicateType];
    
}

@end
