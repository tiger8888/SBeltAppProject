//
//  ZLUserInfoViewController.m
//  SBeltApp
//
//  Created by 王 维 on 9/13/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLUserInfoViewController.h"
#import "sharedHeader.h"


@interface ZLUserInfoViewController ()

@end

@implementation ZLUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithMode:(userInfoMode)mode withUser:(ZLUserInfoObject *)userInfo{
    if (self = [super init]) {
        
    }
    _mode = mode;
    currentUser = userInfo;
    if (currentUser == nil) {
        currentUser = [[ZLUserInfoObject alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 44)];
    NSString *title;
    if (_mode == userInfoNewMode) {
        title = @"新用户";
    }else{
        title = @"用户编辑";
    }
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:title];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(CancelAction:)];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(SaveAction:)];
    
    
    navigationItem.leftBarButtonItem = left;
    navigationItem.rightBarButtonItem = right;
    
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [self.view addSubview:navigationBar];
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 60) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    
	// Do any additional setup after loading the view.
}
-(void)CancelAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)SaveAction:(id)sender{
    
    [configureMnger addNewUser:currentUser];
    
    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define NUM_OF_SECTION              3

#define SECTION_OF_USER_NAME             0
#define SECTION_OF_BREATH_RATE           1
#define SECTION_OF_ECG_RATE              2

// table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUM_OF_SECTION;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_OF_USER_NAME:
            return 1;
            break;
        case SECTION_OF_BREATH_RATE:
            
            break;
        case SECTION_OF_ECG_RATE:
            
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case SECTION_OF_USER_NAME:
            return 40;
            break;
        case SECTION_OF_BREATH_RATE:
            return 40;
            break;
        case SECTION_OF_ECG_RATE:
            return 40;
            break;
        default:
            break;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:header.frame];
    headerLabel.backgroundColor = [UIColor clearColor];
    [header addSubview:headerLabel];
    
    
    switch (section) {
        case SECTION_OF_USER_NAME:
           headerLabel.text = @"用户名:";
            break;
        case SECTION_OF_BREATH_RATE:
            break;
        case SECTION_OF_ECG_RATE:
            break;
        default:
            break;
    }
    
    return header;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case SECTION_OF_USER_NAME:
            return 40;
            break;
        case SECTION_OF_BREATH_RATE:
            return 40;
            break;
        case SECTION_OF_ECG_RATE:
            return 40;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UserManage_Cell_Id"];
    switch (indexPath.section) {
        case SECTION_OF_USER_NAME:
            cell.textLabel.text =  currentUser.name;
            break;
        case SECTION_OF_BREATH_RATE:
            
            break;
            
        case SECTION_OF_ECG_RATE:
            
            break;
        default:
            break;
    }
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == SECTION_OF_USER_NAME) {
        ZLPopTextInputView *popTextInput = [ZLPopTextInputView popTextInputViewWithTarget:self.view withTitle:@"用户名输入"];
        popTextInput.delegate = self;
        popTextInput.center = CGPointMake(WIDTH_OF_SCREEN/2, popTextInput.center.y);
        [popTextInput popOutToShow];
    }

}

-(void)didTextInputViewFinishTextInput:(ZLPopTextInputView *)popTextInputView withText:(NSString *)text{
    currentUser.name = text;
    [tableView reloadData];
}

@end
