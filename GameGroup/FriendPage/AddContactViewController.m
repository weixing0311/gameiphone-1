//
//  AddContactViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AddContactViewController.h"
#import "NormalTableCell.h"
#import "SearchPersonViewController.h"

@interface AddContactViewController ()
{
    UITableView*  m_myTableView;
}

@end

@implementation AddContactViewController

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

    [self setTopViewWithTitle:@"添加好友" withBackButton:YES];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20)) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
}

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    NormalTableCell *cell = (NormalTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NormalTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
             if (indexPath.row == 0) {
            cell.leftImageView.image = KUIImage(@"add_role");
            cell.titleLable.text = @"通过游戏角色添加";
             }
             else{
            cell.leftImageView.image = KUIImage(@"add_nickname");
            cell.titleLable.text = @"通过用户昵称查找";

             }
        } break;
        case 1:
        {
            if (indexPath.row == 0) {
                cell.leftImageView.image = KUIImage(@"add_phone");
                cell.titleLable.text = @"通过手机号添加";
            }
            else
            {
                cell.leftImageView.image = KUIImage(@"add_id");
                cell.titleLable.text = @"通过陌游ID添加";
            }
        } break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    SearchPersonViewController* searchVC = [[SearchPersonViewController alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
        searchVC.viewType = SEARCH_TYPE_ROLE;
        }else{
        searchVC.viewType = SEARCH_TYPE_NICKNAME;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            searchVC.viewType = SEARCH_TYPE_PHONE;
        }
        else
        {
            searchVC.viewType = SEARCH_TYPE_ID;
        }
    }
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
