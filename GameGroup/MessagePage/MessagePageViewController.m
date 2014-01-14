//
//  MessagePageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MessagePageViewController.h"
#import "IntroduceViewController.h"
#import "SRRefreshView.h"
#import "KKChatController.h"
#import "AppDelegate.h"
#import "MessageCell.h"
#import "NotificationViewController.h"
#import "AttentionMessageViewController.h"
#import "CharacterEditViewController.h"
#import "MyTitleObjViewController.h"
#import "FriendRecommendViewController.h"

@interface MessagePageViewController ()
{
    UITableView * m_messageTable;
    
    //搜索
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
    
    UILabel*   titleLabel;

    SystemSoundID soundID;
    
    NSMutableArray * newReceivedMsgArray;//新接收的消息
    NSMutableArray * allMsgArray;
    
    NSMutableArray * pyChineseArray;
    NSArray * searchResultArray;
    
    NSMutableArray * allMsgUnreadArray;
    
    NSMutableArray * allNickNameArray;
    NSMutableArray * allHeadImgArray;
}
@end

@implementation MessagePageViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    if (![self.appDel.xmppHelper ifXMPPConnected]) {
        titleLabel.text = @"消息(未连接)";
    }
    self.appDel.xmppHelper.buddyListDelegate = self;
    self.appDel.xmppHelper.chatDelegate = self;
    self.appDel.xmppHelper.processFriendDelegate = self;
    self.appDel.xmppHelper.addReqDelegate = self;
    self.appDel.xmppHelper.commentDelegate = self;
    self.appDel.xmppHelper.deletePersonDelegate = self;
    self.appDel.xmppHelper.otherMsgReceiveDelegate = self;
    self.appDel.xmppHelper.recommendReceiveDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
//    if ([[TempData sharedInstance] needChat]) {
//        [[Custom_tabbar showTabBar] hideTabBar:YES];
//        NSDictionary * theDict = (NSDictionary *)[DataStoreManager queryOneFriendInfoWithUserName:[[TempData sharedInstance] getNeedChatUser]];
//        KKChatController * kkchat = [[KKChatController alloc] init];
//        kkchat.chatWithUser = [theDict objectForKey:@"username"];
//        kkchat.nickName = [[theDict objectForKey:@"nickname"] length]>1?[theDict objectForKey:@"nickname"]:[theDict objectForKey:@"username"];
//        kkchat.chatUserImg = [DataStoreManager queryFirstHeadImageForUser:[theDict objectForKey:@"username"]];
//        [self.navigationController pushViewController:kkchat animated:YES];
//        kkchat.msgDelegate = self;
//        [[TempData sharedInstance] setNeedChatNO];
//    }

    if (![self isHaveLogin]) {
        [[Custom_tabbar showTabBar] hideTabBar:YES];

        IntroduceViewController* vc = [[IntroduceViewController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navi animated:NO completion:^{
        }];
    }
    else
    {
        [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];//根据用户名创建数据库
        NSLog(@"getMyUserID: %@", [DataStoreManager getMyUserID]);
    
        [self.view bringSubviewToFront:hud];
        if ([GameCommon shareGameCommon].isFirst) {
                [self getFriendByHttp];
                [self sendDeviceToken];
        }
        else
        {
            if (![self.appDel.xmppHelper ifXMPPConnected]&&![titleLabel.text isEqualToString:@"消息(连接中...)"]) {
                [self getChatServer];
            }
        }
        
        [self displayMsgsForDefaultView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"" withBackButton:NO];
    
    UIButton* cleanBtn = [[UIButton alloc] initWithFrame:CGRectMake(320-55, startX-44, 50, 44)];
    [cleanBtn setTitle:@"清空" forState:UIControlStateNormal];
    [cleanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cleanBtn setBackgroundColor:[UIColor clearColor]];
    cleanBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [cleanBtn addTarget:self action:@selector(cleanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cleanBtn];
    
    allMsgArray = [NSMutableArray array];
    allMsgUnreadArray = [NSMutableArray array];
    newReceivedMsgArray = [NSMutableArray array];
    allNickNameArray = [NSMutableArray array];
    allHeadImgArray = [NSMutableArray array];
    pyChineseArray = [NSMutableArray array];
    searchResultArray = [NSArray array];
    
    m_messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - ( 50 + startX)) style:UITableViewStylePlain];
    [self.view addSubview:m_messageTable];
    m_messageTable.dataSource = self;
    m_messageTable.delegate = self;
    m_messageTable.contentOffset = CGPointMake(0, 44);
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"搜索消息";
    m_messageTable.tableHeaderView = searchBar;
    [m_messageTable addSubview:searchBar];
    searchBar.delegate = self;
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, startX - 44, 320, 44)];
    titleLabel.backgroundColor=[UIColor clearColor];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    self.appDel = [[UIApplication sharedApplication] delegate];

    
//    hud = [[MBProgressHUD alloc] initWithView:self.view];
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    hud = [[MBProgressHUD alloc] initWithWindow:window];
    [window addSubview:hud];
    hud.labelText = @"获取信息中...";
}

- (void)displayNewMessage
{
    
}

#pragma mark 清空
- (void)cleanBtnClick:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要清空消息页面吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 345;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 345) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [DataStoreManager deleteAllThumbMsg];
            [self displayMsgsForDefaultView];
        }
    }
}

#pragma mark发送token
- (void)sendDeviceToken
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSMutableDictionary* locationDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [locationDict setObject:[GameCommon shareGameCommon].deviceToken forKey:@"deviceToken"];
    [locationDict setObject:appType forKey:@"appType"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict setObject:@"140" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];

    [NetManager requestWithURLStrNoController:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"deviceToken fail");
    }];
}

#pragma mark - 根据存储初始化界面
- (void)displayMsgsForDefaultView
{
    allMsgArray = (NSMutableArray *)[DataStoreManager qureyAllThumbMessages];
    
    //暂时只有打招呼，所以insert打招呼一个...
//    [allMsgArray insertObject:[DataStoreManager qureyLastReceivedHello] atIndex:0];
    [self readAllnickNameAndImage];
    
    allMsgUnreadArray = (NSMutableArray *)[DataStoreManager queryUnreadCountForCommonMsg];
//    [allMsgUnreadArray insertObject:[DataStoreManager qureyUnreadForReceivedHellos] atIndex:0];
    //    [allMsgArray insertObject:[DataStoreManager queryLastPublicMsg] atIndex:0];
    [m_messageTable reloadData];
    [self displayTabbarNotification];
}

-(void)readAllnickNameAndImage
{
    NSMutableArray * nickName = [NSMutableArray array];
    NSMutableArray * headimg = [NSMutableArray array];
    NSMutableArray * pinyin = [NSMutableArray array];
    for (int i = 0; i<allMsgArray.count; i++) {
//        NSString * nickName2 = [DataStoreManager queryNickNameForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]];
        NSString * nickName2 = @"";
        if ([[[allMsgArray objectAtIndex:i] objectForKey:@"sender"] isEqualToString:@"1"]) {//头衔等
            nickName2 = [DataStoreManager getOtherMessageTitleWithUUID:[[allMsgArray objectAtIndex:i] objectForKey:@"messageuuid"] type:[[allMsgArray objectAtIndex:i] objectForKey:@"msgType"]];
        }
        else
            nickName2 = [DataStoreManager queryRemarkNameForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]];//别名
        [nickName addObject:nickName2?nickName2 : @""];
        NSString * pinyin2 = [[GameCommon shareGameCommon] convertChineseToPinYin:nickName2];
        [pinyin addObject:[pinyin2 stringByAppendingFormat:@"+%@",nickName2]];
        [headimg addObject:[DataStoreManager queryFirstHeadImageForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]]];
    }
    allNickNameArray = nickName;
    allHeadImgArray = headimg;
    pyChineseArray = pinyin;
    NSLog(@"hhhhhhead:%@",allHeadImgArray);
}

-(void)displayTabbarNotification
{
    int allUnread = 0;
    for (int i = 0; i<allMsgUnreadArray.count; i++) {
        allUnread = allUnread+[[allMsgUnreadArray objectAtIndex:i] intValue];
    }
    if (allUnread>0) {
        [[Custom_tabbar showTabBar] notificationWithNumber:YES AndTheNumber:allUnread OrDot:NO WithButtonIndex:0];
        if (allUnread>99) {
            [[Custom_tabbar showTabBar] notificationWithNumber:YES AndTheNumber:99 OrDot:NO WithButtonIndex:0];
        }
    }
    else
    {
        [[Custom_tabbar showTabBar] removeNotificatonOfIndex:0];
    }
    
}

#pragma mark - 搜索
-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
//    if (KISHighVersion_7) {
//        [searchBar setFrame:CGRectMake(0, 20, 320, 44)];
//        searchBar.backgroundImage = [UIImage imageNamed:@"top.png"];
//        [UIView animateWithDuration:0.3 animations:^{
//            [m_messageTable setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height- 50 - startX)];
////            m_messageTable.contentOffset = CGPointMake(0, -20);
//        } completion:^(BOOL finished) {
//
//        }];
//    }
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    if (KISHighVersion_7) {
        
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
//    if (KISHighVersion_7) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [searchBar setFrame:CGRectMake(0, 0, 320, 44)];
//            [m_messageTable setFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - 50 - startX)];
//        } completion:^(BOOL finished) {
//            searchBar.backgroundImage = nil;
//        }];
//    }
}
-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    if (KISHighVersion_7) {
//        tableView.backgroundColor = [UIColor grayColor];
        [tableView setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height - 50 - 64)];
//        [tableView setContentOffset:CGPointMake(0, 20)];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    
}
#pragma mark 数据存储
-(void)makeMsgVStoreMsg:(NSDictionary *)messageContent
{
    [self storeNewMessage:messageContent];
}

-(void)storeNewMessage:(NSDictionary *)messageContent
{
    NSString * type = KISDictionaryHaveKey(messageContent, @"msgType");
    type = type?type:@"notype";
    if ([type isEqualToString:@"reply"]||[type isEqualToString:@"zanDynamic"]) {
        [DataStoreManager storeNewMsgs:messageContent senderType:SYSTEMNOTIFICATION];//系统消息
    }
    else if([type isEqualToString:@"normalchat"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:COMMONUSER];//普通聊天消息
    }
    else if ([type isEqualToString:@"sayHello"] || [type isEqualToString:@"deletePerson"])//关注和取消关注
    {
        AudioServicesPlayAlertSound(1007);

        [DataStoreManager storeNewMsgs:messageContent senderType:SAYHELLOS];//打招呼消息
    }
    else if([type isEqualToString:@"recommendfriend"])
    {
        [DataStoreManager storeNewMsgs:messageContent senderType:RECOMMENDFRIEND];
    }
}


#pragma mark 表格

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];
    NSLog(@"%@",searchBar.text);
    
    searchResultArray = [pyChineseArray filteredArrayUsingPredicate:resultPredicate ]; //注意retain
    NSLog(@"%@",searchResultArray);
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultArray count];
    }
    else
        return allMsgArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSString * thisOne = [searchResultArray objectAtIndex:indexPath.row];
        NSInteger theIndex = [pyChineseArray indexOfObject:thisOne];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:theIndex]]];
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"sayHello"] || [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {//关注
            [cell.headImageV setImage:KUIImage(@"mess_guanzhu")];
        }
        else if([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"character"])//角色
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"] JSONValue];

            NSString* imageName = [self getCharacterHeardWithID:[GameCommon getNewStringWithId:KISDictionaryHaveKey(dict, @"gameid")]];

            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
        }
        else if([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"title"])
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"] JSONValue];
            
            NSString* imageName = [self getTitleHeardImgWithID:KISDictionaryHaveKey(dict, @"rarenum")];
            
            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");

        }
        else if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"pveScore"])
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"] JSONValue];
            
            NSString* imageName = [self getPveScoreHeardWithID:KISDictionaryHaveKey(dict, @"classid")];
            
            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
        }
        else if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"])
        {
            cell.headImageV.image = KUIImage(@"mess_tuijian");
            
            cell.contentLabel.text = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"];
        }
        else
        {
            cell.headImageV.imageURL = theUrl;
            cell.contentLabel.text = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"msg"];
        }

        if ([[allMsgUnreadArray objectAtIndex:theIndex] intValue]>0) {
            cell.unreadCountLabel.hidden = NO;
            cell.notiBgV.hidden = NO;
            if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"character"] ||
                [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"title"] ||
                [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"pveScore"] ||
                [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"] ||
                [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"sayHello"] ||
                [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {
                cell.notiBgV.image = KUIImage(@"redpot");
                cell.unreadCountLabel.hidden = YES;
            }
            else
            {
                [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:theIndex]];
                cell.notiBgV.image = KUIImage(@"redCB.png");
                if ([[allMsgUnreadArray objectAtIndex:theIndex] intValue]>99) {
                    [cell.unreadCountLabel setText:@"99"];
                }
                else
                    [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:theIndex]];
            }
        }
        else
        {
            cell.unreadCountLabel.hidden = YES;
            cell.notiBgV.hidden = YES;
        }

        cell.nameLabel.text = [allNickNameArray objectAtIndex:theIndex];
        cell.timeLabel.text = [GameCommon CurrentTime:[GameCommon getCurrentTime] AndMessageTime:[[allMsgArray objectAtIndex:theIndex] objectForKey:@"time"]];
        
    }
    else
    {
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[allHeadImgArray objectAtIndex:indexPath.row]]];
        if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"sayHello"] || [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {//关注
            [cell.headImageV setImage:KUIImage(@"mess_guanzhu")];
            cell.contentLabel.text = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"];
        }
        else if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"character"])//角色
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"] JSONValue];
            
            NSString* imageName = [self getCharacterHeardWithID:[GameCommon getNewStringWithId:KISDictionaryHaveKey(dict, @"gameid")]];
            
            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
        }
        else if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"title"])
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"] JSONValue];
            
            NSString* imageName = [self getTitleHeardImgWithID:KISDictionaryHaveKey(dict, @"rarenum")];
            
            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
        }
        else if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"pveScore"])
        {
            NSDictionary * dict = [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"] JSONValue];
            
            NSString* imageName = [self getPveScoreHeardWithID:KISDictionaryHaveKey(dict, @"classid")];
            
            cell.headImageV.image = KUIImage(imageName);
            
            cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
        }
        else if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"])
        {
            cell.headImageV.image = KUIImage(@"mess_tuijian");
            
            cell.contentLabel.text = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"];
        }
        else
        {
            cell.headImageV.imageURL = theUrl;
            cell.contentLabel.text = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msg"];
        }

        if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>0) {
            cell.unreadCountLabel.hidden = NO;
            cell.notiBgV.hidden = NO;
            if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"character"] ||
                [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"title"] ||
                [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"pveScore"] ||
                [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"] |
                [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"sayHello"] ||
                [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {
                cell.notiBgV.image = KUIImage(@"redpot");
                cell.unreadCountLabel.hidden = YES;
            }
            else
            {
                [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:indexPath.row]];
                cell.notiBgV.image = KUIImage(@"redCB.png");
                if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>99) {
                    [cell.unreadCountLabel setText:@"99"];
                }
                else
                    [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:indexPath.row]];
            }
        }
        else
        {
            cell.unreadCountLabel.hidden = YES;
            cell.notiBgV.hidden = YES;
        }
        cell.nameLabel.text = [allNickNameArray objectAtIndex:indexPath.row];
        cell.timeLabel.text = [GameCommon CurrentTime:[GameCommon getCurrentTime] AndMessageTime:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"time"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_messageTable deselectRowAtIndexPath:indexPath animated:YES];
    
    [[Custom_tabbar showTabBar] hideTabBar:YES];
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        NSString * thisOne = [searchResultArray objectAtIndex:indexPath.row];
        NSInteger theIndex = [pyChineseArray indexOfObject:thisOne];
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"sayHello"] || [[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {//关注
            AttentionMessageViewController * friq = [[AttentionMessageViewController alloc] init];
            [self.navigationController pushViewController:friq animated:YES];
            [searchDisplay setActive:NO animated:NO];
            
            [self cleanUnReadCountWithType:3 Content:@"" typeStr:@""];

            return;
        }
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"] isEqualToString:@"123456789"]) {
            NotificationViewController * notiV = [[NotificationViewController alloc] init];
            [self.navigationController pushViewController:notiV animated:YES];
            return;
        }
        if([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"character"])//角色
        {
            [[Custom_tabbar showTabBar] hideTabBar:YES];
        
            CharacterEditViewController* VC = [[CharacterEditViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [searchDisplay setActive:NO animated:NO];
            
            [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:theIndex] objectForKey:@"messageuuid"] typeStr:@"character"];
            return;
        }
        if([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"title"])
        {
            [[Custom_tabbar showTabBar] hideTabBar:YES];
            
            MyTitleObjViewController* VC = [[MyTitleObjViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [searchDisplay setActive:NO animated:NO];
            
            [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:theIndex] objectForKey:@"messageuuid"] typeStr:@"title"];

            return;
        }
        if ([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"pveScore"])
        {
            [searchDisplay setActive:NO animated:NO];
            [[Custom_tabbar showTabBar] when_tabbar_is_selected:3];
            
            [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:theIndex] objectForKey:@"messageuuid"] typeStr:@"pveScore"];

            return;
        }
        if([[[allMsgArray objectAtIndex:theIndex] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"])
        {
            [[Custom_tabbar showTabBar] hideTabBar:YES];
            
            FriendRecommendViewController* VC = [[FriendRecommendViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
            [searchDisplay setActive:NO animated:NO];
            
            [self cleanUnReadCountWithType:2 Content:@"" typeStr:@""];

            return;
        }
        KKChatController * kkchat = [[KKChatController alloc] init];
        kkchat.chatWithUser = [[allMsgArray objectAtIndex:theIndex] objectForKey:@"sender"];
        kkchat.nickName = [allNickNameArray objectAtIndex:theIndex];
        kkchat.chatUserImg = [allHeadImgArray objectAtIndex:theIndex];
        [self.navigationController pushViewController:kkchat animated:YES];
        kkchat.msgDelegate = self;
        [searchDisplay setActive:NO animated:NO];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"sayHello"] || [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {//关注
        AttentionMessageViewController * friq = [[AttentionMessageViewController alloc] init];
        [self.navigationController pushViewController:friq animated:YES];
        [searchDisplay setActive:NO animated:NO];
        
        [self cleanUnReadCountWithType:3 Content:@"" typeStr:@""];

        return;
    }
    if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"] isEqualToString:@"123456789"]) {//系统消息
        NotificationViewController * notiV = [[NotificationViewController alloc] init];
        [self.navigationController pushViewController:notiV animated:YES];
        [searchDisplay setActive:NO animated:NO];
        return;
    }
    if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"character"])//角色
    {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        
        CharacterEditViewController* VC = [[CharacterEditViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        [searchDisplay setActive:NO animated:NO];
        
        [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"messageuuid"] typeStr:@"character"];

        return;
    }
    if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"title"])
    {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        
        MyTitleObjViewController* VC = [[MyTitleObjViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        [searchDisplay setActive:NO animated:NO];
        
        [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"messageuuid"] typeStr:@"title"];

        return;
    }
    if ([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"pveScore"])
    {
        [[Custom_tabbar showTabBar] when_tabbar_is_selected:3];
        [searchDisplay setActive:NO animated:NO];
        
        [self cleanUnReadCountWithType:1 Content:[[allMsgArray objectAtIndex:indexPath.row]  objectForKey:@"messageuuid"] typeStr:@"pveScore"];

        return;
    }
    if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"])//好又推荐
    {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        
        FriendRecommendViewController* VC = [[FriendRecommendViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        [searchDisplay setActive:NO animated:NO];
        
        [self cleanUnReadCountWithType:2 Content:@"" typeStr:@""];

        return;
    }
    KKChatController * kkchat = [[KKChatController alloc] init];
    kkchat.chatWithUser = [[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"];
    kkchat.nickName = [allNickNameArray objectAtIndex:indexPath.row];
    kkchat.chatUserImg = [allHeadImgArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:kkchat animated:YES];
    kkchat.msgDelegate = self;
    [searchDisplay setActive:NO animated:NO];
}

- (void)cleanUnReadCountWithType:(NSInteger)type Content:(NSString*)pre typeStr:(NSString*)typeStr
{
    if (1 == type) {//头衔、角色、战斗力
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"messageuuid==[c]%@ AND msgType==[c]%@",pre, typeStr];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            thumbMsgs.unRead = @"0";
        }];//清数字
    }
    else if (2 == type)//推荐的人
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"12345"];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            thumbMsgs.unRead = @"0";
        }];//清数字
    }
    else if (3 == type)//关注
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"1234"];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            thumbMsgs.unRead = @"0";
        }];//清数字
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row==0) {
//        return NO;
//    }
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        if([[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"character"] || [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"title"] || [[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"pveScore"])//角色
        {
            [DataStoreManager deleteThumbMsgWithUUID:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"messageuuid"]];
        }
        else
            [DataStoreManager deleteThumbMsgWithSender:[[allMsgArray objectAtIndex:indexPath.row] objectForKey:@"sender"]];
        [allMsgArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self displayMsgsForDefaultView];
    }
}

#pragma mark 获取角色等头像
- (NSString*)getCharacterHeardWithID:(NSString*)gameId
{
    if ([gameId isEqualToString:@"1"]) {
        return @"wow";
    }
    return @"";
}

- (NSString*)getPveScoreHeardWithID:(NSString*)characterId
{
    NSInteger imageId = [characterId integerValue];
    if (imageId > 0 && imageId < 12) {//1~11
        return [NSString stringWithFormat:@"clazz_%d", imageId];
    }
    else
        return @"clazz_0.png";
}

- (NSString*)getTitleHeardImgWithID:(NSString*)titleId
{
    NSInteger imageId = [titleId integerValue];
    
    NSString* rarenum = [NSString stringWithFormat:@"rarenum_%d", imageId];
    
    return rarenum;
}

#pragma mark NotConnectDelegate
-(void)notConnectted
{
    [titleLabel setText:@"消息(未连接)"];
     NSLog(@"未连接上服务器");
    if (![GameCommon testConnection])
    {
        [self showAlertViewWithTitle:@"提示" message:@"未检测到网络" buttonTitle:@"确定"];
        return;
    }
    if ([self isHaveLogin] && [GameCommon testConnection] && ![GameCommon shareGameCommon].isFirst) {
        if ([GameCommon shareGameCommon].connectTimes > 3) {
            return;
        }
        [self logInToChatServer];
    }
}

#pragma mark 登陆xmpp
- (void)getChatServer//自动登陆情况下获得服务器
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict setObject:@"116" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//    [postDict setObject:locationDict forKey:@"params"];
    if([GameCommon shareGameCommon].isFirst)
        [hud show:YES];

    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"服务器数据 %@", responseObject);
        [hud hide:YES];
        
        [[TempData sharedInstance] SetServer:KISDictionaryHaveKey(responseObject, @"address") TheDomain:KISDictionaryHaveKey(responseObject, @"name")];//得到域名
        [self logInToChatServer];
        [self getMyUserInfoFromNet];//获得“我”信息

    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide:YES];
    }];

}

-(void)logInToChatServer
{
//    [hud show:YES];
    self.appDel.xmppHelper.notConnect = self;
    self.appDel.xmppHelper.xmpptype = login;
    [self.appDel.xmppHelper connect:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]stringByAppendingFormat:@"%@",[[TempData sharedInstance] getDomain]] password:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] host:[[TempData sharedInstance] getServer] success:^(void){
        NSLog(@"登陆成功xmpp");
        [hud hide:YES];
        titleLabel.text = @"消息";
        
        [[TempData sharedInstance] setOpened:YES];
        [GameCommon shareGameCommon].connectTimes = 0;//断掉自动连接3次
    }fail:^(NSError *result){
        NSLog(@" localizedDescription %@", result.localizedDescription);
        titleLabel.text = @"消息(未连接)";
        [hud hide:YES];
    }];
}


- (void)getMyUserInfoFromNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [DataStoreManager saveUserInfo:KISDictionaryHaveKey(responseObject, @"user")];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {

    }];

}

#pragma mark 收到聊天消息或其他消息
-(void)newMessageReceived:(NSDictionary *)messageContent
{
    NSRange range = [[messageContent objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[messageContent objectForKey:@"sender"] substringToIndex:range.location];
    if (![DataStoreManager ifHaveThisUser:sender]) {//是否为联系人 不是就请求资料
        [self requestPeopleInfoWithName:sender ForType:1 Msg:nil];
    }
    
    [self storeNewMessage:messageContent];
    [self displayMsgsForDefaultView];
}

#pragma mark - 获得好友、关注、粉丝列表
-(void)getFriendByHttp
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
//    [paramDict setObject:@"1" forKey:@"shiptype"];// 1：好友   2：关注  3：粉丝
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:sorttype_1]) {
        [paramDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:sorttype_1] forKey:@"sorttype_1"];
    }
    else
    {
        [paramDict setObject:@"1" forKey:@"sorttype_1"];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:sorttype_2]) {
        [paramDict setObject:[[NSUserDefaults standardUserDefaults] objectForKey:sorttype_2] forKey:@"sorttype_2"];
    }
    else
    {
        [paramDict setObject:@"1" forKey:@"sorttype_2"];
    }
    [paramDict setObject:@"2" forKey:@"sorttype_3"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"111" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
       
        [self parseFriendsList:KISDictionaryHaveKey(responseObject, @"1")];
        [self parseAttentionList:KISDictionaryHaveKey(responseObject, @"2")];
    
        [self parseFansList:(KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"3"), @"users"))];
        [GameCommon shareGameCommon].fansCount = [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"3"), @"totalResults")];
        [self getChatServer];//登陆xmpp
        
        [GameCommon shareGameCommon].isFirst = NO;//不再请求好友列表

    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide:YES];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)parseAttentionList:(id)attentionList
{
    [DataStoreManager cleanAttentionList];

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
        else if([attentionList isKindOfClass:[NSArray class]])
        {
            for (NSDictionary * dict in attentionList) {
                [DataStoreManager saveUserAttentionInfo:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)parseFansList:(id)fansList
{
    [DataStoreManager cleanFansList];

    dispatch_queue_t queue = dispatch_queue_create("com.living.game", NULL);
    dispatch_async(queue, ^{
        if ([fansList isKindOfClass:[NSDictionary class]]) {
            NSArray* keyArr = [fansList allKeys];
            for (NSString* key in keyArr) {
                for (NSMutableDictionary * dict in [fansList objectForKey:key]) {
                    [DataStoreManager saveUserFansInfo:dict];
                }
            }
        }
        else if ([fansList isKindOfClass:[NSArray class]]) {
            for (NSDictionary * dict in fansList) {
                [DataStoreManager saveUserFansInfo:dict];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

#pragma mark - 其他消息 头衔、角色等
-(void)otherMessageReceived:(NSDictionary *)info
{
    AudioServicesPlayAlertSound(1007);
    
    [DataStoreManager storeNewMsgs:info senderType:OTHERMESSAGE];//其他消息
    
    [self displayMsgsForDefaultView];
}


#pragma mark - 好友状态更改(比如昵称啥修改了,收到消息)
-(void)processFriend:(XMPPPresence *)processFriend{
//    NSString *username=[[processFriend from] user];
    NSLog(@"好友状态更改lalalala");
//    [self requestPeopleInfoWithName:username ForType:1 Msg:nil];
}

#pragma mark 收到验证好友请求
-(void)newAddReq:(NSDictionary *)userInfo
{
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
    
    [self storeNewMessage:userInfo];
    
    [self requestPeopleInfoWithName:fromUser ForType:0 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
}

#pragma mark 收到取消关注 删除好友请求
-(void)deletePersonReceived:(NSDictionary *)userInfo
{
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
    
    [DataStoreManager deleteThumbMsgWithSender:fromUser];
    
    [self storeNewMessage:userInfo];

    [self requestPeopleInfoWithName:fromUser ForType:2 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
}

#pragma mark 收到推荐好友
-(void)recommendFriendReceived:(NSDictionary *)info
{
    [DataStoreManager storeNewMsgs:info senderType:RECOMMENDFRIEND];//其他消息
    NSArray* recommendArr = [KISDictionaryHaveKey(info, @"msg") JSONValue];
    
    for (NSDictionary* tempDic in recommendArr) {
        [DataStoreManager saveRecommendWithData:tempDic];
    }
    [self displayMsgsForDefaultView];
}

-(void)requestPeopleInfoWithName:(NSString *)userName ForType:(int)type Msg:(NSString *)msg
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * recDict = KISDictionaryHaveKey(responseObject, @"user");
        if (type==0) {//打招呼的 存到粉丝列表里
            
            [DataStoreManager saveUserFansInfo:recDict];
            
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
            
            [self displayMsgsForDefaultView];
        }
        else if (type==1){//聊天消息
            if ([DataStoreManager ifIsAttentionWithUserName:userName]) {
                [DataStoreManager deleteAttentionWithUserName:userName];//从关注表删除
                [DataStoreManager saveUserInfo:recDict];//存为好友
            }
            else
                [DataStoreManager saveUserFansInfo:recDict];//存为粉丝

//            [DataStoreManager saveUserInfo:recDict];//存为好友
            [self displayMsgsForDefaultView];
        }
        else if (type == 2)//取消关注 删除
        {
            if ([DataStoreManager ifHaveThisFriend:userName]) {//移到关注表
                [DataStoreManager deleteFriendWithUserName:userName];
                [DataStoreManager saveUserAttentionInfo:recDict];
            }
            if ([DataStoreManager ifIsFansWithUserName:userName]) {//从粉丝表移出
                [DataStoreManager deleteFansWithUserName:userName];
            }
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
            
            [self displayMsgsForDefaultView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
