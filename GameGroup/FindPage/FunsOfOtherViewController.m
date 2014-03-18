//
//  FunsOfOtherViewController.m
//  GameGroup
//
//  Created by admin on 14-3-12.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "FunsOfOtherViewController.h"
#import "PersonTableCell.h"
#import "TestViewController.h"
@interface FunsOfOtherViewController ()
{
    UITableView * m_myFansTableView;
    SRRefreshView          *slimeView_fans;
    PullUpRefreshView      *refreshView;
    NSMutableDictionary*  m_sortTypeDic;
    NSMutableArray * m_otherSortFansArray;
    NSInteger              m_currentPage;
    NSInteger                 m_allcurrentPage;
}

@end

@implementation FunsOfOtherViewController
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
    
    [self setTopViewWithTitle:@"粉丝" withBackButton:YES];
    
    
    m_sortTypeDic= [NSMutableDictionary dictionary];
    m_otherSortFansArray = [NSMutableArray array];
    m_currentPage=0;
    m_allcurrentPage =0;
    
    m_myFansTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - startX) style:UITableViewStylePlain];
    m_myFansTableView.dataSource = self;
    m_myFansTableView.delegate = self;
    [self.view addSubview:m_myFansTableView];
    
    slimeView_fans = [[SRRefreshView alloc] init];
    slimeView_fans.delegate = self;
    slimeView_fans.upInset = 0;
    slimeView_fans.slimeMissWhenGoingBack = NO;
    slimeView_fans.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    slimeView_fans.slime.skinColor = [UIColor whiteColor];
    slimeView_fans.slime.lineWith = 1;
    slimeView_fans.slime.shadowBlur = 4;
    slimeView_fans.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [m_myFansTableView addSubview:slimeView_fans];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_myFansTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_myFansTableView;
    [refreshView stopLoading:NO];
    
    
    
    
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.labelText = @"获取中";
    [self.view addSubview:hud];
    [self getFansBySort];
	// Do any additional setup after loading the view.
}

#pragma mark -粉丝列表 只有距离排序
- (void)getFansBySort
{
    [hud show:YES];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.userId forKey:@"userid"];
    [paramDict setObject:@"3" forKey:@"shiptype"];// 1：好友   2：关注  3：粉丝
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    [paramDict setObject:@"20" forKey:@"maxSize"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", m_currentPage] forKey:@"pageIndex"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"111" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
   // [paramDict setObject:sort forKey:@"sorttype_3"];
    
    //[hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ((m_currentPage != 0 && ![KISDictionaryHaveKey(responseObject, @"3") isKindOfClass:[NSArray class]]) || (m_currentPage == 0 && ![KISDictionaryHaveKey(responseObject, @"3") isKindOfClass:[NSDictionary class]] )) {
                [refreshView stopLoading:YES];
                [slimeView_fans endRefresh];
                return;
            }

            if (m_currentPage == 0) {//默认展示存储的
                m_allcurrentPage = [KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"3"), @"totalResults") intValue]/20;

                [m_otherSortFansArray removeAllObjects];
                [m_otherSortFansArray addObjectsFromArray:KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"3"), @"users")];
                
            }
            else{
                [m_otherSortFansArray addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"3")];
            }
            
            m_currentPage ++;//从0开始
            [m_myFansTableView reloadData];
            [refreshView stopLoading:NO];
            [refreshView setRefreshViewFrame];
            
            [slimeView_fans endRefresh];
        }else{
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide:YES];
        [refreshView stopLoading:NO];
        [slimeView_fans endRefresh];
    }];
}
-(void)parseFansList:(id)fansList
{
    //    [DataStoreManager cleanFansList];//先清 再存
    dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
    dispatch_async(queue, ^{
        if([fansList isKindOfClass:[NSArray class]]){
            for (NSDictionary * dict in fansList) {
                [DataStoreManager saveUserFansInfo:dict];
            }
        }
        m_otherSortFansArray = [DataStoreManager queryAllFansWithOtherSortType:@"distance" ascend:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_myFansTableView reloadData];
            [refreshView setRefreshViewFrame];
        });
    });
    //上拉加载
}

#pragma mark 表格
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [m_otherSortFansArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell3 = @"cell";
    PersonTableCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell3];
    if (!cell) {
        cell = [[PersonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell3];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * tempDict;
    
    tempDict = [m_otherSortFansArray objectAtIndex:indexPath.row];

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
    
    NSString * fruits = KISDictionaryHaveKey(tempDict, @"img");
    NSArray  * array= [fruits componentsSeparatedByString:@","];
    NSString* headURL;
    if (array.count>0) {
        headURL = [array objectAtIndex:0];
    }
    
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:[[GameCommon getNewStringWithId:headURL] stringByAppendingString:@"/80"]]];
    cell.nameLabel.text = [tempDict objectForKey:@"nickname"];
    cell.gameImg_one.image = KUIImage(@"wow");
    cell.distLabel.text = [KISDictionaryHaveKey(tempDict, @"charactername") isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(tempDict, @"achievement");
    cell.distLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(tempDict, @"characterid") integerValue]];
    
    cell.timeLabel.text = [GameCommon getTimeAndDistWithTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"updateUserLocationDate")] Dis:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"distance")]];
    
    
    [cell refreshCell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myFansTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * tempDict;
    tempDict = [m_otherSortFansArray objectAtIndex:indexPath.row];
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    TestViewController *detailVC = [[TestViewController alloc]init];
    
    detailVC.userId = KISDictionaryHaveKey(tempDict, @"id");
    detailVC.nickName = KISDictionaryHaveKey(tempDict, @"nickname");

    
    
    
    detailVC.achievementStr = [KISDictionaryHaveKey(tempDict, @"achievement") isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(tempDict, @"achievement");
    
    detailVC.achievementColor =KISDictionaryHaveKey(tempDict, @"achievementLevel") ;
    
    detailVC.sexStr =  KISDictionaryHaveKey(tempDict, @"gender");
    
    detailVC.titleImage =[BaseImageUrl stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")]] ;
    
    detailVC.ageStr = [GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]];
    detailVC.constellationStr =KISDictionaryHaveKey(tempDict, @"constellation");
    NSLog(@"vc.VC.constellationStr%@",detailVC.constellationStr);
    
    detailVC.timeStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"updateUserLocationDate")];
    detailVC.jlStr =[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"distance")];
    detailVC.createTimeStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"createTime")];
    if([KISDictionaryHaveKey(tempDict, @"active")intValue]==2){
        detailVC.isActiveAc =YES;
    }
    else{
        detailVC.isActiveAc =NO;
    }
    
    detailVC.isChatPage = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}




- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_myFansTableView.contentSize.height < m_myFansTableView.frame.size.height) {
        refreshView.viewMaxY = 0;
    }
    else
        refreshView.viewMaxY = m_myFansTableView.contentSize.height - m_myFansTableView.frame.size.height;
    [refreshView viewdidScroll:scrollView];
    [slimeView_fans scrollViewDidScroll];
}



#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == m_myFansTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == m_myFansTableView)
    {
        [refreshView didEndDragging:scrollView];
        [slimeView_fans scrollViewDidEndDraging];
        
    }
}

- (void)PullUpStartRefresh:(PullUpRefreshView *)refreshView
{
    NSLog(@"start");
    if (m_currentPage<m_allcurrentPage) {
        NSLog(@"加载更多");
        [self getFansBySort];
    }else{
        
    }
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    m_currentPage = 0;
    
    [self getFansBySort];
}

-(void)endRefresh
{
    [slimeView_fans endRefreshFinish:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
/*
 
 {
 active = 2;
 age = 27;
 alias = " ";
 appType = " ";
 backgroundImg = " ";
 birthdate = 19860821;
 city = " ";
 constellation = "\U72ee\U5b50\U5ea7";
 createTime = " ";
 deviceToken = " ";
 distance = "15.929373176287228";
 email = "306750047@qq.com";
 fan = 55;
 gender = 0;
 hobby = " ";
 id = 10110207;
 ifFraudulent = " ";
 img = "1635,28313,41068,41069,41077,41078,";
 lastForbiddenTime = " ";
 latitude = "39.982788";
 longitude = "116.304398";
 modTime = 1394593408000;
 nickname = "\U53ef\U4e50";
 password = "lueSGJZetyySpUndWjMBEg==";
 phoneNumber = " ";
 rarenum = 4;
 realname = " ";
 remark = " ";
 signature = " ";
 state = 0;
 superremark = ll;
 superstar = 1;
 updateUserLocationDate = 1394698915202;
 username = 18000109959;
 }
 
 */