//
//  NearByViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "NearByViewController.h"
#import "PersonTableCell.h"
#import "LocationManager.h"
#import "TestViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
@interface NearByViewController ()
{
    UILabel*            m_titleLabel;
    
    UITableView*        m_myTableView;
    NSMutableArray*     m_tabelData;
    
    NSInteger           m_searchType;//3全部 0男 1女
    
    NSInteger           m_totalPage;
    NSInteger           m_currentPage;//0开始
    
    NSMutableArray *m_imgArray;
    MJRefreshHeaderView *m_header;
    MJRefreshFooterView *m_footer;

}
@end

@implementation NearByViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"" withBackButton:YES];

    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KISHighVersion_7 ? 20 : 0, 220, 44)];
    m_titleLabel.textColor = [UIColor whiteColor];
    m_titleLabel.backgroundColor = [UIColor clearColor];
    m_titleLabel.text = @"附近的玩家";
    m_titleLabel.textAlignment = NSTextAlignmentCenter;
    m_titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:m_titleLabel];
    
    m_searchType = 2;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:NearByKey] && [[[NSUserDefaults standardUserDefaults] objectForKey:NearByKey] length] > 0) {
        NSString* type = [[NSUserDefaults standardUserDefaults] objectForKey:NearByKey];
        if ([type isEqualToString:@"0"]) {
            m_titleLabel.text = @"附近的玩家(男)";
            m_searchType = 0;
        }
        else if ([type isEqualToString:@"1"]) {
            m_titleLabel.text = @"附近的玩家(女)";
            m_searchType = 1;
        }
        else if ([type isEqualToString:@"2"]) {
            m_titleLabel.text = @"附近的玩家";
            m_searchType = 2;
        }
    }
    m_imgArray = [NSMutableArray array];
    m_tabelData = [[NSMutableArray alloc] init];
    
    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [menuButton setBackgroundImage:KUIImage(@"menu_button_normal") forState:UIControlStateNormal];
    [menuButton setBackgroundImage:KUIImage(@"menu_button_click") forState:UIControlStateHighlighted];
    [self.view addSubview:menuButton];
    [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_myTableView.dataSource = self;
    m_myTableView.delegate = self;
    [self.view addSubview:m_myTableView];
    
    
    m_totalPage = 0;
    m_currentPage = 0;
    
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:hud];
//    hud.labelText = @"定位中...";
//    
    
    //if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)){} 是否开启了本应用的定位服务
    
    AppDelegate *app = [[UIApplication sharedApplication]delegate];
    if (app.reach.currentReachabilityStatus ==NotReachable) {
        [self showAlertViewWithTitle:@"提示" message:@"请求数据失败，请检查网络" buttonTitle:@"确定"];
        return;
    }
    else{
      //  [hud show:YES];
//    [[LocationManager sharedInstance] startCheckLocationWithSuccess:^(double lat, double lon) {
//        [[TempData sharedInstance] setLat:lat Lon:lon];
//        [hud hide:YES];
//
//        [self getNearByDataByNet];
//    } Failure:^{
//        [hud hide:YES];
//        [self showAlertViewWithTitle:@"提示" message:@"定位失败，请确认设置->隐私->定位服务中陌游的按钮为打开状态" buttonTitle:@"确定"];
//    }
//     ];
        [self addFooter];
        [self addHeader];
       // [self getNearByDataByNet];
    }
    
}

- (void)getNearByDataByNet
{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isGetNearByDataByNet"];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
   
    if (m_searchType != 2) {
        [paramDict setObject:[NSString stringWithFormat:@"%d", m_searchType] forKey:@"gender"];
    }
    [paramDict setObject:[NSString stringWithFormat:@"%d", m_currentPage] forKey:@"pageIndex"];
    [paramDict setObject:@"10" forKey:@"maxSize"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"120" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    hud.labelText = @"查询中...";
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSLog(@"附近的人 %@", responseObject);
        if ((m_currentPage ==0 && ![responseObject isKindOfClass:[NSDictionary class]]) || (m_currentPage != 0 && ![responseObject isKindOfClass:[NSArray class]])) {
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isGetNearByDataByNet"];
            [m_footer endRefreshing];
            [m_header endRefreshing];
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
        
        m_currentPage ++;//从0开始
        
        [m_header endRefreshing];
        [m_footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        
        [m_header endRefreshing];
        [m_footer endRefreshing];

    }];
    //////

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
    if (buttonIndex == 0) {//男
        m_searchType = 0;
        m_titleLabel.text = @"附近的玩家(男)";
    }
    else if (buttonIndex == 1) {//女
        m_searchType = 1;
        m_titleLabel.text = @"附近的玩家(女)";
    }
    else//全部
    {
        m_titleLabel.text = @"附近的玩家";
        m_searchType = 2;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", m_searchType] forKey:NearByKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self getNearByDataByNet];
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
    
//    cell.ageLabel.text = [GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]];
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"gender")] isEqualToString:@"0"]) {//男♀♂
        cell.ageLabel.text = [@"♂ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_man.png"];
    }
    else
    {
        cell.ageLabel.text = [@"♀ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(238, 100, 196, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_woman.png"];
    }
    if ([KISDictionaryHaveKey(tempDict, @"img") isEqualToString:@""]||[KISDictionaryHaveKey(tempDict, @"img")isEqualToString:@" "]) {
        cell.headImageV.imageURL = nil;
       
    }else{
    NSArray* heardImgArray = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")] componentsSeparatedByString:@","];

    if (heardImgArray.count>0&&(![[heardImgArray objectAtIndex:0] isEqualToString:@""]||![KISDictionaryHaveKey(tempDict, @"img")isEqualToString:@" "])) {
        cell.headImageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@/80",[heardImgArray objectAtIndex:0]]];
    }else{
        cell.headImageV.imageURL = nil;
    }
    }
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
    
   // PersonDetailViewController* VC = [[PersonDetailViewController alloc] init];
    TestViewController* VC = [[TestViewController alloc] init];

    if([KISDictionaryHaveKey(recDict, @"active")intValue] ==2){
        VC.isActiveAc =YES;
    }
    else{
        VC.isActiveAc =NO;
    }
    VC.userId = KISDictionaryHaveKey(recDict, @"id");
    VC.nickName = KISDictionaryHaveKey(recDict, @"nickname");
    VC.isChatPage = NO;
    VC.ageStr = [NSString stringWithFormat:@"%d",[KISDictionaryHaveKey(recDict, @"age")intValue]];
    VC.sexStr = [NSString stringWithFormat:@"%d",[KISDictionaryHaveKey(recDict, @"gender")intValue]];
    VC.timeStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"updateUserLocationDate")];
    VC.jlStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"distance")];
    NSArray* heardImgArray = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"img")] componentsSeparatedByString:@","];
    
    VC.createTimeStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"createTime")];

    VC.achievementStr =[[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"title")] isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(KISDictionaryHaveKey(KISDictionaryHaveKey(recDict, @"title"), @"titleObj"), @"title");
    
    VC.achievementColor =[[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"title")] isEqualToString:@""] ? @"暂无头衔" :KISDictionaryHaveKey(KISDictionaryHaveKey(KISDictionaryHaveKey(recDict, @"title"), @"titleObj"), @"rarenum");
    
    
    VC.constellationStr =KISDictionaryHaveKey(recDict, @"constellation");
    NSLog(@"vc.VC.constellationStr%@",VC.constellationStr);
    VC.titleImage = [BaseImageUrl stringByAppendingString:[heardImgArray count] != 0 ? [heardImgArray objectAtIndex:0] : @""];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark --加载刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = m_myTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            [self getNearByDataByNet];
        
    };
    m_footer = footer;
    
}
- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = m_myTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        m_currentPage = 0;
        [self getNearByDataByNet];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        
    };
    [header beginRefreshing];
    m_header = header;
}



-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
