//
//  SearchResultViewController.m
//  GameGroup
//
//  Created by admin on 14-2-20.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PersonTableCell.h"
#import "PersonDetailViewController.h"
#import "LocationManager.h"

@interface SearchResultViewController ()
{
    UILabel*            m_titleLabel;
    
    UITableView*        m_myTableView;
    NSMutableArray*     m_tabelData;
    
  //  NSInteger           m_searchType;//3全部 0男 1女
    
    NSInteger           m_totalPage;
    NSInteger           m_currentPage;//0开始
    
    PullUpRefreshView      *refreshView;
    SRRefreshView   *_slimeView;
    
}

@end

@implementation SearchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNearByDataByNet];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KISHighVersion_7 ? 20 : 0, 220, 44)];
    m_titleLabel.textColor = [UIColor whiteColor];
    m_titleLabel.backgroundColor = [UIColor clearColor];
    m_titleLabel.text = @"查询结果";
    m_titleLabel.textAlignment = NSTextAlignmentCenter;
    m_titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:m_titleLabel];
    
    
    m_tabelData = [[NSMutableArray alloc] init];
//筛选Button
    
//    UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    menuButton.frame=CGRectMake(270, startX - 44, 50, 44);
//    [menuButton setBackgroundImage:KUIImage(@"menu_button_normal") forState:UIControlStateNormal];
//    [menuButton setBackgroundImage:KUIImage(@"menu_button_click") forState:UIControlStateHighlighted];
//    [self.view addSubview:menuButton];
//    [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_myTableView.dataSource = self;
    m_myTableView.delegate = self;
    [self.view addSubview:m_myTableView];
    
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
    
    m_totalPage = 0;
    m_currentPage = 0;
    
    //if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)){} 是否开启了本应用的定位服务
    [[LocationManager sharedInstance] startCheckLocationWithSuccess:^(double lat, double lon) {
        [[TempData sharedInstance] setLat:lat Lon:lon];
        
        [self getNearByDataByNet];
    } Failure:^{
        [self showAlertViewWithTitle:@"提示" message:@"定位失败，请确认设置->隐私->定位服务中小伙伴的按钮为打开状态" buttonTitle:@"确定"];
    }];

}

- (void)getNearByDataByNet
{
    
    //6222 0110 2463 0240
        if ((m_currentPage ==0 && ![_responseObject isKindOfClass:[NSDictionary class]]) || (m_currentPage != 0 && ![_responseObject isKindOfClass:[NSArray class]])) {
            [refreshView stopLoading:YES];
            [_slimeView endRefresh];
            return;
        }
        if (m_currentPage == 0) {
            [m_tabelData removeAllObjects];
            
            [m_tabelData addObjectsFromArray:KISDictionaryHaveKey(_responseObject, @"users")];
            
            m_totalPage = [[_responseObject objectForKey:@"totalResults"] intValue];
        }
        else
        {
            [m_tabelData addObjectsFromArray:_responseObject];
        }
        
        [m_myTableView reloadData];
        
        [refreshView stopLoading:NO];
        //        }
        m_currentPage ++;//从0开始
        
        [refreshView setRefreshViewFrame];
        [_slimeView endRefresh];
        
 
}

#pragma mark 筛选
//- (void)menuButtonClick:(id)sender
//{
//    UIActionSheet* actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"筛选条件"
//                                  delegate:self
//                                  cancelButtonTitle:@"取消"
//                                  destructiveButtonTitle:Nil
//                                  otherButtonTitles:@"只看男", @"只看女", @"看全部", nil];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [actionSheet showInView:self.view];
//}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    [m_tabelData removeAllObjects];
//    [m_myTableView reloadData];
//    
//    m_currentPage = 0;
//    if (buttonIndex == 0) {//男
//        m_searchType = 0;
//        m_titleLabel.text = @"附近的玩家(男)";
//    }
//    else if (buttonIndex == 1) {//女
//        m_searchType = 1;
//        m_titleLabel.text = @"附近的玩家(女)";
//    }
//    else//全部
//    {
//        m_titleLabel.text = @"附近的玩家";
//        m_searchType = 2;
//    }
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", m_searchType] forKey:NearByKey];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self getNearByDataByNet];
//}

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
    VC.userId = KISDictionaryHaveKey(recDict, @"id");
    VC.nickName = KISDictionaryHaveKey(recDict, @"nickname");
    VC.isChatPage = NO;
    [self.navigationController pushViewController:VC animated:YES];
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
    [_slimeView scrollViewDidScroll];
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
        [self getNearByDataByNet];
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
    
    [self getNearByDataByNet];
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
