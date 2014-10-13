//
//  languageStringManager.h
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  languageStringKey(key)    ([[languageStringManage sharedInstance] getStringByKey:(key)])


typedef NS_ENUM(NSInteger, languageMode){
    
    LANGUAGEMODE_CHINESE,
    LANGUAGEMODE_ENGLISH,
    
    LANGUAGETYPEEND
    
};
@interface languageStringManage : NSObject{
    languageMode currentMode;
    NSString        *plistPath;
}

+(languageStringManage *)sharedInstance;

-(NSString *)getStringByKey:(NSString *)skey;


@end
