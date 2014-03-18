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
@property (nonatomic,retain) NSMutableArray * guildArray;//服务器好友列表
@end

@implementation AddSameServerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.guildArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"推荐达人" withBackButton:YES];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _guildArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *cellIdentifier = @"headerView";
    MyHeadView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cellIdentifier];
    if (view == nil) {
        view = [[MyHeadView alloc]initWithReuseIdentifier:cellIdentifier];
    }
    view.titleL.text = [NSString stringWithFormat:@"%@服务器的达人",[[TempData sharedInstance] gamerealm]];
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
        NSString* imageID = [_guildArray[indexPath.row] objectForKey:@"img"];
        if ([imageID componentsSeparatedByString:@","].count>0) {
            imageID = [[imageID componentsSeparatedByString:@","] objectAtIndex:0];
            NSLog(@"%@",imageID);
        }
        cell.nameL.text = [_guildArray[indexPath.row] objectForKey:@"charactername"];
        cell.photoNoL.text =[_guildArray[indexPath.row] objectForKey:@"nickname"];
        cell.headerImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@/80",imageID]];
        if ([[_guildArray[indexPath.row] objectForKey:@"iCare"] integerValue] == 0) {
            [cell.addFriendB setTitle:@"加为好友" forState:UIControlStateNormal];
            cell.addFriendB.userInteractionEnabled = YES;
            [cell.addFriendB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:[UIImage imageNamed:@"addfriend2"] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:[UIImage imageNamed:@"addfriend1"] forState:UIControlStateHighlighted];
        }else
        {
            [cell.addFriendB setTitle:@"已添加" forState:UIControlStateNormal];
            cell.addFriendB.userInteractionEnabled = NO;
            [cell.addFriendB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
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
    NSMutableDictionary * dic = _guildArray[indexPath.row];
    [dic setObject:@"1" forKey:@"iCare"];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:dic[@"userid"] forKey:@"frienduserid"];
    [paramDict setObject:@"1" forKey:@"type"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"109" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
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
        for (NSDictionary * dic in responseObject[@"guild"]) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dict setObject:@"0" forKey:@"iCare"];
            [_guildArray addObject:dict];
        }
        [_tableView reloadData];
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
