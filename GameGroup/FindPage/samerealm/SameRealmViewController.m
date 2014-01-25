//
//  SameRealmViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "SameRealmViewController.h"
#import "PersonDetailViewController.h"
#import "PersonTableCell.h"

@interface SameRealmViewController ()
{
    UIButton*           m_selectRealmButton;
    SelectView*         m_selectView;
    
    NSMutableArray*     m_realmsArray;
    
    UITableView*        m_myTableView;
    NSMutableArray*     m_tabelData;
    
    NSInteger           m_searchType;//3全部 0男 1女
    
    NSInteger           m_totalPage;
    NSInteger           m_currentPage;//0开始
    
    PullUpRefreshView      *refreshView;
    SRRefreshView   *_slimeView;
}

@end

@implementation SameRealmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    m_tabelData = [[NSMutableArray alloc] init];
    m_realmsArray = [[NSMutableArray alloc] init];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX - (KISHighVersion_7?0:20))];
    m_myTableView.dataSource = self;
    m_myTableView.delegate = self;
    [self.view addSubview:m_myTableView];
    
    m_selectView = [[SelectView alloc] initWithFrame:CGRectZero];
    m_selectView.selectDelegate = self;
    [self.view addSubview:m_selectView];
    
//    [self setTopViewWithTitle:@"" withBackButton:YES];
//    UIImageView* topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, KISHighVersion_7 ? 64 : 44)];
//    topImageView.backgroundColor = kColorWithRGB(23, 161, 240, 1.0);
//    [self.view addSubview:topImageView];
//    
//    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KISHighVersion_7 ? 20 : 0, 50, 44)];
//    [backButton setBackgroundImage:KUIImage(@"back") forState:UIControlStateNormal];
//    [backButton setBackgroundImage:KUIImage(@"back_click") forState:UIControlStateHighlighted];
//    backButton.backgroundColor = [UIColor clearColor];
//    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backButton];
    
    
//    m_myTableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeigth - startX);

    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = NO;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [m_myTableView addSubview:_slimeView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_myTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_myTableView;
    [refreshView stopLoading:NO];
    
    m_selectRealmButton = [[UIButton alloc] initWithFrame:CGRectMake(60, KISHighVersion_7 ? 20 : 0, 200, 44)];
    [m_selectRealmButton setImage:KUIImage(@"toparrow_down") forState:UIControlStateNormal];
    [m_selectRealmButton setImage:KUIImage(@"toparrow_up") forState:UIControlStateSelected];
    m_selectRealmButton.imageEdgeInsets = UIEdgeInsetsMake(26, 160, 26, 26);
    m_selectRealmButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 18);
    [m_selectRealmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    m_selectRealmButton.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    m_selectRealmButton.backgroundColor = [UIColor clearColor];
    [m_selectRealmButton addTarget:self action:@selector(selectRealmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_selectRealmButton];
    m_selectRealmButton.hidden = YES;

    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame=CGRectMake(270, startX - 44, 50, 44);
    [menuButton setBackgroundImage:KUIImage(@"menu_button_normal") forState:UIControlStateNormal];
    [menuButton setBackgroundImage:KUIImage(@"menu_button_click") forState:UIControlStateHighlighted];
    [self.view addSubview:menuButton];
    [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_searchType = 3;
    m_totalPage = 0;
    m_currentPage = 0;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
    
    [self getRealmsDataByNet];//所有服务器名
}

- (void)getRealmsDataByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"125" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
        [hud hide:YES];
        if ([KISDictionaryHaveKey(responseObject, @"1") isKindOfClass:[NSArray class]])
        {
            NSMutableArray* selectArray = [[NSMutableArray alloc] init];
            for (NSDictionary* tempDic in KISDictionaryHaveKey(responseObject, @"1"))
            {
                NSString* realmStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"realm")];
                if (![m_realmsArray containsObject:realmStr])
                {
                    [m_realmsArray addObject:realmStr];
                   
                    NSMutableDictionary* selectViewDic = [NSMutableDictionary dictionaryWithCapacity:1];
                    [selectViewDic setObject:@"1" forKey:kSelectGameIdKey];
                    [selectViewDic setObject:realmStr forKey:kSelectRealmKey];
                    [selectViewDic setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"name")] forKey:kSelectCharacterKey];
                    [selectArray addObject:selectViewDic];
                }
            }
            if ([m_realmsArray count] > 0) {
                [m_selectRealmButton setTitle:[m_realmsArray objectAtIndex:0] forState:UIControlStateNormal];
                
                float viewHeight = 21 + [m_realmsArray count] * 40;
                m_selectView.frame = CGRectMake(0, 0, kScreenWidth, viewHeight);
                m_selectView.center = CGPointMake(kScreenWidth/2, -(startX + viewHeight/2));
                m_selectView.buttonTitleArray = selectArray;
                [m_selectView setMainView];
                m_selectRealmButton.hidden = NO;

                [self getSameRealmDataByNet];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请求数据失败，请检查网络！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 56;
            [alert show];
        }
        [hud hide:YES];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 56) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)getSameRealmDataByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    if (m_searchType != 3) {
        [paramDict setObject:[NSString stringWithFormat:@"%d", m_searchType] forKey:@"gender"];
    }
    [paramDict setObject:@"1" forKey:@"gameid"];
    NSArray* realmArr = [m_selectRealmButton.titleLabel.text componentsSeparatedByString:@"("];
    if (realmArr && [realmArr count] != 0) {
        [paramDict setObject:[realmArr objectAtIndex:0] forKey:@"realm"];
    }
    [paramDict setObject:[NSString stringWithFormat:@"%d", m_currentPage] forKey:@"pageIndex"];
    [paramDict setObject:@"10" forKey:@"maxSize"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"121" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"同服的人 %@", responseObject);
        [hud hide:YES];

        if ((m_currentPage ==0 && ![responseObject isKindOfClass:[NSDictionary class]]) || (m_currentPage != 0 && ![responseObject isKindOfClass:[NSArray class]])) {
            [refreshView stopLoading:YES];
            [_slimeView endRefresh];
            
            return;
        }
        if (m_currentPage == 0) {
            [m_tabelData removeAllObjects];
            
            [m_tabelData addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"users")];
            
            m_totalPage = [[responseObject objectForKey:@"totalResults"] intValue];
        }
        else
        {
            [m_tabelData addObjectsFromArray:responseObject];
        }
        
        [m_myTableView reloadData];

        [refreshView stopLoading:NO];

        m_currentPage ++;//从0开始
        
        [refreshView setRefreshViewFrame];
        [_slimeView endRefresh];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [refreshView stopLoading:NO];
        [_slimeView endRefresh];

        [hud hide:YES];
    }];
}

#pragma mark 服务器筛选
- (void)selectRealmClick:(id)sender
{
    m_selectRealmButton.selected = !m_selectRealmButton.selected;
    
    float viewHeight = 21 + [m_realmsArray count] * 40;
//    [UIView animateWithDuration:0.4 animations:^{
        if (m_selectRealmButton.selected) {
            m_selectView.center = CGPointMake(kScreenWidth/2, startX + viewHeight/2);
        }
        else
            m_selectView.center = CGPointMake(kScreenWidth/2, -(startX + viewHeight/2));
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)selectButtonWithIndex:(NSInteger)buttonIndex
{
    [self selectRealmClick:Nil];
    
    m_searchType = 3;
    [m_selectRealmButton setTitle:[m_realmsArray objectAtIndex:buttonIndex] forState:UIControlStateNormal];
    
    m_currentPage = 0;
    [m_tabelData removeAllObjects];
    [self getSameRealmDataByNet];
}

#pragma mark 筛选
- (void)menuButtonClick:(id)sender
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"筛选条件"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"只看男", @"只看女", @"看全部", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    [m_tabelData removeAllObjects];
    [m_myTableView reloadData];
    
    m_currentPage = 0;
    
    NSString* currentTitle = @"";
    NSArray* realmArr = [m_selectRealmButton.titleLabel.text componentsSeparatedByString:@"("];
    if (realmArr && [realmArr count] != 0) {
        currentTitle = [realmArr objectAtIndex:0];
    }

    if (buttonIndex == 0) {//男
        [m_selectRealmButton setTitle:[currentTitle stringByAppendingString:@"(男)"] forState:UIControlStateNormal];
        m_searchType = 0;
    }
    else if (buttonIndex == 1) {//女
        [m_selectRealmButton setTitle:[currentTitle stringByAppendingString:@"(女)"] forState:UIControlStateNormal];
        m_searchType = 1;
    }
    else//全部
    {
        [m_selectRealmButton setTitle:currentTitle forState:UIControlStateNormal];
        m_searchType = 3;
    }
    [self getSameRealmDataByNet];
}

#pragma mark - table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_tabelData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    PersonTableCell *cell = (PersonTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PersonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary* tempDict = [m_tabelData objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"alias")] isEqualToString:@""] ? [tempDict objectForKey:@"nickname"] : KISDictionaryHaveKey(tempDict, @"alias");
    cell.gameImg_one.image = KUIImage(@"wow");
    
//    cell.sexImg.image = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"gender")] isEqualToString:@"0"] ? KUIImage(@"man") : KUIImage(@"woman");
    
//    cell.sexBg.backgroundColor = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"gender")] isEqualToString:@"0"] ? kColorWithRGB(33, 193, 250, 1.0) : kColorWithRGB(238, 100, 196, 1.0);
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"gender")] isEqualToString:@"0"]) {//男♀♂
        cell.ageLabel.text = [@"♀ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_man.png"];
    }
    else
    {
        cell.ageLabel.text = [@"♂ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(238, 100, 196, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_woman.png"];
    }
    NSArray* heardImgArray = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")] componentsSeparatedByString:@","];
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:[heardImgArray count] != 0 ? [heardImgArray objectAtIndex:0] : @""]];

    NSDictionary* titleDic = KISDictionaryHaveKey(tempDict, @"title");
    if ([titleDic isKindOfClass:[NSDictionary class]]) {
        cell.distLabel.text = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"title")] isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"title");
        cell.distLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"rarenum") integerValue]];
    }
    else
    {
        cell.distLabel.text = @"暂无头衔";
        cell.distLabel.textColor = [UIColor blackColor];
    }
    
    cell.timeLabel.text = [GameCommon getTimeAndDistWithTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"updateUserLocationDate")] Dis:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"distance")]];
    
    [cell refreshCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* recDict = [m_tabelData objectAtIndex:indexPath.row];
    
    PersonDetailViewController* VC = [[PersonDetailViewController alloc] init];
    VC.userName = KISDictionaryHaveKey(recDict, @"username");
    VC.nickName = KISDictionaryHaveKey(recDict, @"nickname");
    VC.isChatPage = NO;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == m_myTableView)
    {
        if (m_myTableView.contentSize.height < m_myTableView.frame.size.height) {
            refreshView.viewMaxY = 0;
        }
        else
            refreshView.viewMaxY = m_myTableView.contentSize.height - m_myTableView.frame.size.height;
        [refreshView viewdidScroll:scrollView];
        [_slimeView scrollViewDidScroll];

    }
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
        [_slimeView scrollViewDidEndDraging];

    }
}

- (void)PullUpStartRefresh
{
    NSLog(@"start");
    if(m_currentPage < m_totalPage)//从0开始记录页码
    {
        [self getSameRealmDataByNet];
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //    [self performSelector:@selector(endRefresh)
    //               withObject:nil
    //               afterDelay:2
    //                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    m_currentPage = 0;
    
    [self getSameRealmDataByNet];
}

-(void)endRefresh
{
    [_slimeView endRefreshFinish:^{
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
