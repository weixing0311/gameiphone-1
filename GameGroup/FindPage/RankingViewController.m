//
//  RankingViewController.m
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//
/*
 
 
 * 头衔排行
 *
 * @param gameid
 *            游戏id
 * @param ranktype
 *            排行类型，三个值：1，2，3， 1是好友， 2是全服， 3是全国， 大头衔也就是 基本头衔有这个字段值是多个这间用逗号分隔的
 * @param characterid
 *            角色id
 * @param rankvaltype
 *            排行值类型， 战斗力还是坐骑等
 * @param pageIndex
 *            起始页， 如果传 -1 我就认为是取角色id附近的排名， 会返回这个角色的排行，
 *            如果这个角色的排名就是前几名会返回rank排名为1的，这时pageIndex其实 就相当于为0第一页时的返回数据，
 *            所以前端要判断取角色排名的时侯是否返 回了rank = 1， 如果有下一页应该是传pageIndex = 1 而不是
 *            pageIndex = 0
 * @param maxSize
 *            记录数
 * @param realm
 *            服务器， 全服排行用这个
 * @param classid
 *            职业id， 全服和全国用这个， 不传默认全职业
 * @return
 */


#import "RankingViewController.h"
#import "RankingCell.h"
#import "PersonDetailViewController.h"
#import "SendNewsViewController.h"
#define kSegmentFriend (0)
#define kSegmentRealm (1)
#define kSegmentCountry (2)

@interface RankingViewController ()

@end

@implementation RankingViewController
{
    NSMutableArray *m_cArray;
    UITableView *m_tableView;
    UIButton       * m_serverBtn;
    UIButton       * m_countryBtn;
    UIButton       * m_friendBtn;
    
    
    
    PullUpRefreshView      *refreshView;
    SRRefreshView   *_slimeView;

    UIImageView *m_underListImageView;
    
    float btnWidth;//判断button的位置
    float btnOfX;
     UIView*         bgView;
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_cArray = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getSortDataByNet];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setTopViewWithTitle:@"排行榜" withBackButton:YES];
    
    [self setTopViewWithTitle:[NSString stringWithFormat:@"%@排行",self.titleOfRanking] withBackButton:YES];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30)];
    [shareButton setBackgroundImage:KUIImage(@"share_normal.png") forState:UIControlStateNormal];
    [shareButton setBackgroundImage:KUIImage(@"share_normal.png") forState:UIControlStateHighlighted];
    shareButton.backgroundColor = [UIColor clearColor];
    [shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];

    
    
    //创建头button
    [self buildTopBtnView];
    
    
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX+44, 320, self.view.frame.size.height -startX-44) style:UITableViewStylePlain];
    m_tableView.rowHeight = 70;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.showsVerticalScrollIndicator = NO;
    m_tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_tableView];
    

    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";

    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = NO;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [m_tableView addSubview:_slimeView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_tableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_tableView;
    [refreshView stopLoading:NO];
    

    
}




#pragma mark -- tableview delegate datasourse
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_cArray.count;
    //return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = [m_cArray objectAtIndex:indexPath.row];
    NSLog(@"dicdic%@",dic);
    NSInteger i = [KISDictionaryHaveKey(dic, @"rank")integerValue];
    if (i <=3) {
        cell.NumLabel.backgroundColor =UIColorFromRGBA(0xff9600, 1);
    }else if(i>3&&i<=10) {
        cell.NumLabel.backgroundColor =UIColorFromRGBA(0x8a5d96, 1);
    }
    else{
        cell.NumLabel.backgroundColor =UIColorFromRGBA(0x828be5, 1);
    }
    
    if ([KISDictionaryHaveKey(dic, @"charactername") isEqualToString:self.characterName]&&[KISDictionaryHaveKey(dic, @"realm") isEqualToString:self.server]) {
        cell.backgroundColor = UIColorFromRGBA(0xd0ebe9, 1);
    }else {
        cell.backgroundColor =[UIColor whiteColor];
    }
    
    
    //cell.titleImageView.image = KUIImage(@"ceshi.jpg");
    cell.titleImageView.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    cell.titleImageView.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",KISDictionaryHaveKey(dic, @"img")]];

    cell.NumLabel.text = [GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"rank")];
    cell.titleLabel.text = KISDictionaryHaveKey(dic, @"nickname");
    cell.serverLabel.text = [NSString stringWithFormat:@"%@-%@",KISDictionaryHaveKey(dic, @"charactername"),KISDictionaryHaveKey(dic, @"characterclass")];
    cell.CountOfLabel.text =[NSString stringWithFormat:@"%@",KISDictionaryHaveKey(dic, @"value")];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonDetailViewController *detailVC = [[PersonDetailViewController alloc]init];
    NSDictionary *dic = [m_cArray objectAtIndex:indexPath.row];
    
    detailVC.userId = KISDictionaryHaveKey(dic, @"userid");
    detailVC.nickName = KISDictionaryHaveKey(dic, @"displayName");
    detailVC.isChatPage = NO;
    [self.navigationController pushViewController:detailVC animated:YES];

}


#pragma mark ---创建顶部分类button
-(void)buildTopBtnView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, startX, 320, 44)];
    view.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:view];
    m_friendBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    m_countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    m_serverBtn  = [UIButton  buttonWithType:UIButtonTypeCustom];
    
    [m_friendBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    [m_countryBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    [m_serverBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    

    
    if ([self.COME_FROM isEqualToString:@"0"]) {
        NSLog(@"看别人的");
        btnWidth = 160;
        btnOfX = 0;
        m_friendBtn.hidden =YES;
    }
    if([self.COME_FROM isEqualToString:@"1"]){
        NSLog(@"看自己的");
        btnWidth = 106;
        btnOfX =106;
    }
    m_friendBtn.frame = CGRectMake(btnOfX-btnWidth,0,btnWidth,44);
    m_countryBtn.frame = CGRectMake(btnOfX+btnWidth,0,btnWidth,44);
    m_serverBtn.frame = CGRectMake(btnOfX,0,btnWidth,44);

    m_underListImageView = [[UIImageView alloc]init];
    m_underListImageView.image =KUIImage(@"tab_line");

    if ([self.cRankvaltype isEqualToString:@"1"]) {
        m_friendBtn.selected = YES;
        m_underListImageView.frame =CGRectMake(btnOfX-btnWidth, 41,btnWidth,4);
    }
    if ([self.cRankvaltype isEqualToString:@"2"]) {
        m_serverBtn.selected = YES;
        m_underListImageView.frame =CGRectMake(btnOfX, 41,btnWidth,4);
    }
    if ([self.cRankvaltype isEqualToString:@"3"]) {
        m_countryBtn.selected = YES;
        m_underListImageView.frame =CGRectMake(btnOfX+btnWidth, 41,btnWidth,4);
    }

    
    
    [m_friendBtn setTitle:@"好友" forState:UIControlStateNormal];
    [m_countryBtn setTitle:@"全国" forState:UIControlStateNormal];
    NSString *str = self.server;
    if (str==Nil) {
        str =@"服务器";
    }
    [m_serverBtn setTitle:str forState:UIControlStateNormal];
    
//    m_friendBtn.backgroundColor = [UIColor clearColor];
//    m_countryBtn.backgroundColor = [UIColor clearColor];
//    m_serverBtn.backgroundColor = [UIColor clearColor];
    
    [m_friendBtn setTitleColor:UIColorFromRGBA(0xff9600, 1) forState:UIControlStateSelected];
    [m_friendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [m_countryBtn setTitleColor:UIColorFromRGBA(0xff9600, 1) forState:UIControlStateSelected];
    [m_countryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [m_serverBtn setTitleColor:UIColorFromRGBA(0xff9600, 1) forState:UIControlStateSelected];
    [m_serverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [m_friendBtn addTarget:self action:@selector(loadingFriendInfo:) forControlEvents:UIControlEventTouchUpInside];
    [m_countryBtn addTarget:self action:@selector(loadingCountryInfo:) forControlEvents:UIControlEventTouchUpInside];
    [m_serverBtn addTarget:self action:@selector(loadingServerInfo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:m_friendBtn];
    [view addSubview:m_countryBtn];
    [view addSubview:m_serverBtn];
    [view addSubview:m_underListImageView];


}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ---分享button方法
-(void)shareBtnClick:(UIButton *)sender
{
    if (bgView != nil) {
        [bgView removeFromSuperview];
    }
    bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(328, 0, kScreenHeigth-320, kScreenWidth);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"分享到"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"我的动态", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];

}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self performSelector:@selector(pushSendNews) withObject:nil afterDelay:1.0];
    }
    if (bgView != nil) {
        [bgView removeFromSuperview];
    }
}

- (void)pushSendNews
{
    //http://www.dapps.net/dev/iphone/iphone-ipad-screenshots-tips.html
    //    CGImageRef UIGetScreenImage();
    //    CGImageRef img = UIGetScreenImage();
    //    UIImage* scImage=[UIImage imageWithCGImage:img];
    UIGraphicsBeginImageContext(CGSizeMake(kScreenWidth, kScreenHeigth));
    //    if(upScroll.center.y < 0)
    //    {
    //        [downScroll.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    }
    //    else
    //    {
    //        CGContextRef cm = UIGraphicsGetCurrentContext();
    //        CGContextTranslateCTM(cm, 200, 0.0);
    //        [upScroll.layer renderInContext:cm];
    //    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    SendNewsViewController* VC = [[SendNewsViewController alloc] init];
    VC.titleImage = viewImage;
    VC.delegate = self;
    VC.defaultContent = [NSString stringWithFormat:@"分享%@的%@排名",self.characterName,self.titleOfRanking];
    [self.navigationController pushViewController:VC animated:NO];
}


#pragma mark --顶部分类button方法
-(void)loadingFriendInfo:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    if ([self.cRankvaltype isEqualToString:@"1"]) {
        return;
    }
    self.cRankvaltype =@"1";
    self.pageCount = -1;
     [m_cArray removeAllObjects];
    [self getSortDataByNet];
    
    m_friendBtn.selected = YES;
    m_countryBtn.selected = NO;
    m_serverBtn.selected = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    m_underListImageView.frame = CGRectMake(m_friendBtn.frame.origin.x, 41, m_friendBtn.frame.size.width, 4);
    [UIView commitAnimations];

    

}
-(void)loadingCountryInfo:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    if ([self.cRankvaltype isEqualToString:@"3"]) {
        return;
    }
   
    self.cRankvaltype =@"3";
     self.pageCount = 0;
    [m_cArray removeAllObjects];
   [self getSortDataByNet];
    
    //[self slimeRefreshStartRefresh:(SRRefreshView *)refreshView];
    
    
    m_friendBtn.selected = NO;
    m_countryBtn.selected = YES;
    m_serverBtn.selected = NO;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    m_underListImageView.frame = CGRectMake(m_countryBtn.frame.origin.x, 41, m_countryBtn.frame.size.width, 4);
    [UIView commitAnimations];


}
-(void)loadingServerInfo:(UIButton *)sender
{
    NSLog(@"%@",sender.titleLabel.text);
    if ([self.cRankvaltype isEqualToString:@"2"]) {
        return;
    }
    self.pageCount = 0;
    self.cRankvaltype =@"2";
    [m_cArray removeAllObjects];

  [self getSortDataByNet];
    m_friendBtn.selected = NO;
    m_countryBtn.selected = NO;
    m_serverBtn.selected = YES;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    m_underListImageView.frame = CGRectMake(m_serverBtn.frame.origin.x, 41, m_serverBtn.frame.size.width, 4);
    [UIView commitAnimations];


}

#pragma mark --网络请求
- (void)getSortDataByNet
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    //hud.labelText = @"请求中...";

    [hud show:YES];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    
    if ([self.cRankvaltype isEqualToString:@"2"]) {
        [paramDict setObject:self.custType forKey:@"classid"];
        }
    
    [paramDict setObject:self.server forKey:@"realm"];
    [paramDict setObject:@"1" forKey:@"gameid"];
    [paramDict setObject:self.characterid forKey:@"characterid"];
    [paramDict setObject:self.cRankvaltype forKey:@"ranktype"];
    
    [paramDict setObject:self.dRankvaltype forKey:@"rankvaltype"];
    
    [paramDict setObject:[NSString stringWithFormat:@"%d",self.pageCount] forKey:@"pageIndex"];
  //  [paramDict setObject:@"5" forKey:@"maxSize"];

    
  //  [paramDict setObject:@"-1" forKey:@"pageIndex"];
    [paramDict setObject:@"10" forKey:@"maxSize"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"130" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
   // [hud show:YES];

    
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            if (self.pageCount == 0) {
                [m_cArray removeAllObjects];
                
                [m_cArray addObjectsFromArray:responseObject];
                
                NSLog(@"切换或者刷新==0");
            }
            else
            {
                [m_cArray addObjectsFromArray:responseObject];
                
                NSLog(@"要加载更多");
            }
            
            [m_tableView reloadData];
            
            [refreshView stopLoading:NO];
            //        }
            self.pageCount ++;
            NSLog(@"m_PageCount ++%d",self.pageCount);
            [refreshView setRefreshViewFrame];
            [_slimeView endRefresh];
        }else
        {
            [refreshView stopLoading:YES];
            [_slimeView endRefresh];
        }
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [refreshView stopLoading:YES];
                [_slimeView endRefresh];
            }
        }
        
     //   [hud hide:YES];
    }];
}
#pragma mark  scrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_tableView.contentSize.height < m_tableView.frame.size.height) {
        refreshView.viewMaxY = 0;
    }
    else
        refreshView.viewMaxY = m_tableView.contentSize.height - m_tableView.frame.size.height;
    [refreshView viewdidScroll:scrollView];
    [_slimeView scrollViewDidScroll];
}

#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == m_tableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == m_tableView)
    {
        [refreshView didEndDragging:scrollView];
        [_slimeView scrollViewDidEndDraging];
        
    }
}
//上拉加载
- (void)PullUpStartRefresh
{
    NSLog(@"start");
    [self getSortDataByNet];
}

#pragma mark - slimeRefresh delegate
//刷新
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    self.pageCount = 0;
    [self getSortDataByNet];
}

-(void)endRefresh
{
    [_slimeView endRefreshFinish:^{
        
    }];
}
@end
/*
 "ranktype":"3","realm":"卡拉赞","gameid":"1","maxSize":"10","pageIndex":"0","rankvaltype":"pveScore","characterid":"155846"},"isCompression":"0"}
 
 
 "ranktype":"1","realm":"卡拉赞","gameid":"1","maxSize":"10","pageIndex":"0","rankvaltype":"pveScore","characterid":"155846"},"isCompression":"0"}
 
 */