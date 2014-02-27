//
//  SetViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "SetViewController.h"
#import "NormalTableCell.h"
#import "EGOCache.h"
#import "AppDelegate.h"
#import "AboutViewController.h"

@interface SetViewController ()
{
    UITableView*  m_myTableView;
    BOOL isOver;
}
@end

@implementation SetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"设置" withBackButton:YES];

    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20)) style:UITableViewStyleGrouped];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
}

#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    NormalTableCell *cell = (NormalTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[NormalTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                cell.leftImageView.image = KUIImage(@"me_set_info");
                cell.titleLable.text = @"关于小伙伴";
            }
            else
            {
                cell.leftImageView.image = KUIImage(@"me_set_delete");
                cell.titleLable.text = @"清理缓存";
            }
        } break;
        case 1:
        {
            cell.leftImageView.image = KUIImage(@"me_set_exit");
            cell.titleLable.text = @"退出登录";
        } break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                AboutViewController* VC = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else
            {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您确认要清除所有的缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
                
                alert.tag = 110;
                [alert show];
            }
        } break;
        case 1:
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您确认要退出登陆吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            alert.tag = 111;
            [alert show];
        } break;
        default:
            break;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (110 == alertView.tag) {
            [[EGOCache globalCache] clearCache];
//            NSFileManager *file_manager = [NSFileManager defaultManager];
//            NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
//            [file_manager removeItemAtPath:path error:nil];
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.labelText = @"清理中...";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(3);
                hud.customView = [[UIImageView alloc]initWithImage:KUIImage(@"ok_click")];

                hud.labelText = @"清理成功";
                
                sleep(1);
            }];

            NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
            NSFileManager *fm = [NSFileManager defaultManager];
            NSDirectoryEnumerator *e = [fm enumeratorAtPath:cache];
            NSString *fileName = nil;
              while (fileName = [e nextObject]) {
                  NSError *error = nil;
                  NSString *filePath = [cache stringByAppendingPathComponent:fileName];
                  BOOL flag =[fm removeItemAtPath:filePath error:&error];
                  NSLog(@"%d %@",flag,[error localizedDescription]);
                  
              }
        }
        else if(111 == alertView.tag)
        {
            [self loginOutNet];
        }

    }
}

- (unsigned long long)fileSizeAtPath:(NSString*) filePath
{
    NSDictionary* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [[attr objectForKey:NSFileSize] unsignedLongLongValue];
}
- (void)loginOutNet
{
//    XMPPHelper *xmppHelper = [[XMPPHelper alloc]init];
   
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
//    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"102" forKey:@"method"];//退出登陆
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"layoutresponseObject%@", responseObject);
        [GameCommon loginOut];//注销

        [self.navigationController popViewControllerAnimated:NO];

    } failure:^(AFHTTPRequestOperation *operation, id error) {

    }];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
