//
//  ZLStorageFunctionManage.h
//  SBeltApp
//
//  Created by 王 维 on 6/18/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  FILE_TYPE_ECG_WAVE_FILE            1
#define  FILE_TYPE_BREATH_WAVE_FILE         2
#define  FILE_TYPE_ACTIVITY_WAVE_FILE       3
#define  FILE_TYPE_GENERAL_DATA_FILE        4
#define  FILE_TYPE_UNKNOWN                  5

@interface ZLStorageFunctionManage : NSObject{
    NSString *generalDataFilePath;
    NSString *GDPDataFilePath;
    NSString *PDPDataFilePath;
    NSString *ecgWaveDataFilePath;
    NSString *breathWaveDataFilePath;
    NSString *accWaveDataFilePath;
    NSString *readmeFilePath;
}


+(ZLStorageFunctionManage *)sharedInstance;

//监测存储开始
-(void)storeProcedureInMonitorFunction_Start;

-(void)storeProcedureInMonitorFunction_Stop;

//存储数据

typedef struct _generalDataPackage{
    unsigned char           seqNum;
    unsigned short          deviceID;
    unsigned short          deviceVer;
    unsigned short          firmwareID;
    unsigned short          firmwareVer;
    unsigned short          heartRate;
    unsigned short          respirationRate;
    unsigned short          reserved1;
    unsigned short          heartBeatNumber;
    unsigned short          heartBeatTimerstamp_1;
    unsigned short          heartBeatTimerstamp_2;
    unsigned short          heartBeatTimerstamp_3;
    unsigned short          heartBeatTimerstamp_4;
    unsigned short          heartBeatTimerstamp_5;
    unsigned short          heartBeatTimerstamp_6;
    unsigned short          heartBeatTimerstamp_7;
    unsigned short          heartBeatTimerstamp_8;
    unsigned short          heartBeatTimerstamp_9;
    unsigned short          heartBeatTimerstamp_10;
    unsigned short          heartBeatTimerstamp_11;
    unsigned short          heartBeatTimerstamp_12;
    unsigned short          heartBeatTimerstamp_13;
    unsigned short          heartBeatTimerstamp_14;
    unsigned short          heartBeatTimerstamp_15;
    float                   skinTemperature;
    unsigned short          reserved2;
    unsigned char           alarm;
    unsigned char           batteryStatus;
    
}generalDataPackage;

-(BOOL)storeIntoGeneralDataFileWithPackage:(generalDataPackage)package;

-(BOOL)storeIntoGDPDataFile:(NSData *)GDPStream;//原始二进制流
-(BOOL)storeIntoPDPDataFile:(NSData *)PDPStream;//原始二进制流
-(BOOL)storeIntoECGWaveDataFile:(NSData *)ecgWaveData;
-(BOOL)storeIntoRespirationWaveDataFile:(NSData *)respirationWaveData;
-(BOOL)storeIntoAccelerometerWaveDataFile:(NSData *)accelerometerWaveData;



//文件浏览
-(NSDictionary *)getFilesInMonitorFunction;
-(NSString *)getECGWaveDataFilePathInDirectory:(NSString *)dir;
-(NSString *)getBreathDataFilePathInDirectory:(NSString *)dir;
-(NSString *)getAccDataFilePathInDirectory:(NSString *)dir;
-(NSString *)getGeneralDataFilePathInDirectory:(NSString *)dir;
-(int)getFileTypeFromFileName:(NSString *)fileName;
@end
