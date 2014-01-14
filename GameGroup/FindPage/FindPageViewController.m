//
//  FindPageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "FindPageViewController.h"
#import "NearByViewController.h"
#import "NormalTableCell.h"
#import "SameRealmViewController.h"
#import "CanRankTitleObjViewController.h"
#import "NewsViewController.h"

@interface FindPageViewController ()
{
    UITableView*  m_myTableView;
}
@end

@implementation FindPageViewController

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    
    if (![self isHaveLogin]) {
        [[Custom_tabbar showTabBar] when_tabbar_is_selected:0];
        return;
    }
    
    [m_myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"发现" withBackButton:NO];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - 50 - startX) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
}

#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
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
            cell.leftImageView.image = KUIImage(@"state_icon");
            cell.titleLable.text = @"好友动态";
            if ([[NSUserDefaults standardUserDefaults]objectForKey:haveFriendNews] && [[[NSUserDefaults standardUserDefaults]objectForKey:haveFriendNews] isEqualToString:@"1"])
            {
                
                cell.notiBgV.hidden = NO;
            }
            else
                cell.notiBgV.hidden = YES;
        } break;
        case 1:
        {
            if (0 == indexPath.row) {
                cell.leftImageView.image = KUIImage(@"near_icon");
                cell.titleLable.text = @"附近的玩家";
            }
            else
            {
                cell.leftImageView.image = KUIImage(@"same_fu_icon");
                cell.titleLable.text = @"同服的玩家";
            }
            cell.notiBgV.hidden = YES;

        } break;
        case 2:
        {
//            if (0 == indexPath.row) {
//                cell.textLabel.text = @"我的可进化头衔";
//            }
//            else
//            {
            cell.leftImageView.image = KUIImage(@"ranking_icon");
            cell.titleLable.text = @"我的可排名头衔";
            
            cell.notiBgV.hidden = YES;

//            }
        } break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {            
            [[Custom_tabbar showTabBar] hideTabBar:YES];
            NewsViewController* VC = [[NewsViewController alloc] init];
            VC.myViewType = FRIEND_NEWS_TYPE;
            VC.userId = [DataStoreManager getMyUserID];//好友动态
            [self.navigationController pushViewController:VC animated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveFriendNews];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[GameCommon shareGameCommon] displayTabbarNotification];

        }break;
        case 1:
        {
            if (indexPath.row == 0) {
                [[Custom_tabbar showTabBar] hideTabBar:YES];
                NearByViewController* VC = [[NearByViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else if (indexPath.row == 1)
            {
                [[Custom_tabbar showTabBar] hideTabBar:YES];
                SameRealmViewController* realmsVC = [[SameRealmViewController alloc] init];
                [self.navigationController pushViewController:realmsVC animated:YES];
            }
        } break;
        case 2:
        {
            [[Custom_tabbar showTabBar] hideTabBar:YES];

            CanRankTitleObjViewController* titleVC = [[CanRankTitleObjViewController alloc] init];
            [self.navigationController pushViewController:titleVC animated:YES];
        }   break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
