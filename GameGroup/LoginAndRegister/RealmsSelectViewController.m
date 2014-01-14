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
//        m_realmsIndexArray = [m_realmsDic allKeys];
    }
    
    m_realmsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_realmsTableView.delegate = self;
    m_realmsTableView.dataSource = self;
    [self.view addSubview:m_realmsTableView];
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
