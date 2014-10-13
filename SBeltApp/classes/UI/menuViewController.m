//
//  menuViewController.m
//  SBeltApp
//
//  Created by 王 维 on 6/17/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "menuViewController.h"
#import <QuartzCore/QuartzCore.h>

#define keySecondMenuItemOne        @"secondMenuItem1"
#define keySecondMenuItemTwo        @"secondMenuItem2"
#define keySecondMenuItemThree      @"secondMenuItem3"

#define HEIGHT_OF_CELL   60


@interface menuViewController ()

@end

@implementation menuViewController

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
    
//    navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,self.navigationController.navigationBar.frame.origin.y, self.navigationController.navigationBar.frame.size.width, 44.0);
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    menuView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 3*HEIGHT_OF_CELL) style:UITableViewStylePlain];
    menuView.center = CGPointMake(320/2, 460/2);
    menuView.delegate = self;
    menuView.dataSource = self;
    menuView.backgroundColor = [UIColor clearColor];
    menuView.userInteractionEnabled  =  YES;
    menuView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:menuView];
	
    
    currentSelect = 0xff;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    if (currentSelect>0 || currentSelect <2) {
        [menuView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:currentSelect inSection:0] animated:YES];
    }
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT_OF_CELL;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootMenuViewControlller_CellID"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_CELL)];
    bgView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [cell setBackgroundView:bgView];
    

    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEIGHT_OF_CELL)];
    selectView.backgroundColor = [UIColor orangeColor];
    [cell setSelectedBackgroundView:selectView];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = languageStringKey(keySecondMenuItemOne);
    }else if(indexPath.row == 1){
        cell.textLabel.text = languageStringKey(keySecondMenuItemTwo);
    }else{
        cell.textLabel.text = languageStringKey(keySecondMenuItemThree);
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    ZLSeperator *seperator = [ZLSeperator seperatorWithWidth:tableView.frame.size.width - 2];
    seperator.center = CGPointMake(tableView.frame.size.width/2, HEIGHT_OF_CELL);
    [cell addSubview:seperator];
    
    return  cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    currentSelect = indexPath.row;
    switch (currentSelect) {
        case 0:
        {
           
            ZLUserMngVC = [[ZLUserManageViewController alloc] init];
            [self.navigationController pushViewController:ZLUserMngVC animated:YES];
            
            break;
            
            
        }
        case 1:
        {
            
            ZLUserInfoObject *userInfo = [configureMnger getUserInforByName:[configureMnger getCurrentUser]];
            
            ZLActivityVC = [[ZLActivityViewController alloc] initWithUserInfo:userInfo];

            [UIApplication sharedApplication].keyWindow.rootViewController = ZLActivityVC;
            
            
            
        
        }
            break;
        case 2:
        {
            ZLDataMngVC = [[ZLDataManageViewController alloc] init];
            [self.navigationController pushViewController:ZLDataMngVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark tableview delegate end

@end
