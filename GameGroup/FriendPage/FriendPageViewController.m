//
//  FriendPageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "FriendPageViewController.h"
#import "AddContactViewController.h"
#import "TestViewController.h"
//#import "ContactsCell.h"
#import "PersonTableCell.h"
#import "MJRefresh.h"
#define kSegmentFrinds    (0)
#define kSegmentAttention (1)
#define kSegmentFans      (2)

@interface FriendPageViewController ()
{
    UILabel*   titleLabel;
    
    UIButton   *m_menuButton;
    
    NSMutableDictionary*  m_sortTypeDic;
    
    UIButton*  m_friendButton;
    UIButton*  m_attentionButton;
    UIButton*  m_fansButton;
    NSInteger  m_segmentClickIndex;
    
    UITableView*  m_myTableView;
    UITableView*  m_myAttentionsTableView;
    UITableView*  m_myFansTableView;
    NSInteger              m_currentPage;
    
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
    NSArray *     searchResultArray;
    
    NSMutableArray * m_friendsArray;
    NSMutableDictionary * m_friendDict;
    
    NSMutableArray * m_attentionsArray;
    NSMutableDictionary * m_attentionDict;
    NSMutableArray *m_imgArray;
    //    NSMutableArray * m_fansArray;
    //    NSMutableDictionary * m_fansDict;
    
    NSMutableArray * m_sectionArray_friend;
    NSMutableArray * m_sectionIndexArray_friend;
    
    NSMutableArray * m_sectionArray_attention;
    NSMutableArray * m_sectionIndexArray_attention;
    
    NSMutableArray * m_otherSortFriendArray;//除按字母排序外 其他排序使用
    NSMutableArray * m_otherSortAttentionArray;//除按字母排序外 其他排序使用
    
    NSMutableArray * m_otherSortFansArray;
    MJRefreshHeaderView *m_Friendheader;
    MJRefreshFooterView *m_Friendfooter;
    MJRefreshHeaderView *m_attentionheader;
    MJRefreshFooterView *m_attentionfooter;

    MJRefreshHeaderView *m_fansheader;
    MJRefreshFooterView *m_fansfooter;

    
}

@end

@implementation FriendPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    
    if (![self isHaveLogin]) {
        [[Custom_tabbar showTabBar] when_tabbar_is_selected:0];
        return;
    }
}

#pragma mark 刷新表格
- (void)reloadContentList:(NSNotification*)notification
{
    NSString* tabIndex = notification.object?notification.object : @"0";
    [self refreshSortType:[tabIndex integerValue]];
}

- (void)refreshSortType:(NSInteger)tabIndex
{
    NSString* sort_1 = [[NSUserDefaults standardUserDefaults] objectForKey:sorttype_1] ? [[NSUserDefaults standardUserDefaults] objectForKey:sorttype_1] : @"1";
    NSString* sort_2 = [[NSUserDefaults standardUserDefaults] objectForKey:sorttype_2] ? [[NSUserDefaults standardUserDefaults] objectForKey:sorttype_2] : @"1";
    [m_sortTypeDic setObject:sort_1 forKey:sorttype_1];
    [m_sortTypeDic setObject:sort_2 forKey:sorttype_2];
    
    [self refreshFriendList:tabIndex];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"" withBackButton:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentList:) name:kReloadContentKey object:nil];
    
    m_currentPage = 1;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KISHighVersion_7 ? 20 : 0, 220, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = @"好友";
    [self.view addSubview:titleLabel];
    
//    m_menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    m_menuButton.frame=CGRectMake(5, KISHighVersion_7 ? 27 : 7, 37, 30);
//    [m_menuButton setBackgroundImage:KUIImage(@"menu_button_normal") forState:UIControlStateNormal];
//    [m_menuButton setBackgroundImage:KUIImage(@"menu_button_click") forState:UIControlStateHighlighted];
//    [self.view addSubview:m_menuButton];
//    [m_menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_sortTypeDic = [NSMutableDictionary dictionary];
    
    m_friendsArray = [NSMutableArray array];//搜索用
    m_friendDict = [NSMutableDictionary dictionary];//显示用
    m_imgArray = [NSMutableArray array];
    m_attentionsArray = [NSMutableArray array];
    m_attentionDict = [NSMutableDictionary dictionary];
    
    //    m_fansArray = [NSMutableArray array];
    //    m_fansDict = [NSMutableDictionary dictionary];
    m_otherSortFansArray = [NSMutableArray array];
    
    m_sectionArray_friend = [NSMutableArray array];
    m_sectionIndexArray_friend = [NSMutableArray array];
    
    m_sectionArray_attention = [NSMutableArray array];
    m_sectionIndexArray_attention = [NSMutableArray array];
    
    //    m_sectionArray_fans = [NSMutableArray array];
    //    m_sectionIndexArray_fans = [NSMutableArray array];
    
    searchResultArray = [NSMutableArray array];
    
    m_otherSortFriendArray = [NSMutableArray array];
    m_otherSortAttentionArray = [NSMutableArray array];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [addButton setBackgroundImage:KUIImage(@"add_button_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"add_button_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTopView];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX + 40, 320, self.view.frame.size.height - (40 + 50 + startX))];
    m_myTableView.dataSource = self;
    m_myTableView.delegate = self;
    [self.view addSubview:m_myTableView];
    
    
    m_myAttentionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX + 40, 320, self.view.frame.size.height - (40 + 50 + startX)) style:UITableViewStylePlain];
    m_myAttentionsTableView.dataSource = self;
    m_myAttentionsTableView.delegate = self;
    //    [self.view addSubview:m_myAttentionsTableView];//提前add会导致好友的索引无法点击
    m_myAttentionsTableView.hidden = YES;
    
    
    m_myFansTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX + 40, 320, self.view.frame.size.height - (40 + 50 + startX)) style:UITableViewStylePlain];
    m_myFansTableView.dataSource = self;
    m_myFansTableView.delegate = self;
    [self.view addSubview:m_myFansTableView];
    m_myFansTableView.hidden = YES;
    
    
    [self refreshSortType:kSegmentFrinds];
    [self addHeader];
    [self addHeader1];
    [self addHeader2];
    // 3.2.上拉加载更多
    [self addFooter];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
}

- (void)addTopView
{
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, 40)];
    topBg.image = KUIImage(@"segment_bg");
    [self.view addSubview:topBg];
    
    m_segmentClickIndex = kSegmentFrinds;
    
    m_friendButton = [[UIButton alloc] initWithFrame:CGRectMake(10, startX + 5, 100, 33)];
    [m_friendButton setBackgroundImage:KUIImage(@"segment_button") forState:UIControlStateSelected];
    [m_friendButton setTitle:@"好友" forState:UIControlStateNormal];
    [m_friendButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    m_friendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_friendButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_friendButton];
    m_friendButton.selected = YES;
    
    m_attentionButton = [[UIButton alloc] initWithFrame:CGRectMake(110, startX + 5, 100, 33)];
    [m_attentionButton setBackgroundImage:KUIImage(@"segment_button") forState:UIControlStateSelected];
    [m_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
    [m_attentionButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_attentionButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    m_attentionButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_attentionButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_attentionButton];
    
    m_fansButton = [[UIButton alloc] initWithFrame:CGRectMake(210, startX + 5, 100, 33)];
    [m_fansButton setBackgroundImage:KUIImage(@"segment_button") forState:UIControlStateSelected];
    [m_fansButton setTitle:@"粉丝" forState:UIControlStateNormal];
    [m_fansButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_fansButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    m_fansButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_fansButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_fansButton];
}

- (void)segmentChanged:(UIButton*)segButton
{
    if (segButton.selected) {
        return;
    }
    
    if (segButton == m_friendButton) {
        m_friendButton.selected = YES;
        m_attentionButton.selected = NO;
        m_fansButton.selected = NO;
        m_segmentClickIndex = kSegmentFrinds;
        m_menuButton.hidden = NO;
        
        //        m_myAttentionsTableView.hidden = YES;
        m_myTableView.hidden = NO;
        [m_myAttentionsTableView removeFromSuperview];
        m_myFansTableView.hidden = YES;
        
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"])
        {
            if ([[m_friendDict allKeys] count] == 0) {
                [self refreshFriendList:kSegmentFrinds];
            }
        }
        else
        {
            if ([m_otherSortFriendArray count] == 0) {
                [self refreshFriendList:kSegmentFrinds];
            }
        }
    }
    else if(segButton == m_attentionButton)
    {
        m_friendButton.selected = NO;
        m_attentionButton.selected = YES;
        m_fansButton.selected = NO;
        m_segmentClickIndex = kSegmentAttention;
        m_menuButton.hidden = NO;
        
        m_myTableView.hidden = YES;
        m_myAttentionsTableView.hidden = NO;
        
        [self.view addSubview:m_myAttentionsTableView];
        
        m_myFansTableView.hidden = YES;
        
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"])
        {
            if ([[m_attentionDict allKeys] count] == 0) {
                [self refreshFriendList:kSegmentAttention];
            }
        }
        else
        {
            if ([m_otherSortAttentionArray count] == 0) {
                [self refreshFriendList:kSegmentAttention];
            }
        }
    }
    else
    {
        m_friendButton.selected = NO;
        m_attentionButton.selected = NO;
        m_fansButton.selected = YES;
        m_segmentClickIndex = kSegmentFans;
        m_menuButton.hidden = YES;
        
        m_myTableView.hidden = YES;
        m_myAttentionsTableView.hidden = YES;
        m_myFansTableView.hidden = NO;
        
        if ([m_otherSortFansArray count] == 0) {
            [self refreshFriendList:kSegmentFans];
        }
    }
    [searchDisplay setActive:NO animated:NO];
    
    [self refreshTopLabel];
}

- (void)refreshTopLabel
{
    NSInteger rowNum = 0;
    switch (m_segmentClickIndex) {
        case kSegmentFrinds:
        {
            if(![[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"])
                rowNum = [m_otherSortFriendArray count];
            else
                rowNum = [m_friendsArray count];
            titleLabel.text = [NSString stringWithFormat:@"好友(%d)", rowNum];
        }   break;
        case kSegmentAttention:
        {
            if(![[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"])
                rowNum = [m_otherSortAttentionArray count];
            
            else
            {
                rowNum = [m_attentionsArray count];
            }
            titleLabel.text = [NSString stringWithFormat:@"关注(%d)", rowNum];
        } break;
        case kSegmentFans:
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:FansCount]) {
                rowNum = [[[NSUserDefaults standardUserDefaults] objectForKey:FansCount] integerValue];
            }
            else
                rowNum = 0;
            titleLabel.text = [NSString stringWithFormat:@"粉丝(%d)", rowNum];
        }break;
        default:
            break;
    }
}

#pragma mark -获得好友列表
- (void)getFriendBySort:(NSString*)sort
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"1" forKey:@"shiptype"];// 1：好友   2：关注  3：粉丝
    [paramDict setObject:sort forKey:@"sorttype_1"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"111" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    //[hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:sort forKey:sorttype_1];
        [[NSUserDefaults standardUserDefaults] synchronize];//保存方式
        
        [m_sortTypeDic setObject:sort forKey:sorttype_1];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self parseFriendsList:KISDictionaryHaveKey(responseObject, @"1")];
        }
        
        //        [hud hide:YES];
        // [slimeView_friend endRefresh];
        [m_Friendheader endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide:YES];
        [m_Friendheader endRefreshing];
        //  [slimeView_friend endRefresh];
    }];
}

-(void)parseFriendsList:(id)friendsList
{
    [DataStoreManager cleanFriendList];//先清 再存
    dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
    dispatch_async(queue, ^{
        if ([friendsList isKindOfClass:[NSDictionary class]]) {
            NSArray* keyArr = [friendsList allKeys];
            for (NSString* key in keyArr) {
                for (NSMutableDictionary * dict in [friendsList objectForKey:key]) {
                    //                    [dict setObject:key forKey:@"nameindex"];
                    [DataStoreManager saveUserInfo:dict];
                }
            }
        }
        else if([friendsList isKindOfClass:[NSArray class]]){
            for (NSDictionary * dict in friendsList) {
                [DataStoreManager saveUserInfo:dict];
            }
        }
        //先存后取
        m_friendDict = [DataStoreManager queryAllFriends];//所有朋友
        m_sectionArray_friend = [DataStoreManager querySections];
        [m_sectionIndexArray_friend removeAllObjects];//存放 index 目前 + M
        for (int i = 0; i < m_sectionArray_friend.count; i++) {
            NSLog(@"qq %@ #### %@",[m_sectionArray_friend objectAtIndex:i], [[m_sectionArray_friend objectAtIndex:i] objectAtIndex:0]);
            [m_sectionIndexArray_friend addObject:[[m_sectionArray_friend objectAtIndex:i] objectAtIndex:0]];
        }
        m_friendsArray = [NSMutableArray arrayWithArray:[m_friendDict allKeys]];
        [m_friendsArray sortUsingSelector:@selector(compare:)];
        
        //        [m_otherSortFriendArray removeAllObjects];
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"2"]) {
            m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"distance" ascend:YES];
        }
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"3"]) {
            m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"achievementLevel" ascend:YES];
        }
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"4"]) {
            m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"refreshTime" ascend:NO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [m_myTableView reloadData];
            [self refreshTopLabel];
        });
    });
    
}

#pragma mark -获得关注列表
- (void)getAttentionBySort:(NSString*)sort
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"2" forKey:@"shiptype"];// 1：好友   2：关注  3：粉丝
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"111" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [paramDict setObject:sort forKey:@"sorttype_2"];
    
    [self.view bringSubviewToFront:hud];
    //[hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:sort forKey:sorttype_2];
        [[NSUserDefaults standardUserDefaults] synchronize];//保存方式
        
        [m_sortTypeDic setObject:sort forKey:sorttype_2];
        NSLog(@"m_sortTypeDic%@",m_sortTypeDic);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self parseAttentionsList:KISDictionaryHaveKey(responseObject, @"2")];
        }
        
        //        [hud hide:YES];
        [m_attentionheader endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide:YES];
        [m_attentionheader endRefreshing];

    }];
}

-(void)parseAttentionsList:(id)attentionList
{
    [DataStoreManager cleanAttentionList];//先清 再存
    dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
    dispatch_async(queue, ^{
        if ([attentionList isKindOfClass:[NSDictionary class]]) {
            NSArray* keyArr = [attentionList allKeys];
            for (NSString* key in keyArr) {
                for (NSMutableDictionary * dict in [attentionList objectForKey:key]) {
                    //                    [dict setObject:key forKey:@"nameindex"];
                    [DataStoreManager saveUserAttentionInfo:dict];
                }
            }
        }
        else if([attentionList isKindOfClass:[NSArray class]]){
            for (NSDictionary * dict in attentionList) {
                [DataStoreManager saveUserAttentionInfo:dict];
            }
        }
        //先存后取
        m_attentionDict = [DataStoreManager queryAllAttention];
        m_sectionArray_attention = [DataStoreManager queryAttentionSections];
        [m_sectionIndexArray_attention removeAllObjects];
        for (int i = 0; i < m_sectionArray_attention.count; i++) {
            [m_sectionIndexArray_attention addObject:[[m_sectionArray_attention objectAtIndex:i] objectAtIndex:0]];
        }
        m_attentionsArray = [NSMutableArray arrayWithArray:[m_attentionDict allKeys]];
        [m_attentionsArray sortUsingSelector:@selector(compare:)];
        
        //        [m_otherSortAttentionArray removeAllObjects];
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"2"]) {
            m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"distance" ascend:YES];
        }
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"3"]) {
            m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"achievementLevel" ascend:YES];
        }
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"4"]) {
            m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"refreshTime" ascend:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            [m_myAttentionsTableView reloadData];
            [self refreshTopLabel];
        });
    });
}


#pragma mark -粉丝列表 只有距离排序
- (void)getFansBySort:(NSString*)sort
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:@"3" forKey:@"shiptype"];// 1：好友   2：关注  3：粉丝
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLat]] forKey:@"latitude"];
    [paramDict setObject:[NSString stringWithFormat:@"%f",[[TempData sharedInstance] returnLon]] forKey:@"longitude"];
    [paramDict setObject:@"20" forKey:@"maxSize"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", m_currentPage] forKey:@"pageIndex"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"111" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [paramDict setObject:sort forKey:@"sorttype_3"];
    
    //[hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ((m_currentPage != 0 && ![KISDictionaryHaveKey(responseObject, @"3") isKindOfClass:[NSArray class]]) || (m_currentPage == 0 && ![KISDictionaryHaveKey(responseObject, @"3") isKindOfClass:[NSDictionary class]] )) {
                //  [refreshView stopLoading:YES];
                // [slimeView_fans endRefresh];
                return;
            }
            if (m_currentPage == 0) {//默认展示存储的
                //                [m_fansArray removeAllObjects];
                //                [m_fansDict removeAllObjects];
                
                [m_otherSortFansArray removeAllObjects];
                
                [m_myFansTableView reloadData];
                
                [DataStoreManager cleanFansList];
                [self parseFansList:[KISDictionaryHaveKey(responseObject, @"3") objectForKey:@"users"]];
                
                [[NSUserDefaults standardUserDefaults] setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"3"), @"totalResults")] forKey:FansCount];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
                [self parseFansList:KISDictionaryHaveKey(responseObject, @"3")];
            
            m_currentPage ++;//从0开始
            
            [m_fansheader endRefreshing];
            [m_fansfooter endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [m_fansheader endRefreshing];
        [m_fansfooter endRefreshing];
    }];
}
-(void)parseFansList:(id)fansList
{
    //    [DataStoreManager cleanFansList];//先清 再存
    dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
    dispatch_async(queue, ^{
        //        if ([fansList isKindOfClass:[NSDictionary class]]) {
        //            NSArray* keyArr = [fansList allKeys];
        //            for (NSString* key in keyArr) {
        //                for (NSMutableDictionary * dict in [fansList objectForKey:key]) {
        ////                    [dict setObject:key forKey:@"nameindex"];
        //                    [DataStoreManager saveUserFansInfo:dict];
        //                }
        //            }
        //        }
        //        else
        if([fansList isKindOfClass:[NSArray class]]){
            for (NSDictionary * dict in fansList) {
                [DataStoreManager saveUserFansInfo:dict];
            }
        }
        //先存后取
        //        m_fansDict = [DataStoreManager queryAllFans];
        //        m_fansArray = [NSMutableArray arrayWithArray:[m_fansDict allKeys]];
        //        [m_fansArray sortUsingSelector:@selector(compare:)];
        m_otherSortFansArray = [DataStoreManager queryAllFansWithOtherSortType:@"distance" ascend:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_myFansTableView reloadData];
            [self refreshTopLabel];
        });
    });
    //上拉加载
}

#pragma mark -刷新表格
-(void)refreshFriendList:(NSInteger)tabIndex
{
    if (tabIndex == kSegmentFrinds) {
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {
            m_friendDict = [DataStoreManager queryAllFriends];//所有朋友
            m_sectionArray_friend = [DataStoreManager querySections];
            [m_sectionIndexArray_friend removeAllObjects];//存放 index 目前 + M
            for (int i = 0; i < m_sectionArray_friend.count; i++) {
                [m_sectionIndexArray_friend addObject:[[m_sectionArray_friend objectAtIndex:i] objectAtIndex:0]];
            }
            m_friendsArray = [NSMutableArray arrayWithArray:[m_friendDict allKeys]];
            [m_friendsArray sortUsingSelector:@selector(compare:)];
        }
        else
        {
            if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"2"]) {
                m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"distance" ascend:YES];
            }
            if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"3"]) {
                m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"achievementLevel" ascend:YES];
            }
            if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"4"]) {
                m_otherSortFriendArray = [DataStoreManager queryAllFriendsWithOtherSortType:@"refreshTime" ascend:NO];
            }
        }
        [m_myTableView reloadData];
    }
    else if(kSegmentAttention == tabIndex)
    {
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {
            m_attentionDict = [DataStoreManager queryAllAttention];
            m_sectionArray_attention = [DataStoreManager queryAttentionSections];
            [m_sectionIndexArray_attention removeAllObjects];
            for (int i = 0; i < m_sectionArray_attention.count; i++) {
                [m_sectionIndexArray_attention addObject:[[m_sectionArray_attention objectAtIndex:i] objectAtIndex:0]];
            }
            m_attentionsArray = [NSMutableArray arrayWithArray:[m_attentionDict allKeys]];
            [m_attentionsArray sortUsingSelector:@selector(compare:)];
        }
        else
        {
            if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"2"]) {
                m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"distance" ascend:YES];
            }
            if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"3"]) {
                m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"achievementLevel" ascend:YES];
            }
            if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"4"]) {
                m_otherSortAttentionArray = [DataStoreManager queryAllAttentionWithOtherSortType:@"refreshTime" ascend:NO];
            }
        }
        [m_myAttentionsTableView reloadData];
    }
    else if(kSegmentFans == tabIndex)
    {
        //        m_fansDict = [DataStoreManager queryAllFans];
        //        m_fansArray = [NSMutableArray arrayWithArray:[m_fansDict allKeys]];
        //        [m_fansArray sortUsingSelector:@selector(compare:)];
        
        m_otherSortFansArray = [DataStoreManager queryAllFansWithOtherSortType:@"distance" ascend:YES];
        
        [m_myFansTableView reloadData];
        // [refreshView setRefreshViewFrame];
    }
    
    [self refreshTopLabel];
}

#pragma mark -添加好友
- (void)addButtonClick:(id)sender
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    
    AddContactViewController * addV = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addV animated:YES];
}

#pragma mark 更改排序方式
- (void)menuButtonClick:(id)sender
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"排序方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按字母顺序排序", @"按距离远近排序", @"按头衔等级排序",@"按更新时间排序",nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (m_segmentClickIndex) {
        case kSegmentFrinds:
            [self getFriendBySort:[NSString stringWithFormat:@"%d", buttonIndex + 1]];
            break;
        case kSegmentAttention:
            [self getAttentionBySort:[NSString stringWithFormat:@"%d", buttonIndex + 1]];
            break;
        case kSegmentFans:
            break;
        default:
            break;
    }
}

#pragma mark - 搜索
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    //    if (KISHighVersion_7) {
    //        [searchBar setFrame:CGRectMake(0, 20, 320, 44)];
    //        searchBar.backgroundImage = [UIImage imageNamed:@"top.png"];
    //        [UIView animateWithDuration:0.3 animations:^{
    ////            [m_messageTable setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height- 50 - startX)];
    ////            m_messageTable.contentOffset = CGPointMake(0, -20);
    //        } completion:^(BOOL finished) {
    //
    //        }];
    //    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    //    if (KISHighVersion_7) {
    //        [UIView animateWithDuration:0.2 animations:^{
    //            [searchBar setFrame:CGRectMake(0, 0, 320, 44)];
    //            //            [m_messageTable setFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - 50 - startX)];
    //        } completion:^(BOOL finished) {
    //            searchBar.backgroundImage = nil;
    //        }];
    //    }
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    //    if (KISHighVersion_7) {
    //        //        tableView.backgroundColor = [UIColor grayColor];
    //        [tableView setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 50 - 64)];
    //        //        [tableView setContentOffset:CGPointMake(0, 20)];
    //    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    
}
#pragma mark 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 1;
    }
    if (tableView == m_myTableView) {
        if(![[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {
            return 1;
        }
        return m_sectionIndexArray_friend.count;
    }
    else if(tableView == m_myAttentionsTableView)
    {
        if(![[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {
            return 1;
        }
        return m_sectionIndexArray_attention.count;
    }
    else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];
    //    NSLog(@"%@",searchBar.text);
    //    switch (m_segmentClickIndex) {
    //        case kSegmentFrinds:
    //            searchResultArray = [m_friendsArray filteredArrayUsingPredicate:resultPredicate];
    //            break;
    //        case kSegmentAttention:
    //            searchResultArray = [m_attentionsArray filteredArrayUsingPredicate:resultPredicate];
    //            break;
    //        case kSegmentFans:
    //            searchResultArray = [m_fansArray filteredArrayUsingPredicate:resultPredicate];
    //            break;
    //        default:
    //            break;
    //    }
    //    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
    //        return [searchResultArray count];
    //    }
    if (tableView == m_myTableView) {
        if(![[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"])
        {
            return [m_otherSortFriendArray count];
        }
        else
            return [[[m_sectionArray_friend objectAtIndex:section] objectAtIndex:1] count];//0 为index 1为nameKey数组
    }
    else if(tableView == m_myAttentionsTableView)
    {
        //        if ([m_sectionArray_attention count] == 0) {//首次进入无数据
        //            return 0;
        //        }
        if(![[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"])
            return [m_otherSortAttentionArray count];
        else
            return [[[m_sectionArray_attention objectAtIndex:section] objectAtIndex:1] count];//0 为index 1为nameKey数组
    }
    else
    {
        return [m_otherSortFansArray count];
    }
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
    /*
     //    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
     //        switch (m_segmentClickIndex) {
     //            case kSegmentFrinds:
     //                tempDict = [m_friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
     //                break;
     //            case kSegmentAttention:
     //                tempDict = [m_attentionDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
     //                break;
     //            case kSegmentFans:
     //                tempDict = [m_fansDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
     //                break;
     //            default:
     //                break;
     //        }
     //    }
     //    else
     //    {
     */
    if (tableView == m_myTableView) {
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {//按字母排
            tempDict = [m_friendDict objectForKey:[[[m_sectionArray_friend objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
        }
        else
            tempDict = [m_otherSortFriendArray objectAtIndex:indexPath.row];
    }
    else if(tableView == m_myAttentionsTableView)
    {
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {//按字母排
            tempDict = [m_attentionDict objectForKey:[[[m_sectionArray_attention objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
            NSLog(@"tempDict%@",tempDict);
        }
        else
            tempDict = [m_otherSortAttentionArray objectAtIndex:indexPath.row];
    }
    else
    {
        tempDict = [m_otherSortFansArray objectAtIndex:indexPath.row];
    }
    //    }
    
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"sex")] isEqualToString:@"0"]) {//男♀♂
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
    if ([KISDictionaryHaveKey(tempDict, @"img")isEqualToString:@""]||[KISDictionaryHaveKey(tempDict, @"img")isEqualToString:@" "]) {
        cell.headImageV.imageURL = nil;
    }else{
        if ([GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")]) {
            cell.headImageV.imageURL = [NSURL URLWithString:[[BaseImageUrl stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")]] stringByAppendingString:@"/80"]];
        }else{
            cell.headImageV.imageURL = nil;
        }
    }
    cell.nameLabel.text = [tempDict objectForKey:@"displayName"];
    cell.gameImg_one.image = KUIImage(@"wow");
    cell.distLabel.text = [KISDictionaryHaveKey(tempDict, @"achievement") isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(tempDict, @"achievement");
    cell.distLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(tempDict, @"achievementLevel") integerValue]];
    
    cell.timeLabel.text = [GameCommon getTimeAndDistWithTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"updateUserLocationDate")] Dis:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"distance")]];
    
    
    [cell refreshCell];
    return cell;
}
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
 {
 [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
 NSDictionary * tempDict;
 [[Custom_tabbar showTabBar] hideTabBar:YES];
 PersonDetailViewController* detailVC = [[PersonDetailViewController alloc] init];
 
 //    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
 //        switch (m_segmentClickIndex) {
 //            case kSegmentFrinds:
 //                tempDict = [m_friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
 //                break;
 //            case kSegmentAttention:
 //                tempDict = [m_attentionDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
 //                break;
 //            case kSegmentFans:
 //                tempDict = [m_fansDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
 //                break;
 //            default:
 //                break;
 //        }
 //    }
 //    else
 //    {
 switch (m_segmentClickIndex) {
 case kSegmentFrinds:
 {
 if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {//按字母排
 tempDict = [m_friendDict objectForKey:[[[m_sectionArray_friend objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
 }
 else
 tempDict = [m_otherSortFriendArray objectAtIndex:indexPath.row];
 detailVC.viewType = VIEW_TYPE_FriendPage;
 }  break;
 case kSegmentAttention:
 {
 if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {//按字母排
 tempDict = [m_attentionDict objectForKey:[[[m_sectionArray_attention objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
 }
 else
 tempDict = [m_otherSortAttentionArray objectAtIndex:indexPath.row];
 detailVC.viewType = VIEW_TYPE_AttentionPage;
 }  break;
 case kSegmentFans:
 {
 tempDict = [m_otherSortFansArray objectAtIndex:indexPath.row];
 
 detailVC.viewType = VIEW_TYPE_FansPage;
 } break;
 default:
 break;
 }
 //    }
 detailVC.userId = KISDictionaryHaveKey(tempDict, @"userid");
 detailVC.nickName = KISDictionaryHaveKey(tempDict, @"displayName");
 detailVC.isChatPage = NO;
 [self.navigationController pushViewController:detailVC animated:YES];
 }
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * tempDict;
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    // PersonDetailViewController* detailVC = [[PersonDetailViewController alloc] init];
    TestViewController *detailVC = [[TestViewController alloc]init];
    switch (m_segmentClickIndex) {
        case kSegmentFrinds:
        {
            if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {//按字母排
                tempDict = [m_friendDict objectForKey:[[[m_sectionArray_friend objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
            }
            else
                tempDict = [m_otherSortFriendArray objectAtIndex:indexPath.row];
            detailVC.viewType = VIEW_TYPE_FriendPage1;
        }  break;
        case kSegmentAttention:
        {
            if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {//按字母排
                tempDict = [m_attentionDict objectForKey:[[[m_sectionArray_attention objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
            }
            else
                tempDict = [m_otherSortAttentionArray objectAtIndex:indexPath.row];
            detailVC.viewType = VIEW_TYPE_AttentionPage1;
        }  break;
        case kSegmentFans:
        {
            tempDict = [m_otherSortFansArray objectAtIndex:indexPath.row];
            
            detailVC.viewType = VIEW_TYPE_FansPage1;
        } break;
        default:
            break;
    }
    //    }
    detailVC.achievementStr = [KISDictionaryHaveKey(tempDict, @"achievement") isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(tempDict, @"achievement");
    detailVC.achievementColor =KISDictionaryHaveKey(tempDict, @"achievementLevel") ;
    detailVC.sexStr =  KISDictionaryHaveKey(tempDict, @"sex");
    
    detailVC.titleImage =[BaseImageUrl stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")]] ;
    
    detailVC.ageStr = [GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]];
    detailVC.constellationStr =KISDictionaryHaveKey(tempDict, @"constellation");
    NSLog(@"vc.VC.constellationStr%@",detailVC.constellationStr);
    
    detailVC.userId = KISDictionaryHaveKey(tempDict, @"userid");
    detailVC.nickName = KISDictionaryHaveKey(tempDict, @"displayName");
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




#pragma mark 索引
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return @"";
    }
    
    if (tableView == m_myTableView) {
        if ([m_sectionIndexArray_friend count] == 0 || ![[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {
            return @"";
        }
        return [m_sectionIndexArray_friend objectAtIndex:section];
    }
    else if(tableView == m_myAttentionsTableView)
    {
        if ([m_sectionIndexArray_attention count] == 0 || ![[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {
            return @"";
        }
        return [m_sectionIndexArray_attention objectAtIndex:section];
    }
    else
        return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == m_myTableView) {
        if ([[m_sortTypeDic objectForKey:sorttype_1] isEqualToString:@"1"]) {
            return m_sectionIndexArray_friend;
        }
    }
    else if(tableView == m_myAttentionsTableView)
    {
        if ([[m_sortTypeDic objectForKey:sorttype_2] isEqualToString:@"1"]) {
            return m_sectionIndexArray_attention;
        }
    }
    else{
        return nil;
    }
    return nil;
}

#pragma mark  scrollView  delegate
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = m_myFansTableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        m_currentPage = 0;
        [self getFansBySort:@""];

    };
    m_fansfooter = footer;
}

- (void)addHeader
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];


    header.scrollView = m_myTableView;
        header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
                    [self getFriendBySort:[m_sortTypeDic objectForKey:sorttype_1]];
        };
        header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
            
        };
        header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
            
        };
    //}
    m_Friendheader = header;
}
- (void)addHeader1
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = m_myAttentionsTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self getAttentionBySort:[m_sortTypeDic objectForKey:sorttype_2]];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        
    };
    m_attentionheader = header;
}

- (void)addHeader2
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = m_myFansTableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        m_currentPage = 0;
        [self getFansBySort:@""];
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        
    };
    m_fansheader = header;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
