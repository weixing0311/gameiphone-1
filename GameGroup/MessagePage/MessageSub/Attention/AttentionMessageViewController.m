//
//  AttentionMessageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AttentionMessageViewController.h"
//#import "MyNormalTableCell.h"
#import "MessageCell.h"
#import "TestViewController.h"
#import "KKChatController.h"
@interface AttentionMessageViewController ()
{
    UITableView*  m_myTableView;
    
    NSMutableArray*     m_tableData;
    NSMutableArray *allHeadImgArray;
    NSMutableArray * allMsgUnreadArray;
    
    NSMutableArray * allNickNameArray;
    NSMutableArray * allSayHelloArray;//id
    NSMutableArray * sayhellocoArray;//内容

}
@end

@implementation AttentionMessageViewController

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
    [m_myTableView reloadData];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSMutableArray *array = (NSMutableArray *)[DataStoreManager qureyAllThumbMessages];
    [self readAllnickNameAndImage];
    [self.dataArray removeAllObjects];
    // NSMutableArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"sayHello_wx_info"];
    for (NSDictionary *dic in array) {
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"sayHello_wx_info"] containsObject:KISDictionaryHaveKey(dic, @"sender")]) {
            [self.dataArray addObject:dic];
        }
    }
    [self readAllnickNameAndImage];
    [m_myTableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"最新关注" withBackButton:YES];
    self.dataArray = [NSMutableArray array];

    allHeadImgArray = [NSMutableArray array];
    allSayHelloArray = [NSMutableArray array];
    allNickNameArray = [NSMutableArray array];
    allMsgUnreadArray = [NSMutableArray array];
    
//    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];

    UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [deleteButton setBackgroundImage:KUIImage(@"delete_normal") forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:KUIImage(@"delete_click") forState:UIControlStateHighlighted];
    [self.view addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
   // m_tableData = (NSMutableArray*)[DataStoreManager queryAllReceivedHellos];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth-startX-(KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
//    m_myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_myTableView];
    [self readAllnickNameAndImage];
}

- (void)backButtonClick:(id)sender
{
   // m_myTableView.editing = NO;
    [self.navigationController popViewControllerAnimated:YES];
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
            [DataStoreManager deleteAllHello];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)readAllnickNameAndImage
{
    NSMutableArray * nickName = [NSMutableArray array];
    NSMutableArray * headimg = [NSMutableArray array];
    NSMutableArray * pinyin = [NSMutableArray array];
    for (int i = 0; i<self.dataArray.count; i++) {
        //        NSString * nickName2 = [DataStoreManager queryRemarkNameForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]];//别名
        NSString * nickName2 = [DataStoreManager queryMsgRemarkNameForUser:[[self.dataArray objectAtIndex:i] objectForKey:@"sender"]];
        [nickName addObject:nickName2?nickName2 : @""];
        NSString * pinyin2 = [[GameCommon shareGameCommon] convertChineseToPinYin:nickName2];
        [pinyin addObject:[pinyin2 stringByAppendingFormat:@"+%@",nickName2]];
        //        [headimg addObject:[DataStoreManager queryFirstHeadImageForUser:[[allMsgArray objectAtIndex:i] objectForKey:@"sender"]]];
        [headimg addObject:[DataStoreManager queryMsgHeadImageForUser:[[self.dataArray objectAtIndex:i] objectForKey:@"sender"]]];
    }
    allNickNameArray = nickName;
    allHeadImgArray = headimg;
}



#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"userCell";
//    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
//    NSString* imgID = [self getHead:[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"headImgID"]];
//    if ([imgID isEqualToString:@""]||[imgID isEqualToString:@" "]) {
//        cell.headImageV.imageURL = nil;
//    }else{
//    if (imgID) {
//        cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@/80",imgID]];
//    }else
//    {
//        cell.headImageV.imageURL = nil;
//    }
//    }
//    cell.contentLabel.text = [[m_tableData objectAtIndex:indexPath.row] objectForKey:@"addtionMsg"];
//    
//    cell.unreadCountLabel.hidden = YES;
//    cell.notiBgV.hidden = YES;
//    
//    cell.nameLabel.text = [[m_tableData objectAtIndex:indexPath.row] objectForKey:@"nickName"];
//    cell.timeLabel.text = @"";
    
    static NSString *identifier = @"userCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];

    NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@/80",[allHeadImgArray objectAtIndex:indexPath.row]]];
    if ([[allHeadImgArray objectAtIndex:indexPath.row]isEqualToString:@""]||[[allHeadImgArray objectAtIndex:indexPath.row]isEqualToString:@" "]) {
        cell.headImageV.imageURL = nil;
    }else{
        cell.headImageV.imageURL = theUrl;
    }
    cell.contentLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"msg"];
  /*  if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>0) {
        cell.unreadCountLabel.hidden = NO;
        cell.notiBgV.hidden = NO;
        if ([[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"recommendfriend"] |
            [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"sayHello"] ||
            [[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"msgType"] isEqualToString:@"deletePerson"]) {
            cell.notiBgV.image = KUIImage(@"redpot");
            cell.unreadCountLabel.hidden = YES;
        }
        else
        {
            [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:indexPath.row]];
            
            if ([[allMsgUnreadArray objectAtIndex:indexPath.row] intValue]>99) {
                [cell.unreadCountLabel setText:@"99+"];
                cell.notiBgV.image = KUIImage(@"redCB_big");
                cell.notiBgV.frame=CGRectMake(40, 8, 22, 18);
                cell.unreadCountLabel.frame =CGRectMake(0, 0, 22, 18);
            }
            else{
                cell.notiBgV.image = KUIImage(@"redCB.png");
                [cell.unreadCountLabel setText:[allMsgUnreadArray objectAtIndex:indexPath.row]];
                cell.notiBgV.frame=CGRectMake(42, 8, 18, 18);
                cell.unreadCountLabel.frame =CGRectMake(0, 0, 18, 18);
            }
        }
    }*/
//    else
//    {
//        cell.unreadCountLabel.hidden = YES;
//        cell.notiBgV.hidden = YES;
//    }
    cell.nameLabel.text = [allNickNameArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = [GameCommon CurrentTime:[[GameCommon getCurrentTime] substringToIndex:10]AndMessageTime:[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"time"] substringToIndex:10]];

    return cell;
}

-(NSString *)getHead:(NSString *)headImgStr
{
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>0) {
        for (NSString* a in i) {
            if (a.length > 0 && ![a isEqualToString:@" "])
                return a;
        }
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    NSDictionary* tempDict = [m_tableData objectAtIndex:indexPath.row];
//    
//   // PersonDetailViewController* detailVC = [[PersonDetailViewController alloc] init];
//    TestViewController *detailVC = [[TestViewController alloc]init];
//    detailVC.userId = KISDictionaryHaveKey(tempDict, @"userid");
//    NSLog(@"detailVC.userId%@",detailVC.userId);
//    detailVC.nickName = KISDictionaryHaveKey(tempDict, @"nickName");
//    detailVC.isChatPage = NO;
//    NSLog(@"最新关注获得数据%@",tempDict);
//    [self.navigationController pushViewController:detailVC animated:YES];
    KKChatController *kkchat = [[KKChatController alloc]init];
    kkchat.nickName = [allHeadImgArray objectAtIndex:indexPath.row];
    kkchat.chatWithUser = [[self.dataArray objectAtIndex:indexPath.row]objectForKey:@"sender"];
    kkchat.chatUserImg = [allHeadImgArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:kkchat animated:YES];
    
    
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
            [DataStoreManager deleteAllHello];
        }
        else
        {
            [DataStoreManager deleteReceivedHelloWithUserId:KISDictionaryHaveKey(tempDic, @"userid") withTime:KISDictionaryHaveKey(tempDic, @"receiveTime")];
        }
        [m_tableData removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
