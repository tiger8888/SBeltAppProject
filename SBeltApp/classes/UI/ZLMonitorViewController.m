//
//  ZLMonitorViewController.m
//  SBeltApp
//
//  Created by 王 维 on 6/14/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLMonitorViewController.h"
#import "ZLScrollMenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLDragView.h"
#import "UIImageView+Curled.h"
#import "sharedHeader.h"



#define MAINGRAYCOLOR  ([UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0])

#define DisplayArea_Color       ([UIColor colorWithRed:253.0/255.0 green:245.0/255.0 blue:230.0/255.0 alpha:1.0])

#define ECG_Frame_Color         ([UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:69.0/255.0 alpha:1.0])
#define Respiration_Frame_Color ([UIColor colorWithRed:176.0/255.0 green:48.0/255.0 blue:96.0/255.0 alpha:1.0])
#define Activity_Frame_Color    ([UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0])
#define HeartRate_Frame_Color   ([UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0])
#define BreathRate_Frame_Color  HeartRate_Frame_Color//([UIColor colorWithRed:255.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:1.0])


@interface ZLMonitorViewController ()
{
  ZLScrollMenuView *toolbarMenu;
  UIButton *ECGSelectScaleBtn;
  UIButton *RESPSelectScaleBtn;
}
@end

@implementation ZLMonitorViewController
@synthesize ECGTrack,RespirationTrack,ActivityTrack;
@synthesize heartRateTrack,breathRateTrack;
@synthesize dragView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      ZLBluetoothLEManage *bleMgr = [ZLBluetoothLEManage sharedInstanceWithLandscape:NO mode:0];
      
      bleSerialComMgr.delegate = bleMgr;

    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
  
}

#pragma mark Gesture Recognizer Action
-(void)longPressAction:(UIGestureRecognizer *)gestureRecognizer{
    if (bToolBarOpen == NO) {
        [self openToolBar];
        bToolBarOpen = YES;
    }
}
-(void)shortPressAction:(UIGestureRecognizer *)gestureRecognizer{
    if (bToolBarOpen == YES) {
        [self closeToolBar];
        bToolBarOpen = NO;
    }
    if (self.dragView.frame.origin.x <= 200) {
        [self.dragView dismissSelf];
    }

}
#pragma mark ToolBar
-(void)openToolBar{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //bgView.frame = CGRectMake(0, 0,WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 64);
        //container.frame = CGRectMake(0, 0,WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 64);
      [self.view bringSubviewToFront: toolbarMenu];
      CGFloat h = toolbarMenu.frame.size.height;
      toolbarMenu.frame = CGRectMake(0, HEIGHT_OF_SCREEN - h, WIDTH_OF_SCREEN, h);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)closeToolBar{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //bgView.frame = CGRectMake(0, 0,WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
        //container.frame = CGRectMake(0, 0,WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
      CGFloat h = toolbarMenu.frame.size.height;
      toolbarMenu.frame = CGRectMake(0, HEIGHT_OF_SCREEN, WIDTH_OF_SCREEN, h);

    } completion:^(BOOL finished) {
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    

    bInStoring = NO;
    bToolBarOpen = NO;
    


    

    
    toolbarMenu = [[ZLScrollMenuView alloc] initWithFrame:CGRectMake(0, HEIGHT_OF_SCREEN, WIDTH_OF_SCREEN, 64)];
    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Browse-彩色.png"] withHighLightImage:[UIImage imageNamed:@"Browse-灰色.png"] withTitle:@"浏览" withTarget:self withSel:@selector(browseFunction)];
    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Store-彩色.png"] withHighLightImage:[UIImage imageNamed:@"Store-灰色.png"] withTitle:@"存储" withTarget:self withSel:@selector(storageFunction)];
    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Setting-彩色1.png"] withHighLightImage:[UIImage imageNamed:@"Setting-灰色1.png"] withTitle:@"设置" withTarget:self withSel:@selector(settingFunction)];
    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Bluetooth-彩色.png"] withHighLightImage:[UIImage imageNamed:@"Bluetooth-灰色.png"] withTitle:@"连接" withTarget:self withSel:@selector(bluetoothFunction)];
    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Freeze-彩色.png"] withHighLightImage:[UIImage imageNamed:@"Freeze-灰色.png"] withTitle:@"冻结" withTarget:self withSel:@selector(freezeFunction)];

    [toolbarMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:nil] withHighLightImage:[UIImage imageNamed:nil] withTitle:@"Exit" withTarget:self withSel:@selector(exitFunction)];
    
    [toolbarMenu layoutAllButtons];
    [self.view addSubview:toolbarMenu];
    
    
    
    bgView = [UIButton buttonWithType:UIButtonTypeCustom];
    bgView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN);
    bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0, 6);
    bgView.layer.shadowOpacity = 1.0;
    //bgView.layer.shadowRadius = 0;
    [bgView setBackgroundColor:[UIColor blackColor]];
    
    [self.view addSubview:bgView];
  
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [bgView addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *shortPressGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortPressAction:)];
    [bgView addGestureRecognizer:shortPressGesture];
  
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 20)];
    statusView.backgroundColor = MAINGRAYCOLOR;
    container = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)];
    container.delegate = self;
    container.dataSource = self;
    container.backgroundColor = MAINGRAYCOLOR;
    container.userInteractionEnabled = YES;
    container.separatorStyle = UITableViewCellSelectionStyleNone;
    [bgView addSubview:container];
    [bgView addSubview:statusView];
  
    
    self.dragView = [ZLDragView dragView];
    [bgView addSubview:self.dragView];
    
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerHandler:) userInfo:nil repeats:NO];
    
    
    flashView  = [ZLFlashView flashView];
    flashView.center = CGPointMake(320 - 40, 40);
    [self.view addSubview:flashView];

    [self initFrameView];
    [self initTrackView];


    
}


-(void)initFrameView{
  
  //ACTI Frame view
  self.actiFrameView =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(24, 15, 320-8-24, 140-5)];
  [self.actiFrameView setFrameColor:HeartRate_Frame_Color];
  [self.actiFrameView setTitle:@"ACTI"];
  [self.actiFrameView setParams_VInterval:140.0/8.0/5.0 hInterval:self.actiFrameView.frame.size.width/6.0/5.0];
  self.actiFrameView.backgroundColor = DisplayArea_Color;
  self.actiFrameView.center = CGPointMake(self.actiFrameView.center.x, self.actiFrameView.center.y);
//  
  
  //heartRate
    self.heartRateFrameView =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(24, 2, 320-8-24, 140-5)];
  [self.heartRateFrameView setFrameColor:HeartRate_Frame_Color];
  [self.heartRateFrameView setTitle:@"HR"];
  [self.heartRateFrameView setParams_VInterval:140.0/8.0/5.0 hInterval:self.heartRateFrameView.frame.size.width/6.0/5.0];
  self.heartRateFrameView.backgroundColor = DisplayArea_Color;
  self.heartRateFrameView.center = CGPointMake(self.heartRateFrameView.center.x, self.heartRateFrameView.center.y);
  
  //breathe rate
  
  self.breatheRateFrameView =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(24, 2, 320-8-24, 140-5)];
  [self.breatheRateFrameView setFrameColor:BreathRate_Frame_Color];
  [self.breatheRateFrameView setTitle:@"BR"];
  [self.breatheRateFrameView setParams_VInterval:140.0/8.0/5.0 hInterval:self.breatheRateFrameView.frame.size.width/6.5/5.0];
  self.breatheRateFrameView.backgroundColor = DisplayArea_Color;
  self.breatheRateFrameView.center = CGPointMake(self.breatheRateFrameView.center.x, self.breatheRateFrameView.center.y);

}


- (void)ECGScaleSelected:(id)sender
{
  UIButton *btn = sender;
  static CGFloat scale = 1;
  scale /= 2;
  if(scale == (1/8.0f))
    scale = 4;
  
  [ECGTrack setScaleOfX:scale/2];
  [RespirationTrack setScaleOfX:scale];

  if(scale == 1)
    [btn setTitle:@"Tx1" forState:UIControlStateNormal];
  else if(scale == 2)
    [btn setTitle:@"Tx2" forState:UIControlStateNormal];
  else if(scale == 4)
    [btn setTitle:@"Tx4" forState:UIControlStateNormal];
  else if(scale == (1/2.0f))
    [btn setTitle:@"Tx1/2" forState:UIControlStateNormal];
  else
    [btn setTitle:@"Tx1/4" forState:UIControlStateNormal];
}

- (void)RESPScaleSelected:(id)sender
{
  UIButton *btn = sender;
  static CGFloat scale = 1;
  scale /= 2;
  if(scale == (1/8.0f))
    scale = 1;
  
  [RespirationTrack setScaleOfX:scale];
  
  if(scale == 1)
    [btn setTitle:@"Tx1" forState:UIControlStateNormal];
  else if(scale == (1/2.0f))
    [btn setTitle:@"Tx1/2" forState:UIControlStateNormal];
  else
    [btn setTitle:@"Tx1/4" forState:UIControlStateNormal];

}
-(void)initTrackView{
  

  ECGTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(8, 2, 320-8, 140-5)];
  ECGTrack.backgroundColor = [UIColor clearColor];
  ECGTrack.center = CGPointMake(320/2, ECGTrack.center.y);
  [ECGTrack setScaleOfX:0.5];
  
  ECGSelectScaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  ECGSelectScaleBtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
  [ECGSelectScaleBtn setFrame:CGRectMake(ECGTrack.frame.size.width - 60, 2, 50, 30)];
  [ECGSelectScaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [ECGSelectScaleBtn setTitle:@"Tx1" forState:UIControlStateNormal];
  [ECGSelectScaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [ECGSelectScaleBtn addTarget:self action:@selector(ECGScaleSelected:) forControlEvents:UIControlEventTouchUpInside];
  
  [ECGTrack addSubview:ECGSelectScaleBtn];

  
  
  RespirationTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(8, 2, 320-8, 140-5)];
  RespirationTrack.backgroundColor = [UIColor clearColor];
  RespirationTrack.center = CGPointMake(320/2, RespirationTrack.center.y);
  [RespirationTrack setScaleOfX:1];
  
  RESPSelectScaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  RESPSelectScaleBtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1.0];
  [RESPSelectScaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [RESPSelectScaleBtn setFrame:CGRectMake(RespirationTrack.frame.size.width - 40, 2, 36, 12)];
  
  [RESPSelectScaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [RESPSelectScaleBtn setTitle:@"1" forState:UIControlStateNormal];
  [RESPSelectScaleBtn addTarget:self action:@selector(RESPScaleSelected:) forControlEvents:UIControlEventTouchDown];
  //[RespirationTrack addSubview:RESPSelectScaleBtn];
  
  ActivityTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(24, 24, 320-8, 140-5)];
  ActivityTrack.backgroundColor = [UIColor clearColor];
  //ActivityTrack.center = CGPointMake(320/2, ActivityTrack.center.y);
  [ActivityTrack setScaleOfX:1];
  
  
  heartRateTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(24+24+10, 2, 320-8-24, 140-5)];
  heartRateTrack.backgroundColor = [UIColor clearColor];
  heartRateTrack.center = CGPointMake(320/2+10, heartRateTrack.center.y);
  [heartRateTrack setScaleOfX:1];
  
  breathRateTrack = [[ZLChartTrackView alloc] initWithFrame:CGRectMake(24+24+10, 2, 320-8-24, 140-5)];
  breathRateTrack.backgroundColor = [UIColor clearColor];
  breathRateTrack.center = CGPointMake(320/2+10, breathRateTrack.center.y);
  [breathRateTrack setScaleOfX:1];
    
}
/*************/

-(void)browseFunction{
    NSLog(@"browseFunction");
    NSMutableDictionary *fileDictionary = [NSMutableDictionary dictionaryWithDictionary:[[ZLStorageFunctionManage sharedInstance] getFilesInMonitorFunction]];
    
    NSArray *keys = [fileDictionary allKeys];
    NSLog(@"file key count %d",keys.count);
    
//    for (NSString *key in keys) {
//        NSLog(key);
//        NSMutableArray *filePaths = [fileDictionary valueForKey:key];
//        NSLog(@"file count %d",filePaths.count);
//        for (NSString *filePath in filePaths) {
//            NSLog(filePath);
//        }
//    }
//    
    ZLTreeView *treeView = [ZLTreeView getTree];
    treeView.delegate = self;
    [treeView setContent:fileDictionary];
    [self.view addSubview:treeView];

}

-(NSString *)getHRBRStringFrom:(NSString *)str{
    NSMutableString *temp = [NSMutableString stringWithString:str];
    NSMutableString *returnStr = [[NSMutableString alloc] init];
    //NSLog(@"getPayloadStringFrom");
    while (1) {
        NSRange range = [temp rangeOfString:@"\n"];
        if (range.length == 0) {
            break;
        }
        NSString *subStr = [temp substringToIndex:range.location];
        if (subStr.length<=400) {
            [returnStr appendString:[self getBRHRFromOnePackage:subStr]];
        }
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+1)];
    }
    
    NSLog(@"%@",returnStr);
    return returnStr;
}
-(NSString *)getBRHRFromOnePackage:(NSString *)package{
    //NSLog(@"package %@",package);
    int count = 0,location = 0;
    NSRange locationRange;
    NSMutableString *returnStr = [[NSMutableString alloc] init];
    
    while (1) {
        locationRange = [package rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(location, package.length - location)];
        location = locationRange.location + 1;
        if (count == 4) {
            NSRange tempRange = [package rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(location, package.length - location)];
            NSString *hrStr = [package substringWithRange:NSMakeRange(location, tempRange.location - location)];
            //NSLog(@"hr = %@",hrStr);
            [returnStr appendString:hrStr];
            [returnStr appendString:@","];
        }else if(count == 5){
            NSRange tempRange = [package rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(location, package.length - location)];
            NSString *BrStr = [package substringWithRange:NSMakeRange(location, tempRange.location - location)];
           // NSLog(@"br = %@",BrStr);
            [returnStr appendString:BrStr];
            //[returnStr appendString:@","];
        }else if(count == 6){
            [returnStr appendString:@"\n"];
            break;
        }
        
        count++;
    }
    
    return returnStr;
}
-(NSString *)getPayloadStringFrom:(NSString *)str{
    NSMutableString *temp = [NSMutableString stringWithString:str];
    NSMutableString *returnStr = [[NSMutableString alloc] init];
    //NSLog(@"getPayloadStringFrom");
    while (1) {
        NSRange range = [temp rangeOfString:@"\n"];
        if (range.length == 0) {
            break;
        }
        NSString *subStr = [temp substringToIndex:range.location];
        if (subStr.length<=15) {
            [returnStr appendString:subStr];
            [returnStr appendString:@"\n"];
        }
        [temp deleteCharactersInRange:NSMakeRange(0, range.location+1)];
    }
    
    NSLog(@"%@",returnStr);
    return returnStr;
}
-(void)treeView:(ZLTreeView *)tree didSelectFile:(NSString *)file inDir:(NSString *)dir{
    NSLog(@"select file : %@ in %@",file,dir);
    int fileType = [[ZLStorageFunctionManage sharedInstance] getFileTypeFromFileName:file];
    NSString *filePath = [[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dir] stringByAppendingPathComponent:file];
    
    
    switch (fileType) {
        case FILE_TYPE_ECG_WAVE_FILE:
        {
            NSString *ecgFileData = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
            NSLog(@"ecgFileData:%ld",(unsigned long)ecgFileData.length);
     
            NSString *ecgWaveStr = [self getPayloadStringFrom:ecgFileData];
            [self replayECGWave:ecgWaveStr];
           
        }
            break;
        case FILE_TYPE_BREATH_WAVE_FILE:
        {
            NSString *breathFileData = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
            NSLog(@"breathFileData:%ld",(unsigned long)breathFileData.length);
            
            NSString *breathWaveStr = [self getPayloadStringFrom:breathFileData];
            [self replayBreathWave:breathWaveStr];
        }
            break;
        case FILE_TYPE_ACTIVITY_WAVE_FILE:
        {
            NSString *accFileData = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
            NSLog(@"accFileData:%ld",(unsigned long)accFileData.length);
            
            NSString *accWaveStr = [self getPayloadStringFrom:accFileData];
            [self replayActivityWave:accWaveStr];
        }
            break;
        case FILE_TYPE_GENERAL_DATA_FILE:
        {
            NSString *generalFileData = [NSString stringWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
            NSLog(@"generalFileData:%ld",(unsigned long)generalFileData.length);
             NSString *generalHRBRStr = [self getHRBRStringFrom:generalFileData];
            [self replayGeneralData:generalHRBRStr];
        }
            break;
        default:
            NSLog(@"unknown file");
            break;
    }
    
}

-(void)storageFunction{
    NSLog(@"storageFunction");

    
    if (bInStoring) {
        [flashView stopFlashAnimation];
        bDataStoring = NO;
        [[ZLStorageFunctionManage sharedInstance] storeProcedureInMonitorFunction_Stop];
    }else{
        [flashView startFlashAnimation];
        [[ZLStorageFunctionManage sharedInstance] storeProcedureInMonitorFunction_Start];
        bDataStoring = YES;
        //[self writeTestStart];
    }
    
    bInStoring = !bInStoring;
}

// test code start
NSTimer *writeLoopTimer;
-(void)writeTestStart{
    writeLoopTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(writeTestHandler) userInfo:nil repeats:YES];
}
-(void)writeTestHandler{
    char d[10] = {0x12,0x34,0x56,0x78,0xAB,0xCD,0xEF,0xFF,0xFF,0xFF};
    [[ZLStorageFunctionManage sharedInstance] storeIntoGDPDataFile:[NSData dataWithBytes:&d length:10]];
}
-(void)stopWriteTest{
    if (writeLoopTimer) {
        [writeLoopTimer invalidate];
        writeLoopTimer = nil;
    }
}
// test code end

-(void)settingFunction{
    NSLog(@"settingFunction");
    ZLSettingView *settingView = [ZLSettingView getSettingView];
    [self.view addSubview:settingView];
}
-(void)bluetoothFunction{
  NSLog(@"bluetoothFunction");
  ZLBluetoothLEManage *bleMgr = [ZLBluetoothLEManage sharedInstanceWithLandscape:NO mode:0];
  [bleMgr startEnumPortsProcedure];
  bleSerialComMgr.delegate = bleMgr;

  [self.view addSubview:bleMgr];
  
}
-(void)freezeFunction{
    NSLog(@"freezeFunction");
  [self shortPressAction:nil];
    UIImage *freezeImg = [self getImageFromView:self.view];
   
    ZLFreezeManage *freezeMgr = [ZLFreezeManage freezeManageWithImge:freezeImg];
    
    [self.view addSubview:freezeMgr];


}
-(void)exitFunction{
    exit(0);
}
-(void)uploadFunction{
    NSLog(@"uploadFunction");
    [ECGTrack addValueToBuffer:40];
}

-(UIImage *)getImageFromView:(UIView *)orgView{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/*************/
//-(void)timerHandler:(NSTimer *)timer{
//    container.transform = CGAffineTransformMakeScale(1.2, 1.2);
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






#pragma mark tableview delegate

#define HEIGHT_OF_CELL   180


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/3;
}
-(void)drawTimeScaleInView:(UIView *)view withInterva:(CGFloat)interval withTextColor:(UIColor *)color{
    
    
    for (int i = 0; i<=10; i++) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140-4, 20, 20)];
        timeLabel.center = CGPointMake(i*interval+4, timeLabel.center.y);
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = [NSString stringWithFormat:@"%d",i];
        timeLabel.textColor = color;
        timeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [view addSubview:timeLabel];
    }

    
}
- (void)drawActiRateInView:(UIView*)view withInterval:(CGFloat)interval withTextColor:(UIColor*)color
{
  for (int i = 0; i<=8; i++)
  {
    UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, 40, 20)];
    scaleLabel.center = CGPointMake(12, 146 - i*16);
    scaleLabel.backgroundColor = [UIColor clearColor];
    scaleLabel.textAlignment = NSTextAlignmentCenter;
    scaleLabel.text = [NSString stringWithFormat:@"%d",i*2];
    scaleLabel.textColor = color;
    scaleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
    [view addSubview:scaleLabel];
  }

}
-(void)drawHeartRateInView:(UIView *)view withInterva:(CGFloat)interval withTextColor:(UIColor *)color{
    
    
    for (int i = 0; i<=7; i++) {
        UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, 40, 20)];
        scaleLabel.center = CGPointMake(12, 134 - i*interval);
        scaleLabel.backgroundColor = [UIColor clearColor];
        scaleLabel.textAlignment = NSTextAlignmentCenter;
        scaleLabel.text = [NSString stringWithFormat:@"%d",i*40];
        scaleLabel.textColor = color;
        scaleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [view addSubview:scaleLabel];
    }
    
    
}

-(void)drawBreathRateInView:(UIView *)view withInterva:(CGFloat)interval withTextColor:(UIColor *)color{
    
    
    for (int i = 0; i<=7; i++) {
        UILabel *scaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, 40, 20)];
        scaleLabel.center = CGPointMake(12, 134 - i*interval);
        scaleLabel.backgroundColor = [UIColor clearColor];
        scaleLabel.textAlignment = NSTextAlignmentCenter;
        scaleLabel.text = [NSString stringWithFormat:@"%d",i*10];
        scaleLabel.textColor = color;
        scaleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [view addSubview:scaleLabel];
    }
    
    
}

-(void)drawHRBRTimeScaleInView:(UIView *)view withInterva:(CGFloat)interval withTextColor:(UIColor *)color inStartPoint:(CGPoint)point{
    
    
    for (int i = 0; i < 7; i++) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 140-4, 40, 20)];
        timeLabel.center = CGPointMake(point.x+i*interval, point.y);
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.text = [NSString stringWithFormat:@"%d",i*50];
        timeLabel.textColor = color;
        timeLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [view addSubview:timeLabel];
    }
    
    
}

float ecgGain = 1.0;
-(void)ecgGainAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    ecgGain += 0.5;
    if (ecgGain > 2.0) {
        ecgGain = 0.5;
    }
    [button setTitle:[NSString stringWithFormat:@"Gx%.1f",ecgGain] forState:UIControlStateNormal];
    [ECGTrack setECGGain:ecgGain];
}

float respGain = 1.0;
-(void)respGainAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    respGain += 0.5;
    if (respGain > 2.0) {
        respGain = 0.5;
    }
    [button setTitle:[NSString stringWithFormat:@"Gx%.1f",respGain] forState:UIControlStateNormal];
    [RespirationTrack setRespGain:respGain];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
    
    UIView *cellBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_CELL)];
    [cell setBackgroundView:cellBgView];
    cellBgView.backgroundColor = MAINGRAYCOLOR;
    
    
    cell.userInteractionEnabled = YES;
    
    //title lable
    FXLabel *titleLabel = [[FXLabel alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_OF_CELL)];
    titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.alpha = 0.4;
    titleLabel.font = [UIFont fontWithName:@"ArialMT" size:60];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:titleLabel];
    
    UIScrollView *scrollContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, HEIGHT_OF_CELL)];
    scrollContainer.backgroundColor = [UIColor clearColor];
    scrollContainer.showsHorizontalScrollIndicator = NO;
    scrollContainer.userInteractionEnabled = YES;
    [cell addSubview:scrollContainer];
    
    if (indexPath.row == 0) {//ECG

        //track frame
        ZLChartFrameView *chartView  =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(8, 2, 320-8, 140-5)];
        [chartView setFrameColor:ECG_Frame_Color];
        [chartView setTitle:@"ECG"];
        chartView.backgroundColor = DisplayArea_Color;
        [chartView setParams_VInterval:4.0 hInterval:chartView.frame.size.width/10/5];
        chartView.center = CGPointMake(320/2, chartView.center.y);
        [scrollContainer addSubview:chartView];
        
       
        //[self drawTimeScaleInView:scrollContainer withInterva:chartView.frame.size.width/10.0 withTextColor:ECG_Frame_Color];
        
        ecgGainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ecgGainButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        ecgGainButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 2, 50, 30);
        ecgGainButton.layer.cornerRadius = 6;
        ecgGainButton.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [ecgGainButton setTitle:@"Gx1" forState:UIControlStateNormal];
        [ecgGainButton addTarget:self action:@selector(ecgGainAction:) forControlEvents:UIControlEventTouchUpInside];
        [ecgGainButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        //ecgGainButton.center = CGPointMake(30, chartView.frame.size.height/2);
        [cell addSubview:ecgGainButton];
        
        
        // track view

        [scrollContainer addSubview:ECGTrack];

        
    }
    if (indexPath.row == 1) {//Respiration
        
        ZLChartFrameView *chartView  =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(8, 2, 320-8, 140-5)];
        [chartView setFrameColor:Respiration_Frame_Color];
        [chartView setTitle:@"RESP"];
        [chartView setParams_VInterval:4.0 hInterval:chartView.frame.size.width/10/5];
        chartView.backgroundColor = DisplayArea_Color;
        chartView.center = CGPointMake(320/2, chartView.center.y);
        [scrollContainer addSubview:chartView];
        
        
        respGainButton = [UIButton buttonWithType:UIButtonTypeCustom];
        respGainButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        respGainButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, 2, 50, 30);
        respGainButton.layer.cornerRadius = 6;
        respGainButton.titleLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:10];
        [respGainButton setTitle:@"Gx1" forState:UIControlStateNormal];
        [respGainButton addTarget:self action:@selector(respGainAction:) forControlEvents:UIControlEventTouchUpInside];
        [respGainButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        //respGainButton.center = CGPointMake(30, chartView.frame.size.height/2);
        [cell addSubview:respGainButton];
        
        
        //track view

        [scrollContainer addSubview:RespirationTrack];
        
        
        //[self drawTimeScaleInView:scrollContainer withInterva:chartView.frame.size.width/10.0 withTextColor:Respiration_Frame_Color];
        
    }
    if (indexPath.row == 2) {//activity
        
        //frame view
//        ZLChartFrameView *chartView  =  [[ZLChartFrameView alloc] initWithFrame:CGRectMake(8, 2, 320-8, 140-5)];
//        [chartView setFrameColor:Activity_Frame_Color];
//        [chartView setTitle:@"ACTI"];
//        //[chartView setParams_VInterval:4.0 hInterval:chartView.frame.size.width/10/5];
//        chartView.backgroundColor = DisplayArea_Color;
//        chartView.center = CGPointMake(320/2, chartView.center.y);
//      
//        [scrollContainer addSubview:chartView];
//        
        //track view

        [scrollContainer addSubview:self.actiFrameView];
        [scrollContainer addSubview:ActivityTrack];
        [self drawActiRateInView:scrollContainer withInterval:0 withTextColor:HeartRate_Frame_Color];
      
    
        //[self drawTimeScaleInView:scrollContainer withInterva:chartView.frame.size.width/10.0 withTextColor:Activity_Frame_Color];
      //[self drawHRBRTimeScaleInView:scrollContainer withInterva:self.actiFrameView.frame.size.width/6.0 withTextColor:Activity_Frame_Color inStartPoint:CGPointMake(self.actiFrameView.frame.origin.x, self.actiFrameView.frame.origin.y + self.actiFrameView.frame.size.height + 6)];
    }
    if (indexPath.row == 3) {//heart rate
        
        
        [scrollContainer addSubview:self.heartRateFrameView];
        
        
        //track view
        
        [scrollContainer addSubview:heartRateTrack];
        
        [self drawHeartRateInView:scrollContainer withInterva:140.0/8.0 withTextColor:HeartRate_Frame_Color];
        
        //[self drawHRBRTimeScaleInView:scrollContainer withInterva:self.heartRateFrameView.frame.size.width/6.0 withTextColor:HeartRate_Frame_Color inStartPoint:CGPointMake(self.heartRateFrameView.frame.origin.x, self.heartRateFrameView.frame.origin.y + self.heartRateFrameView.frame.size.height + 6)];
        
    }
    if (indexPath.row == 4) {//breath rate
        
        
       

        [scrollContainer addSubview:self.breatheRateFrameView];
        
        //track view
       
        
        [scrollContainer addSubview:breathRateTrack];
        
        
        [self drawBreathRateInView:scrollContainer withInterva:140.0/8.0 withTextColor:BreathRate_Frame_Color];
        
        //[self drawHRBRTimeScaleInView:scrollContainer withInterva:self.breatheRateFrameView.frame.size.width/6.0 withTextColor:BreathRate_Frame_Color inStartPoint:CGPointMake(self.breatheRateFrameView.frame.origin.x, self.breatheRateFrameView.frame.origin.y + self.breatheRateFrameView.frame.size.height + 6)];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    

    return  cell;
    
    
}




#pragma mark tableview delegate end
long ecgLocation = 0,ecgSampleCut = 0;
long breathLocation = 0;
long activityLocation = 0;
long generalLocation = 0;


-(void)stopOthers{

    
    if (ecgReplayTimer) {
        [ecgReplayTimer invalidate];
        ecgReplayTimer = nil;
    }
    if (generalDataTimer) {
        [generalDataTimer invalidate];
        generalDataTimer = nil;
    }
    if (breathReplayTimer) {
        [breathReplayTimer invalidate];
        breathReplayTimer = nil;
    }
    if (activityReplayTimer) {
        [activityReplayTimer invalidate];
        activityReplayTimer = nil;
    }
    
    [ECGTrack clearToStart];
    [RespirationTrack clearToStart];
    [ActivityTrack clearToStart];
    [heartRateTrack clearToStart];
    [breathRateTrack clearToStart];
    
}

-(void)replayGeneralData:(NSString *)dataStr{
    NSLog(@"general data %@",dataStr);
    
    [self stopOthers];
    
    
    NSLog(@"general Data handler");
    generalLocation = 0;
    
    generalDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(generalDataReplayHandler:) userInfo:dataStr repeats:YES];
    
    // updateUITimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateUI) userInfo:dataStr repeats:YES];
}

-(void)replayECGWave:(NSString *)dataStr{
    NSLog(@"replayECGWave %@",dataStr);

        [self stopOthers];

     NSLog(@"ecg replay handler");
    
    ecgLocation = 0;
    ecgSampleCut = 0;
    
    
    ecgReplayTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(ecgReplayHandler:) userInfo:dataStr repeats:YES];
    

}

-(void)replayBreathWave:(NSString *)dataStr{
    NSLog(@"replayBreathWave %@",dataStr);

    [self stopOthers];

    NSLog(@"breath replay handler");
    breathLocation = 0;
    
    breathReplayTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(breathReplayHandler:) userInfo:dataStr repeats:YES];
    
    // updateUITimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateUI) userInfo:dataStr repeats:YES];
}
-(void)replayActivityWave:(NSString *)dataStr{
    NSLog(@"replayActivityWave %@",dataStr);

        [self stopOthers];
    
    NSLog(@"activity replay handler");
    activityLocation = 0;
    
    activityReplayTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(activityReplayHandler:) userInfo:dataStr repeats:YES];
    
    // updateUITimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateUI) userInfo:dataStr repeats:YES];
}

-(void)ecgReplayHandler:(NSTimer *)timer{
   
    NSString *dataStr = timer.userInfo;
    NSRange nextRange = [dataStr rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(ecgLocation, dataStr.length - ecgLocation)];
    long nextLoc = nextRange.location;
    if (nextRange.length == 0) {
        if (ecgReplayTimer) {
            [ecgReplayTimer invalidate];
            ecgReplayTimer = nil;
        }
        return;
    }
    
    NSString *ecgValue = [dataStr substringWithRange:NSMakeRange(ecgLocation, nextLoc - ecgLocation)];
    ecgLocation = nextLoc + 1;
    printf("%s\n",[ecgValue.description UTF8String]);
    int value = [ecgValue intValue];
    printf("int %d\n",value);
    if (ecgSampleCut%1 == 0) {
        
        float rotateValueECG = 1024.0-value;
        
        [ZLMonitorVC.ECGTrack addValueToBuffer:rotateValueECG/700.0*100.0];
        [ECGTrack setNeedsDisplay];
    }
    ecgSampleCut++;
    
}

-(void)breathReplayHandler:(NSTimer *)timer{
    
    NSString *dataStr = timer.userInfo;
    NSRange nextRange = [dataStr rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(breathLocation, dataStr.length - breathLocation)];
    long nextLoc = nextRange.location;
    if (nextRange.length == 0) {
        if (breathReplayTimer) {
            [breathReplayTimer invalidate];
            breathReplayTimer = nil;
        }
        return;
    }
    
    NSString *breathValue = [dataStr substringWithRange:NSMakeRange(breathLocation, nextLoc - breathLocation)];
    breathLocation = nextLoc + 1;
    printf("%s\n",[breathValue.description UTF8String]);
    int value = [breathValue intValue];
    printf("int %d\n",value);

    float rollAverageResult = [ZLBluetoothLEManage rollAverage:value];
    [RespirationTrack addValueToBuffer:rollAverageResult/1024.0*120.0];
    [RespirationTrack setNeedsDisplay];


}

-(void)activityReplayHandler:(NSTimer *)timer{
    
    NSString *dataStr = timer.userInfo;
    NSRange nextRange = [dataStr rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(activityLocation, dataStr.length - activityLocation)];
    long nextLoc = nextRange.location;
    if (nextRange.length == 0) {
        if (activityReplayTimer) {
            [activityReplayTimer invalidate];
            activityReplayTimer = nil;
        }
        return;
    }
    
    NSString *activityValue = [dataStr substringWithRange:NSMakeRange(activityLocation, nextLoc - activityLocation)];
    activityLocation = nextLoc + 1;
    //printf("%s\n",[activityValue.description UTF8String]);
    int x,y,z,value;
    // get x
    NSRange xRange = [activityValue rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(0, activityValue.length)];
    NSString *xStr = [activityValue substringToIndex:xRange.location];
    x = [xStr intValue];
    
    // get y
    NSRange yRange = [activityValue rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(xRange.location+1,activityValue.length - (xRange.location+1))];
    NSString *yStr = [activityValue substringWithRange:NSMakeRange(xRange.location+1, yRange.location - (xRange.location+1))];
    y = [yStr intValue];
    
    // get z
    NSString *zStr = [activityValue substringFromIndex:yRange.location+1];
    z = [zStr intValue];
    
    int _x = x-512,_y = y-512,_z = z-512;
    //int value = [activityValue intValue];
    value = sqrtf(_x*_x+_y*_y+_z*_z);
    printf("x,y,z,value %d,%d,%d,%d\n",x,y,z,value);
    
    [ActivityTrack addValueToBuffer:value-40.0];
    [ActivityTrack setNeedsDisplay];
    
    
}
-(void)generalDataReplayHandler:(NSTimer *)timer{
    
    
    NSString *dataStr = timer.userInfo;
    NSRange nextRange = [dataStr rangeOfString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(generalLocation, dataStr.length - generalLocation)];
    long nextLoc = nextRange.location;
    if (nextRange.length == 0) {
        if (generalDataTimer) {
            [generalDataTimer invalidate];
            generalDataTimer = nil;
        }
        return;
    }
    
    NSString *hrbrValue = [dataStr substringWithRange:NSMakeRange(generalLocation, nextLoc - generalLocation)];
    generalLocation = nextLoc + 1;

    int hr,br;
    // get x
    NSRange hrRange = [hrbrValue rangeOfString:@"," options:NSCaseInsensitiveSearch range:NSMakeRange(0, hrbrValue.length)];
    NSString *hrStr = [hrbrValue substringToIndex:hrRange.location];
    hr = [hrStr intValue];
    
    
    // get z
    NSString *brStr = [hrbrValue substringFromIndex:hrRange.location+1];
    br = [brStr intValue];
    

    printf("hr,br %d,%d\n",hr,br);
    
    [heartRateTrack addValueToBuffer:((float)hr/255.0*100.0)];
    [breathRateTrack addValueToBuffer:br];
    
    [heartRateTrack setNeedsDisplay];
    [breathRateTrack setNeedsDisplay];
}
#pragma mark packet end

@end
