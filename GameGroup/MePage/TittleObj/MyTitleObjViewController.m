//
//  MyTitleObjViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyTitleObjViewController.h"
#import "TitleObjDetailViewController.h"

@interface MyTitleObjViewController ()
{
    UITableView*  m_showTitleObjTable;
    NSMutableArray* m_showDataArray;
    UITableView*  m_hideTitleObjTable;
    NSMutableArray* m_hideDataArray;

    UIButton*     m_showButton;
    UIButton*     m_hideButton;
    
    BOOL          m_isHaveChange;
    
    UIView*       m_warnView;
}
@end

@implementation MyTitleObjViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTopViewWithTitle:@"头衔管理" withBackButton:YES];
    
    m_showDataArray = [[NSMutableArray alloc] init];
    m_hideDataArray = [[NSMutableArray alloc] init];
    
    m_isHaveChange = NO;
    
    m_showTitleObjTable = [[UITableView alloc] initWithFrame:CGRectMake(0, startX + 40, kScreenWidth, kScreenHeigth - startX - 40 - (KISHighVersion_7 ? 0 : 20))];
    m_showTitleObjTable.delegate = self;
    m_showTitleObjTable.dataSource = self;
    m_showTitleObjTable.editing = YES;
    [self.view addSubview:m_showTitleObjTable];
    
    m_hideTitleObjTable = [[UITableView alloc] initWithFrame:CGRectMake(0, startX + 40, kScreenWidth, kScreenHeigth - startX - 40 - (KISHighVersion_7 ? 0 : 20))];
    m_hideTitleObjTable.delegate = self;
    m_hideTitleObjTable.dataSource = self;
    [self.view addSubview:m_hideTitleObjTable];
    m_hideTitleObjTable.hidden = YES;
    
    [self setTopView];
}

- (void)setTopView
{
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(270, startX - 44, 50, 44);
    [addButton setBackgroundImage:KUIImage(@"ok_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"ok_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(saveTitleObjChanged:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, 40)];
    topBg.image = KUIImage(@"segment_bg");
    [self.view addSubview:topBg];
    
    m_showButton = [[UIButton alloc] initWithFrame:CGRectMake(10, startX + 5, 150, 35)];
    [m_showButton setBackgroundImage:KUIImage(@"segment_button_long") forState:UIControlStateSelected];
    [m_showButton setTitle:@"展示的头衔" forState:UIControlStateNormal];
    [m_showButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_showButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    m_showButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_showButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_showButton];
    m_showButton.selected = YES;
    
    m_hideButton = [[UIButton alloc] initWithFrame:CGRectMake(160, startX + 5, 150, 35)];
    [m_hideButton setBackgroundImage:KUIImage(@"segment_button_long") forState:UIControlStateSelected];
    [m_hideButton setTitle:@"隐藏的头衔" forState:UIControlStateNormal];
    [m_hideButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_hideButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    m_hideButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_hideButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_hideButton];
    m_hideButton.selected = NO;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
    
    [self showMessageWithContent:@"按住并拖动列表最右方图标即可实现排序" point:CGPointMake(kScreenWidth/2, kScreenHeigth - 100)];
  
    [self getTitleObjByNet];
}

- (void)segmentChanged:(UIButton*)segButton
{
    if (segButton.selected) {
        return;
    }
    if (segButton == m_showButton) {
        m_showButton.selected = YES;
        m_hideButton.selected = NO;
        m_showTitleObjTable.hidden = NO;
        m_hideTitleObjTable.hidden = YES;
        [m_showTitleObjTable reloadData];
    }
    else if(segButton == m_hideButton)
    {
        m_showButton.selected = NO;
        m_hideButton.selected = YES;
        m_showTitleObjTable.hidden = YES;
        m_hideTitleObjTable.hidden = NO;
        [m_hideTitleObjTable reloadData];
    }
}

- (void)getTitleObjByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"129" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        if ([KISDictionaryHaveKey(responseObject, @"0") isKindOfClass:[NSArray class]]) {//显示的
            [m_showDataArray addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"0")];
        }
        if ([KISDictionaryHaveKey(responseObject, @"1") isKindOfClass:[NSArray class]]) {//隐藏的
            [m_hideDataArray addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"1")];
        }
        [m_showTitleObjTable reloadData];
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

#pragma mark 返回
- (void)backButtonClick:(id)sender
{
    if (m_isHaveChange) {
        UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的改动还未保存，确认要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alter.tag = 75;
        [alter show];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 75) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 按钮
- (void)hideButtonClick:(MyTitleObjShowCell*)myCell
{
    if ([m_showDataArray count] == 1) {
        [self showAlertViewWithTitle:@"提示" message:@"请至少展示一个头衔！" buttonTitle:@"确定"];
        return;
    }
    m_isHaveChange = YES;
    
    NSInteger selectRow = myCell.myIndexPath.row;
    
    [m_hideDataArray insertObject:[m_showDataArray objectAtIndex:selectRow] atIndex:0];
    [m_showDataArray removeObjectAtIndex:selectRow];
    
    [m_showTitleObjTable reloadData];
}

- (void)showButtonClick:(MyTitleObjHideCell*)myCell
{
    if ([m_showDataArray count] >= 10) {
        [self showAlertViewWithTitle:@"提示" message:@"您不可以再展示头衔了！" buttonTitle:@"确定"];
        return;
    }
    m_isHaveChange = YES;

    NSInteger selectRow = myCell.myIndexPath.row;
    
    [m_showDataArray addObject:[m_hideDataArray objectAtIndex:selectRow]];
    [m_hideDataArray removeObjectAtIndex:selectRow];
    
    [m_hideTitleObjTable reloadData];
}

- (void)saveTitleObjChanged:(id)sender
{
    NSString* titleId = @"";
    NSString* hideStatus = @"";
    for (int i = 0; i < [m_showDataArray count]; i++) {
        NSDictionary* showDic = [m_showDataArray objectAtIndex:i];
        if (i != [m_showDataArray count] - 1) {
            titleId = [titleId stringByAppendingFormat:@"%@,", [GameCommon getNewStringWithId:KISDictionaryHaveKey(showDic, @"id")]];
            hideStatus = [hideStatus stringByAppendingString:@"0,"];
        }
        else
        {
            titleId = [titleId stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(showDic, @"id")]];
            hideStatus = [hideStatus stringByAppendingString:@"0"];
        }
    }
    if ([m_showDataArray count] != 0 && [m_hideDataArray count] != 0) {
        titleId = [titleId stringByAppendingString:@","];
        hideStatus = [hideStatus stringByAppendingString:@","];
    }
    for (int i = 0; i < [m_hideDataArray count]; i++) {
        NSDictionary* hideDic = [m_hideDataArray objectAtIndex:i];
        if (i != [m_hideDataArray count] - 1) {
            titleId = [titleId stringByAppendingFormat:@"%@,", [GameCommon getNewStringWithId:KISDictionaryHaveKey(hideDic, @"id")]];
            hideStatus = [hideStatus stringByAppendingString:@"1,"];
        }
        else
        {
            titleId = [titleId stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(hideDic, @"id")]];
            hideStatus = [hideStatus stringByAppendingString:@"1"];
        }
    }
    NSLog(@"%@  %@", titleId, hideStatus);
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:titleId forKey:@"titleid"];
    [paramDict setObject:hideStatus forKey:@"hide"];
    [paramDict setObject:@"modsort" forKey:@"conditionType"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"128" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    hud.labelText = @"修改中...";
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
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

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == m_showTitleObjTable) {
        return [m_showDataArray count];
    }
    else
        return [m_hideDataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_showTitleObjTable) {
        static NSString *CellIdentifier = @"Cell";
        MyTitleObjShowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MyTitleObjShowCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.heardImg.image = KUIImage(@"titleobj_red");
            cell.numLabel.text = @"";
        }
        else
        {
            cell.heardImg.image = KUIImage(@"titleobj_gray");
            cell.numLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row + 1];
        }
        NSDictionary* tempDic = [m_showDataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"titleObj"), @"title");
        cell.nameLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"titleObj"), @"rarenum") integerValue]];
        cell.gameImg.image = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"gameid")] isEqualToString:@"1"] ? KUIImage(@"wow") : KUIImage(@"");
        cell.characterLabel.text = KISDictionaryHaveKey(tempDic, @"charactername");
        
        cell.myIndexPath = indexPath;
        cell.myCellDelegate = self;

        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CellHide";
        MyTitleObjHideCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MyTitleObjHideCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.heardImg.image = KUIImage(@"titleobj_gray");
        cell.numLabel.text = [NSString stringWithFormat:@"%02d", indexPath.row + 1];
    
        NSDictionary* tempDic = [m_hideDataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"titleObj"), @"title");
        cell.nameLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"titleObj"), @"rarenum") integerValue]];
        cell.gameImg.image = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"gameid")] isEqualToString:@"1"] ? KUIImage(@"wow") : KUIImage(@"");
        cell.characterLabel.text = KISDictionaryHaveKey(tempDic, @"charactername");
        
        cell.myIndexPath = indexPath;
        cell.myCellDelegate = self;
        
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)showCellSelectClick:(MyTitleObjShowCell*)myCell//编辑状态下的cell不可点击
{
    TitleObjDetailViewController* detailVC = [[TitleObjDetailViewController alloc] init];
    detailVC.titleObjArray = m_showDataArray;
    detailVC.showIndex = myCell.myIndexPath.row;
    detailVC.isFriendTitle = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_showTitleObjTable)
        return YES;
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == m_showTitleObjTable)
        return YES;
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (tableView == m_hideTitleObjTable)
        return;
    if (sourceIndexPath != destinationIndexPath)
    {
        m_isHaveChange = YES;

        id cellObject = [m_showDataArray objectAtIndex:sourceIndexPath.row];
        [m_showDataArray removeObjectAtIndex:sourceIndexPath.row];
        [m_showDataArray insertObject:cellObject atIndex:destinationIndexPath.row];
        [m_showTitleObjTable reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
