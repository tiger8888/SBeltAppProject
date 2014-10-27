//
//  ZLBluetoothLEManage.m
//  SBeltApp
//
//  Created by 王 维 on 6/20/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLBluetoothLEManage.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLPopInfoView.h"
#import "sharedHeader.h"



#define  HEIGHT_OF_CELL       40.0
#define  HEIGHT_OF_HEADER     40.0

#define  update_UI_interval     0.1

@implementation ZLBluetoothLEManage
@synthesize streamBuffer;


+(ZLBluetoothLEManage *)sharedInstanceWithLandscape:(BOOL)bLand mode:(int)mode{
    static ZLBluetoothLEManage *_instance= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (bLand) {
            _instance = [[ZLBluetoothLEManage alloc] initWithFrame:CGRectMake(0, 0, HEIGHT_OF_SCREEN, WIDTH_OF_SCREEN) mode:mode];
        }else{
            _instance = [[ZLBluetoothLEManage alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN) mode:mode];
        }
    });
    
    return _instance;
};
- (id)initWithFrame:(CGRect)frame mode:(int)mode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        bleSerialComMgr.delegate = self;
        
        //初始化缓冲区
        bMainThreadUsed = YES;
        
        foundSensors = [[NSMutableArray alloc] init];
        
//        [foundSensors addObject:@"1"];
//        [foundSensors addObject:@"2"];
//        [foundSensors addObject:@"1"];
//        [foundSensors addObject:@"2"];
        
        itemlist = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, self.frame.size.height - 100) style:UITableViewStyleGrouped];
        itemlist.layer.cornerRadius = 10;
        itemlist.layer.borderColor = [UIColor blackColor].CGColor;
        itemlist.layer.borderWidth = 2;
        itemlist.delegate = self;
        itemlist.dataSource = self;
        itemlist.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:itemlist];
        
  
        inProgressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        inProgressIndicator.frame = CGRectMake(0, 0, 50, 50);
        inProgressIndicator.center = CGPointMake(300/2, 20);
        [itemlist addSubview:inProgressIndicator];
        
        
        //[self performSelector:@selector(startEnumPortsProcedure) withObject:nil afterDelay:1.0];
        
        
        if (mode == 0) {// monitor
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:update_UI_interval target:self selector:@selector(updateMonitorUI) userInfo:nil repeats:YES];
        }else{
            updateTimer = [NSTimer scheduledTimerWithTimeInterval:update_UI_interval target:self selector:@selector(updateActivityUI) userInfo:nil repeats:YES];
        }
        
        
        //模拟开始
//        [self startEmulate];
        
 
    }
    return self;
}

/*模拟数据*/
NSData *emuBuffer;
int emuLocation = 0,totalLen = 0;

-(void)startEmulate{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"新协议数据" ofType:@"dat"];
    emuBuffer = [NSData dataWithContentsOfFile:path];
    
    NSLog(@"emulate data leng : %d",emuBuffer.length);
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(readPackageToParse:) userInfo:nil repeats:YES];
}
-(void)readPackageToParse:(NSTimer *)timer{
    int lenOfPack = 24;
    if (emuLocation >= emuBuffer.length-24) {
        return;
    }
    NSData *package = [emuBuffer subdataWithRange:NSMakeRange(emuLocation, lenOfPack)];
//    NSLog(@"package : %@, len is %d",package,package.length);
    [self localEmulateData:package];
    emuLocation+=lenOfPack;
}
-(void)localEmulateData:(NSData *)stream{

    NSData *rData = stream;
    static long l  =  0;
    l += rData.length;
    NSLog(@"emulate data directly , length %ld",l);
    
    [self dataParser:rData];
    
}
/*模拟数据*/


-(NSData *)dataFromHexString:(NSString *)string {
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
        
    }
    
    return data;
}
-(void)startEnumPortsProcedure{
    NSLog(@"startEnumPortsProcedure");
    [foundSensors removeAllObjects];
    [itemlist reloadData];
    [inProgressIndicator stopAnimating];
    [inProgressIndicator startAnimating];
    [bleSerialComMgr stopEnumeratePorts];
    [bleSerialComMgr startEnumeratePorts:4.0];
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

#pragma mark bleSerialComManager begin
-(void)bleSerilaComManagerDidEnumComplete:(BLESerialComManager *)bleSerialComManager
{
  [inProgressIndicator stopAnimating];
  [foundSensors addObjectsFromArray:bleSerialComManager.ports];
  [itemlist reloadData];
}
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager withEnumeratedPorts:(NSArray *)ports{
    NSLog(@"withEnumeratedPorts");
    [inProgressIndicator stopAnimating];
    [foundSensors addObjectsFromArray:ports];
    
    [itemlist reloadData];
}
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result{
    NSLog(@"didOpenPort");
    
    [inProgressIndicator stopAnimating];
    
    if (result == RESULT_SUCCESS) {
        ZLPopInfoView *info = [ZLPopInfoView popInfoViewWithContent:@"Port Open" withTargetView:self.superview];
        [info showWitInterval:1.5];
        
        [self removeFromSuperview];
        
        openedPort = port;
        
    }else{
        ZLPopInfoView *info = [ZLPopInfoView popInfoViewWithContent:@"Port Open Failed" withTargetView:self.superview];
        openedPort = nil;
        [info showWitInterval:1.5];
    }
    
    
}
-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length{
    NSLog(@"didDataReceivedOnPort");

    //数据存入buffer
    NSData *rData = [bleSerialComMgr readDataFromPort:port withLength:length];
    static long l  =  0;
    l += rData.length;
    NSLog(@"from module directly , length %ld",l);
    
    [self dataParser:rData];

}


#pragma mark bleSerailComManager end

/****************
 数据流的抓包过程
 ****************/
#define  FLAG_EMPTY                0
#define  FLAG_STX                  (FLAG_EMPTY+1)
#define  FLAG_MSGID_GDP            (FLAG_STX+1)
#define  FLAG_MSGID_PDP            (FLAG_MSGID_GDP+1)
#define  FLAG_PAYLOAD              (FLAG_MSGID_PDP+1)
#define  FLAG_PAYLOAD_OVER         (FLAG_PAYLOAD+1)
#define  FLAG_CRC                  (FLAG_PAYLOAD_OVER+1)


#define  FLAG_ETX                  9




static unsigned int _streamFlag;
static unsigned int _length,_location;
static unsigned char _crc;

typedef enum _MSGID{
    _MSGID_GDP,
    _MSGID_PDP,
    
}MSGID;

static MSGID _msgId;


static unsigned char *buffer;

-(void)dataParser:(NSData *)data{
    unsigned int len = data.length;
    char chData[24];
    [data getBytes:&chData length:len];
    
    for (int i = 0 ; i < len; i++) {
        unsigned char c = (unsigned char)chData[i];
        
        if (_streamFlag == FLAG_MSGID_GDP || _streamFlag == FLAG_MSGID_PDP) {

            _length = c;
            _location = 0;
            if (buffer!=nil) {
                free(buffer);
                buffer = nil;
            }
            buffer = malloc(_length);
            memset(buffer, 0x00, _length);
            _streamFlag = FLAG_PAYLOAD;
//            NSLog(@"/******     length found %d ******/",_length);
            continue;
        }else if (_streamFlag == FLAG_PAYLOAD) {
            buffer[_location++] = c;
            //NSLog(@"copy 0x%02x number %d",c,_location);
            if (_location == _length) {
                _streamFlag = FLAG_PAYLOAD_OVER;
//                NSLog(@"/******     payload over ******/");
            }
            continue;
        }else if(_streamFlag == FLAG_PAYLOAD_OVER){
            //CRC
            _streamFlag = FLAG_CRC;
            _crc = c;
//            NSLog(@"/******     CRC   0x%02x  ******/",c);
            continue;
        }
        
        switch (c) {
            case 0x02://STX
            {
                if (_streamFlag == FLAG_EMPTY) {
//                    NSLog(@"/******  begin package  ******/");
                   _streamFlag = FLAG_STX;
                }
                break;
            }
            case 0x20://通用数据包 msgID GDP
            {
                if (_streamFlag == FLAG_STX) {
//                    NSLog(@"/******   msg id GDP found ******/");
                    _streamFlag = FLAG_MSGID_GDP;
                    _msgId = _MSGID_GDP;
                }
                break;
            }
            case 0x21://生理信号波形数据包  msgID PDP
            {
                if (_streamFlag == FLAG_STX) {
//                    NSLog(@"/******   msg id PDP found ******/");
                    _streamFlag = FLAG_MSGID_PDP;
                    _msgId = _MSGID_PDP;
                }
                break;
            }
            case 0x03:
            {
                if (_streamFlag == FLAG_CRC) {
//                    NSLog(@"/******  end package  ******/");
                    NSData *payload = [NSData dataWithBytes:buffer length:_length];
                    free(buffer);
                    buffer = nil;
                    //NSLog(@"payload %@",payload);
                    switch (_msgId) {
                        case _MSGID_GDP:
                        {
                            [self GDPPayloadParser:payload];
                            if (bDataStoring) {
                                [self GDPOriginalDataStoreWithPayload:payload withCRC:_crc];
                            }
                            break;
                        }
                        case _MSGID_PDP:
                        {
                            [self PDPPayloadParser:payload];
                            if (bDataStoring) {
                                [self PDPOriginalDataStoreWithPayload:payload withCRC:_crc];
                            }
                            break;
                        }
                        default:
                            break;
                    }
                    _streamFlag = FLAG_EMPTY;
                }
               
                break;
            }
            default:
//                NSLog(@"/******  empty 0x%02x ******/",c);
                _streamFlag = FLAG_EMPTY;
                break;
        }
    }
}
/**
    GDP payload的分析
 **/
#define samplesBufferSize   200
static unsigned short heartRateSamples[samplesBufferSize] = {0},heartRateSampleCount = 0;
static float breathRateSamples[samplesBufferSize] = {0.0};
static unsigned int   breathRateSampleCount = 0;


//-(short)getRealRespiration:(char[2])res{
//    if (res[0] & 0x80) {
//        return ^(short)((res[0] * 0x10 + res[1]) - 0x01)
//    }
//}

-(void)GDPPayloadParser:(NSData *)payload{
    unsigned char *temp,seqNum;
    int len = payload.length;
    
    temp = malloc(len);
    memset(temp, 0x00, len);
    
    [payload getBytes:temp length:len];
    
    //0 SEQ Num
    seqNum = temp[0];
    
    printf("_GDPPayloadParser _begin_ %d\n",seqNum);
    //1 2 3 4 5 6 7 8 general information
    deviceId            =   temp[1]*0x10+temp[2];
    deviceVersion       =   temp[3]*0x10+temp[4];
    firmwareId          =   temp[5]*0x10+temp[6];
    firmwareVersion     =   temp[7]*0x10+temp[8];
    
    //9 10 heart rate
    int heartRate = temp[10] * 0x10 + temp[9];
    heartRateSamples[heartRateSampleCount++] = heartRate;
    if (heartRateSampleCount>=samplesBufferSize) {
        heartRateSampleCount = 0;
    }
    printf("heart rate %d\n",heartRate);
    
    //11 12 Respiration
    
    
    printf("Respiration original : 0x%2x,0x%2x\n",temp[12],temp[11]);
    short int respiration = temp[12] * 0x0100 + temp[11];
  

        printf("real respiration : %d\n",respiration);
        
        breathRateSamples[breathRateSampleCount++] = respiration;
        printf("sample respiration %d\n",respiration);
        if (breathRateSampleCount>=samplesBufferSize) {
            breathRateSampleCount = 0;
        }
  
        activitySample[activitySampleCount++] = temp[47];
        if(activitySampleCount >= samplesBufferSize)
        {
          activitySampleCount = 0;
        }
    
    
    
    //13 reserved
    int reserved1 = temp[13];
    
    //14 heart beat number
    int heartBeatNumber = temp[14];
    printf("heartBeatNumber : %d\n",heartBeatNumber);
    
    //15~44 heart beat timerstamp
    int heartBeatTimerStamp1 = temp[16]*0x10 + temp[15];
    int heartBeatTimerStamp2 = temp[18]*0x10 + temp[17];
    int heartBeatTimerStamp3 = temp[20]*0x10 + temp[19];
    int heartBeatTimerStamp4 = temp[22]*0x10 + temp[21];
    int heartBeatTimerStamp5 = temp[24]*0x10 + temp[23];
    int heartBeatTimerStamp6 = temp[26]*0x10 + temp[25];
    int heartBeatTimerStamp7 = temp[28]*0x10 + temp[27];
    int heartBeatTimerStamp8 = temp[30]*0x10 + temp[29];
    int heartBeatTimerStamp9 = temp[32]*0x10 + temp[31];
    int heartBeatTimerStamp10 = temp[34]*0x10 + temp[33];
    int heartBeatTimerStamp11 = temp[36]*0x10 + temp[35];
    int heartBeatTimerStamp12 = temp[38]*0x10 + temp[37];
    int heartBeatTimerStamp13 = temp[40]*0x10 + temp[39];
    int heartBeatTimerStamp14 = temp[42]*0x10 + temp[41];
    int heartBeatTimerStamp15 = temp[44]*0x10 + temp[43];
    
    printf("%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n",heartBeatTimerStamp1,
           heartBeatTimerStamp2,
           heartBeatTimerStamp3,
           heartBeatTimerStamp4,
           heartBeatTimerStamp5,
           heartBeatTimerStamp6,
           heartBeatTimerStamp7,
           heartBeatTimerStamp8,
           heartBeatTimerStamp9,
           heartBeatTimerStamp10,
           heartBeatTimerStamp11,
           heartBeatTimerStamp12,
           heartBeatTimerStamp13,
           heartBeatTimerStamp14,
           heartBeatTimerStamp15);
    
    //45 46 skin temperature
    float skinTemperature = (float)(temp[46]*0x10+temp[45])/10.0;
    printf("skin temperature %.1f\n",skinTemperature);
    
    //47 48 reserved
    unsigned short reserved2 = temp[48]*0x10+temp[47];
    //49 alarm
    char alarm = temp[49];
    //50 battery status
    char battery = temp[50];
    printf("battery %d%%\n",battery);
    //free
    free(temp);
    
    printf("_GDPPayloadParser _end_\n");
    
    generalDataPackage generalPackage;
    generalPackage.seqNum                   =   seqNum;
    generalPackage.deviceID                 =   deviceId;
    generalPackage.deviceVer                =   deviceVersion;
    generalPackage.firmwareID               =   firmwareId;
    generalPackage.firmwareVer              =   firmwareVersion;
    generalPackage.heartRate                =   heartRate;
    generalPackage.respirationRate          =   respiration;
    generalPackage.reserved1                =   reserved1;
    generalPackage.heartBeatNumber          =   heartBeatNumber;
    generalPackage.heartBeatTimerstamp_1    =   heartBeatTimerStamp1;
    generalPackage.heartBeatTimerstamp_2    =   heartBeatTimerStamp2;
    generalPackage.heartBeatTimerstamp_3    =   heartBeatTimerStamp3;
    generalPackage.heartBeatTimerstamp_4    =   heartBeatTimerStamp4;
    generalPackage.heartBeatTimerstamp_5    =   heartBeatTimerStamp5;
    generalPackage.heartBeatTimerstamp_6    =   heartBeatTimerStamp6;
    generalPackage.heartBeatTimerstamp_7    =   heartBeatTimerStamp7;
    generalPackage.heartBeatTimerstamp_8    =   heartBeatTimerStamp8;
    generalPackage.heartBeatTimerstamp_9    =   heartBeatTimerStamp9;
    generalPackage.heartBeatTimerstamp_10   =   heartBeatTimerStamp10;
    generalPackage.heartBeatTimerstamp_11    =   heartBeatTimerStamp11;
    generalPackage.heartBeatTimerstamp_12    =   heartBeatTimerStamp12;
    generalPackage.heartBeatTimerstamp_13    =   heartBeatTimerStamp13;
    generalPackage.heartBeatTimerstamp_14    =   heartBeatTimerStamp14;
    generalPackage.heartBeatTimerstamp_15    =   heartBeatTimerStamp15;
    generalPackage.skinTemperature           =   skinTemperature;
    generalPackage.reserved2                 =   reserved2;
    generalPackage.alarm                     =   alarm;
    generalPackage.batteryStatus             =   battery;
    
//    [ZLMonitorVC.dragView updateDragViewWithHr:heartRate rr:15.7 activity:0.6 tsk:skinTemperature battery:battery];

    /*Attention:因为没有对battery有额外的处理，所以在解析完后直接显示，并没有在updateMonitorUI里面更新*/
    [ZLMonitorVC.dragView setBatteryValue:battery];
    
    if (bDataStoring) {
        [[ZLStorageFunctionManage sharedInstance] storeIntoGeneralDataFileWithPackage:generalPackage];
    }
}
-(void)GDPOriginalDataStoreWithPayload:(NSData *)payload withCRC:(unsigned char)crc{
    unsigned char header[3] = {0x02,0x20,0x33},tail = 0x03;
    NSMutableData *package = [NSMutableData dataWithBytes:header length:3];
    [package appendData:payload];
    [package appendData:[NSData dataWithBytes:&crc length:1]];
    [package appendData:[NSData dataWithBytes:&tail length:1]];
    NSLog(@"GDP store original package : %@",package);
    [[ZLStorageFunctionManage sharedInstance] storeIntoGDPDataFile:package];
}
-(void)PDPOriginalDataStoreWithPayload:(NSData *)payload withCRC:(unsigned char)crc{
    unsigned char header[3] = {0x02,0x21,0x51},tail = 0x03;
    NSMutableData *package = [NSMutableData dataWithBytes:header length:3];
    [package appendData:payload];
    [package appendData:[NSData dataWithBytes:&crc length:1]];
    [package appendData:[NSData dataWithBytes:&tail length:1]];
    NSLog(@"PDP store original package : %@",package);
    [[ZLStorageFunctionManage sharedInstance] storeIntoPDPDataFile:package];
}

/**
 PDP payload的分析
 **/
-(void)PDPPayloadParser:(NSData *)payload{
    unsigned char *temp,seqNum;
    int len = payload.length;
    
    temp = malloc(len);
    memset(temp, 0x00, len);
    
    [payload getBytes:temp length:len];
    
    //seqNum
    seqNum = temp[0];
    printf("_PDPPayloadParser _begin_ %d\n",seqNum);
    //ECG waveform
    [self ECGWaveformPacket:[payload subdataWithRange:NSMakeRange(1, 40)]];
    
    //respiration waveform
    [self respirationWaveformPacket:[payload subdataWithRange:NSMakeRange(41, 10)]];

    //accelerometer
    //[self accelerometerPacket:[payload subdataWithRange:NSMakeRange(51, 30)]];
    
    printf("_PDPPayloadParser _end_\n");
}
//-(NSString *)getCurrentTimeString{
//    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
//    NSDate *date = [NSDate date];
//    [[NSDate date] timeIntervalSince1970];
//    
//    NSString *timeStr = [formatter stringFromDate:date];
//    return timeStr;
//}
-(void)ECGWaveformPacket:(NSData *)packet{
    //总长度40字节，32个数据，每个10bits
    unsigned short    ECGData[32] = {0};
    unsigned char   temp[40]    = {0};
    
    [packet getBytes:&temp length:40];
    
    printf("_ECGWaveformPacket _begin_\n");
    for (int i = 0; i < 8; i++) {//8次，每次计算5个字节
        unsigned short char0 = temp[i*5+0];
        unsigned short char1 = temp[i*5+1];
        unsigned short char2 = temp[i*5+2];
        unsigned short char3 = temp[i*5+3];
        unsigned short char4 = temp[i*5+4];
        

    ECGData[i*4+0] = (unsigned short)((char1&(0b00000011))<<8)  + (unsigned short)((char0&0b11111111)>>0);//8bits+2bits
    ECGData[i*4+1] = (unsigned short)((char2&(0b00001111))<<6)  + (unsigned short)((char1&0b11111100)>>2);//6bits+4bits
    ECGData[i*4+2] = (unsigned short)((char3&(0b00111111))<<4)  + (unsigned short)((char2&0b11110000)>>4);//4bits+6bits
    ECGData[i*4+3] = (unsigned short)((char4&(0b11111111))<<2)  + (unsigned short)((char3&0b11000000)>>6);//2bits+8bits
        
        printf("%d,%d,%d,%d,",ECGData[i*4+0],ECGData[i*4+1],ECGData[i*4+2],ECGData[i*4+3]);
    
    }
 
    printf("\n_ECGWaveformPacket _end_\n");
    
    [self storeECGDataIntoMonitorView:ECGData];
    if (bDataStoring) {
        [[ZLStorageFunctionManage sharedInstance] storeIntoECGWaveDataFile:[NSData dataWithBytes:ECGData length:32*2]];
    }
    
}
-(void)respirationWaveformPacket:(NSData *)packet{
    //共10个字节，8个数据
    unsigned short    respirationData[8] = {0};
    unsigned char   temp[10]    = {0};
    
    [packet getBytes:&temp length:10];
    
    printf("_respirationWaveformPacket _begin_\n");
    for (int i = 0; i < 2; i++) {//2次，每次计算5个字节
        unsigned short char0 = temp[i*5+0];
        unsigned short char1 = temp[i*5+1];
        unsigned short char2 = temp[i*5+2];
        unsigned short char3 = temp[i*5+3];
        unsigned short char4 = temp[i*5+4];
        
        
        
    respirationData[i*4+0] = (unsigned short)((char1&(0b00000011))<<8)  + (unsigned short)((char0&0b11111111)>>0);//8bits+2bits
    respirationData[i*4+1] = (unsigned short)((char2&(0b00001111))<<6)  + (unsigned short)((char1&0b11111100)>>2);//6bits+4bits
    respirationData[i*4+2] = (unsigned short)((char3&(0b00111111))<<4)  + (unsigned short)((char2&0b11110000)>>4);//4bits+6bits
    respirationData[i*4+3] = (unsigned short)((char4&(0b11111111))<<2)  + (unsigned short)((char3&0b11000000)>>6);//2bits+8bits
        
    printf("%d,%d,%d,%d,",respirationData[i*4+0],respirationData[i*4+1],respirationData[i*4+2],respirationData[i*4+3]);
    }
    
    printf("_respirationWaveformPacket _end_\n");
    
    [self storeRespirationDataIntoMonitorView:respirationData];
    if (bDataStoring) {
        [[ZLStorageFunctionManage sharedInstance] storeIntoRespirationWaveDataFile:[NSData dataWithBytes:respirationData length:8*2]];
    }
}
-(void)accelerometerPacket:(NSData *)packet{
    //共30个字节，24个数据
    unsigned short    accelerometerData[24] = {0};
    unsigned char   temp[30]    = {0};
    
    [packet getBytes:&temp length:30];
    
    printf("_accelerometerPacket _begin_\n");
    for (int i = 0; i < 6; i++) {//6次，每次计算5个字节
        unsigned short char0 = temp[i*5+0];
        unsigned short char1 = temp[i*5+1];
        unsigned short char2 = temp[i*5+2];
        unsigned short char3 = temp[i*5+3];
        unsigned short char4 = temp[i*5+4];
        
        
//        accelerometerData[i*4+0] = (unsigned short)((char1&(0b0011111111))<<2)  + (unsigned short)((char2&0b0011000000)>>6);//8bits+2bits
//        accelerometerData[i*4+1] = (unsigned short)((char2&(0b0000111111))<<4)  + (unsigned short)((char3&0b0011110000)>>4);//6bits+4bits
//        accelerometerData[i*4+2] = (unsigned short)((char3&(0b0000001111))<<6)  + (unsigned short)((char4&0b0011111100)>>2);//4bits+6bits
//        accelerometerData[i*4+3] = (unsigned short)((char4&(0b0000000011))<<8)  + (unsigned short)((char5&0b0011111111));//2bits+8bits
    
        
    accelerometerData[i*4+0] = (unsigned short)((char1&(0b00000011))<<8)  + (unsigned short)((char0&0b11111111)>>0);//8bits+2bits
    accelerometerData[i*4+1] = (unsigned short)((char2&(0b00001111))<<6)  + (unsigned short)((char1&0b11111100)>>2);//6bits+4bits
    accelerometerData[i*4+2] = (unsigned short)((char3&(0b00111111))<<4)  + (unsigned short)((char2&0b11110000)>>4);//4bits+6bits
    accelerometerData[i*4+3] = (unsigned short)((char4&(0b11111111))<<2)  + (unsigned short)((char3&0b11000000)>>6);//2bits+8bits
        
        printf("%d,%d,%d,%d,",accelerometerData[i*4+0],accelerometerData[i*4+1],accelerometerData[i*4+2],accelerometerData[i*4+3]);
    }
    
    printf("\n_accelerometerPacket _end_\n");
    
    
    
    //[self storeActivityDataIntoMonitorView:accelerometerData];
    if (bDataStoring) {
        [[ZLStorageFunctionManage sharedInstance] storeIntoAccelerometerWaveDataFile:[NSData dataWithBytes:accelerometerData length:24*2]];
    }

}


#define ecgSampleSize           400
#define respirationSampleSize   200
#define activitySampleSize      200
static int ecgSampleCount = 0,ecgSamples[ecgSampleSize] = {0};
static int respirationSampeCount = 0,respirationSamples[respirationSampleSize] = {0};
static int activitySampleCount = 0,activitySample[activitySampleSize] = {0};

-(void)storeECGDataIntoMonitorView:(unsigned short [])ecg{
    //32个数据
    for (int i=0; i<32; i++) {
        if (i % 2 == 0) {//采样降频
            ecgSamples[ecgSampleCount++] = ecg[i];
            NSLog(@"wangwei %d,%d",ecgSampleCount,ecgSamples[ecgSampleCount]);
            if (ecgSampleCount>=ecgSampleSize) {
                NSLog(@"ecg error!! over flow ");
                ecgSampleCount = 0;
            }
        }

    }
    
}
//-(void)RespirationRollAverage{
//    
//    int respirationStep = 8;
//    int loc = respirationSampeCount;
//    unsigned short newSample = 0,sum = 0;
//    
//    if (loc <= respirationStep) {
//        for (int i = 0; i < loc; i++) {
//            printf("respirationSamples[%d] = %d\n",i,respirationSamples[i]);
//            sum+= respirationSamples[i];
//        }
//        newSample = sum/loc;
//    }else{
//        for(int i = 0; i < respirationStep; i++){
//            printf("respirationSamples[%d] = %d\n",i,respirationSamples[i]);
//            sum+= respirationSamples[loc-respirationStep+i];
//        }
//        newSample = sum/respirationStep;
//    }
//    printf("new Sample after roll average is %d \n",newSample);
//    respirationSamples[respirationSampeCount] = newSample;
//
//}
-(void)storeRespirationDataIntoMonitorView:(unsigned short [])resp{
    //8个数据
    for (int i=0; i<8; i++) {
            
            respirationSamples[respirationSampeCount++] = resp[i];
        
            if (respirationSampeCount>=respirationSampleSize) {
                NSLog(@"respiration error!! over flow ");
                respirationSampeCount = 0;
            }
        
    }
}
-(void)storeActivityDataIntoMonitorView:(unsigned short [])acti{
    //24个数据，算矢量
    // 0~887~1774
    for (int i = 0; i < 8; i++) {
        
        unsigned short x = acti[i*3 + 0];
        unsigned short y = acti[i*3 + 1];
        unsigned short z = acti[i*3 + 2];
        
        unsigned short result = sqrtf(x*x+y*y+z*z);
        
        if (activitySampleCount >= activitySampleSize) {
            NSLog(@"activity error!! over flow ");
            activitySampleCount = 0;
        }
        printf("count  : %d result %d\n",activitySampleCount,result);

        activitySample[activitySampleCount] = result;
        printf("activity sample %d\n",activitySample[activitySampleCount]);
        
        activitySampleCount ++;
        
    }
}

#define  respirationRollAverageStep  16
float rollAverageBuffer[respirationRollAverageStep];
int  loc = 0;
+(float)rollAverage:(float)value{
    if (loc < respirationRollAverageStep) {
        rollAverageBuffer[loc] = value;
        loc ++;
    }else{
        for (int i = 1; i < respirationRollAverageStep; i++) {
            rollAverageBuffer[i-1] = rollAverageBuffer[i];
        }
        rollAverageBuffer[respirationRollAverageStep - 1] = value;
    }
    
    float sum = 0;
    for (int i = 0; i < loc; i++) {
        sum+=rollAverageBuffer[i];
    }
    return sum/loc;
}
-(void)updateActivityUI{
    
    for (int i = 0; i<respirationSampeCount; i++) {
        printf("respiration sample  %d\n",respirationSamples[i]);
        float rotateValueResp = 1024.0 - respirationSamples[i];
        float rollAverageResult = [ZLBluetoothLEManage rollAverage:rotateValueResp];
        NSLog(@" %.2f AfterRollAverage %.2f",rotateValueResp,rollAverageResult);
        

        [ZLActivityVC updateRespirationView:rollAverageResult/1024.0*120.0];

    }
    respirationSampeCount = 0;
    
    
    //heart rate
    for (int i = 0; i<heartRateSampleCount; i++) {
        printf("heart rate sample %d \n",heartRateSamples[i]);
        [ZLActivityVC updateHeartRate:((float)heartRateSamples[i]/255.0*100.0)];

    }
    heartRateSampleCount = 0;
    
    
    //breath rate
    for (int i = 0; i<breathRateSampleCount; i++) {
        printf("breath rate sample %.1f \n",breathRateSamples[i]);
        
        [ZLActivityVC updateBreatheRate:breathRateSamples[i]];
       
    }
    breathRateSampleCount = 0;
    
    
    
}
-(void)updateMonitorUI{

        //NSLog(@"draw thread ,count: ecg = %d,resp = %d,acti = %d,heartRate = %d ,breathRate = %d ",ecgSampleCount,respirationSampeCount,activitySampleCount,heartRateSampleCount,breathRateSampleCount);
    //ecg
    for (int i = 0; i<ecgSampleCount; i++) {
        printf("ecg sample  %d\n",ecgSamples[i]);
        float rotateValueECG = 1024.0-ecgSamples[i];
        [ZLMonitorVC.ECGTrack addValueToBuffer:rotateValueECG/700.0*100.0];
        [ZLMonitorVC.ECGTrack setNeedsDisplay];
    }
    ecgSampleCount = 0;
    
    //respiration
    for (int i = 0; i<respirationSampeCount; i++) {
        printf("respiration sample  %d\n",respirationSamples[i]);
        float rotateValueResp = 1024.0 - respirationSamples[i];
        float rollAverageResult = [ZLBluetoothLEManage rollAverage:rotateValueResp];
        NSLog(@" %.2f AfterRollAverage %.2f",rotateValueResp,rollAverageResult);
        
        int yUILocation = rollAverageResult/1024.0*120.0;
        NSLog(@"yUILocation = %d",yUILocation);
        
        [ZLMonitorVC.RespirationTrack addValueToBuffer:yUILocation];
        [ZLMonitorVC.RespirationTrack setNeedsDisplay];
    }
    respirationSampeCount = 0;
    
    //activity
    static float activityToUI = 0.0;
  activityToUI = activitySample[activitySampleCount - 1]/10;
//    for (int i = 0; i<activitySampleCount; i++) {
//            printf("activity sample in update UI %d\n",activitySample[i]);
//        
//        activityToUI = activitySample[i];
//        //0~887~1774
//        int yUILocation = activitySample[i]/1774.0*140.0;
//        NSLog(@"yUILocation = %d",yUILocation);
//            [ZLMonitorVC.ActivityTrack addValueToBuffer:yUILocation];
//            [ZLMonitorVC.ActivityTrack setNeedsDisplay];
//    }
    activitySampleCount = 0;
    
    
    //heart rate
    static float heartRateToUI = 0.0;
    for (int i = 0; i<heartRateSampleCount; i++) {
        printf("heart rate sample %d \n",heartRateSamples[i]);
        heartRateToUI = heartRateSamples[i];
        
        //每个刻度值的像素点
        float pixelPerScale = [ZLMonitorVC.heartRateFrameView getVInterval];
        printf("pixelPerScale = %.1f\n",pixelPerScale);
        
        float yy = heartRateToUI/40 * (pixelPerScale*5);
        printf("yy = %.1f\n",yy);
        float realYInTrack = ZLMonitorVC.heartRateFrameView.frame.size.height - yy + 10;
        printf("realYInTrack = %.1f\n",realYInTrack);
        
        [ZLMonitorVC.heartRateTrack addValueToBuffer:realYInTrack];
        [ZLMonitorVC.heartRateTrack setNeedsDisplay];
    }
    heartRateSampleCount = 0;
    
    //breath rate
    static float absBreatheRateToUI = 0.0;
    
    for (int i = 0; i<breathRateSampleCount; i++) {
        printf("breath rate sample %.1f \n",breathRateSamples[i]);
        //因新协议改动，符号位需去掉
        absBreatheRateToUI = fabs(breathRateSamples[i]);
        
        //每个刻度值的像素点
        float pixelPerScale = [ZLMonitorVC.breatheRateFrameView getVInterval];
        printf("pixelPerScale = %.1f\n",pixelPerScale);
        
        float yy = absBreatheRateToUI/10.0/10 * (pixelPerScale*5);
        printf("yy = %.1f\n",yy);
        float realYInTrack = ZLMonitorVC.breatheRateFrameView.frame.size.height - yy + 10;
        printf("realYInTrack = %.1f\n",realYInTrack);

        
        [ZLMonitorVC.breathRateTrack addValueToBuffer:realYInTrack];
        [ZLMonitorVC.breathRateTrack setNeedsDisplay];
    }
    breathRateSampleCount = 0;

    //更新右边栏的值
    [ZLMonitorVC.dragView updateDragViewWithHr:heartRateToUI br:absBreatheRateToUI/10.0 activity:activityToUI tsk:0.0];
}
#pragma mark tableview begin
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return foundSensors.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_OF_CELL;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HEIGHT_OF_HEADER;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_HEADER)];
        
    
    [header setBackgroundColor:[UIColor clearColor]];
    

    //[inProgressIndicator startAnimating];
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    
    return footer;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
    
    
    BLEPort *port = [foundSensors objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = port.name;

    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BLEPort *port = [foundSensors objectAtIndex:indexPath.row];
    
    if (port.peripheral.isConnected == NO) {
        paramsPackage4Open openParams;
        [bleSerialComMgr startOpen:port withParams:openParams];
        
        portOpenTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(portOpenTimeout:) userInfo:port repeats:NO];
        
        [inProgressIndicator startAnimating];
    }else{
        [bleSerialComMgr closePort:port];
        ZLPopInfoView *popClose = [ZLPopInfoView popInfoViewWithContent:@"Port Closed" withTargetView:self.superview];
        openedPort = nil;
        [popClose showWitInterval:1.5];
    }
    
    
   // [tableView reloadData];
}
-(void)portOpenTimeout:(NSTimer *)timer{
    BLEPort *port = timer.userInfo;
    //[bleSerialComMgr ]
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"scrollViewDidEndDragging ");
    if (openedPort) {
        [bleSerialComMgr closePort:openedPort];
        openedPort = nil;
    }
    [self startEnumPortsProcedure];
}


-(void)syncCurrentTime{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:[NSDate date]];
    unsigned char cmdChars[23] = {0x00};

    NSString *timeString = [NSString stringWithFormat:@"TIME%04d%02d%02d%02d%02d%02dEND",dateComps.year,dateComps.month,dateComps.day,dateComps.hour,dateComps.minute,dateComps.second];
    [[timeString dataUsingEncoding:NSASCIIStringEncoding] getBytes:&cmdChars[0] length:21];

    cmdChars[21]= 0x0D;
    cmdChars[22]= 0x0A;

    NSData *sendData = [NSData dataWithBytes:&cmdChars length:23];
    printf("write data : %s\n",[sendData.description UTF8String]);
    
    [bleSerialComMgr writeData:sendData toPort:openedPort];
    
}


#pragma mark tableview end

@end
