//
//  ZLConfigureManage.m
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLConfigureManage.h"

#define USER_CONFIGURE_FILE_NAME        @"/UserInfomation.plist"


#define kUsersInDictionary              @"keyZLUsersInDictionary"

#define kCurrentUser                    @"keyCurrentUserInConfigureManage"



@implementation ZLConfigureManage

-(id)init{
    self  = [super init];
    if (self) {
        [self createFile];
        [self checkDefaultUser];
        
    }
    return self;
}

-(void)createFile{
    
    path = [[self getDocumentsDirectoryPath] stringByAppendingString:USER_CONFIGURE_FILE_NAME];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"user configure exist");
        return ;
    }else{
        
        //创建文件夹
        if([[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]){
            NSLog(@"creat file success");
        }else{
            NSLog(@"create file fail");
        }
        
    }
}

-(void)checkDefaultUser{

    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (allUser == nil) {
        
        allUser = [[NSMutableDictionary alloc] init];
        
        
        ZLUserInfoObject *defaultUser = [[ZLUserInfoObject alloc] init];
        defaultUser.name = @"默认";
        defaultUser.strOthersBehaveType = @"****";
        defaultUser.strOthersStatusType = @"****";
        defaultUser.strOthersDiseaseType = @"****";
        defaultUser.strOthersMedicateType = @"****";
        
        [self setCurrentUserName:defaultUser.name];
        
        [allUser  setObject:defaultUser forKey:defaultUser.name];
        
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allUser];
        
        if([data writeToFile:path atomically:YES]){
            NSLog(@"write file success");
        }else{
            NSLog(@"write file fail");
        }
    }
    
    
    
    
}

-(NSString *)getDocumentsDirectoryPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

-(NSMutableArray *)getAllUser{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSMutableArray *usersArray = [[NSMutableArray alloc] init];
    
    if (allUser == nil) {
        
        return nil;
        
    }else{
        NSArray *keys = [allUser allKeys];
        NSLog(@"all keys : %@",keys);
        for (NSString *key in keys) {
            NSObject *objectInDictionary = [allUser objectForKey:key];
            [usersArray addObject:objectInDictionary];
        }
    }
    
    return usersArray;
    
}

-(BOOL)addNewUser:(ZLUserInfoObject *)userInfo{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (userInfo.name == nil) {
        return NO;
    }
    if ([self isDuplicateName:userInfo]) {
        return NO;
    }
    if (allUser!=nil) {
        [allUser setObject:userInfo forKey:userInfo.name];
        data = [NSKeyedArchiver archivedDataWithRootObject:allUser];
        if ([data writeToFile:path atomically:YES]) {
            NSLog(@"add success");
        }else{
            NSLog(@"add fail");
        }
    }
    
    return YES;
    
}
-(BOOL)deleteUserByName:(NSString *)name{
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
//    [allUser setObject:nil forKey:name];
    
    [allUser removeObjectForKey:name];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:allUser];
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"add success");
    }else{
        NSLog(@"add fail");
    }
    return YES;
}

-(ZLUserInfoObject *)getUserInforByName:(NSString *)name{
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
  return  [allUser objectForKey:name];
}
-(BOOL)updateUserInfo:(ZLUserInfoObject *)userInfo{
    ZLUserInfoObject *user = [self getUserInforByName:userInfo.name];
    if (user == nil) {
        return NO;
    }
    
    user.breathRate = userInfo.breathRate;
    user.behaveSelectIndex = userInfo.behaveSelectIndex;
    user.guideBreathRate = userInfo.guideBreathRate;
    user.statusSelectIndex = userInfo.statusSelectIndex;
    user.medicateSelectIndex = userInfo.medicateSelectIndex;
    user.strOthersBehaveType = userInfo.strOthersBehaveType;
    user.strOthersStatusType = userInfo.strOthersStatusType;
    user.strOthersDiseaseType = userInfo.strOthersDiseaseType;
    user.strOthersMedicateType = userInfo.strOthersMedicateType;
    
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [allUser setObject:user forKey:user.name];
    
    data = [NSKeyedArchiver archivedDataWithRootObject:allUser];
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"update success");
        return YES;
    }else{
        NSLog(@"update fail");
    }
    return YES;
}

-(void)setCurrentUserName:(NSString *)user{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:user forKey:kCurrentUser];
    
    [userDefaults synchronize];
    
}
-(NSString *)getCurrentUser{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [userDefaults objectForKey:kCurrentUser];
    
    return user;
    
}

-(BOOL)isDuplicateName:(ZLUserInfoObject *)userInfo{
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSMutableDictionary *allUser = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSArray *keys = [allUser allKeys];
    
    if (userInfo.name == nil) {
        return NO;
    }
    
    for (NSString *key in keys) {
        if ([key isEqualToString:userInfo.name]) {
            return YES;
        }
    }
    
    return NO;
    
}

@end
