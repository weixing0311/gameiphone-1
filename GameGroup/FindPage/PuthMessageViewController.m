//
//  PuthMessageViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-12.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "PuthMessageViewController.h"
#import <MessageUI/MessageUI.h>
@interface PuthMessageViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation PuthMessageViewController

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
    [self setTopViewWithTitle:@"通讯录好友" withBackButton:YES];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(30, 77.5, 40, 45)];
    imageV.image = [UIImage imageNamed:@"addressBookIcon"];
    [self.view addSubview:imageV];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 200, 20)];
    label1.text = _addressDic[@"name"];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor blackColor];
    [self.view addSubview:label1];
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 200, 20)];
    label2.text = [NSString stringWithFormat:@"手机号:%@",_addressDic[@"mobileid"]];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.text = [NSString stringWithFormat:@"%@还未开通陌游",_addressDic[@"name"]];
    [self.view addSubview:label3];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发送邀请" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_updata_normol"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_updata_click"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(30, 180, 260, 40);
    [button addTarget:self action:@selector(puthMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}
- (void)puthMessage
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.recipients = @[_addressDic[@"mobileid"]];
        picker.body=[NSString stringWithFormat:@"魔兽世界找不到我的时候, 来陌游找我. 下载地址:www.momotalk.com"];
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    else {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"您的设备不支持短信功能" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alertV show];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
