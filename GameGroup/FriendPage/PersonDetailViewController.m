//
//  PersonDetailViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-13.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "PhotoViewController.h"
#import "AppDelegate.h"
#import "SetRemarkNameViewController.h"
#import "KKChatController.h"
#import "TitleObjDetailViewController.h"
#import "NewsViewController.h"
#import "AppDelegate.h"

@interface PersonDetailViewController ()
{
    UILabel*        m_titleLabel;
    HGPhotoWall*    m_photoWall;
    
    UIScrollView*    m_myScrollView;
    
    float           m_currentStartY;
    
    UILabel*        m_relationLabel;//关系
    
    AppDelegate*    m_delegate;
    
    UIView*         m_buttonBgView;
}
@end

@implementation PersonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    m_titleLabel.text = [DataStoreManager queryRemarkNameForUser:self.userName];//别名或昵称
    if ([m_titleLabel.text isEqualToString:@""]) {//不是好友或关注
        m_titleLabel.text = self.nickName;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, startX - 44, 220, 44)];
    m_titleLabel.textColor = [UIColor whiteColor];
    m_titleLabel.backgroundColor = [UIColor clearColor];
    m_titleLabel.text = self.nickName;
    m_titleLabel.textAlignment = NSTextAlignmentCenter;
    m_titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:m_titleLabel];
    
    m_delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    m_currentStartY = 0;
    
    m_myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX - (KISHighVersion_7?0:20))];
    [self.view addSubview:m_myScrollView];
    m_myScrollView.backgroundColor = [UIColor clearColor];
    
    if (self.hostInfo) {//有值 查找用户
        [self buildMainView];
        [self setBottomView];
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"请求中...";
    }
    else//没有详情 请求
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"请求中...";

        [self getUserInfoByNet];
    }
    
}

- (void)getUserInfoByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.userName forKey:@"username"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);

        self.hostInfo = [[HostInfo alloc] initWithHostInfo:responseObject];
        
        m_titleLabel.text = [[GameCommon getNewStringWithId:self.hostInfo.alias] isEqualToString:@""] ? self.hostInfo.nickName : self.hostInfo.alias;

        if ([self.hostInfo.relation isEqualToString:@"1"]) {
            self.viewType = VIEW_TYPE_FriendPage;
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserInfo:dic];
            }
            else
                [DataStoreManager saveUserInfo:self.hostInfo.infoDic];
        }
        else if([self.hostInfo.relation isEqualToString:@"2"]) {
            self.viewType = VIEW_TYPE_AttentionPage;
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserAttentionInfo:dic];
            }
            else
                [DataStoreManager saveUserAttentionInfo:self.hostInfo.infoDic];
        }
        else if([self.hostInfo.relation isEqualToString:@"3"]) {
            self.viewType = VIEW_TYPE_FansPage;
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserFansInfo:dic];
            }
            else
                [DataStoreManager saveUserFansInfo:self.hostInfo.infoDic];
        }
        else  {
            self.viewType = VIEW_TYPE_STRANGER;
        }
        [self buildMainView];
        [self setBottomView];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

#pragma mark -创建界面
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    return temp;
}

- (void)buildMainView
{
    m_photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    m_photoWall.descriptionType = DescriptionTypeImage;
    [m_photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
    m_photoWall.delegate = self;
    [m_myScrollView addSubview:m_photoWall];
    m_photoWall.backgroundColor = kColorWithRGB(105, 105, 105, 1.0);
    m_currentStartY += m_photoWall.frame.size.height;
    
    UIView* genderView = [CommonControlOrView setGenderAndAgeViewWithFrame:CGRectMake(10, m_currentStartY, kScreenWidth, 30) gender:self.hostInfo.gender age:self.hostInfo.age star:self.hostInfo.starSign gameId:@"1"];
    [m_myScrollView addSubview:genderView];
    
    UILabel* timeLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(150, m_currentStartY, 160, 30) textColor:kColorWithRGB(151, 151, 151, 1.0) font:[UIFont systemFontOfSize:12.0] text:[GameCommon getTimeAndDistWithTime:self.hostInfo.updateTime Dis:self.hostInfo.distrance] textAlignment:NSTextAlignmentRight];
    [m_myScrollView addSubview:timeLabel];
    
    m_currentStartY += 30;
    [self setOneLineWithY:m_currentStartY];
    
    //////个人动态
    [self setUserInfoView];
    [self setRoleView];
    [self setAchievementView];
    [self setOtherView];
    
    m_myScrollView.contentSize = CGSizeMake(kScreenWidth, m_currentStartY);
}

- (void)setUserInfoView
{
    float currentHeigth = 0;
    if ([self.hostInfo.state isKindOfClass:[NSDictionary class]] && [[self.hostInfo.state allKeys] count] != 0) {
        
        UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 30)];
        topBg.image = KUIImage(@"table_heard_bg");
        [m_myScrollView addSubview:topBg];
        
        UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"个人动态" textAlignment:NSTextAlignmentLeft];
        [topBg addSubview:titleLabel];
        
        m_currentStartY += 30;

        NSString* showTitle = @"";
        NSString* imageId = @"";
        if ([KISDictionaryHaveKey(self.hostInfo.state, @"destUser") isKindOfClass:[NSDictionary class]])
        {//目标 别人评论了我
            NSDictionary* destDic = KISDictionaryHaveKey(self.hostInfo.state, @"destUser");
            imageId = [GameCommon getHeardImgId: KISDictionaryHaveKey(destDic, @"userimg")];
            showTitle = [NSString stringWithFormat:@"%@%@",[[GameCommon getNewStringWithId:KISDictionaryHaveKey(destDic, @"alias")] isEqualToString:@""] ? KISDictionaryHaveKey(destDic, @"nickname") : KISDictionaryHaveKey(destDic, @"alias") , KISDictionaryHaveKey(self.hostInfo.state, @"showtitle")];
        }
        else
        {
            if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"type")] isEqualToString:@"3"]) {
                showTitle = [KISDictionaryHaveKey(self.hostInfo.state, @"nickname") stringByAppendingString:@"发表了该内容"];
            }
            else
                showTitle = [KISDictionaryHaveKey(self.hostInfo.state, @"nickname") stringByAppendingString:KISDictionaryHaveKey(self.hostInfo.state, @"showtitle")];
            imageId = [GameCommon getHeardImgId: KISDictionaryHaveKey(self.hostInfo.state, @"userimg")];
        }
      
        NSString* tit = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"title")] isEqualToString:@""] ? KISDictionaryHaveKey(self.hostInfo.state, @"msg") : KISDictionaryHaveKey(self.hostInfo.state, @"title");
        if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"title")] isEqualToString:@""]) {
            tit = [NSString stringWithFormat:@"「%@」", tit];
        }
        UIView* person_state = [CommonControlOrView setPersonStateViewTime:[GameCommon getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"createDate")]] nameText:showTitle achievement:tit achievementLevel:@"1" imgUrl:[BaseImageUrl stringByAppendingString:imageId]];
        currentHeigth = person_state.frame.size.height;
        person_state.frame = CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth);
        [m_myScrollView addSubview:person_state];
        
        UIButton* titleSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth)];
        titleSelect.backgroundColor = [UIColor clearColor];
        [titleSelect addTarget:self action:@selector(stateSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [m_myScrollView addSubview:titleSelect];

        m_currentStartY += currentHeigth;
        [self setOneLineWithY:m_currentStartY];
    }
/////////////////
    UIButton* zanBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, m_currentStartY + 10, 75, 30)];
    [zanBtn setImage:KUIImage(@"detail_zan") forState:UIControlStateNormal];
    zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
    [zanBtn addTarget:self action:@selector(ZanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_myScrollView addSubview:zanBtn];
    
    UILabel* zanLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(42, m_currentStartY + 10, 45, 30) textColor:kColorWithRGB(151, 151, 151, 1.0) font:[UIFont systemFontOfSize:12.0] text:self.hostInfo.zanNum textAlignment:NSTextAlignmentLeft];
    [m_myScrollView addSubview:zanLabel];
    
    UIButton* fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(85, m_currentStartY + 10, 75, 30)];
    [fansBtn setImage:KUIImage(@"detail_fans") forState:UIControlStateNormal];
    fansBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
//    [fansBtn setTitle:self.hostInfo.fanNum forState:UIControlStateNormal];
    [fansBtn addTarget:self action:@selector(FansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_myScrollView addSubview:fansBtn];
    
    UILabel* fansLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(117, m_currentStartY + 10, 45, 30) textColor:kColorWithRGB(151, 151, 151, 1.0) font:[UIFont systemFontOfSize:12.0] text:self.hostInfo.fanNum textAlignment:NSTextAlignmentLeft];
    [m_myScrollView addSubview:fansLabel];
    
    m_buttonBgView = [[UIView alloc] initWithFrame:CGRectMake(165, m_currentStartY, kScreenWidth-165, 50)];
    m_buttonBgView.backgroundColor = [UIColor clearColor];
    [m_myScrollView addSubview:m_buttonBgView];

    m_currentStartY += 50;
////////////////////////
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 30)];
    topBg.image = KUIImage(@"table_heard_bg");
    [m_myScrollView addSubview:topBg];
    
    UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"个人资料" textAlignment:NSTextAlignmentLeft];
    [topBg addSubview:titleLabel];
    
    m_currentStartY += 30;
   
    if ([self.hostInfo.superstar isEqualToString:@"1"]) {//明星用户
        UIView* person_auth = [CommonControlOrView setTwoLabelViewNameText:@"       认证" text:self.hostInfo.superremark nameTextColor:kColorWithRGB(102, 102, 102, 1.0) textColor:kColorWithRGB(51, 51, 51, 1.0)];
        currentHeigth = person_auth.frame.size.height;
        person_auth.frame = CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth);
        [m_myScrollView addSubview:person_auth];
        
        UIImageView* vAuthImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, m_currentStartY+10, 20, 20)];
        vAuthImg.image = KUIImage(@"v_auth");
        [m_myScrollView addSubview:vAuthImg];
        
        m_currentStartY += currentHeigth;
        [self setOneLineWithY:m_currentStartY];
    }
    
    UIView* person_id = [CommonControlOrView setTwoLabelViewNameText:@"小伙伴ID" text:self.hostInfo.userId nameTextColor:kColorWithRGB(102, 102, 102, 1.0) textColor:kColorWithRGB(51, 51, 51, 1.0)];
    currentHeigth = person_id.frame.size.height;
    person_id.frame = CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth);
    [m_myScrollView addSubview:person_id];

    m_currentStartY += currentHeigth;
    [self setOneLineWithY:m_currentStartY];

    UIView* person_dis = [CommonControlOrView setTwoLabelViewNameText:@"个人标签" text:([self.hostInfo.hobby isEqualToString:@""] ? @"暂无标签" : self.hostInfo.hobby) nameTextColor:kColorWithRGB(102, 102, 102, 1.0) textColor:kColorWithRGB(51, 51, 51, 1.0)];
    currentHeigth = person_dis.frame.size.height;
    person_dis.frame = CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth);
    [m_myScrollView addSubview:person_dis];

    m_currentStartY += currentHeigth;
    [self setOneLineWithY:m_currentStartY];
    
    UIView* person_signature = [CommonControlOrView setTwoLabelViewNameText:@"个性签名" text:([self.hostInfo.signature isEqualToString:@""] ? @"暂无签名" : self.hostInfo.signature) nameTextColor:kColorWithRGB(102, 102, 102, 1.0) textColor:kColorWithRGB(51, 51, 51, 1.0)];
    currentHeigth = person_signature.frame.size.height;
    person_signature.frame = CGRectMake(0, m_currentStartY, kScreenWidth, currentHeigth);
    [m_myScrollView addSubview:person_signature];
    
    m_currentStartY += currentHeigth;
    [self setOneLineWithY:m_currentStartY];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, m_currentStartY, 100, 37)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
    nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
    nameLabel.text = @"关系";
    [m_myScrollView addSubview:nameLabel];
    
    m_relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, m_currentStartY, 100, 37)];
    m_relationLabel.backgroundColor = [UIColor clearColor];
    m_relationLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
    m_relationLabel.font = [UIFont boldSystemFontOfSize:14.0];
    switch (self.viewType) {
        case VIEW_TYPE_FriendPage:
            m_relationLabel.text = @"好友";
            break;
        case VIEW_TYPE_AttentionPage:
            m_relationLabel.text = @"关注";
            break;
        case VIEW_TYPE_FansPage:
            m_relationLabel.text = @"粉丝";
            break;
        case VIEW_TYPE_STRANGER:
            m_relationLabel.text = @"陌生人";
            break;
        default:
            break;
    }
    [m_myScrollView addSubview:m_relationLabel];
    
    m_currentStartY += 37;
    [self setOneLineWithY:m_currentStartY];
}

- (void)ZanButtonClick:(id)sender
{
    [self showAlertViewWithTitle:@"" message:[NSString stringWithFormat:@"获得赞的数量：%@", self.hostInfo.zanNum] buttonTitle:@"确定"];
}

- (void)FansButtonClick:(id)sender
{
    [self showAlertViewWithTitle:@"" message:[NSString stringWithFormat:@"拥有粉丝数量：%@", self.hostInfo.fanNum] buttonTitle:@"确定"];
}

- (void)stateSelectClick:(id)sender
{
    [[Custom_tabbar showTabBar] hideTabBar:YES];
   
    NewsViewController* VC = [[NewsViewController alloc] init];
    VC.userId = self.hostInfo.userId;
    VC.myViewType = ONEPERSON_NEWS_TYPE;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)setRoleView
{
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 30)];
    topBg.image = KUIImage(@"table_heard_bg");
    [m_myScrollView addSubview:topBg];
    
    UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"我的角色" textAlignment:NSTextAlignmentLeft];
    [topBg addSubview:titleLabel];
    
    m_currentStartY += 30;
    
    NSArray* charactersArr = KISDictionaryHaveKey(self.hostInfo.characters, @"1");
    if (![charactersArr isKindOfClass:[NSArray class]]) {
        return;
    }
    for (int i = 0; i < [charactersArr count]; i++) {
        NSDictionary* characterDic = [charactersArr objectAtIndex:i];
        NSString* realm = [KISDictionaryHaveKey(characterDic, @"raceObj") isKindOfClass:[NSDictionary class]] ? KISDictionaryHaveKey(KISDictionaryHaveKey(characterDic, @"raceObj"), @"sidename") : @"";
        if ([KISDictionaryHaveKey(characterDic, @"failedmsg") isEqualToString:@"404"])//角色不存在
        {
            UIView* myCharacter = [CommonControlOrView setCharactersViewWithName:KISDictionaryHaveKey(characterDic, @"name") gameId:@"1" realm:@"角色不存在" pveScore:[NSString stringWithFormat:@"%@",KISDictionaryHaveKey(characterDic, @"pveScore")] img:@"0" auth:[GameCommon getNewStringWithId:KISDictionaryHaveKey(characterDic, @"auth")]];
            myCharacter.frame = CGRectMake(0, m_currentStartY, kScreenWidth, 60);
            [m_myScrollView addSubview:myCharacter];
        }
        else
        {
            UIView* myCharacter = [CommonControlOrView setCharactersViewWithName:KISDictionaryHaveKey(characterDic, @"name") gameId:@"1" realm:[KISDictionaryHaveKey(characterDic, @"realm") stringByAppendingString:realm] pveScore:[NSString stringWithFormat:@"%@",KISDictionaryHaveKey(characterDic, @"pveScore")] img:KISDictionaryHaveKey(characterDic, @"clazz") auth:[GameCommon getNewStringWithId:KISDictionaryHaveKey(characterDic, @"auth")]];
            myCharacter.frame = CGRectMake(0, m_currentStartY, kScreenWidth, 60);
            [m_myScrollView addSubview:myCharacter];
        }
        m_currentStartY += 60;
        [self setOneLineWithY:m_currentStartY];
    }
}

- (void)setAchievementView
{
    if ([self.hostInfo.achievementArray isKindOfClass:[NSArray class]] && [self.hostInfo.achievementArray count] != 0) {
        UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 30)];
        topBg.image = KUIImage(@"table_heard_bg");
        [m_myScrollView addSubview:topBg];
        
        UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"我的头衔" textAlignment:NSTextAlignmentLeft];
        [topBg addSubview:titleLabel];
        
        m_currentStartY += 30;
        
        for (int i = 0; i < [self.hostInfo.achievementArray count]; i++) {
            NSDictionary* smallTitleDic = KISDictionaryHaveKey([self.hostInfo.achievementArray objectAtIndex:i], @"titleObj");

            NSString* rarenum = [NSString stringWithFormat:@"rarenum_small_%@", [GameCommon getNewStringWithId:KISDictionaryHaveKey(smallTitleDic , @"rarenum")]];
            
            UIView* titleObjView = [CommonControlOrView setMyTitleObjWithImage:rarenum titleName:KISDictionaryHaveKey(smallTitleDic, @"title") rarenum:KISDictionaryHaveKey(smallTitleDic, @"rarenum") showCurrent:i == 0 ? NO : YES];
            titleObjView.frame = CGRectMake(0, m_currentStartY, kScreenWidth, 40);
            [m_myScrollView addSubview:titleObjView];
            
            UIButton* titleSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 40)];
            titleSelect.backgroundColor = [UIColor clearColor];
            [titleSelect addTarget:self action:@selector(titleObjSelectClick:) forControlEvents:UIControlEventTouchUpInside];
            titleSelect.tag = i;
            [m_myScrollView addSubview:titleSelect];
            
            m_currentStartY += 40;
            
            [self setOneLineWithY:m_currentStartY];
        }
    }
}

- (void)titleObjSelectClick:(UIButton*)selectBut
{
    TitleObjDetailViewController* detailVC = [[TitleObjDetailViewController alloc] init];
    detailVC.titleObjArray = [NSArray arrayWithObject:[self.hostInfo.achievementArray objectAtIndex:selectBut.tag]];
    detailVC.showIndex = 0;
    detailVC.isFriendTitle = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)setOtherView
{
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, m_currentStartY, kScreenWidth, 30)];
    topBg.image = KUIImage(@"table_heard_bg");
    [m_myScrollView addSubview:topBg];
    
    UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"其他" textAlignment:NSTextAlignmentLeft];
    [topBg addSubview:titleLabel];
    
    m_currentStartY += 30;

    UIImageView *timeImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, m_currentStartY + 5, 35, 35)];
    timeImg.image = KUIImage(@"time");
    [m_myScrollView addSubview:timeImg];
    
    UILabel* timeTitleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(55, m_currentStartY + 5, 100, 35) textColor:kColorWithRGB(51, 51, 51, 1.0) font:[UIFont boldSystemFontOfSize:15.0] text:@"注册时间" textAlignment:NSTextAlignmentLeft];
    [m_myScrollView addSubview:timeTitleLabel];
    
    NSString* timeStr = [[GameCommon shareGameCommon] getDataWithTimeInterval:self.hostInfo.createTime];
    
    UILabel* timeLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(160, m_currentStartY + 5, 150, 35) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:15.0] text:timeStr textAlignment:NSTextAlignmentRight];
    [m_myScrollView addSubview:timeLabel];
    
    m_currentStartY += 45;
}

- (void)setOneLineWithY:(float)frameY
{
    UIImageView* lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, frameY, kScreenWidth, 2)];
    lineImg.image = KUIImage(@"line");
    lineImg.backgroundColor = [UIColor clearColor];
    [m_myScrollView addSubview:lineImg];
}

#pragma mark -按钮布局
- (void)setBottomView
{
//    UIImageView* image_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - 50 -(KISHighVersion_7 ? 0 : 20), kScreenWidth, 50)];
//    image_bottom.image = KUIImage(@"inputbg");
//    [self.view addSubview:image_bottom];
    
    switch (self.viewType) {
        case VIEW_TYPE_FriendPage:
        {
            UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
            editButton.frame=CGRectMake(270, startX - 44, 50, 44);
            [editButton setBackgroundImage:KUIImage(@"edit_normal") forState:UIControlStateNormal];
            [editButton setBackgroundImage:KUIImage(@"edit_click") forState:UIControlStateHighlighted];
            [self.view addSubview:editButton];
            [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton* button_left = [CommonControlOrView
                                     setButtonWithFrame:CGRectMake(65, 10, 80, 30)//120
                                     title:@"删除好友"
                                     fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                     bgImage:KUIImage(@"blue_small_3_normal")
                                     HighImage:KUIImage(@"blue_small_3_click")
                                     selectImage:Nil];
            [button_left addTarget:self action:@selector(deleteFriend:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_left];
            
            UIButton* button_right = [CommonControlOrView
                                     setButtonWithFrame:CGRectMake(10, 10, 40, 30)//120
                                     title:@""
                                     fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                     bgImage:KUIImage(@"chat_normal")
                                     HighImage:KUIImage(@"chat_click")
                                     selectImage:Nil];
            [button_right addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_right];
        }break;
        case VIEW_TYPE_AttentionPage:
        {
            UIButton *editButton=[UIButton buttonWithType:UIButtonTypeCustom];
            editButton.frame=CGRectMake(270, startX - 44, 50, 44);
            [editButton setBackgroundImage:KUIImage(@"edit_normal") forState:UIControlStateNormal];
            [editButton setBackgroundImage:KUIImage(@"edit_click") forState:UIControlStateHighlighted];
            [self.view addSubview:editButton];
            [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton* button_left = [CommonControlOrView
                                     setButtonWithFrame:CGRectMake(65, 10, 80, 30)//120
                                     title:@"取消关注"
                                     fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                     bgImage:KUIImage(@"blue_small_3_normal")
                                     HighImage:KUIImage(@"blue_small_3_click")
                                     selectImage:Nil];
            [button_left addTarget:self action:@selector(cancelAttentionClick:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_left];
            
            UIButton* button_right = [CommonControlOrView
                                      setButtonWithFrame:CGRectMake(10, 10, 40, 30)//120
                                      title:@""
                                      fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                      bgImage:KUIImage(@"chat_normal")
                                      HighImage:KUIImage(@"chat_click")
                                      selectImage:Nil];
            [button_right addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_right];
        }  break;
        case VIEW_TYPE_FansPage:
        {
            UIButton* button_left = [CommonControlOrView
                                     setButtonWithFrame:CGRectMake(65, 10, 80, 30)//120
                                     title:@"添加好友"
                                     fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                     bgImage:KUIImage(@"blue_small_3_normal")
                                     HighImage:KUIImage(@"blue_small_3_click")
                                     selectImage:Nil];
            [button_left addTarget:self action:@selector(addFriendClick:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_left];
            
            UIButton* button_right = [CommonControlOrView
                                      setButtonWithFrame:CGRectMake(10, 10, 40, 30)//120
                                      title:@""
                                      fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                      bgImage:KUIImage(@"chat_normal")
                                      HighImage:KUIImage(@"chat_click")
                                      selectImage:Nil];
            [button_right addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_right];
        }break;
        case VIEW_TYPE_STRANGER:
        {
            UIButton* button_left = [CommonControlOrView
                                     setButtonWithFrame:CGRectMake(65, 10, 80, 30)//120
                                     title:@"添加关注"
                                     fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                     bgImage:KUIImage(@"blue_small_3_normal")
                                     HighImage:KUIImage(@"blue_small_3_click")
                                     selectImage:Nil];
            [button_left addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_left];
            
            UIButton* button_right = [CommonControlOrView
                                      setButtonWithFrame:CGRectMake(10, 10, 40, 30)//120
                                      title:@""
                                      fontSize:[UIFont boldSystemFontOfSize:15.0] textColor:[UIColor whiteColor]
                                      bgImage:KUIImage(@"chat_normal")
                                      HighImage:KUIImage(@"chat_click")
                                      selectImage:Nil];
            [button_right addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
            [m_buttonBgView addSubview:button_right];
        }break;
        default:
        {
           
        }break;
    }
}

- (void)addFriendClick:(id)sender
{
    [hud show:YES];
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.hostInfo.userId forKey:@"frienduserid"];
    [paramDict setObject:@"2" forKey:@"type"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"109" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        
        [DataStoreManager deleteFansWithUserName:self.userName];
//        [GameCommon shareGameCommon].fansTableChanged = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
        
        [[GameCommon shareGameCommon] fansCountChanged:NO];
        
        if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"1"])
        {
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserInfo:dic];
            }
            else
                [DataStoreManager saveUserInfo:self.hostInfo.infoDic];
//            [GameCommon shareGameCommon].friendTableChanged = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"2"])//关注
        {
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserAttentionInfo:dic];
            }
            else
                [DataStoreManager saveUserAttentionInfo:self.hostInfo.infoDic];
//            [GameCommon shareGameCommon].attentionTableChanged = YES;//有更新
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

        }
        [self showMessageWindowWithContent:@"添加成功" imageType:0];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

- (void)deleteFriend:(id)sender
{
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定要删除该好友吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 234;
    [alter show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 234) {//删除好友
        if (buttonIndex != alertView.cancelButtonIndex) {
            //后台存储
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
            
            [paramDict setObject:self.hostInfo.userId forKey:@"frienduserid"];
            [paramDict setObject:@"2" forKey:@"type"];

            [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
            [postDict setObject:paramDict forKey:@"params"];
            [postDict setObject:@"110" forKey:@"method"];
            [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
            
            [hud show:YES];
            
            [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [hud hide:YES];
                
                [DataStoreManager deleteThumbMsgWithSender:self.hostInfo.userName];//删除聊天消息
                [DataStoreManager deleteFriendWithUserName:self.userName];//从表删除
//                [GameCommon shareGameCommon].friendTableChanged = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];

                if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"3"])
                {
                    if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                        NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                        [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                        [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                        
                        [DataStoreManager saveUserFansInfo:dic];
                    }
                    else
                        [DataStoreManager saveUserFansInfo:self.hostInfo.infoDic];//加到粉丝里
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];

                    [[GameCommon shareGameCommon] fansCountChanged:YES];
                }
                [self.navigationController popViewControllerAnimated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, id error) {
                if ([error isKindOfClass:[NSDictionary class]]) {
                    if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
                    {
                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alert show];
                    }
                }
                [hud hide:YES];
            }];
        }
    }
    else if(alertView.tag == 345)//取消关注
    {
        //后台存储
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
        
        [paramDict setObject:self.hostInfo.userId forKey:@"frienduserid"];
        [paramDict setObject:@"1" forKey:@"type"];

        [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
        [postDict setObject:paramDict forKey:@"params"];
        [postDict setObject:@"110" forKey:@"method"];
        [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        
        [hud show:YES];
        
        [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];
            
            [DataStoreManager deleteThumbMsgWithSender:self.hostInfo.userName];

            ////////////////////////
            [DataStoreManager deleteAttentionWithUserName:self.userName];
//            [GameCommon shareGameCommon].attentionTableChanged = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, id error) {
            if ([error isKindOfClass:[NSDictionary class]]) {
                if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
                {
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            }
            [hud hide:YES];
        }];
    }
}

- (void)startChat:(id)sender
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
//    [[TempData sharedInstance] setNeedChatToUser:self.hostInfo.userName];
    if (self.isChatPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else//直接进入聊天页面
    {
        KKChatController * kkchat = [[KKChatController alloc] init];
        kkchat.chatWithUser = self.hostInfo.userName;
//        kkchat.nickName = [DataStoreManager queryRemarkNameForUser:self.userName];
//        kkchat.chatUserImg = [DataStoreManager queryFirstHeadImageForUser:self.hostInfo.userName];
        kkchat.nickName = self.nickName;
        kkchat.chatUserImg = [GameCommon getHeardImgId:self.hostInfo.headImgStr];
        [self.navigationController pushViewController:kkchat animated:YES];
    }
}

- (void)attentionClick:(id)sender
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.hostInfo.userId forKey:@"frienduserid"];
    [paramDict setObject:@"1" forKey:@"type"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"109" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [hud hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"2"])
        {
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserAttentionInfo:dic];
            }
            else
                [DataStoreManager saveUserAttentionInfo:self.hostInfo.infoDic];
//            [GameCommon shareGameCommon].attentionTableChanged = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]] && [KISDictionaryHaveKey(responseObject, @"shiptype") isEqualToString:@"1"])//为好友
        {
            if (self.hostInfo.achievementArray && [self.hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:self.hostInfo.infoDic];
                [dic setObject:[self.hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserInfo:dic];
            }
            else
                [DataStoreManager saveUserInfo:self.hostInfo.infoDic];
//            [GameCommon shareGameCommon].friendTableChanged = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
        }
        [self showMessageWindowWithContent:@"关注成功" imageType:0];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

- (void)cancelAttentionClick:(id)sender
{
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确实取消对该用户的关注吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag = 345;
    [alter show];
}

#pragma mark 修改备注名字
- (void)editButtonClick:(id)sender
{
    SetRemarkNameViewController* VC = [[SetRemarkNameViewController alloc] init];
    VC.userName = self.hostInfo.userName;
    VC.nickName = self.hostInfo.nickName;
    VC.userId = self.hostInfo.userId;
    VC.isFriend = self.viewType == VIEW_TYPE_FriendPage ? YES : NO;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 头像
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    
}

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    //放大
    PhotoViewController * pV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.hostInfo.headImgArray indext:index];
    [self presentViewController:pV animated:NO completion:^{
        
    }];
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    
}

- (void)photoWallAddAction
{
    
}

- (void)photoWallAddFinish
{
    
}

- (void)photoWallDeleteFinish
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
