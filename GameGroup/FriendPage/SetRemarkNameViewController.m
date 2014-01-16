//
//  SetRemarkNameViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-18.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "SetRemarkNameViewController.h"

@interface SetRemarkNameViewController ()
{
    UITextField*    m_remarkText;
}
@end

@implementation SetRemarkNameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"备注" withBackButton:YES];
    
    [self setMainView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"修改中...";
}

- (void)backButtonClick:(id)sender
{
    if (!KISEmptyOrEnter(m_remarkText.text)) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您这样返回是没有保存的喔！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 100;
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (alertView.cancelButtonIndex != buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)setMainView
{
    UILabel *titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, startX + 10, 300, 30) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0] text:[NSString stringWithFormat:@"原名：%@", self.nickName] textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:titleLabel];
    
    UIImageView* textBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, startX + 50, 300, 40)];
    textBg.image = KUIImage(@"text_bg");
    [self.view addSubview:textBg];
    
    m_remarkText = [[UITextField alloc] initWithFrame:CGRectMake(20, 50 + startX, 280, 40)];
    m_remarkText.placeholder = @"备注名称";
    m_remarkText.returnKeyType = UIReturnKeyDone;
    m_remarkText.delegate = self;
    m_remarkText.font = [UIFont boldSystemFontOfSize:15.0];
    m_remarkText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_remarkText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_remarkText];
    [m_remarkText becomeFirstResponder];
    
    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 105 + startX, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [okButton setTitle:@"完 成" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
}

- (void)okButtonClick:(id)sender
{
    [m_remarkText resignFirstResponder];
    if (KISEmptyOrEnter(m_remarkText.text)) {
//        [self showAlertViewWithTitle:@"提示" message:@"请输入备注名称" buttonTitle:@"确定"];
//        return;
        m_remarkText.text = @"";
    }
    else if([[GameCommon shareGameCommon] unicodeLengthOfString:m_remarkText.text] > 6)
    {
        [self showAlertViewWithTitle:@"提示" message:@"备注名称最长6个汉字" buttonTitle:@"确定"];
        return;
    }
  
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
   
    [paramDict setObject:self.userId forKey:@"frienduserid"];
    [paramDict setObject:m_remarkText.text forKey:@"friendalias"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"117" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        if (self.isFriend) {
            [DataStoreManager saveFriendRemarkName:m_remarkText.text userName:self.userName];
        }
        else
        {
            [DataStoreManager saveAttentionRemarkName:m_remarkText.text userName:self.userName];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];

}

#pragma mark textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_remarkText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
