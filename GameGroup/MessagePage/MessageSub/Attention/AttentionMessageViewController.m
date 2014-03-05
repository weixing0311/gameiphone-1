//
//  AttentionMessageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AttentionMessageViewController.h"
//#import "MyNormalTableCell.h"
#import "PersonDetailViewController.h"
#import "MessageCell.h"

@interface AttentionMessageViewController ()
{
    UITableView*  m_myTableView;
    
    NSMutableArray*     m_tableData;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"最新关注" withBackButton:YES];
    
//    [AFImageRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"multipart/form-data"]];

    UIButton *deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [deleteButton setBackgroundImage:KUIImage(@"delete_normal") forState:UIControlStateNormal];
    [deleteButton setBackgroundImage:KUIImage(@"delete_click") forState:UIControlStateHighlighted];
    [self.view addSubview:deleteButton];
    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    m_tableData = (NSMutableArray*)[DataStoreManager queryAllReceivedHellos];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth-startX-(KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
//    m_myTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_myTableView];
}

- (void)backButtonClick:(id)sender
{
    m_myTableView.editing = NO;
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
    cell.headImageV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[self getHead:[[m_tableData objectAtIndex:indexPath.row] objectForKey:@"headImgID"]]]];
    cell.contentLabel.text = [[m_tableData objectAtIndex:indexPath.row] objectForKey:@"addtionMsg"];
    
    cell.unreadCountLabel.hidden = YES;
    cell.notiBgV.hidden = YES;
    
    cell.nameLabel.text = [[m_tableData objectAtIndex:indexPath.row] objectForKey:@"nickName"];
    cell.timeLabel.text = @"";

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
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* tempDict = [m_tableData objectAtIndex:indexPath.row];
    
    PersonDetailViewController* detailVC = [[PersonDetailViewController alloc] init];
    
    detailVC.userId = KISDictionaryHaveKey(tempDict, @"userid");
    NSLog(@"detailVC.userId%@",detailVC.userId);
    detailVC.nickName = KISDictionaryHaveKey(tempDict, @"nickName");
    detailVC.isChatPage = NO;
    NSLog(@"最新关注获得数据%@",tempDict);
    [self.navigationController pushViewController:detailVC animated:YES];
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
