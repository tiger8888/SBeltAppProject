//
//  languageStringManager.m
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "languageStringManage.h"

#define  keyForChineseMode              @"chinese"
#define  keyForEnglishMode              @"english"

@implementation languageStringManage

+(languageStringManage *)sharedInstance{
    static languageStringManage *sharedInstance = nil;
    
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if (self) {
        currentMode = LANGUAGEMODE_CHINESE;
        plistPath = [[NSBundle mainBundle] pathForResource:@"strings" ofType:@"plist"];
        
    }
    return self;
}
-(NSString *)getLanguageKeyByMode{
    return (currentMode == LANGUAGEMODE_CHINESE)?keyForChineseMode:keyForEnglishMode;
}
-(NSString *)getStringByKey:(NSString *)skey{
    NSDictionary *stringGroup = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSDictionary *currentLanguageStringGroup = (NSDictionary *)[stringGroup valueForKey:[self getLanguageKeyByMode]];
   NSString *getString = (NSString *)[currentLanguageStringGroup valueForKey:skey];
    return getString;
}



@end
