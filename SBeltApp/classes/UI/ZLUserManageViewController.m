//
//  ZLUserManageViewController.m
//  SBeltApp
//
//  Created by 王 维 on 9/4/13.
//  Copyright (c) 2013 BDE. All rights reserved.
//

#import "ZLUserManageViewController.h"
#import "sharedHeader.h"

@interface ZLUserManageViewController ()

@end

@implementation ZLUserManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *addBtn  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewUser:)];
    
    editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(enterEditMode:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addBtn,editBtn, nil];
    
    [self.navigationItem setTitle:@"用户管理"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN - 60) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelectionDuringEditing = YES;
    [self.view addSubview:_tableView];
    
    currentSelected = 0;
    
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    allUsers = [configureMnger getAllUser];
    [_tableView reloadData];
}
-(void)enterEditMode:(id)sender{
    if (_tableView.isEditing) {
        [editBtn setTitle:@"Edit"];
        [_tableView setEditing:NO animated:YES];
    }else{
        [editBtn setTitle:@"Done"];
        [_tableView setEditing:YES animated:YES];
    }
    
}
-(void)addNewUser:(id)sender{
    ZLUserInfoViewController *userInfo = [[ZLUserInfoViewController alloc] initWithMode:userInfoNewMode withUser:nil];
    [self presentViewController:userInfo animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#define NUM_OF_SECTION              1


// table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NUM_OF_SECTION;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

            return allUsers.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

            return 60;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 10)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UserManage_Cell_Id"];

    ZLUserInfoObject *user = [allUsers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = user.name;
    
    if (indexPath.row == currentSelected) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.isEditing) {
        ZLUserInfoViewController *userInfoVC = [[ZLUserInfoViewController alloc] initWithMode:userInfoEditMode withUser:[allUsers objectAtIndex:indexPath.row]];
        
        [self presentViewController:userInfoVC animated:YES completion:^{
            
        }];
    }else{
        currentSelected = indexPath.row;
        ZLUserInfoObject *userInfo = [allUsers objectAtIndex:currentSelected];
        [configureMnger setCurrentUserName:userInfo.name];
        currentUser = userInfo;//当前用户设置
        [tableView reloadData];
    }
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ZLUserInfoObject *user = [allUsers objectAtIndex:indexPath.row];
        [configureMnger deleteUserByName:user.name];
    }
    allUsers = [configureMnger getAllUser];
    [tableView reloadData];
    
}

@end
