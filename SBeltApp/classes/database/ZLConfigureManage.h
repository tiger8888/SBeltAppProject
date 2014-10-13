//
//  ZLConfigureManage.h
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLUserInfoObject.h"

@interface ZLConfigureManage : NSObject{
    NSString *path;
}

-(NSMutableArray *)getAllUser;
-(BOOL)addNewUser:(ZLUserInfoObject *)userInfo;
-(BOOL)deleteUserByName:(NSString *)name;
-(ZLUserInfoObject *)getUserInforByName:(NSString *)name;
-(BOOL)updateUserInfo:(ZLUserInfoObject *)userInfo;


//设置当前用户
-(void)setCurrentUserName:(NSString *)user;
-(NSString *)getCurrentUser;



@end
