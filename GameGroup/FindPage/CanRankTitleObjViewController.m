//
//  CanRankTitleObjViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-27.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "CanRankTitleObjViewController.h"
#import "TitleObjTableCell.h"
#import "TitleObjDetailViewController.h"

@interface CanRankTitleObjViewController ()
{
    UITableView* m_myTableView;
    
    NSMutableArray* m_tableDataArray;
}
@end

@implementation CanRankTitleObjViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"可排名头衔" withBackButton:YES];
    
    m_tableDataArray = [[NSMutableArray alloc] init];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX - (KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    [self getTitleObjByNet];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"查询中";
    [self.view addSubview:hud];
}

- (void)getTitleObjByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"129" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        if ([KISDictionaryHaveKey(responseObject, @"0") isKindOfClass:[NSArray class]]) {//显示的
            for (NSDictionary* tempDic in KISDictionaryHaveKey(responseObject, @"0")) {
                if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"titleObj"), @"rank")] isEqualToString:@"1"]) {//有排名
                    [m_tableDataArray addObject:tempDic];
                }
            }
        }
        [m_myTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
    
}

#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_tableDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myTitleObjTableCell";
    TitleObjTableCell *cell = (TitleObjTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TitleObjTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([m_tableDataArray count] == 0)//头衔
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        cell.nameLabel.text = @"没有头衔展示";
        cell.nameLabel.textColor = [UIColor blackColor];
        return cell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary* infoDic = [m_tableDataArray objectAtIndex:indexPath.row];
    NSString* rarenum = [NSString stringWithFormat:@"rarenum_small_%@", [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj") , @"rarenum")]];
    cell.headImageV.image = KUIImage(rarenum);
    cell.nameLabel.text = KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj"), @"title");
    cell.nameLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj"), @"rarenum") integerValue]];

    cell.userdButton.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TitleObjDetailViewController* detailVC = [[TitleObjDetailViewController alloc] init];
    detailVC.titleObjArray = m_tableDataArray;
    detailVC.showIndex = indexPath.row;
    detailVC.isOnlyUpView = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
