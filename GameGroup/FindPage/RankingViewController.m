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
@interface RankingViewController ()

@end

@implementation RankingViewController
{
    NSMutableArray *m_cArray;
    UITableView *m_tableView;
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
    //[self getSortDataByNet];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTopViewWithTitle:@"排行榜" withBackButton:YES];

    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height - ( 50 + startX)) style:UITableViewStylePlain];
    m_tableView.rowHeight = 70;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return m_cArray.count;
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    RankingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RankingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleImageView.image = KUIImage(@"ceshi.jpg");
    cell.NumLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.titleLabel.text = @"下一站灬停留";
    cell.serverLabel.text = @"冰霜之刃 - 猎人";
    cell.CountOfLabel.text = @"11500";
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getSortDataByNet
{
    
    
    
//     gameid 游戏id
//     ranktype 排行类型，三个值：1，2，3， 1是好友， 2是全服， 3是全国， 大头衔也就是基本头衔有这个字段值是多个这间用逗号分隔的
//     characterid 角色id
//     rankvaltype 排行值类型， 战斗力还是坐骑等， 值对应大头衔里相应字段的值
//     pageIndex 起始页， 如果传 -1 我就认为是取角色id附近的排名， 会返回这个角色的排行， 如果这个角色的排名就是前几名会返回rank排名为1的，这时pageIndex其实就相当于为0第一页时的返回数据， 所以前端要判断取角色排名的时侯是否返回了rank = 1， 如果有下一页应该是传pageIndex = 1 而不是 pageIndex = 0
//     maxSize  记录数
//     realm  服务器， 全服排行用这个
//     classid  职业id， 全服和全国用这个， 不传默认全职业
    
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"1" forKey:@"gameid"];
    
   // [paramDict setObject:KISDictionaryHaveKey(self.sccDic, @"realm") forKey:@"realm"];
    [paramDict setObject:self.custType forKey:@"classid"];
    
    [paramDict setObject:self.characterid forKey:@"characterid"];
    
    
//    [paramDict setObject:self.cRankvaltype forKey:@"ranktype"];
    [paramDict setObject:@"1,2,3" forKey:@"ranktype"];
    
    [paramDict setObject:self.dRankvaltype forKey:@"rankvaltype"];
    [paramDict setObject:@"0" forKey:@"pageIndex"];
    [paramDict setObject:@"10" forKey:@"maxSize"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"130" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];

    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"RankingresponseObject%@",responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            m_cArray = responseObject;
            [m_tableView reloadData];
        }
        
        
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

@end



/*
 
 itleDic{
 characterid = 158171;
 charactername = "\U6de1\U6de1\U5730\U4f24";
 clazz = 5;
 gameid = 1;
 hasDate = 1392699274000;
 hide = 1;
 id = 160817;
 realm = "\U51b0\U971c\U4e4b\U5203";
 sortnum = 6;
 titleObj =     {
 createDate = 1389340897000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 111;
 img = 501;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = itemlevel;
 rarememo = "1.53%";
 rarenum = 6;
 remark = "\U867d\U7136\U6c38\U6052\U5c9b\U5904\U5904\U5145\U6ee1\U5371\U9669\Uff0c\U4f46\U4e5f\U6709\U5f88\U591a\U4e0d\U9519\U7684\U673a\U9047\Uff0c\U5bcc\U8d35\U9669\U4e2d\U6c42\U554a\Uff01";
 remarkDetail = "\U83b7\U53d6\U6761\U4ef6\Uff1a
 \n\U83b7\U53d6\U88c5\U5907\U5230\U8fbe496\U7ea7\U522b
 \n
 \n\U4e0b\U4e00\U5934\U8854\Uff1a
 \n\U88c5\U5907\U7b49\U7ea7\U5230\U8fbe561";
 simpletitle = "\U7d2b\U88c5\U5f00\U59cb!";
 sortnum = 1;
 title = "\U7d2b\U88c5\U5f00\U59cb!";
 titlekey = "wow_itemlevel_496";
 titletype = "\U88c5\U5907\U7b49\U7ea7";
 };
 titleid = 111;
 userid = 10110253;
 userimg = " ";
 } */