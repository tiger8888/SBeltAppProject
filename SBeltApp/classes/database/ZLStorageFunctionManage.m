//
//  ZLStorageFunctionManage.m
//  SBeltApp
//
//  Created by 王 维 on 6/18/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLStorageFunctionManage.h"
#import "languageStringManage.h"

#define keyItemOne  @"rootMenuItem1"
#define keyItemTwo  @"rootMenuItem2"
/*
 创建数据文件
 "时间+ACCData.csv"
 "时间+BreathWaveData.csv"
 "时间+ECGWaveData.csv"
 "时间+GeneralData.csv"
 "时间+Data.dat"  通用数据包(GDP)
 "时间+Wave.dat"  波形数据包(PDP)
 "时间+Readme.txt"
 */
NSString *accDataSuffix             = @"_ACCData.csv";
NSString *breathWaveDataSuffix      = @"_BreathWaveData.csv";
NSString *ecgWavecDataSuffix        = @"_ECGWaveData.csv";
NSString *generalDataSuffix         = @"_GeneralData.csv";
NSString *DataSuffix                = @"_Data.dat";
NSString *waveSuffix                = @"_Wave.dat";
NSString *readMeSuffix              = @"_Readme.txt";

@implementation ZLStorageFunctionManage

+(ZLStorageFunctionManage *)sharedInstance{
    static ZLStorageFunctionManage *_instance= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ZLStorageFunctionManage alloc] init];
    });
    
    return _instance;
}


-(id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)storeProcedureInMonitorFunction_Start{
    NSString *documentsPath = [self getDocumentsDirectoryPath];

    
    //新的存储开始，新的文件
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy_MM_dd-HH_mm_ss"];
    NSDate *date = [NSDate date];
    [[NSDate date] timeIntervalSince1970];
    
    NSString *timePrefix = [formatter stringFromDate:date];
    
    NSString *directory = [[languageStringKey(keyItemOne) stringByAppendingString:@"_"] stringByAppendingString:timePrefix];
    
    NSString *realDirPath = [documentsPath stringByAppendingPathComponent:directory];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:realDirPath]){
        NSLog(@"error , directory exist");
        return ;
    }else{
        
        //创建文件夹
        if([[NSFileManager defaultManager] createDirectoryAtPath:realDirPath withIntermediateDirectories:YES attributes:nil error:nil]){
            NSLog(@"create directory success");
        }else{
            NSLog(@"create directory failed");
            return ;
        }
    }
    
    
    NSLog(realDirPath.description);
    
    
    
    accWaveDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:accDataSuffix]];
    [self createFileWithPath:accWaveDataFilePath];
    [@"SeqNum,Year-Month-Day,Hour:Minute:Second:MS,X-axis,Y-axis,Z-axis\n" writeToFile:accWaveDataFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
    //NSLog(accDataFilePath);
    
    breathWaveDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:breathWaveDataSuffix]];
    [self createFileWithPath:breathWaveDataFilePath];
    [@"SeqNum,Year-Month-Day,Hour:Minute:Second:MS,Breath wave data\n" writeToFile:breathWaveDataFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
    //NSLog(breathWaveDataFilePath);
    
    ecgWaveDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:ecgWavecDataSuffix]];
    [self createFileWithPath:ecgWaveDataFilePath];
    [@"SeqNum,Year-Month-Day,Hour:Minute:Second:MS,ECG data\n" writeToFile:ecgWaveDataFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
   //NSLog(ecgDataFilePath);
    
    
    generalDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:generalDataSuffix]];
    [self createFileWithPath:generalDataFilePath];
    [@"Year-Month-Day, Hour:Minute:Second, Sequenc Number, DeviceID/Version, Firmware ID/Version,HR,BR,Reserved,HeartBeat Number,Heart Beat Timerstamp #1 ,Heart Beat Timerstamp #2 ,Heart Beat Timerstamp #3,Heart Beat Timerstamp #4,Heart Beat Timerstamp #5,Heart Beat Timerstamp #6,Heart Beat Timerstamp #7,Heart Beat Timerstamp #8 ,Heart Beat Timerstamp #9 ,Heart Beat Timerstamp #10 ,Heart Beat Timerstamp #11 ,Heart Beat Timerstamp #12 ,Heart Beat Timerstamp #13 ,Heart Beat Timerstamp #14 ,Heart Beat Timerstamp #15 ,Skin Temperature,VMU,ALARM,Battery Status\n" writeToFile:generalDataFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    //NSLog(generalDataFilePath);
    
    //通用数据包文件
    GDPDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:DataSuffix]];
    [self createFileWithPath:GDPDataFilePath];
    
    //波形数据文件
    PDPDataFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:waveSuffix]];
    [self createFileWithPath:PDPDataFilePath];
    
    
    
    readmeFilePath = [realDirPath stringByAppendingPathComponent:[timePrefix stringByAppendingString:readMeSuffix]];
    [self createFileWithPath:readmeFilePath];
    NSString *currentTime = [self getCurrentTimeString];
    NSMutableString *startTime = [[NSMutableString alloc] initWithString: @"StartTime : "];
    [startTime appendString:currentTime];
    [startTime appendString:@"\n"];
    [startTime writeToFile:readmeFilePath atomically:YES encoding:NSASCIIStringEncoding error:nil];
    
}

-(void)storeProcedureInMonitorFunction_Stop{
    NSString *currentTime = [self getCurrentTimeString];
    NSMutableString *stopTime = [[NSMutableString alloc] initWithString: @"StopTime : "];
    [stopTime appendString:currentTime];

    
    NSFileHandle *readMeFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:readmeFilePath];
    [readMeFileHandle seekToEndOfFile];
    [readMeFileHandle writeData:[stopTime dataUsingEncoding:NSASCIIStringEncoding]];
    [readMeFileHandle closeFile];
    
}

-(BOOL)storeIntoGeneralDataFileWithPackage:(generalDataPackage)package deviceVersion:(NSString*)devVer firmVersion:(NSString*)firmVer
{
    if (!generalDataFilePath) {
        NSLog(@"invalid ecg wave Data File Path");
        return NO;
    }
   NSMutableString *timeStr = [NSMutableString stringWithString:[self getCurrentTimeString]]; //Year-Month-Day, Hour:Minute:Second,
    [timeStr appendString:@","];
    
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.seqNum]]; //Sequenc Number,
  [timeStr appendString:[NSString stringWithFormat:@"%@,",devVer]]; //DeviceID/Version,
  [timeStr appendString:[NSString stringWithFormat:@"%@,",firmVer]]; //Firmware ID/Version,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartRate]]; //HR,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.respirationRate]];//BR,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.reserved1]];//Reserved,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatNumber]]; //HeartBeat Number,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_1]];//Heart Beat Timerstamp #1 ,

    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_2]]; //Heart Beat Timerstamp #2 ,
    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_3]];  //Heart Beat Timerstamp #3,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_4]];  //Heart Beat Timerstamp #4,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_5]]; //Heart Beat Timerstamp #5,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_6]]; //Heart Beat Timerstamp #6,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_7]]; //Heart Beat Timerstamp #7,

    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_8]]; //Heart Beat Timerstamp #8 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_9]];   //Heart Beat Timerstamp #9 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_10]]; //Heart Beat Timerstamp #10 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_11]]; //Heart Beat Timerstamp #11 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_12]]; //Heart Beat Timerstamp #12 ,

    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_13]]; //Heart Beat Timerstamp #13 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_14]];   //Heart Beat Timerstamp #14 ,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.heartBeatTimerstamp_15]]; //Heart Beat Timerstamp #15 ,
  [timeStr appendString:[NSString stringWithFormat:@"%.1f,",package.skinTemperature]];  //Skin Temperature,
  [timeStr appendString:[NSString stringWithFormat:@"%d,",package.reserved2]]; //VMU,

    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.alarm]];  //ALARM,"
    [timeStr appendString:[NSString stringWithFormat:@"%d,",package.batteryStatus]]; //Battery Status\n
    [timeStr appendString:@"\n"];
    
    NSFileHandle *generalDataFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:generalDataFilePath];
    [generalDataFileHandle seekToEndOfFile];
    [generalDataFileHandle writeData:[timeStr dataUsingEncoding:NSASCIIStringEncoding]];
    [generalDataFileHandle closeFile];
    
    return YES;
}
-(BOOL)storeIntoGDPDataFile:(NSData *)GDPStream{
    if (!GDPDataFilePath) {
        NSLog(@"invalid GDP Data File Path");
        return NO;
    }
    NSFileHandle *GDPFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:GDPDataFilePath];
    [GDPFileHandle seekToEndOfFile];
    [GDPFileHandle writeData:GDPStream];
    [GDPFileHandle closeFile];
    
    return YES;
}
-(BOOL)storeIntoPDPDataFile:(NSData *)PDPStream{
    if (!PDPDataFilePath) {
        NSLog(@"invalid PDP Data File Path");
        return NO;
    }
    NSFileHandle *PDPFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:PDPDataFilePath];
    [PDPFileHandle seekToEndOfFile];
    [PDPFileHandle writeData:PDPStream];
    [PDPFileHandle closeFile];
    
    return YES;
}
-(BOOL)storeIntoECGWaveDataFile:(UInt8)seqNum data:(NSData *)ecgWaveData
{
    if (!ecgWaveDataFilePath) {
        NSLog(@"invalid ecg wave Data File Path");
        return NO;
    }
    NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%d,", seqNum];
    [timeStr appendString:[self getCurrentTimeString]];
    [timeStr appendString:@"\n"];
  
  NSFileHandle *ecgWaveDataFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:ecgWaveDataFilePath];
  [ecgWaveDataFileHandle seekToEndOfFile];
  [ecgWaveDataFileHandle writeData:[timeStr dataUsingEncoding:NSASCIIStringEncoding]];
  
    NSMutableString *data = [[NSMutableString alloc] init];

    for (int i=0; i<ecgWaveData.length/2; i++)
    {
    
        [data appendString:@", , ,"];

        NSData *one = [ecgWaveData subdataWithRange:NSMakeRange(i*2, 2)];
        unsigned short ecgData;
        [one getBytes:&ecgData length:2];
        [data appendString:[NSString stringWithFormat:@"%d",ecgData]];
        [data appendString:@"\n"];

    }
  
    
    
    [ecgWaveDataFileHandle writeData:[data dataUsingEncoding:NSASCIIStringEncoding]];
    [ecgWaveDataFileHandle closeFile];
    
    return YES;
}
-(BOOL)storeIntoRespirationWaveDataFile:(UInt8)seqNum data:(NSData *)respirationWaveData
{
    if (!breathWaveDataFilePath) {
        NSLog(@"invalid breath wave Data File Path");
        return NO;
    }
    
  NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%d,", seqNum];
  [timeStr appendString:[self getCurrentTimeString]];
  [timeStr appendString:@"\n"];
  
  NSFileHandle *breathWaveDataFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:breathWaveDataFilePath];
  [breathWaveDataFileHandle seekToEndOfFile];
  [breathWaveDataFileHandle writeData:[timeStr dataUsingEncoding:NSASCIIStringEncoding]];
  
    NSMutableString *data = [[NSMutableString alloc] init];
    for (int i=0; i<respirationWaveData.length/2; i++)
    {
        [data appendString:@", , ,"];

        NSData *one = [respirationWaveData subdataWithRange:NSMakeRange(i*2, 2)];
        unsigned short breathData;
        [one getBytes:&breathData length:2];
        [data appendString:[NSString stringWithFormat:@"%d",breathData]];
        [data appendString:@"\n"];

    }
  
    [breathWaveDataFileHandle writeData:[data dataUsingEncoding:NSASCIIStringEncoding]];
    [breathWaveDataFileHandle closeFile];
    
    return YES;
}
-(BOOL)storeIntoAccelerometerWaveDataFile:(UInt8)seqNum data:(NSData *)accelerometerWaveData
{
    if (!accWaveDataFilePath) {
        NSLog(@"invalid acc wave Data File Path");
        return NO;
    }
  
    NSMutableString *timeStr = [NSMutableString stringWithFormat:@"%d,", seqNum];
    [timeStr appendString:[self getCurrentTimeString]];
    [timeStr appendString:@"\n"];
    
    
  NSFileHandle *accWaveDataFileHandle = [NSFileHandle fileHandleForUpdatingAtPath:accWaveDataFilePath];
  [accWaveDataFileHandle seekToEndOfFile];
  [accWaveDataFileHandle writeData:[timeStr dataUsingEncoding:NSASCIIStringEncoding]];
  
  NSMutableString *dataStr = [[NSMutableString alloc] init];

    for (int i=0; i<accelerometerWaveData.length/6; i++)
    {
        [dataStr appendString:@", , ,"];

        NSData *xyz = [accelerometerWaveData subdataWithRange:NSMakeRange(i*6, 6)];
        unsigned short x,y,z;
        [xyz getBytes:&x range:NSMakeRange(0, 2)];
        [xyz getBytes:&y range:NSMakeRange(2, 2)];
        [xyz getBytes:&z range:NSMakeRange(4, 2)];
        
        [dataStr appendString:[NSString stringWithFormat:@"%d,",x]];
        [dataStr appendString:[NSString stringWithFormat:@"%d,",y]];
        [dataStr appendString:[NSString stringWithFormat:@"%d,",z]];
        [dataStr appendString:@"\n"];

    }
  
  [accWaveDataFileHandle writeData:[dataStr dataUsingEncoding:NSASCIIStringEncoding]];
  [accWaveDataFileHandle closeFile];
  
  
    
    return YES;

}
-(NSString *)getCurrentTimeString{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd,HH:mm:ss:SSS"];
    NSDate *date = [NSDate date];
    [[NSDate date] timeIntervalSince1970];
    
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}


-(NSDictionary *)getFilesInMonitorFunction{
     
   NSMutableArray *directoryPaths = [self getAllFilesInDirPath:[self getDocumentsDirectoryPath]];

    NSMutableDictionary *resultDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSString *dirPath in directoryPaths) {
        //NSLog(dirPath);
        
        NSString *dirWholePath = [[self getDocumentsDirectoryPath] stringByAppendingPathComponent:dirPath];
        
        NSMutableArray *filePaths = [self getAllFilesInDirPath:dirWholePath];

        [resultDictionary setValue:filePaths forKey:dirPath];
    }
    
    //NSLog(resultDictionary.description);
    
    return resultDictionary;
}
-(NSString *)getECGWaveDataFilePathInDirectory:(NSString *)dir{
    NSString *timeStr = [dir substringWithRange:NSMakeRange(0, 12)];
    NSLog(@"%@",timeStr);
    
}
-(NSString *)getBreathDataFilePathInDirectory:(NSString *)dir{

}
-(NSString *)getAccDataFilePathInDirectory:(NSString *)dir{

}
-(int)getFileTypeFromFileName:(NSString *)fileName{
    NSString *fileTypeStr = [fileName substringFromIndex:19];
    if ([fileTypeStr isEqualToString:ecgWavecDataSuffix]) {
        return FILE_TYPE_ECG_WAVE_FILE;
    }else if ([fileTypeStr isEqualToString:breathWaveDataSuffix]){
        return FILE_TYPE_BREATH_WAVE_FILE;
    }else if ([fileTypeStr isEqualToString:accDataSuffix]){
        return FILE_TYPE_ACTIVITY_WAVE_FILE;
    }else if ([fileTypeStr isEqualToString:generalDataSuffix]){
        return FILE_TYPE_GENERAL_DATA_FILE;
    }
    return FILE_TYPE_UNKNOWN;
}
-(NSMutableArray *)getAllFilesInDirPath:(NSString *)path{
    NSArray *fileList = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    //NSLog(fileList.description);
    return [NSMutableArray arrayWithArray:fileList];
}

/**** utility ***/

-(NSString *)getDocumentsDirectoryPath{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
-(void)createFileWithPath:(NSString *)path{
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"error, file exist");
    }else{
        if ([[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]) {
            
        }else{
            NSLog(@"create file error");
        }
    }
}




@end
