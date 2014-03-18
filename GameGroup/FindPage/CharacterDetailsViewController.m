//
//  CharacterDetailsViewController.m
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "CharacterDetailsViewController.h"
#import "CharaInfo.h"
#import "CharacterDetailsView.h"
#import "CharaDaCell.h"
#import "RankingViewController.h"
#import "SendNewsViewController.h"
@interface CharacterDetailsViewController ()

@end

@implementation CharacterDetailsViewController
{
    UITableView          * m_contentTableView;
    UITableView          * m_reamlTableView;
    UITableView          * m_countryTableView;
    CharaInfo            * m_charaInfo;
    CharacterDetailsView * m_charaDetailsView;
    NSMutableArray       * titleImageArray;
    NSArray              * titleArray;
    NSInteger              m_pageNum;
    float startX;
    NSString           *m_serverStr;//储存服务器名称
    NSString           *m_characterId;
    NSString           *m_zhiyeId;
    NSString           *m_characterName;
    BOOL            isInTheQueue;//获取刷新数据队列中
    
    BOOL            isGoToNextPage;
    UIView              *bgView;
    UIActivityIndicatorView   *loginActivity;
}
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
    
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isInTheQueue =NO;
    isGoToNextPage = YES;
    
    [self setTopViewWithTitle:@"角色详情" withBackButton:YES];
     startX = KISHighVersion_7 ? 64 : 44;
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30)];
    [shareButton setBackgroundImage:KUIImage(@"share_normal.png") forState:UIControlStateNormal];
    [shareButton setBackgroundImage:KUIImage(@"share_normal.png") forState:UIControlStateHighlighted];
    shareButton.backgroundColor = [UIColor clearColor];
    [shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];

    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    m_charaDetailsView.listScrollView.backgroundColor = [UIColor clearColor];
    
    m_charaDetailsView =[[CharacterDetailsView alloc]initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - startX)];

    m_charaDetailsView.contentSize = CGSizeMake(320, 610);
    //m_charaDetailsView.bounces = NO;
    m_charaDetailsView.myCharaterDelegate = self;
    
    
    if (self.myViewType ==CHARA_INFO_MYSELF) {
        [m_charaDetailsView comeFromMy];
    }else if(self.myViewType ==CHARA_INFO_PERSON){
        [m_charaDetailsView comeFromPerson];
    }
    [self.view addSubview:m_charaDetailsView];
    
    
    [self buildScrollView];//创建下面的表格
    
    
    titleImageArray =[NSMutableArray array];
    [titleImageArray addObject:KUIImage(@"PVE.png")];
    [titleImageArray addObject:KUIImage(@"killer.png")];
    [titleImageArray addObject:KUIImage(@"itemserver.png")];
    [titleImageArray addObject:KUIImage(@"achievementCount.png")];
    [titleImageArray addObject:KUIImage(@"Wjjc.png")];
    //PVE战斗力  荣誉击杀数  装备等级 成就点数  PVP竞技场）
    titleArray = [NSMutableArray arrayWithObjects:@"PVE战斗力",@"荣誉击杀",@"装备等级",@"成就点数",@"PVP竞技场", nil];
    

    m_charaDetailsView.reloadingBtn.userInteractionEnabled = NO;
    loginActivity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [m_charaDetailsView addSubview:loginActivity];
    loginActivity.center = CGPointMake(160, 290);
    loginActivity.color = [UIColor blackColor];
    [loginActivity startAnimating];

    
    [self getUserInfoByNet];

}

-(void)buildScrollView
{
    
    if (self.myViewType ==CHARA_INFO_MYSELF) {
        m_charaDetailsView.isComeTo = YES;
        m_contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_contentTableView];
        m_contentTableView.dataSource = self;
        m_contentTableView.delegate = self;
        m_contentTableView.bounces = NO;
        m_contentTableView.rowHeight = 55;
        
        m_countryTableView = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_countryTableView];
        m_countryTableView.dataSource = self;
        m_countryTableView.delegate = self;
        m_countryTableView.bounces = NO;
        m_countryTableView.rowHeight = 55;
        
        m_reamlTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_reamlTableView];
        m_reamlTableView.dataSource = self;
        m_reamlTableView.delegate = self;
        m_reamlTableView.bounces = NO;
        m_reamlTableView.rowHeight = 55;
        
    }else if(self.myViewType ==CHARA_INFO_PERSON){
        m_charaDetailsView.isComeTo = NO;
        m_contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_contentTableView];
        m_contentTableView.dataSource = self;
        m_contentTableView.delegate = self;
        m_contentTableView.bounces = NO;
        m_contentTableView.rowHeight = 60;
        m_contentTableView.hidden =YES;
        
        
        m_countryTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_countryTableView];
        m_countryTableView.dataSource = self;
        m_countryTableView.delegate = self;
        m_countryTableView.bounces = NO;
        m_countryTableView.rowHeight = 60;
        
        
        m_reamlTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) style:UITableViewStylePlain];
        [m_charaDetailsView.listScrollView addSubview:m_reamlTableView];
        m_reamlTableView.dataSource = self;
        m_reamlTableView.delegate = self;
        m_reamlTableView.bounces = NO;
        m_reamlTableView.rowHeight = 60;
     
        
        
    }
    
    m_contentTableView.hidden =YES;
    m_reamlTableView.hidden = YES;
    m_countryTableView.hidden =YES;
}

//获取网络数据
- (void)getUserInfoByNet
{
   
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"146" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        m_contentTableView.hidden =NO;
        m_reamlTableView.hidden = NO;
        m_countryTableView.hidden =NO;
        m_charaDetailsView.unlessLabel.hidden =YES;
        [loginActivity stopAnimating];
        [loginActivity removeFromSuperview];

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            
            
            m_charaInfo = [[CharaInfo alloc] initWithCharaInfo:responseObject];
            m_charaDetailsView.NickNameLabel.text = m_charaInfo.roleNickName;
            NSString *guildStr =[NSString stringWithFormat:@"%@", m_charaInfo.guild];
            NSString *guilStr = nil;
            if (guildStr.length>8 ) {
                guilStr =[NSString stringWithFormat:@"%@..." ,[guildStr substringToIndex:8]];
                m_charaDetailsView.guildLabel.text = [NSString stringWithFormat:@"<%@>",guilStr];
            }else{
                m_charaDetailsView.guildLabel.text = [NSString stringWithFormat:@"<%@>",guildStr];
            }
            if ([m_charaInfo.guild isEqualToString:@""]) {
                m_charaDetailsView.guildLabel.text =@"<无工会>";
            }
            //计算view的franme
            NSString *str =[NSString stringWithFormat:@"%@ %@",m_charaInfo.realm,m_charaInfo.sidename];
            m_charaDetailsView.rightPView.frame = CGRectMake(295-str.length*11, 5, str.length*11+20,20 );
            m_charaDetailsView.realmView.frame = CGRectMake(18, 0, str.length*11+5, 20);
            m_serverStr = m_charaInfo.realm;
            m_characterId = m_charaInfo.characterid;
            m_zhiyeId = m_charaInfo.professionalId;
            m_characterName =m_charaInfo.roleNickName;
            m_charaDetailsView.realmView.text = [NSString stringWithFormat:@"%@ %@", m_charaInfo.realm,m_charaInfo.sidename];
            
            // m_charaDetailsView.realmView.text = m_charaInfo.realm;
            m_charaDetailsView.levelLabel.text =[NSString stringWithFormat:@"Lv.%@ %@", m_charaInfo.level,m_charaInfo.professionalName];
            
            m_charaDetailsView.levelLabel.frame =
            CGRectMake(323-m_charaDetailsView.levelLabel.text.length*9,
                       8,
                       m_charaDetailsView.levelLabel.text.length*9,
                       25);
            NSLog(@"长度%u",m_charaDetailsView.levelLabel.text.length*12);
            
            
            m_charaDetailsView.itemlevelView.text = [NSString stringWithFormat:@"%@/%@",m_charaInfo.itemlevelequipped,m_charaInfo.itemlevel] ;//
            m_charaDetailsView.clazzImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%@",m_charaInfo.professionalId]];
            m_charaDetailsView.headerImageView.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
            m_charaDetailsView.headerImageView.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@/80",m_charaInfo.thumbnail]];
            
            
            if ([[KISDictionaryHaveKey(responseObject, @"ranking") allKeys] containsObject:@"rankingtime"]) {
//                NSString *changeBtnTitle =[NSString stringWithFormat:@"上次更新时间：%@",[GameCommon getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(responseObject, @"rankingtime")]]];
                
                NSString *changeBtnTitle=[self getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"ranking"), @"rankingtime") ]];
                
                
                [[NSUserDefaults standardUserDefaults]setObject:KISDictionaryHaveKey(KISDictionaryHaveKey(responseObject, @"ranking"), @"rankingtime") forKey:@"WX_reloadBtnTitle_wx"];
                
                [m_charaDetailsView.reloadingBtn setTitle:[NSString stringWithFormat:@"上次更新时间:%@",changeBtnTitle] forState:UIControlStateNormal];
            }

            
            if ([m_charaInfo.auth isEqualToString:@"1"]) {
                m_charaDetailsView.certificationImage.image = KUIImage(@"6");
            }else
            {
                m_charaDetailsView.certificationImage.image = KUIImage(@"5");
            }
            //获取表格信息
            
            
            
            [m_contentTableView reloadData];
            [m_countryTableView reloadData];
            [m_reamlTableView reloadData];
            
            m_charaDetailsView.reloadingBtn.userInteractionEnabled = YES;

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [loginActivity stopAnimating];
        [loginActivity removeFromSuperview];
        m_charaDetailsView.reloadingBtn.userInteractionEnabled = YES;
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }else{
            
        }
    }];
    
}


//队列
-(void)getUserLineInfoByNet
{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"159" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    //[hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"res%@",responseObject);
        if ([KISDictionaryHaveKey(responseObject, @"systemstate")isEqualToString:@"ok"]) {
            
            [self reLoadingUserInfoFromNet];
            return ;
        }
        if ([KISDictionaryHaveKey(responseObject, @"systemstate")isEqualToString:@"busy"]) {
            m_charaDetailsView.reloadingBtn.userInteractionEnabled =YES;
            
            NSString *timeStr =[NSString stringWithFormat:@"%d",[KISDictionaryHaveKey(responseObject, @"time")intValue]/60000];
            NSString *str = nil;
            if ([timeStr isEqualToString:@"0"]) {
                str = @"小于1分钟";
            }else{
                str =[NSString stringWithFormat:@"%@分钟",timeStr];
            }
            
            NSString *indexStr = KISDictionaryHaveKey(responseObject, @"index");
            MBProgressHUD *  hud1 = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud1];
            hud1.mode =  MBProgressHUDModeIndeterminate;
            hud1.labelText = nil;
            hud1.detailsLabelText = [NSString stringWithFormat:@"进入更新队列,目前队列位置：%@，预计更新时间：%@",indexStr,str];
            [hud1 showAnimated:YES whileExecutingBlock:^{
                sleep(3);
                
            }];
            return;
        }
            m_charaDetailsView.reloadingBtn.userInteractionEnabled = YES;
            m_charaInfo = [[CharaInfo alloc] initWithReLoadingInfo:responseObject];
        MBProgressHUD *  hud2 = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud2];
        hud2.labelText = @"获取成功";
            hud2.mode =  MBProgressHUDModeCustomView;
        hud2.customView = [[UIImageView alloc]initWithImage:KUIImage(@"37x-Checkmark")];
        [hud2 showAnimated:YES whileExecutingBlock:^{
            sleep(2);
            
        }];
         // [self showMessageWindowWithContent:@"获取成功" imageType:0];
        NSString *changeBtnTitle =[NSString stringWithFormat:@"上次更新时间：%@",[self getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(responseObject, @"rankingtime")]]];
        
        [[NSUserDefaults standardUserDefaults]setObject:KISDictionaryHaveKey(responseObject, @"rankingtime") forKey:@"WX_reloadBtnTitle_wx"];
        
        [m_charaDetailsView.reloadingBtn setTitle:changeBtnTitle forState:UIControlStateNormal];

    } failure:^(AFHTTPRequestOperation *operation, id error) {
        m_charaDetailsView.reloadingBtn.userInteractionEnabled =YES;

        [hud hide:YES];
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];

}
//刷新数据
-(void)reLoadingUserInfoFromNet
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.labelText = @"正拼命从英雄榜获取中...";
    hud.detailsLabelText = nil;
    
    m_charaDetailsView.reloadingBtn.userInteractionEnabled =NO;
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"160" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        m_charaDetailsView.reloadingBtn.userInteractionEnabled =YES;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            m_charaInfo = [[CharaInfo alloc] initWithReLoadingInfo:responseObject];
            
            [hud hide:YES];
            
            [m_contentTableView reloadData];
            [m_countryTableView reloadData];
            [m_reamlTableView reloadData];
            
            NSString *changeBtnTitle =[NSString stringWithFormat:@"上次更新时间：%@",[GameCommon getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(responseObject, @"rankingtime")]]];
            
            [[NSUserDefaults standardUserDefaults]setObject:KISDictionaryHaveKey(responseObject, @"rankingtime") forKey:@"WX_reloadBtnTitle_wx"];
            
            [m_charaDetailsView.reloadingBtn setTitle:changeBtnTitle forState:UIControlStateNormal];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        m_charaDetailsView.reloadingBtn.userInteractionEnabled =YES;

        [hud hide:YES];
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

    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==m_contentTableView) {
        return m_charaInfo.firstCompArray.count;
    }else if (tableView ==m_countryTableView)
    {
        return m_charaInfo.secondCompArray.count;
    }else{
        return m_charaInfo.thirdCompArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    CharaDaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[CharaDaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleImgView.image = [titleImageArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    cell.topImgView.image = KUIImage(@"paiming_ico");
    
    
    if (tableView ==m_contentTableView) {
        cell.CountLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.firstValueArray objectAtIndex:indexPath.row]];
        cell.rankingLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.firstRankArray objectAtIndex:indexPath.row]];
        NSInteger  i =[[m_charaInfo.firstCompArray objectAtIndex:indexPath.row]integerValue];
        if ([[NSString stringWithFormat:@"%@",[m_charaInfo.firstRankArray objectAtIndex:indexPath.row]] isEqualToString:@""]) {
            cell.upDowmImgView.hidden = YES;
        }else
        {
            cell.upDowmImgView.hidden =NO;
        }
        if (i ==1) {
            cell.upDowmImgView.image = KUIImage(@"die");
        }
        if (i==-1) {
            
                cell.upDowmImgView.image = KUIImage(@"zhang");
            }
        else{
                cell.upDowmImgView.image =nil;
            }
        //
    }
    if (tableView ==m_countryTableView){
        cell.CountLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.secondValueArray objectAtIndex:indexPath.row]];
        cell.rankingLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.secondRankArray objectAtIndex:indexPath.row]];
        NSInteger  i =[[m_charaInfo.firstCompArray objectAtIndex:indexPath.row]integerValue];
        if (i ==1) {
            cell.upDowmImgView.image = KUIImage(@"die");
        }
        if (i==-1) {
          
            cell.upDowmImgView.image = KUIImage(@"zhang");
        }
        if (i==0) {
                cell.upDowmImgView.image =nil;
        }
    }
    if (tableView ==m_reamlTableView) {
        cell.CountLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.thirdValueArray objectAtIndex:indexPath.row]];
        
        cell.rankingLabel.text = [NSString stringWithFormat:@"%@",[m_charaInfo.thirdRankArray objectAtIndex:indexPath.row]];
        NSInteger  i =[[m_charaInfo.firstCompArray objectAtIndex:indexPath.row]integerValue];
        if (i ==1) {
            cell.upDowmImgView.image = KUIImage(@"die");
        }
        if (i==-1) {
                cell.upDowmImgView.image = KUIImage(@"zhang");
            }
            if (i==0) {
                cell.upDowmImgView.image =nil;
        }
        
    }
    
    if ([cell.rankingLabel.text isEqualToString:@"0"]||[cell.rankingLabel.text intValue]>100||[cell.rankingLabel.text isEqualToString:@""]) {
        cell.rankingLabel.text =@"--";
        cell.upDowmImgView.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    NSString *alertTitle =nil;
    alertTitle =[titleArray objectAtIndex:indexPath.row];

    RankingViewController *ranking = [[RankingViewController alloc]init] ;
    
    if (tableView ==m_contentTableView) {
        ranking.cRankvaltype = @"1" ;
        NSInteger i =[[m_charaInfo.firstRankArray objectAtIndex:indexPath.row]intValue];
        if (i==0) {
            isGoToNextPage = NO;
        }
        
    }
    if (tableView ==m_countryTableView) {
        ranking.cRankvaltype = @"3" ;
        NSInteger i =[[m_charaInfo.secondRankArray objectAtIndex:indexPath.row]intValue];
        if (i==0) {
            isGoToNextPage = NO;
        }

    }
    if (tableView ==m_reamlTableView) {
        ranking.cRankvaltype = @"2" ;
        NSInteger i =[[m_charaInfo.thirdRankArray objectAtIndex:indexPath.row]intValue];
        if (i==0) {
            isGoToNextPage = NO;
        }

    }

    if (isGoToNextPage ==YES) {
        ranking.characterid =m_characterId;
        ranking.custType = m_zhiyeId;
        ranking.server = m_serverStr;
        ranking.userId = self.userId;
        ranking.pageCount1 = -1;
        ranking.pageCount2 = -1;
        ranking.pageCount3 = -1;
        ranking.characterName =m_characterName;
        ranking. titleOfRanking = [titleArray objectAtIndex:indexPath.row];
        NSArray *array = [m_charaInfo.friendOfRanking allKeys];
        NSLog(@"array%@",array);
        /*
         pvpScore,
         pveScore,
         itemlevel,
         totalHonorableKills,
         achievementPoints
         */
        
        switch (indexPath.row) {
            case 0:
                ranking.dRankvaltype = @"pveScore";
                break;
            case 1:
                ranking.dRankvaltype = @"totalHonorableKills";
                break;
            case 2:
                ranking.dRankvaltype = @"itemlevel";
                break;
            case 3:
                ranking.dRankvaltype = @"achievementPoints";
                break;
            case 4:
                ranking.dRankvaltype = @"pvpScore";
                break;
                
            default:
                break;
        }
        
        ranking.COME_FROM =[NSString stringWithFormat:@"%u",self.myViewType];
        NSLog(@"COME_FROM%@",ranking.COME_FROM);
        [self.navigationController pushViewController:ranking animated:YES];

    }else{
        
        [self showAlertViewWithTitle:@"提示" message:[NSString stringWithFormat:@"该角色尚未进入“%@”排行",alertTitle] buttonTitle:@"确定"];
        isGoToNextPage =YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"contentOfjuese" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"typePerson" object:nil];
    
    
}

- (NSString*)getTimeWithMessageTime:(NSString*)messageTime
{
    NSString* currentString = [GameCommon getCurrentTime];
    if (messageTime.length < 10 || currentString.length < 10) {
        return @"未知";
    }
    NSString* curStr = [currentString substringToIndex:messageTime.length-3];
    NSString* mesStr = [messageTime substringToIndex:messageTime.length-3];
    
    double theCurrentT = [curStr doubleValue];
    double theMessageT = [mesStr doubleValue];
    
    NSLog(@"%f--%f",theCurrentT,theMessageT);
    NSLog(@"++%f",theCurrentT-theMessageT);
    if (((int)(theCurrentT-theMessageT))<60) {
        return @"1分钟以前";
    }
    if (((int)(theCurrentT-theMessageT))<60*59) {
        return [NSString stringWithFormat:@"%.f分钟以前",((theCurrentT-theMessageT)/60+1)];
    }
    if (((int)(theCurrentT-theMessageT))<60*60*24&&((int)(theCurrentT-theMessageT))>60*59) {
        return [NSString stringWithFormat:@"%.f小时以前",((theCurrentT-theMessageT)/3600)==0?1:((theCurrentT-theMessageT)/3600)];
    }
    if (((int)(theCurrentT-theMessageT))<60*60*48) {
        return @"昨天";
    }   
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    return [messageDateStr substringFromIndex:5];
}

- (void)reLoadingList:(CharacterDetailsView *)characterdetailsView
{
    m_charaDetailsView.reloadingBtn.userInteractionEnabled =NO;
        [self getUserLineInfoByNet];
        NSLog(@"刷新数据");
    
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
    VC.isComeFromMe = NO;
   // VC.defaultContent = [NSString stringWithFormat:@"分享了%@的角色详情",self.characterName];
    VC.defaultContent = [NSString stringWithFormat:@"分享了%@的数据",m_characterName];
    [self.navigationController pushViewController:VC animated:NO];
}



@end



