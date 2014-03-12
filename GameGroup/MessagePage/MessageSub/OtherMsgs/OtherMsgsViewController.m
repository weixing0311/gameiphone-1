//
//  OtherMsgsViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 14-1-17.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "OtherMsgsViewController.h"
#import "MessageCell.h"
#import "CharacterEditViewController.h"
#import "MyTitleObjViewController.h"
#import "CharacterDetailsViewController.h"
@interface OtherMsgsViewController ()
{
    UITableView*   m_myTableView;
    
    NSMutableArray*       m_tableData;
}
@end

@implementation OtherMsgsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"角色动态" withBackButton:YES];
    
    m_tableData = (NSMutableArray*)[DataStoreManager queryAllOtherMsg];
    
    UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [deleteButton setBackgroundImage:KUIImage(@"delete_normal") forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:KUIImage(@"delete_click") forState:UIControlStateHighlighted];
    [self.view addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth-startX-(KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];

}
- (void)deleteButtonClick:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确认要清除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag = 345;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 345) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [DataStoreManager cleanOtherMsg];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_tableData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSDictionary * dict = [[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"msgContent"] JSONValue];
    NSLog(@"dicttt%@",dict);
    if([[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"character"])//角色
    {
        NSString* imageName = [self getCharacterHeardWithID:[GameCommon getNewStringWithId:KISDictionaryHaveKey(dict, @"gameid")]];
        cell.headImageV.image = KUIImage(imageName);
    }
    else if([[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"title"])
    {
        NSString* imageName = [self getTitleHeardImgWithID:KISDictionaryHaveKey(dict, @"rarenum")];
        
        cell.headImageV.image = KUIImage(imageName);
        
        cell.nameLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(dict, @"rarenum") integerValue]];
    }
    else if ([[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"pveScore"])
    {
        NSString* imageName = [self getPveScoreHeardWithID:KISDictionaryHaveKey(dict, @"classid")];
        cell.headImageV.image = KUIImage(imageName);
    }
    cell.contentLabel.text = KISDictionaryHaveKey(dict, @"msg");
    
    cell.unreadCountLabel.hidden = YES;
    cell.notiBgV.hidden = YES;
    
    cell.nameLabel.text = [[m_tableData objectAtIndex:indexPath.row] objectForKey:@"myTitle"];
    NSLog(@"cell.nameLabel.text%@",cell.nameLabel.text);
    
    cell.timeLabel.text = [GameCommon CurrentTime:[GameCommon getCurrentTime] AndMessageTime:KISDictionaryHaveKey([m_tableData objectAtIndex:indexPath.row], @"sendTime")];
    return cell;
}

#pragma mark 获取角色等头像
- (NSString*)getCharacterHeardWithID:(NSString*)gameId
{
    if ([gameId isEqualToString:@"1"]) {
        return @"wow";
    }
    return @"";
}

- (NSString*)getPveScoreHeardWithID:(NSString*)characterId
{
    NSInteger imageId = [characterId integerValue];
    if (imageId > 0 && imageId < 12) {//1~11
        return [NSString stringWithFormat:@"clazz_%d", imageId];
    }
    else
        return @"clazz_0.png";
}

- (NSString*)getTitleHeardImgWithID:(NSString*)titleId
{
    NSInteger imageId = [titleId integerValue];
    
    NSString* rarenum = [NSString stringWithFormat:@"rarenum_%d", imageId];
    
    return rarenum;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* tempDict = [m_tableData objectAtIndex:indexPath.row];
    
    if([KISDictionaryHaveKey(tempDict, @"msgType") isEqualToString:@"character"])//角色
    {
        CharacterEditViewController* VC = [[CharacterEditViewController alloc] init];
          VC.isFromMeet =NO;
        [self.navigationController pushViewController:VC animated:YES];
        
        return;
    }
    if([KISDictionaryHaveKey(tempDict, @"msgType") isEqualToString:@"title"])
    {
        MyTitleObjViewController* VC = [[MyTitleObjViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
        
        return;
    }
    if ([KISDictionaryHaveKey(tempDict, @"msgType") isEqualToString:@"pveScore"])
    {
        CharacterDetailsViewController *charVC = [[CharacterDetailsViewController alloc]init];
        NSDictionary * dic = [tempDict[@"msgContent"] JSONValue];
        charVC.characterId = dic[@"characterid"];
        charVC.gameId = @"1";
        charVC.myViewType = CHARA_INFO_MYSELF;
        [self.navigationController pushViewController:charVC animated:YES];
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        NSDictionary* tempDic = [m_tableData objectAtIndex:indexPath.row];
        
        if ([m_tableData count] == 1) {//最后一条
            [DataStoreManager cleanOtherMsg];
        }
        else
        {
            [DataStoreManager deleteOtherMsgWithUUID:KISDictionaryHaveKey(tempDic, @"messageuuid")];
        }
        [m_tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

/*
  message =====<message xmlns="jabber:client" from="sys00000004@gamepro.com" to="10110253@gamepro.com" id="0268a59002bf443aa985647ff641949e" type="chat" msgtype="title" msgTime="1393726203264"><body>{"rarenum":4,"msg":"卡拉赞-竹子控 失去头衔雷霆之怒，逐风者的祝福之剑","gameid":1}</body><payload>{"title": "\u5931\u53bb\u5934\u8854\u96f7\u9706\u4e4b\u6012\uff0c\u9010\u98ce\u8005\u7684\u795d\u798f\u4e4b\u5251"}</payload></message>
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
