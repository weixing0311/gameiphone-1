//
//  FeedBackViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()
{
    UITextView*   m_contentTextView;
}
@end

@implementation FeedBackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTopViewWithTitle:@"反馈" withBackButton:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];
    
    m_contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 + startX, 300, 100)];
    m_contentTextView.backgroundColor = [UIColor whiteColor];
    m_contentTextView.font = [UIFont boldSystemFontOfSize:15.0];
    m_contentTextView.delegate = self;
    m_contentTextView.layer.cornerRadius = 5;
    m_contentTextView.layer.masksToBounds = YES;
    [self.view addSubview:m_contentTextView];
    [m_contentTextView becomeFirstResponder];

    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 125 + startX, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [okButton setTitle:@"提 交" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"提交中...";
}

- (void)okButtonClick:(id)sender
{
    if (KISEmptyOrEnter(m_contentTextView.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入您的反馈意见，谢谢！" buttonTitle:@"确定"];
        return;
    }
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:m_contentTextView.text ,@"msg",@"Platform=iphone", @"detail",nil];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:@"139" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:dic forKey:@"params"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self showMessageWindowWithContent:@"成功" imageType:0];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
