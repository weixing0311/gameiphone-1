//
//  RealmsSelectViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-23.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "RealmsSelectViewController.h"

@interface RealmsSelectViewController ()
{
    UITableView*    m_realmsTableView;
    
    NSMutableDictionary*   m_realmsDic;
    NSArray* m_realmsIndexArray;
}
@end

@implementation RealmsSelectViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setTopViewWithTitle:@"服务器" withBackButton:YES];
    
    m_realmsDic = [[NSMutableDictionary alloc] initWithCapacity:1];
    m_realmsIndexArray = [[NSArray alloc] init];
    
    if ([[[GameCommon shareGameCommon].wow_realms allKeys] count] != 0) {
        [m_realmsDic addEntriesFromDictionary:[GameCommon shareGameCommon].wow_realms];
        
        m_realmsIndexArray = [[m_realmsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    }
    else
    {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        hud.labelText = @"查询中...";
        
        [self firtOpen];
    }
    
    m_realmsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_realmsTableView.delegate = self;
    m_realmsTableView.dataSource = self;
    [self.view addSubview:m_realmsTableView];
}
#pragma mark 开机联网
-(void)firtOpen
{
    [hud show:YES];
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
  
    [paramsDic setObject:@"" forKey:@"gamelist_millis"];
    [paramsDic setObject:@"" forKey:@"wow_realms_millis"];
    [paramsDic setObject:@"" forKey:@"wow_characterclasses_millis"];
    
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramsDic forKey:@"params"];
    [postDict setObject:@"142" forKey:@"method"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide: YES];
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSMutableDictionary* openData = [[NSUserDefaults standardUserDefaults] objectForKey:kOpenData] ? [[NSUserDefaults standardUserDefaults] objectForKey:kOpenData] : [NSMutableDictionary dictionaryWithCapacity:1];
        if ([KISDictionaryHaveKey(responseObject, @"gamelist_update") boolValue]) {
            [openData setObject:KISDictionaryHaveKey(responseObject, @"gamelist") forKey:@"gamelist"];
            [openData setObject:KISDictionaryHaveKey(responseObject, @"gamelist_millis") forKey:@"gamelist_millis"];
        }
        if ([KISDictionaryHaveKey(responseObject, @"wow_characterclasses_update") boolValue]) {
            [openData setObject:KISDictionaryHaveKey(responseObject, @"wow_characterclasses") forKey:@"wow_characterclasses"];
            [openData setObject:KISDictionaryHaveKey(responseObject, @"wow_characterclasses_millis") forKey:@"wow_characterclasses_millis"];
        }
        if ([KISDictionaryHaveKey(responseObject, @"wow_realms_update") boolValue]) {
            [openData setObject:KISDictionaryHaveKey(responseObject, @"wow_realms") forKey:@"wow_realms"];
            [openData setObject:KISDictionaryHaveKey(responseObject, @"wow_realms_millis") forKey:@"wow_realms_millis"];
        }
        [[NSUserDefaults standardUserDefaults] setObject:openData forKey:kOpenData];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([KISDictionaryHaveKey(openData, @"wow_realms") isKindOfClass:[NSDictionary class]]) {//注册服务器数据
            [[GameCommon shareGameCommon].wow_realms addEntriesFromDictionary:KISDictionaryHaveKey(openData, @"wow_realms")];
        }
        if ([KISDictionaryHaveKey(openData, @"wow_characterclasses") isKindOfClass:[NSArray class]]) {
            [[GameCommon shareGameCommon].wow_clazzs addObjectsFromArray:KISDictionaryHaveKey(openData, @"wow_characterclasses")];
        }
        [m_realmsDic addEntriesFromDictionary:[GameCommon shareGameCommon].wow_realms];
        m_realmsIndexArray = [[m_realmsDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        [m_realmsTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        [hud hide: YES];
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
}

#pragma mark 表格
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [m_realmsIndexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [KISDictionaryHaveKey(m_realmsDic, [m_realmsIndexArray objectAtIndex:section]) count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myRealm";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSDictionary* dic = [[m_realmsDic objectForKey:[m_realmsIndexArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        cell.textLabel.text = KISDictionaryHaveKey(dic, @"name");
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_realmsTableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [GameCommon shareGameCommon].selectRealm = [m_realmsTableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.realmSelectDelegate selectOneRealmWithName:[m_realmsTableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 索引
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
//    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
//        return @"";
//    }
    return [m_realmsIndexArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
//        return nil;
//    }
   
    return m_realmsIndexArray;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
