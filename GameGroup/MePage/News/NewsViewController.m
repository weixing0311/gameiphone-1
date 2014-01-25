//
//  NewsViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-27.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsGetTitleCell.h"
#import "OnceDynamicViewController.h"
#import "SendNewsViewController.h"
#import "SendArticleViewController.h"
#import "MyProfileViewController.h"
#import "PersonDetailViewController.h"
#import "ReplyViewController.h"

//alias = " ";
//commentObj = " ";评论
//commentnum = 0;
//createDate = 1388545389000;
//destMessageId = 0;
//destMsgobj = " ";赞
//detailPageId = 3359;
//hide = 0;
//icon = " ";
//id = 51;
//img = " ";
//msg = "\U5168\U56fd\U4ec51\U540d\U73a9\U5bb6\U62e5\U6709";
//nickname = Whoareyou;
//rarenum = 4;
//title = "\U83b7\U5f97\U4e86\U670d\U52a1\U5668\U5341\U5927\U6218\U795e\U5934\U8854";
//titleObj = " ";
//type = 1;3发表  4赞 5评论
//urlLink = " ";
//userid = 00000007;
//username = 11111111111;
//zan = 0;
//zannum = 0;
@interface NewsViewController ()
{
    NSInteger   m_currentPage;
    
    NSMutableArray*  m_newsArray;
    NSMutableArray*  m_rowHeigthArray;
    
    PullUpRefreshView      *refreshView;

    UITableView*     m_myTableView;
    
    SRRefreshView   *_slimeView;
    
    BOOL            isRefresh;
}
@end

@implementation NewsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isRefresh) {
        [_slimeView setLoadingWithexpansion];

        m_currentPage = 0;
        [self getNewsDataByNet];
        
        isRefresh = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    m_currentPage = 0;
    isRefresh = YES;//进来刷新
    
    m_newsArray = [[NSMutableArray alloc] init];
    m_rowHeigthArray = [[NSMutableArray alloc] init];
    
    if (self.myViewType == ME_NEWS_TYPE) {
        [self setTopViewWithTitle:@"我的动态" withBackButton:YES];
        
        [self getDataWithMyStore];
        
        UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.frame=CGRectMake(270, startX - 44, 50, 44);
        [addButton setBackgroundImage:KUIImage(@"add_button_normal") forState:UIControlStateNormal];
        [addButton setBackgroundImage:KUIImage(@"add_button_click") forState:UIControlStateHighlighted];
        [self.view addSubview:addButton];
        [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if(self.myViewType == FRIEND_NEWS_TYPE)
    {
        [self setTopViewWithTitle:@"好友动态" withBackButton:YES];
        
        [self getDataWithFriendStore];
    }
    else if(self.myViewType == ONEPERSON_NEWS_TYPE)//某个好友的
    {
        [self setTopViewWithTitle:@"个人动态" withBackButton:YES];
    }
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX - (KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_myTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_myTableView;
    [refreshView stopLoading:YES];
    [refreshView setRefreshViewFrame];
    
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
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
}

- (void)backButtonClick:(id)sender
{
    if (self.myViewType == ME_NEWS_TYPE) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveMyNews];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(self.myViewType == FRIEND_NEWS_TYPE)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveFriendNews];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(self.myViewType == ONEPERSON_NEWS_TYPE)
    {
        
    }
    [[GameCommon shareGameCommon] displayTabbarNotification];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataWithMyStore
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dMyNews = [DSMyNewsList MR_findAllInContext:localContext];
        for (DSMyNewsList* news in dMyNews) {
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:news.newsId, @"id", news.heardImgId, @"img", news.bigTitle, @"title", news.msg, @"msg", news.detailPageId, @"detailPageId", news.createDate, @"createDate", news.nickName, @"nickname",news.type, @"type",news.commentObj, @"commentObj",news.urlLink, @"urlLink",news.img, @"img",news.zannum, @"zannum",news.userid, @"userid",news.username, @"username",nil];
            [m_newsArray addObject:tempDic];
            if ([news.type isEqualToString:@"5"]) {
                [m_rowHeigthArray addObject:@"105"];
            }
            else
            {
                [m_rowHeigthArray addObject:@"80"];
            }
        }
    }];
}

- (void)getDataWithFriendStore
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dFriendsNews = [DSFriendsNewsList MR_findAllInContext:localContext];
        for (DSFriendsNewsList* news in dFriendsNews) {
            NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:news.newsId, @"id", news.heardImgId, @"img", news.bigTitle, @"title", news.msg, @"msg", news.detailPageId, @"detailPageId", news.createDate, @"createDate", news.nickName, @"nickname",news.type, @"type",news.commentObj, @"commentObj",news.urlLink, @"urlLink",news.img, @"img",news.zannum, @"zannum",news.userid, @"userid",news.username, @"username",nil];
            [m_newsArray addObject:tempDic];
            if ([news.type isEqualToString:@"5"]) {
                [m_rowHeigthArray addObject:@"105"];
            }
            else
            {
                [m_rowHeigthArray addObject:@"80"];
            }
        }
    }];
}

- (void)getNewsDataByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.userId forKey:@"userid"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", m_currentPage] forKey:@"pageIndex"];
    [paramDict setObject:@"20" forKey:@"maxSize"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    switch (self.myViewType) {
        case ME_NEWS_TYPE:
            [postDict setObject:@"131" forKey:@"method"];
            break;
        case FRIEND_NEWS_TYPE:
            [postDict setObject:@"132" forKey:@"method"];
            break;
        case ONEPERSON_NEWS_TYPE:
            [postDict setObject:@"131" forKey:@"method"];
            break;
        default:
            break;
    }
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
//    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];

        if (![responseObject isKindOfClass:[NSArray class]]) {
            [refreshView stopLoading:YES];
            [_slimeView endRefresh];
            return;
        }
        if (m_currentPage == 0) {//默认展示存储的
            
            [self refreshNewsListStore:responseObject];
            [m_newsArray removeAllObjects];
            [m_rowHeigthArray removeAllObjects];
        }
        m_currentPage ++;//从0开始
        
        [m_newsArray addObjectsFromArray:responseObject];
       
        for (NSDictionary* dic in responseObject) {
            if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"5"]) {
                [m_rowHeigthArray addObject:@"105"];
            }
            else
            {
                [m_rowHeigthArray addObject:@"80"];
            }
        }
        [m_myTableView reloadData];
        
        [refreshView stopLoading:NO];
        [refreshView setRefreshViewFrame];
        
        [_slimeView endRefresh];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [refreshView stopLoading:NO];
        [_slimeView endRefresh];

        [hud hide:YES];
    }];
}

- (void)refreshNewsListStore:(NSArray*)tempArray
{
    switch (self.myViewType) {
        case ME_NEWS_TYPE:
        {
            [DataStoreManager cleanMyNewsList];
            
            dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
            dispatch_async(queue, ^{
                for (NSDictionary * dict in tempArray) {
                    [DataStoreManager saveMyNewsWithData:dict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }break;
        case FRIEND_NEWS_TYPE:
        {
            [DataStoreManager cleanFriendsNewsList];
            
            dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
            dispatch_async(queue, ^{
                for (NSDictionary * dict in tempArray) {
                    [DataStoreManager saveFriendsNewsWithData:dict];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            });
        } break;
        default:
            break;
    }
   
}

#pragma mark 修改
-(void)dynamicListAddOneDynamic:(NSDictionary*)dynamic
{
//    [m_newsArray insertObject:dynamic atIndex:0];
//    [m_newsArray removeLastObject];//防止加载重复最后一条
//    
//    [m_myTableView reloadData];
    isRefresh = YES;
}

-(void)dynamicListJustReload
{
    isRefresh = YES;
}
#pragma mark - add
- (void)addButtonClick:(id)sender
{
//    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:Nil otherButtonTitles:@"发表动态", @"发表文章",nil];
//    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    [sheet showInView:self.view];
    SendNewsViewController* sendNews = [[SendNewsViewController alloc] init];
    sendNews.delegate = self;
    [self.navigationController pushViewController:sendNews animated:YES];
}

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        SendNewsViewController* sendNews = [[SendNewsViewController alloc] init];
//        sendNews.delegate = self;
//        [self.navigationController pushViewController:sendNews animated:YES];
//    }
//    else if(1 == buttonIndex)
//    {
//        SendArticleViewController* sendNews = [[SendArticleViewController alloc] init];
//        sendNews.delegate = self;
//        [self.navigationController pushViewController:sendNews animated:YES];
//    }
//}

#pragma mark - table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_newsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[m_rowHeigthArray objectAtIndex:indexPath.row] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    NewsGetTitleCell *cell = (NewsGetTitleCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NewsGetTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* tempDic = [m_newsArray objectAtIndex:indexPath.row];
    if ([KISDictionaryHaveKey(tempDic, @"destUser") isKindOfClass:[NSDictionary class]]) {//目标 别人评论了我
        NSDictionary* destDic = KISDictionaryHaveKey(tempDic, @"destUser");
        NSString* imageName = [GameCommon getHeardImgId:KISDictionaryHaveKey(destDic, @"userimg")];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:imageName]];
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        cell.headImageV.imageURL = theUrl;
        
        cell.nickNameLabel.text = [KISDictionaryHaveKey(destDic, @"userid") isEqualToString:[DataStoreManager getMyUserID]] ? @"我" :KISDictionaryHaveKey(destDic, @"nickname");
        if ([KISDictionaryHaveKey(destDic, @"userid") isEqualToString:@"10000"]) {
            cell.authImage.hidden = NO;
            cell.authImage.image = KUIImage(@"red_auth");
            cell.nickNameLabel.textColor = kColorWithRGB(255, 58, 48, 1.0);
        }
        else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(destDic, @"superstar")] isEqualToString:@"1"])//superstar
        {
            cell.authImage.hidden = NO;
            cell.authImage.image = KUIImage(@"v_auth");
            cell.nickNameLabel.textColor = kColorWithRGB(84, 178, 64, 1.0);
        }
        else
        {
            cell.authImage.hidden = YES;
            cell.authImage.image = nil;
            cell.nickNameLabel.textColor = kColorWithRGB(51, 51, 200, 1.0);
        }
    }
    else
    {
        NSString* imageName = [GameCommon getHeardImgId:KISDictionaryHaveKey(tempDic, @"userimg")];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:imageName]];
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        cell.headImageV.imageURL = theUrl;
        
        cell.nickNameLabel.text = [KISDictionaryHaveKey(tempDic, @"userid") isEqualToString:[DataStoreManager getMyUserID]] ? @"我" :KISDictionaryHaveKey(tempDic, @"nickname");
        
        if ([KISDictionaryHaveKey(tempDic, @"userid") isEqualToString:@"10000"]) {
            cell.authImage.hidden = NO;
            cell.authImage.image = KUIImage(@"red_auth");
            cell.nickNameLabel.textColor = kColorWithRGB(255, 58, 48, 1.0);
        }
        else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"superstar")] isEqualToString:@"1"])//superstar
        {
            cell.authImage.hidden = NO;
            cell.authImage.image = KUIImage(@"v_auth");
            cell.nickNameLabel.textColor = kColorWithRGB(84, 178, 64, 1.0);
        }
        else
        {
            cell.authImage.hidden = YES;
            cell.authImage.image = nil;
            cell.nickNameLabel.textColor = kColorWithRGB(51, 51, 200, 1.0);
        }
    }
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"type")] isEqualToString:@"3"]) {
        cell.commentLabel.hidden = YES;
        cell.commentBgImage.hidden = YES;
        cell.typeLabel.text = @"发表了该内容";
    }
    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"type")] isEqualToString:@"4"]) {
        cell.commentLabel.hidden = YES;
        cell.commentBgImage.hidden = YES;
        cell.typeLabel.text = KISDictionaryHaveKey(tempDic, @"showtitle");
    }
    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"type")] isEqualToString:@"5"]) {
        cell.typeLabel.text = KISDictionaryHaveKey(tempDic, @"showtitle");
        cell.commentLabel.hidden = NO;
        cell.commentBgImage.hidden = NO;
        if ([KISDictionaryHaveKey(tempDic, @"commentObj") isKindOfClass:[NSDictionary class]]) {
            cell.commentLabel.text = KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"commentObj"), @"msg");
        }
        else
            cell.commentLabel.text = @"";
    }
    NSString* tit = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"title")] isEqualToString:@""] ? KISDictionaryHaveKey(tempDic, @"msg") : KISDictionaryHaveKey(tempDic, @"title");
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"title")] isEqualToString:@""]) {
//        cell.isShowArticle = NO;
        cell.bigTitle.text = tit;
        
    }
    else
    {
//        cell.isShowArticle = YES;
        cell.bigTitle.text = [NSString stringWithFormat:@"「%@」", tit];
    }
//    cell.bigTitle.text = tit;

    cell.timeLabel.text = [self getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"createDate")]];
    cell.zanLabel.text = [self getZanLabelWithNum:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"zannum")]];
    cell.rowHeight = [[m_rowHeigthArray objectAtIndex:indexPath.row] intValue];
    cell.rowIndex = indexPath.row;
    NSString* imgStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"img")];
    if (imgStr.length > 0) {
        cell.havePic.hidden = NO;
    }
    else
        cell.havePic.hidden = YES;
    
    cell.myDelegate = self;
    
    [cell refreshCell];
    
    return cell;
}

- (NSString*)getTimeWithMessageTime:(NSString*)messageTime
{
    NSString* currentString = [GameCommon getCurrentTime];
    if (messageTime.length < 10 || currentString.length < 10) {
        return @"未知";
    }
    NSString * finalTime;
    NSString* curStr = [currentString substringToIndex:messageTime.length-3];
    NSString* mesStr = [messageTime substringToIndex:messageTime.length-3];
    
    double theCurrentT = [curStr doubleValue];
    double theMessageT = [mesStr doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    int msgHour = [[msgT substringToIndex:2] intValue];
    int msgmin = [[msgT substringFromIndex:3] intValue];
//    int msgDay = [[messageDateStr substringFromIndex:8] intValue];

    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
//    int day = [[currentStr substringFromIndex:8] intValue];
    
    double currentDayBegin = theCurrentT-hours*3600-minutes*60;
    double yesterdayBegin = currentDayBegin-3600*24;
    
    //今天
    if ([currentStr isEqualToString:messageDateStr] && msgHour == hours) {
        if (minutes-msgmin<=0) {
            finalTime = @"1分钟前";
        }
        else{
            finalTime = [NSString stringWithFormat:@"%d分钟前",(minutes-msgmin)];
        }
    }
    else if ([currentStr isEqualToString:messageDateStr]) {
        finalTime = [NSString stringWithFormat:@"%d小时前",(hours-msgHour)];
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
        finalTime = @"昨天";
    }
    else
    {
        if ((theCurrentT-theMessageT)/86400 <= 0) {
            finalTime = @"1天前";
        }
        else
            finalTime = [NSString stringWithFormat:@"%.f天前",(theCurrentT-theMessageT)/86400];
    }
    return finalTime;
}

- (NSString*)getZanLabelWithNum:(NSString*)zannum
{
    double zanDouble = [zannum doubleValue];
    double newZan = zanDouble;
    if (zanDouble > 1000) {
        newZan = zanDouble/1000;
        return [NSString stringWithFormat:@"%.fK", newZan];
    }
    return [NSString stringWithFormat:@"%.f", newZan];
}

//- (NSString*)getHeadImgWithRow:(NSInteger)row
//{
//    NSArray* arr = [[[m_newsArray objectAtIndex:row] objectForKey:@"userimg"] componentsSeparatedByString:@","];
//    if ([arr isKindOfClass:[NSArray class]]) {
//        if ([arr count] != 0) {
//            return [arr objectAtIndex:0];
//        }
//    }
//    return @"";
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* tempDict = [m_newsArray objectAtIndex:indexPath.row];
 
    OnceDynamicViewController* detailVC = [[OnceDynamicViewController alloc] init];
    detailVC.messageid = KISDictionaryHaveKey(tempDict, @"id");
    detailVC.urlLink = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"urlLink")];
    detailVC.delegate = self;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)CellHeardButtonClick:(int)rowIndex
{
    NSDictionary* tempDict = [m_newsArray objectAtIndex:rowIndex];
    if ([KISDictionaryHaveKey(tempDict, @"destUser") isKindOfClass:[NSDictionary class]]) {//目标 别人评论了我
        NSDictionary* destDic = KISDictionaryHaveKey(tempDict, @"destUser");
        if ([KISDictionaryHaveKey(destDic, @"userid") isEqualToString:[DataStoreManager getMyUserID]]) {
            MyProfileViewController * myP = [[MyProfileViewController alloc] init];
            [self.navigationController pushViewController:myP animated:YES];
        }
        else
        {
            PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
            detailV.userName = KISDictionaryHaveKey(destDic, @"username");
            detailV.nickName = KISDictionaryHaveKey(destDic, @"nickname");
            detailV.isChatPage = NO;
            [self.navigationController pushViewController:detailV animated:YES];
        }
    }
    else
    {
        if ([KISDictionaryHaveKey(tempDict, @"userid") isEqualToString:[DataStoreManager getMyUserID]]) {
            MyProfileViewController * myP = [[MyProfileViewController alloc] init];
            [self.navigationController pushViewController:myP animated:YES];
        }
        else
        {
            PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
            detailV.userName = KISDictionaryHaveKey(tempDict, @"username");
            detailV.nickName = KISDictionaryHaveKey(tempDict, @"nickname");
            detailV.isChatPage = NO;
            [self.navigationController pushViewController:detailV animated:YES];
        }
    }
}

- (void)CellOneButtonClick:(int)rowIndex
{
//    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"type")] isEqualToString:@"5"])//评论
//    {
        NSDictionary* tempDict = [m_newsArray objectAtIndex:rowIndex];

        ReplyViewController* VC = [[ReplyViewController alloc] init];
        VC.messageid = KISDictionaryHaveKey(tempDict, @"id");
        VC.isHaveArticle = YES;
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
//    }
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

    [self getNewsDataByNet];
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
//    [self performSelector:@selector(endRefresh)
//               withObject:nil
//               afterDelay:2
//                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    m_currentPage = 0;
    
    [self getNewsDataByNet];
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
