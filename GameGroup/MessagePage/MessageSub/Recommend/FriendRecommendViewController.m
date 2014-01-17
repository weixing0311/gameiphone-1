//
//  FriendRecommendViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "FriendRecommendViewController.h"
#import "AddContactViewController.h"
#import "DSRecommendList.h"
#import "AppDelegate.h"
#import "PersonDetailViewController.h"

@interface FriendRecommendViewController ()
{
    UITableView*   m_myTableView;
    
    NSMutableArray*       m_tableData;
    NSInteger      m_pageIndex;
    
    PullUpRefreshView      *refreshView;
}
@end

@implementation FriendRecommendViewController

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

    [self setTopViewWithTitle:@"好友推荐" withBackButton:YES];
    
    m_tableData = [[NSMutableArray alloc] initWithCapacity:1];
    
    m_pageIndex = 0;
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(270, startX - 44, 50, 44);
    [addButton setBackgroundImage:KUIImage(@"add_button_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"add_button_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_myTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_myTableView;
    [refreshView stopLoading:NO];
    
    [self getDataByStore];
    
    hud = [[MBProgressHUD alloc] init];
    hud.labelText = @"查询中...";
    [self.view addSubview:hud];
}

- (void)getDataByStore
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dRecommend = [DSRecommendList MR_findAllInContext:localContext];
        for (DSRecommendList* Recommend in dRecommend) {
            NSDictionary* tempDic = [NSDictionary dictionaryWithObjectsAndKeys:Recommend.headImgID, @"headImgID", Recommend.nickName, @"nickname", Recommend.userName, @"username", Recommend.state, @"state", Recommend.fromID, @"type", Recommend.fromStr,@"dis",Recommend.userid,@"userid",nil];
//            [m_tableData addObject:tempDic];
            [m_tableData insertObject:tempDic atIndex:0];
        }
        m_pageIndex = [m_tableData count] > 20?20:[m_tableData count];
        [m_myTableView reloadData];
        [refreshView setRefreshViewFrame];
    }];
}

#pragma mark -添加好友
- (void)addButtonClick:(id)sender
{
    AddContactViewController * addV = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addV animated:YES];
}

#pragma mark 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_tableData count] < 20 ? [m_tableData count] : m_pageIndex;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCharacter";
    RecommendCell *cell = (RecommendCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* tempDic = [m_tableData objectAtIndex:indexPath.row];
    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];

    NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[GameCommon getHeardImgId:KISDictionaryHaveKey(tempDic, @"headImgID")]]];
    cell.headImageV.imageURL = theUrl;
    
    cell.nameLabel.text = KISDictionaryHaveKey(tempDic, @"nickname");
    
    if ([KISDictionaryHaveKey(tempDic, @"type") isEqualToString:@"1"]) {
        cell.fromImage.image = KUIImage(@"recommend_phone");
    }
    else if ([KISDictionaryHaveKey(tempDic, @"type") isEqualToString:@"2"]) {
        cell.fromImage.image = KUIImage(@"recommend_star");
    }
    else  {
        cell.fromImage.image = KUIImage(@"recommend_wow");
    }
    
    cell.fromLabel.text = KISDictionaryHaveKey(tempDic, @"dis");
    
    if ([KISDictionaryHaveKey(tempDic, @"state") isEqualToString:@"0"]) {
        cell.statusButton.backgroundColor = kColorWithRGB(51, 164, 31, 1.0);
        [cell.statusButton setTitle:@"添加" forState:UIControlStateNormal];
        [cell.statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else
    {
        cell.statusButton.backgroundColor = [UIColor clearColor];
        [cell.statusButton setTitle:@"已添加" forState:UIControlStateNormal];
        [cell.statusButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    }
    cell.myDelegate = self;
    cell.myIndexPath = indexPath;
    
    return cell;
}

- (void)cellHeardImgClick:(RecommendCell*)myCell
{
    NSDictionary* tempDict = [m_tableData objectAtIndex:myCell.myIndexPath.row];

    PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
    detailV.userName = KISDictionaryHaveKey(tempDict, @"username");
    detailV.nickName = KISDictionaryHaveKey(tempDict, @"nickname");
    detailV.isChatPage = NO;
    [self.navigationController pushViewController:detailV animated:YES];
}

- (void)cellAddButtonClick:(RecommendCell*)myCell
{
    NSInteger row = myCell.myIndexPath.row;
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [tempDic addEntriesFromDictionary:[m_tableData objectAtIndex:row]];
    
    if ([DataStoreManager ifHaveThisFriend:KISDictionaryHaveKey(tempDic, @"username")]) {
        [self showAlertViewWithTitle:@"提示" message:@"您们已是朋友关系，不能重复添加！" buttonTitle:@"确定"];
        [tempDic setObject:@"1" forKey:@"state"];
        [m_tableData replaceObjectAtIndex:row withObject:tempDic];
        [DataStoreManager updateRecommendStatus:@"1" ForPerson:KISDictionaryHaveKey(tempDic, @"username")];
        [m_myTableView reloadData];
        return;
    }
    if ([DataStoreManager ifIsAttentionWithUserName:KISDictionaryHaveKey(tempDic, @"username")]) {
        [self showAlertViewWithTitle:@"提示" message:@"您已关注过了，不能重复添加！" buttonTitle:@"确定"];
        [tempDic setObject:@"1" forKey:@"state"];
        [m_tableData replaceObjectAtIndex:row withObject:tempDic];
        [DataStoreManager updateRecommendStatus:@"1" ForPerson:KISDictionaryHaveKey(tempDic, @"username")];
        [m_myTableView reloadData];
        return;
    }
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:KISDictionaryHaveKey(tempDic, @"userid")forKey:@"frienduserid"];
    if ([KISDictionaryHaveKey(tempDic, @"type") isEqualToString:@"1"]) {
        [paramDict setObject:@"5" forKey:@"type"];
    }
    else if ([KISDictionaryHaveKey(tempDic, @"type") isEqualToString:@"2"]) {
        [paramDict setObject:@"4" forKey:@"type"];
    }
    else  {
        [paramDict setObject:@"3" forKey:@"type"];
    }
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"109" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        [DataStoreManager updateRecommendStatus:@"1" ForPerson:KISDictionaryHaveKey(tempDic, @"username")];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"2"])
        {
            [self requestPeopleInfoWithName:KISDictionaryHaveKey(tempDic, @"username") ForType:2];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"1"])
        {
            if ([DataStoreManager ifIsFansWithUserName:KISDictionaryHaveKey(tempDic, @"username")]) {
                [DataStoreManager saveUserFriendWithFansList:KISDictionaryHaveKey(tempDic, @"username")];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
                
                [DataStoreManager deleteFansWithUserName:KISDictionaryHaveKey(tempDic, @"username")];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
            }
            else
                [self requestPeopleInfoWithName:KISDictionaryHaveKey(tempDic, @"username") ForType:1];
        }
        [tempDic setObject:@"1" forKey:@"state"];
        [m_tableData replaceObjectAtIndex:row withObject:tempDic];
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

-(void)requestPeopleInfoWithName:(NSString *)userName ForType:(int)type
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];

    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];

        NSMutableDictionary * recDict = KISDictionaryHaveKey(responseObject, @"user");
        if ([KISDictionaryHaveKey(responseObject, @"title") isKindOfClass:[NSArray class]] && [KISDictionaryHaveKey(responseObject, @"title") count] != 0) {
            [recDict setObject:[KISDictionaryHaveKey(responseObject, @"title") objectAtIndex:0] forKey:@"title"];
        }
        
        if ([recDict isKindOfClass:[NSDictionary class]]) {
            if (type == 2) {//关注
                [DataStoreManager saveUserAttentionInfo:recDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];
            }
            else if (type == 1)
            {
                [DataStoreManager saveUserInfo:recDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
    }];
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_myTableView.contentSize.height < m_myTableView.frame.size.height) {
        refreshView.viewMaxY = 0;
    }
    else
        refreshView.viewMaxY = m_myTableView.contentSize.height - m_myTableView.frame.size.height;
    [refreshView viewdidScroll:scrollView];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == m_myTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == m_myTableView)
    {
        [refreshView didEndDragging:scrollView];
    }
}

- (void)PullUpStartRefresh
{
    NSLog(@"start");
  
    m_pageIndex += ([m_tableData count] - m_pageIndex) < 20 ? ([m_tableData count] - m_pageIndex) : 20;
    [m_myTableView reloadData];
    [refreshView setRefreshViewFrame];
    [refreshView stopLoading:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
