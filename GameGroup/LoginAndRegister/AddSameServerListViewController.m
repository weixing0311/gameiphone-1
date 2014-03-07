//
//  AddSameServerListViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-7.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "AddSameServerListViewController.h"
#import "MyHeadView.h"
#import "InDoduAddressTableViewCell.h"
#import "OutDodeAddressTableViewCell.h"
@interface AddSameServerListViewController ()<UITableViewDelegate,UITableViewDataSource,DodeAddressCellDelegate>
{
    UITableView * _tableView;
}
@property (nonatomic,retain) NSMutableArray * guildArray;
@property (nonatomic,retain) NSMutableArray * realmArray;
@end

@implementation AddSameServerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.guildArray = [NSMutableArray array];
        self.realmArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"游戏小伙伴" withBackButton:YES];
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:10];
    nextButton.frame = CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [nextButton addTarget:self action:@selector(passSameServer) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"passButton"] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
    [self loadSameServerList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return 0;
        }break;
        case 1:{
            return 0;
        }break;
        default:{
            return 0;
        }break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"headerView";
    MyHeadView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (view == nil) {
        view = [[MyHeadView alloc]initWithReuseIdentifier:cellIdentifier];
    }
    if (section == 0) {
        view.titleL.text = @"同工会的好友";
    }else{
        view.titleL.text = [NSString stringWithFormat:@"%@服务器的达人",[[TempData sharedInstance] gamerealm]];
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"inDoduCell";
        InDoduAddressTableViewCell *cell = (InDoduAddressTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[InDoduAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }else
    {
        static NSString *identifier = @"inDoduCell";
        InDoduAddressTableViewCell *cell = (InDoduAddressTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[InDoduAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)DodeAddressCellTouchButtonWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }else
    {
        
    }
}
- (void)passSameServer
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)loadSameServerList
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"gameid"];
    if ([[TempData sharedInstance] characterID]) {
        [params setObject:[[TempData sharedInstance] characterID] forKey:@"characterid"];
    }
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"163" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
