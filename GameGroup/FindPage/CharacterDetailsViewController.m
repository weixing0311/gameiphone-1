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
    NSMutableArray       * countLabelArray;
    NSMutableArray       * rankingLabelArray;
    NSInteger              m_pageNum;
     float startX;
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
    
    [self getUserInfoByNet];
    

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    startX = KISHighVersion_7 ? 64 : 44;
    [self setTopViewWithTitle:@"角色详情" withBackButton:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    m_charaDetailsView =[[CharacterDetailsView alloc]initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - startX)];
    m_charaDetailsView.contentSize = CGSizeMake(320, 567);
    m_charaDetailsView.bounces = NO;
    m_charaDetailsView.myChangeDelegate = self;
    [self.view addSubview:m_charaDetailsView];
    
    [self buildScrollView];//创建下面的表格
 

    
    
    titleImageArray =[NSMutableArray array];
    [titleImageArray addObject:KUIImage(@"PVE.png")];
    [titleImageArray addObject:KUIImage(@"achievementCount.png")];
    [titleImageArray addObject:KUIImage(@"killer.png")];
    [titleImageArray addObject:KUIImage(@"Wmount.png")];
    [titleImageArray addObject:KUIImage(@"Wjjc.png")];
//PVE战斗力  荣誉击杀数  装备等级 成就点数  PVP竞技场
    titleArray = [NSMutableArray arrayWithObjects:@"pve战斗力",@"荣誉击杀",@"装备等级",@"成就点数",@"PVP竞技场", nil];
    
    countLabelArray = [NSMutableArray array];
    [countLabelArray addObject:[NSString stringWithFormat:@"%@", m_charaInfo.pveScore]];
    [countLabelArray addObject:@"123123"];
    [countLabelArray addObject:[NSString stringWithFormat:@"%@",   m_charaInfo.itemlevelequipped]];
    [countLabelArray addObject:@"2500"];
    
    
    rankingLabelArray = [NSMutableArray array];
    NSString *str1 =[NSString stringWithFormat:@"%d",arc4random()%1000];
    NSString *str2 =[NSString stringWithFormat:@"%d",arc4random()%1000];
    NSString *str3 =[NSString stringWithFormat:@"%d",arc4random()%1000];
    NSString *str4 =[NSString stringWithFormat:@"%d",arc4random()%1000];
    NSString *str5 =[NSString stringWithFormat:@"%d",arc4random()%1000];
    [rankingLabelArray addObject:str1];
    [rankingLabelArray addObject:str2];
    [rankingLabelArray addObject:str3];
    [rankingLabelArray addObject:str4];
    [rankingLabelArray addObject:str5];
}

-(void)buildScrollView
{
//    m_charaDetailsView.listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 244, 320, 300)];
//    m_listScrollView.pagingEnabled = YES;
//    m_listScrollView.contentSize = CGSizeMake(320*3, 244);
//    [m_charaDetailsView addSubview:m_listScrollView];

    m_contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 300) style:UITableViewStylePlain];
    [m_charaDetailsView.listScrollView addSubview:m_contentTableView];
    m_contentTableView.dataSource = self;
    m_contentTableView.delegate = self;
    m_contentTableView.bounces = NO;
    m_contentTableView.rowHeight = 60;
    
    m_reamlTableView = [[UITableView alloc] initWithFrame:CGRectMake(320, 0, 320, 300) style:UITableViewStylePlain];
    [m_charaDetailsView.listScrollView addSubview:m_reamlTableView];
    m_reamlTableView.dataSource = self;
    m_reamlTableView.delegate = self;
    m_reamlTableView.bounces = NO;
    m_reamlTableView.rowHeight = 60;
    
    m_countryTableView = [[UITableView alloc] initWithFrame:CGRectMake(640, 0, 320, 300) style:UITableViewStylePlain];
    [m_charaDetailsView.listScrollView addSubview:m_countryTableView];
    m_countryTableView.dataSource = self;
    m_countryTableView.delegate = self;
    m_countryTableView.bounces = NO;
    m_countryTableView.rowHeight = 60;

}

//获取网络数据
- (void)getUserInfoByNet
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"请求中...";

    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    
    NSLog(@"self.gameid%@",self.gameId);
    NSLog(@"self.characterId%@",self.characterId);
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"146" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"角色详情页面%@", responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            m_charaInfo = [[CharaInfo alloc] initWithCharaInfo:responseObject];
            NSLog(@"m_charaInfo%@",m_charaInfo.roleNickName);
            m_charaDetailsView.NickNameLabel.text = m_charaInfo.roleNickName;
            m_charaDetailsView.guildLabel.text =[NSString stringWithFormat:@"<%@>", m_charaInfo.guild];
            if ([m_charaInfo.guild isEqualToString:@""]) {
                m_charaDetailsView.guildLabel.text =@"<无工会>";
            }
             m_charaDetailsView.realmView.text = [NSString stringWithFormat:@"%@ %@ %@", m_charaInfo.realm,m_charaInfo.sidename,m_charaInfo.professionalName];
           // m_charaDetailsView.realmView.text = m_charaInfo.realm;
            m_charaDetailsView.levelLabel.text =[NSString stringWithFormat:@"%@级", m_charaInfo.level];
            m_charaDetailsView.itemlevelView.text = [NSString stringWithFormat:@"%@/%@",m_charaInfo.itemlevel,m_charaInfo.itemlevelequipped] ;//
            m_charaDetailsView.clazzImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%@",m_charaInfo.professionalId]];
            [hud hide:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    cell.upDowmImgView.image = KUIImage(@"die");
   // cell.CountLabel.text = [countLabelArray objectAtIndex:indexPath.row];
    cell.rankingLabel.text = [rankingLabelArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)changePageWithReaml:(CharacterDetailsView*)Creaml
{
    
    NSLog(@"走代理");

}
-(void)changePageWithFriend:(CharacterDetailsView*)Cfriend
{
    NSLog(@"走代理");


}
-(void)changePageWithCountry:(CharacterDetailsView*)Ccountry
{
   NSLog(@"走代理");
}



- (void)didReceiveMemoryWarning
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
