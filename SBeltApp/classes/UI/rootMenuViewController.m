//
//  rootMenuViewController.m
//  SBeltApp
//
//  Created by 王 维 on 6/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "rootMenuViewController.h"
#import "languageStringManage.h"
#import "utilityComponentView.h"
#import <QuartzCore/QuartzCore.h>

#define keyItemOne  @"rootMenuItem1"
#define keyItemTwo  @"rootMenuItem2"


#define HEIGHT_OF_CELL   60


@interface rootMenuViewController ()

@end

@implementation rootMenuViewController

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
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
  UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 2*HEIGHT_OF_CELL) style:UITableViewStylePlain];
    menuView.center = CGPointMake(320/2, 460/2);
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.backgroundColor = [UIColor clearColor];
    menuView.userInteractionEnabled  =  YES;
    menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:menuView];
	
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_OF_CELL;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_CELL)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [cell setBackgroundView:bgView];
    
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_CELL)];
    selectView.backgroundColor = [UIColor orangeColor];

    [cell setSelectedBackgroundView:selectView];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = languageStringKey(keyItemOne);
    }else{
        cell.textLabel.text = languageStringKey(keyItemTwo);
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
   ZLSeperator *seperator = [ZLSeperator seperatorWithWidth:tableView.frame.size.width - 2];
    seperator.center = CGPointMake(tableView.frame.size.width/2, HEIGHT_OF_CELL - 1);
    [cell addSubview:seperator];
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self enterZLMonitor];
    }else{
        [self enterSecondaryMenu];
    }
}
-(void)enterZLMonitor{
    
    ZLMonitorVC = [[ZLMonitorViewController alloc] init];
    
    [[HMGLTransitionManager sharedTransitionManager] setTransition:[[RotateTransition alloc] init]];
    [[HMGLTransitionManager sharedTransitionManager] presentModalViewController:ZLMonitorVC onViewController:self];
    
}
-(void)enterSecondaryMenu{
    menuViewController *secondaryMenuVC = [[menuViewController alloc] init];
    [navigationController pushViewController:secondaryMenuVC animated:YES];
}

#pragma mark tableview delegate end

@end
