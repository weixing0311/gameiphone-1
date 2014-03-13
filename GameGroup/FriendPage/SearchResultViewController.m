//
//  SearchResultViewController.m
//  GameGroup
//
//  Created by admin on 14-2-20.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PersonTableCell.h"
#import "LocationManager.h"
#import "TestViewController.h"
@interface SearchResultViewController ()
{
    UILabel*            m_titleLabel;
    
    UITableView*        m_myTableView;
    NSMutableArray*     m_tabelData;
    
    
    NSInteger           m_pageNum;
    
    PullUpRefreshView      *refreshView;
    SRRefreshView   *_slimeView;
    NSMutableArray  *m_imgArray;
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
    //[self getNearByDataByNet];
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
    m_imgArray = [NSMutableArray array];
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
    [refreshView stopLoading:YES];
    [refreshView setRefreshViewFrame];

   
    m_pageNum = 0;

//    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)){}// 是否开启了本应用的定位服务
//    
//    [[LocationManager sharedInstance] startCheckLocationWithSuccess:^(double lat, double lon) {
//        [[TempData sharedInstance] setLat:lat Lon:lon];
//        
//        [self getNearByDataByNet];
//    } Failure:^{
//        [self showAlertViewWithTitle:@"提示" message:@"定位失败，请确认设置->隐私->定位服务中小伙伴的按钮为打开状态" buttonTitle:@"确定"];
//    }];

    hud = [[MBProgressHUD alloc]initWithView: self.view];
    hud.labelText = @"获取中...";
    [self.view addSubview:hud];
     [self getNearByDataByNet];
}

- (void)getNearByDataByNet
{
    [hud show:YES];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]init];
    
    [paramDict setObject:self.nickNameList forKey:@"nickname"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon]getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"150" forKey:@"method"];
    [postDict setObject:[NSString stringWithFormat:@"%d", m_pageNum] forKey:@"pageIndex"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
            if (m_pageNum ==0) {
                refreshView.pullUpDelegate =self;
                refreshView.hidden = NO;
                [m_tabelData removeAllObjects];
                [m_tabelData addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"users")];
            }
            else{
                
                [m_tabelData addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"users")];

            }
        
        
        if ([KISDictionaryHaveKey(responseObject, @"totalResults")integerValue]<=m_tabelData.count&&m_pageNum!=0) {
            refreshView.pullUpDelegate =nil;
            [refreshView stopLoading:YES];
            NSLog(@"11");
            return;
        }
        
        [m_myTableView reloadData];
        [refreshView stopLoading:NO];
        m_pageNum ++;
        [refreshView setRefreshViewFrame];
        [_slimeView endRefresh];


        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString* warn = [error objectForKey:kFailMessageKey];
            if ([[error objectForKey:kFailErrorCodeKey] isEqualToString:@"200002"]) {//用户不存在， 角色存在
            }
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", warn] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
        [_slimeView endRefresh];
        [refreshView stopLoading:YES];
        [refreshView setRefreshViewFrame];


    }];
            // [refreshView stopLoading:NO];

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
    NSArray* heardImgArray = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"img")] componentsSeparatedByString:@","];

  //  PersonDetailViewController* VC = [[PersonDetailViewController alloc] init];
    TestViewController *VC = [[TestViewController alloc]init];
    VC.userId = KISDictionaryHaveKey(recDict, @"id");
    VC.nickName = KISDictionaryHaveKey(recDict, @"nickname");
    
    
    VC.titleImage =[BaseImageUrl stringByAppendingString:[heardImgArray count] != 0 ? [heardImgArray objectAtIndex:0] : @""];
    
    VC.ageStr = [NSString stringWithFormat:@"%d",[KISDictionaryHaveKey(recDict, @"age")intValue]];
    VC.sexStr = [NSString stringWithFormat:@"%d",[KISDictionaryHaveKey(recDict, @"gender")intValue]];
    VC.timeStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"updateUserLocationDate")];
    VC.jlStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"distance")];

    VC.achievementColor =[[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"title")] isEqualToString:@""] ? @"暂无头衔" :KISDictionaryHaveKey(KISDictionaryHaveKey(KISDictionaryHaveKey(recDict, @"title"), @"titleObj"), @"rarenum");
    if([KISDictionaryHaveKey(recDict, @"active")intValue]==2){
        VC.isActiveAc =YES;
    }
    else{
        VC.isActiveAc =NO;
    }

    VC.achievementStr = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"title")] isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(KISDictionaryHaveKey(KISDictionaryHaveKey(recDict, @"title"), @"titleObj"), @"title");
    
    VC.constellationStr =KISDictionaryHaveKey(recDict, @"constellation");
    VC.createTimeStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(recDict, @"createTime")];
    
    
    VC.isChatPage = NO;
    NSLog(@"age%@ sex%@",VC.ageStr,VC.sexStr);
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark  scrollView  delegate
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
//上拉加载
- (void)PullUpStartRefresh:(PullUpRefreshView *)refreshView
{
    NSLog(@"start");
    [self getNearByDataByNet];
}

#pragma mark - slimeRefresh delegate
//刷新
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    m_pageNum = 0;
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
