//
//  AddressListViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "AddressListViewController.h"
#import "MyHeadView.h"
#import "InDoduAddressTableViewCell.h"
#import "OutDodeAddressTableViewCell.h"
//#import "AddSameServerListViewController.h"
#import <MessageUI/MessageUI.h>
@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource,DodeAddressCellDelegate,MFMessageComposeViewControllerDelegate>
{
    UITableView * _tableView;
}
@end

@implementation AddressListViewController

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
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"通讯录好友" withBackButton:NO];
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:10];
    nextButton.frame = CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [nextButton addTarget:self action:@selector(passUploadAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"passButton"] forState:UIControlStateNormal];
    [self.view addSubview:nextButton];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            return _inDudeArray.count;
        }break;
        case 1:{
            return _outDudeArray.count;
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
        view.titleL.text = @"尚未加入陌游的好友";
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
       return 33;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"inDoduCell";
        InDoduAddressTableViewCell *cell = (InDoduAddressTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[InDoduAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSLog(@"%@",_inDudeArray[indexPath.row]);
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.nameL.text = [_inDudeArray[indexPath.row] objectForKey:@"nickname"];
        cell.photoNoL.text = [NSString stringWithFormat:@"手机联系人:%@",[_inDudeArray[indexPath.row] objectForKey:@"addressName"]];
        NSString* imageID = [_inDudeArray[indexPath.row] objectForKey:@"img"];
        if ([imageID componentsSeparatedByString:@","].count>0) {
            imageID = [[imageID componentsSeparatedByString:@","] objectAtIndex:0];
            NSLog(@"%@",imageID);
        }
        cell.headerImage.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl@"%@",imageID]];
        if ([[_inDudeArray[indexPath.row] objectForKey:@"iCare"] integerValue] == 0) {
            [cell.addFriendB setTitle:@"加为好友" forState:UIControlStateNormal];
            cell.addFriendB.userInteractionEnabled = YES;
            [cell.addFriendB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:[UIImage imageNamed:@"addfriend2"] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:[UIImage imageNamed:@"addfriend1"] forState:UIControlStateHighlighted];
        }else
        {
            [cell.addFriendB setTitle:@"等待验证" forState:UIControlStateNormal];
            cell.addFriendB.userInteractionEnabled = NO;
            [cell.addFriendB setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.addFriendB setBackgroundImage:nil forState:UIControlStateHighlighted];
        }
        return cell;
    }else
    {
        static NSString *identifier = @"outDoduCell";
        OutDodeAddressTableViewCell *cell = (OutDodeAddressTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[OutDodeAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.nameL.text = [_outDudeArray[indexPath.row] objectForKey:@"name"];
        cell.photoNoL.text = [_outDudeArray[indexPath.row] objectForKey:@"mobileid"];
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
        NSMutableDictionary * dic = _inDudeArray[indexPath.row];
        [dic setObject:@"1" forKey:@"iCare"];
        [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self showMessageWindowWithContent:@"添加成功" imageType:0];
        NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
        NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
        [paramDict setObject:dic[@"userid"] forKey:@"frienduserid"];
        [paramDict setObject:@"5" forKey:@"type"];
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
    }else
    {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            picker.recipients = [NSArray arrayWithObject:[_outDudeArray[indexPath.row] objectForKey:@"mobileid"]];
            picker.body=[NSString stringWithFormat:@"魔兽世界找不到我的时候, 来陌游找我. 下载地址:www.momotalk.com"];
            [self presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"您的设备不支持短信功能" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
            [alertV show];
        }
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MessageComposeResultSent:{
                [self showMessageWindowWithContent:@"发送成功" imageType:0];
            }break;
            case MessageComposeResultFailed:{
                [self showMessageWindowWithContent:@"发送失败" imageType:0];
            }break;
            default:
                break;
        }
    }];
}
- (void)passUploadAddressBook
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
