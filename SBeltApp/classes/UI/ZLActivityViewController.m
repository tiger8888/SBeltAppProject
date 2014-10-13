//
//  ZLActivityViewController.m
//  SBeltApp
//
//  Created by 王 维 on 9/4/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLActivityViewController.h"
#import "sharedHeader.h"
#import "ZLEventsSelectView.h"

#define DEGREE_OF_ROTATE    (M_PI_2)
#define WIDTH_OF_SCREEN_HERE            WIDTH_OF_SCREEN
#define HEIGTH_OF_SCREEN_HERE           HEIGHT_OF_SCREEN


@interface ZLActivityViewController ()

@end

@implementation ZLActivityViewController


-(id)initWithUserInfo:(ZLUserInfoObject *)userInfo{
    if (self = [super init]) {
        _userInfo = userInfo;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        // Custom initialization
    }
    return self;
}

-(BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"supportedInterfaceOrientations = %d",UIInterfaceOrientationMaskLandscapeLeft);
    return UIInterfaceOrientationMaskLandscapeLeft;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.transform = CGAffineTransformMakeRotation(DEGREE_OF_ROTATE);
    self.view.alpha = 0.0;
    NSLog(@"currentUser : %@",_userInfo.name);
    
    fullScreenCoverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE)];
    fullScreenCoverView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelFullScreenView:)];
    
    [fullScreenCoverView addGestureRecognizer:tapGesture];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];

    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];

    
    NSLog(@"WIDTH_OF_SCREEN = %f,HEIGHT_OF_SCREEN = %f",WIDTH_OF_SCREEN,HEIGHT_OF_SCREEN);
    ZLScrollMenuView *scrollMenu = [[ZLScrollMenuView alloc] initWithFrame:CGRectMake(0, HEIGTH_OF_SCREEN_HERE - 64, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE)];
    
  
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"playAndPause.png"] withHighLightImage:[UIImage imageNamed:@"playAndPause.png"] withTitle:@"播放" withTarget:self withSel:@selector(browseFunction)];
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Setting-彩色1.png"] withHighLightImage:[UIImage imageNamed:@"Setting-灰色1.png"] withTitle:@"设置" withTarget:self withSel:@selector(storageFunction)];
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"Bluetooth-彩色.png"] withHighLightImage:[UIImage imageNamed:@"Bluetooth-灰色.png"] withTitle:@"蓝牙" withTarget:self withSel:@selector(bluetoothFunction)];
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"events.png"] withHighLightImage:[UIImage imageNamed:@"events.png"] withTitle:@"存储" withTarget:self withSel:@selector(eventsSelectAction:)];
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"mute.png"] withHighLightImage:[UIImage imageNamed:@"mute.png"] withTitle:@"浏览" withTarget:self withSel:@selector(browseFunction)];
    
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:@"exit.png"] withHighLightImage:[UIImage imageNamed:@"eixt.png"] withTitle:@"退出" withTarget:self withSel:@selector(exitFunction:)];
    
    [scrollMenu addItemIntoMenuWithNormalImage:[UIImage imageNamed:nil] withHighLightImage:[UIImage imageNamed:nil] withTitle:@"TargetBR" withTarget:self withSel:@selector(targetBRFunction:)];
    
    [scrollMenu layoutAllButtons];
    [self.view addSubview:scrollMenu];
    
    
    
    mainView = [[ZLMainView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE)];
    mainView.layer.masksToBounds = YES;
    [self.view addSubview:mainView];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showToolBar:)];
    [mainView addGestureRecognizer:longPressGR];
    
    UITapGestureRecognizer *shortPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeToolBar:)];
    [mainView addGestureRecognizer:shortPressGR];
    
    
    
    // guide breath rate
    [mainView changeTargetBreathRate:[_userInfo.guideBreathRate intValue]];
    
    
    
    
	// Do any additional setup after loading the view.
}
-(void)showToolBar:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.2 animations:^{
       mainView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE-64);
    } completion:^(BOOL finished) {
        [mainView reLayout];
    }];
    
    
    
}
-(void)cancelFullScreenView:(UIGestureRecognizer *)gesture{
    [self brPickerDismiss];
    
    
}
-(void)closeToolBar:(UIGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.2 animations:^{
        mainView.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN_HERE, HEIGTH_OF_SCREEN_HERE);
    } completion:^(BOOL finished) {
        [mainView reLayout];
    }];
    
    
    
}
-(void)exitFunction:(id)sender{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIApplication sharedApplication].keyWindow.rootViewController = navigationController;
    }];
}
-(void)targetBRFunction:(id)sender{
    
    [self.view addSubview:fullScreenCoverView];
    
    brPickerLabels = [NSArray arrayWithObjects:@"4",@"6",@"8", nil];
    
    [self brPickerShow];
    
    
}

-(void)brPickerShow{
    
    UIPickerView *brPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -200, 300, 120)];
    brPickerView.center = CGPointMake(WIDTH_OF_SCREEN_HERE/2, brPickerView.center.y);
    brPickerView.delegate = self;
    brPickerView.dataSource = self;
    brPickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    brPickerView.showsSelectionIndicator = YES;
    brPickerView.tag = 34;

    [fullScreenCoverView addSubview:brPickerView];
    
    NSLog(@"brPickerShow %d",[_userInfo.guideBreathRate intValue]);
//   [brPickerView selectedRowInComponent:[_userInfo.guideBreathRate intValue]/2-2];
    [brPickerView selectRow:[_userInfo.guideBreathRate intValue]/2-2 inComponent:0 animated:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        brPickerView.frame =    CGRectMake(brPickerView.frame.origin.x, 0, brPickerView.frame.size.width, brPickerView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)brPickerDismiss{
    UIPickerView *brPickerView = (UIPickerView *)[fullScreenCoverView viewWithTag:34];
    [UIView animateWithDuration:0.2 animations:^{
        brPickerView.frame =    CGRectMake(brPickerView.frame.origin.x, -200, brPickerView.frame.size.width, brPickerView.frame.size.height);
    } completion:^(BOOL finished) {
        [brPickerView removeFromSuperview];
        [fullScreenCoverView removeFromSuperview];
    }];
}


-(void)bluetoothFunction{
    NSLog(@"bluetoothFunction");
    ZLBluetoothLEManage *bleMgr = [ZLBluetoothLEManage sharedInstanceWithLandscape:YES mode:1];
    
    bleSerialComMgr.delegate = bleMgr;
    
    [self.view addSubview:bleMgr];
    
}
-(void)eventsSelectAction:(id)sender{
    ZLEventsSelectView *eventsSelectView = [[ZLEventsSelectView alloc] initWithTarget:self];
    [self.view addSubview:eventsSelectView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateRespirationView:(CGFloat)br{
    [mainView updateRespirationTrack:br];
    
}
static short lastBR = 0;
-(void)updateBreatheRate:(CGFloat)br{
    
    if (br != lastBR) {
        printf("updateBreatheRate : %d\n",(short)br);
        lastBR = br;
        float _br = abs(br);
        [mainView updateBreatheRateTrack:_br/10.0];
        /*
         呼吸率处理
         */
        [self trainingBreatheRateHandler:_br/10.0];
        
    }
    
    
    
}
-(void)updateHeartRate:(CGFloat)hr{
    [mainView updateHeartRateTrack:hr];
}
-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager withEnumeratedPorts:(NSArray *)ports{

}

// training
-(void)trainingBreatheRateHandler:(CGFloat)br{
    [trainingMgr addBreathRate:br];
}


-(void)bleSerilaComManager:(BLESerialComManager *)bleSerialComManager didOpenPort:(BLEPort *)port withResult:(resultCodeType)result{

}



-(void)bleSerialComManager:(BLESerialComManager *)bleSerialComManager didDataReceivedOnPort:(BLEPort *)port withLength:(unsigned int)length{


}

// UIPickeView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    

        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        
        myView.textAlignment = NSTextAlignmentCenter;
    
//        myView.text = [pickerNameArray objectAtIndex:row];
        myView.text = [brPickerLabels objectAtIndex:row];
        
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        
        myView.backgroundColor = [UIColor clearColor];
        

    
    return myView;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = 0.0;

        
        componentWidth = 200; // 第一个组键的宽度
    
    return componentWidth;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 40.0;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"picker select row = %d",row);
    switch (row) {
        case 0://选择了引导呼吸率4
            [mainView changeTargetBreathRate:4];
            _userInfo.guideBreathRate = [NSNumber numberWithInt:4];
            break;
        case 1://选择了引导呼吸率6
            [mainView changeTargetBreathRate:6];
            _userInfo.guideBreathRate = [NSNumber numberWithInt:6];
            break;
        case 2://选择了引导呼吸率8
            [mainView changeTargetBreathRate:8];
            _userInfo.guideBreathRate = [NSNumber numberWithInt:8];
            break;
        default:
            break;
    }
    [configureMnger updateUserInfo:_userInfo];
}

@end
