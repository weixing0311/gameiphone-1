//
//  FindPasswordViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-9.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController ()
{
    UITextField*   m_emailText;
    
    UIScrollView* m_phoneNumView;
    UITextField*  m_phoneNumText;
    
    UIScrollView* m_verCodeView;
    UITextField*  m_verCodeText;
    UIButton*     m_refreshVCButton;
    
    NSTimer*      m_verCodeTimer;
    NSInteger     m_leftTime;
    
    UIScrollView* m_newPasswordView;
    UITextField*  m_newPassText_one;
    UITextField*  m_newPassText_two;
}
@end

@implementation FindPasswordViewController

@synthesize viewType;

- (void)viewWillDisappear:(BOOL)animated
{
    if ([m_verCodeTimer isValid]) {
        [m_verCodeTimer invalidate];
        m_verCodeTimer = nil;
    }

    [super viewWillDisappear: animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"重置密码" withBackButton:YES];

    switch (self.viewType) {
        case FINDPAS_TYPE_EMAIL:
            [self setEmailFindView];
            break;
        case FINDPAS_TYPE_PHONENUM:
            [self setPhoneFindView];
            break;
        default:
            break;
    }
}
#pragma mark 手机号码找回
- (void)setPhoneFindView
{
    m_phoneNumView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX, 320, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_phoneNumView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_phoneNumView];
    
    m_verCodeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX, 320, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_verCodeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_verCodeView];
    m_verCodeView.hidden = YES;
    
    m_newPasswordView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX, 320, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_newPasswordView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_newPasswordView];
    m_newPasswordView.hidden = YES;
    
    [self setPhoneView];
    [self setVerCodeView];
    [self setNewPassView];
}

#pragma mark 输入手机号
- (void)setPhoneView
{
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 300, 40)];
    table_top.image = KUIImage(@"table_top");
    [m_phoneNumView addSubview:table_top];
    
    UIImageView* table_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 31, 12, 8)];
    table_arrow.image = KUIImage(@"arrow_bottom");
    [m_phoneNumView addSubview:table_arrow];
    
    UIImageView* table_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55, 300, 40)];
    table_bottom.image = KUIImage(@"table_bottom");
    [m_phoneNumView addSubview:table_bottom];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 16, 100, 38)];
    table_label_one.text = @"中国(+86)";
    table_label_one.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [m_phoneNumView addSubview:table_label_one];
    
    m_phoneNumText = [[UITextField alloc] initWithFrame:CGRectMake(20, 55, 280, 40)];
    m_phoneNumText.font = [UIFont boldSystemFontOfSize:15.0];
    m_phoneNumText.placeholder = @"输入与小伙伴绑定的手机号码";
    m_phoneNumText.returnKeyType = UIReturnKeyDone;
    m_phoneNumText.delegate = self;
    m_phoneNumText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_phoneNumText.keyboardType = UIKeyboardTypeNumberPad;
    m_phoneNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_phoneNumView addSubview:m_phoneNumText];

    UIButton* phoneNextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    [phoneNextButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [phoneNextButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [phoneNextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [phoneNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    phoneNextButton.backgroundColor = [UIColor clearColor];
    [phoneNextButton addTarget:self action:@selector(phoneNextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_phoneNumView addSubview:phoneNextButton];
}

- (void)phoneNextButtonClick:(id)sender
{
    [m_phoneNumText resignFirstResponder];
    if (KISEmptyOrEnter(m_phoneNumText.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入手机号码！" buttonTitle:@"确定"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:m_phoneNumText.text forKey:@"phoneNum"];
    [params setObject:@"findpwd" forKey:@"type"];

    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"112" forKey:@"method"];
    
    hud.labelText = @"获取中...";
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
        topLabel.numberOfLines = 2;
        topLabel.font = [UIFont boldSystemFontOfSize:13.0];
        topLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
        topLabel.text = [NSString stringWithFormat:@"验证码已发送至手机号：%@，请注意查收！", m_phoneNumText.text];
        [m_verCodeView addSubview:topLabel];
        
        m_phoneNumView.hidden = YES;
        m_verCodeView.hidden = NO;
        
        [self startRefreshTime];
        
        [hud hide:YES];
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

#pragma mark 输入验证码
- (void)setVerCodeView
{
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 235, 40)];
    table_top.image = KUIImage(@"text_bg");
    [m_verCodeView addSubview:table_top];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 61, 80, 38)];
    table_label_one.text = @"验证码";
    table_label_one.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [m_verCodeView addSubview:table_label_one];

    m_leftTime = 60;
    
    m_verCodeText = [[UITextField alloc] initWithFrame:CGRectMake(100, 60, 130, 40)];
    m_verCodeText.placeholder = @"请输入验证码";
    m_verCodeText.returnKeyType = UIReturnKeyDone;
    m_verCodeText.delegate = self;
    m_verCodeText.textAlignment = NSTextAlignmentRight;
    m_verCodeText.font = [UIFont boldSystemFontOfSize:15.0];
    m_verCodeText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_verCodeText.keyboardType = UIKeyboardTypeNumberPad;
    m_verCodeText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_verCodeView addSubview:m_verCodeText];
    
    m_refreshVCButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 60, 60, 40)];
    [m_refreshVCButton setBackgroundImage:KUIImage(@"gray_button_normal") forState:UIControlStateNormal];
    [m_refreshVCButton setBackgroundImage:KUIImage(@"gray_button") forState:UIControlStateSelected];
    [m_refreshVCButton setBackgroundImage:KUIImage(@"gray_button_click") forState:UIControlStateHighlighted];
    [m_refreshVCButton setTitleColor:kColorWithRGB(153, 153, 153, 1.0) forState:UIControlStateSelected];
    [m_refreshVCButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
    [m_refreshVCButton addTarget:self action:@selector(refreshVCButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    m_refreshVCButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_refreshVCButton setTitle:@"60s" forState:UIControlStateNormal];
    [m_verCodeView addSubview:m_refreshVCButton];
    
    UIButton* vercodeNextButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110, 300, 40)];
    [vercodeNextButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [vercodeNextButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [vercodeNextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [vercodeNextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    vercodeNextButton.backgroundColor = [UIColor clearColor];
    [vercodeNextButton addTarget:self action:@selector(vercodeNextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_verCodeView addSubview:vercodeNextButton];
}
#pragma mark -重新发送验证码
- (void)refreshVCButtonClick:(id)sender
{

    //以下应为获取成功后
   //[self startRefreshTime];
    
//    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
//    [params setObject:m_phoneNumText.text forKey:@"phoneNum"];
//    [params setObject:@"register" forKey:@"type"];
//    
//    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
//    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
//    [body setObject:params forKey:@"params"];
//    [body setObject:@"112" forKey:@"method"];
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:m_phoneNumText.text forKey:@"phoneNum"];
    [params setObject:@"findpwd" forKey:@"type"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"112" forKey:@"method"];
    
    hud.labelText = @"获取中...";
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 50)];
        topLabel.numberOfLines = 2;
        topLabel.font = [UIFont boldSystemFontOfSize:13.0];
        topLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
        topLabel.text = [NSString stringWithFormat:@"验证码已发送至手机号：%@，请注意查收！", m_phoneNumText.text];
        [m_verCodeView addSubview:topLabel];
        
        m_phoneNumView.hidden = YES;
        m_verCodeView.hidden = NO;
        
        [self startRefreshTime];
        
        [hud hide:YES];
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

- (void)startRefreshTime
{
    m_refreshVCButton.selected = YES;
    m_refreshVCButton.userInteractionEnabled = NO;
    m_leftTime = 60;
    
    if ([m_verCodeTimer isValid]) {
        [m_verCodeTimer invalidate];
        m_verCodeTimer = nil;
    }
    [m_refreshVCButton setTitle:@"60s" forState:UIControlStateSelected];
    m_verCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refrenshVerCodeTime) userInfo:nil repeats:YES];
}

- (void)refrenshVerCodeTime
{
    m_leftTime--;
    if (m_leftTime == 0) {
        m_refreshVCButton.selected = NO;
        [m_refreshVCButton setTitle:@"重发" forState:UIControlStateNormal];
        m_refreshVCButton.userInteractionEnabled = YES;
        if([m_verCodeTimer isValid])
        {
            [m_verCodeTimer invalidate];
            m_verCodeTimer = nil;
        }
    }
    else
        [m_refreshVCButton setTitle:[NSString stringWithFormat:@"%ds", m_leftTime] forState:UIControlStateSelected];
}
#pragma mark -获取验证码 下一步
- (void)vercodeNextButtonClick:(id)sender
{
    [m_verCodeText resignFirstResponder];
    if (KISEmptyOrEnter(m_verCodeText.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入验证码！" buttonTitle:@"确定"];
        return;
    }

    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:m_phoneNumText.text forKey:@"phoneNum"];
    [params setObject:m_verCodeText.text forKey:@"xcode"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"113" forKey:@"method"];
    
    hud.labelText = @"验证中...";
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([m_verCodeTimer isValid]) {
            [m_verCodeTimer invalidate];
            m_verCodeTimer = nil;
        }
        
        m_verCodeView.hidden = YES;
        m_newPasswordView.hidden = NO;
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

#pragma mark 输入新密码
- (void)setNewPassView
{
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
    topLabel.numberOfLines = 2;
    topLabel.font = [UIFont boldSystemFontOfSize:15.0];
    topLabel.textColor = kColorWithRGB(103.0, 103.0, 103.0, 1.0);
    topLabel.text = @"请输入新密码";
    [m_newPasswordView addSubview:topLabel];
    
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, 40)];
    table_top.image = KUIImage(@"table_top");
    [m_newPasswordView addSubview:table_top];
    
    UIImageView* table_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 300, 40)];
    table_bottom.image = KUIImage(@"table_bottom");
    [m_newPasswordView addSubview:table_bottom];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 36, 100, 38)];
    table_label_one.text = @"新密码";
    table_label_one.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [m_newPasswordView addSubview:table_label_one];
    
    UILabel* table_label_two = [[UILabel alloc] initWithFrame:CGRectMake(20, 76, 100, 38)];
    table_label_two.text = @"重复密码";
    table_label_two.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_two.font = [UIFont boldSystemFontOfSize:15.0];
    [m_newPasswordView addSubview:table_label_two];

    m_newPassText_one = [[UITextField alloc] initWithFrame:CGRectMake(100, 36, 200, 40)];
    m_newPassText_one.placeholder = @"请输入新密码";
    m_newPassText_one.secureTextEntry = YES;
    m_newPassText_one.returnKeyType = UIReturnKeyDone;
    m_newPassText_one.delegate = self;
    m_newPassText_one.textAlignment = NSTextAlignmentRight;
    m_newPassText_one.font = [UIFont boldSystemFontOfSize:15.0];
    m_newPassText_one.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPassText_one.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_newPasswordView addSubview:m_newPassText_one];
    
    m_newPassText_two = [[UITextField alloc] initWithFrame:CGRectMake(100, 75, 200, 40)];
    m_newPassText_two.placeholder = @"请再次输入密码";
    m_newPassText_two.secureTextEntry = YES;
    m_newPassText_two.returnKeyType = UIReturnKeyDone;
    m_newPassText_two.delegate = self;
    m_newPassText_two.textAlignment = NSTextAlignmentRight;
    m_newPassText_two.font = [UIFont boldSystemFontOfSize:15.0];
    m_newPassText_two.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_newPassText_two.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_newPasswordView addSubview:m_newPassText_two];
    
    UILabel* bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 30)];
    bottomLabel.font = [UIFont boldSystemFontOfSize:13.5];
    bottomLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
    bottomLabel.text = @"密码长度最少6位，为保证安全性，不要过于简单";
    [m_newPasswordView addSubview:bottomLabel];
    
    UIButton* newPassButtonOK = [[UIButton alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
    [newPassButtonOK setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [newPassButtonOK setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [newPassButtonOK setTitle:@"完成" forState:UIControlStateNormal];
    [newPassButtonOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    newPassButtonOK.backgroundColor = [UIColor clearColor];
    [newPassButtonOK addTarget:self action:@selector(newPassButtonOKClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_newPasswordView addSubview:newPassButtonOK];
}

- (void)newPassButtonOKClick:(id)sender
{
    [m_newPassText_one resignFirstResponder];
    [m_newPassText_two resignFirstResponder];
    if (m_newPassText_one.text.length < 6) {
        [self showAlertViewWithTitle:@"提示" message:@"新密码长度最少6位！" buttonTitle:@"确定"];
        return;
    }
    else if (![m_newPassText_one.text isEqualToString:m_newPassText_two.text])
    {
        [self showAlertViewWithTitle:@"提示" message:@"两次密码输入不一致！" buttonTitle:@"确定"];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:m_phoneNumText.text forKey:@"phoneNum"];
    [params setObject:m_verCodeText.text forKey:@"xcode"];
    [params setObject:m_newPassText_one.text forKey:@"password"];

    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"138" forKey:@"method"];
    
    hud.labelText = @"修改中...";
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
 
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 199992;
        [alertView show];
        
       // [self.navigationController popViewControllerAnimated:YES];

    } failure:^(AFHTTPRequestOperation *operation,  id error) {
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==199992) {
         [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 邮箱找回
- (void)setEmailFindView
{
    UILabel* topLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5 + startX, 300, 50)];
    topLabel.numberOfLines = 2;
    topLabel.font = [UIFont boldSystemFontOfSize:13.0];
    topLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
    topLabel.text = @"密码重置链接将发送到您注册的邮箱，如果未能收取到邮件，请检查您邮箱内的“垃圾邮件”文件夹";
    [self.view addSubview:topLabel];
    
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60 + startX, 300, 40)];
    table_top.image = KUIImage(@"text_bg");
    [self.view addSubview:table_top];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 61 + startX, 80, 38)];
    table_label_one.text = @"注册邮箱";
    table_label_one.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_one];

    m_emailText = [[UITextField alloc] initWithFrame:CGRectMake(100, 60 + startX, 200, 40)];
    m_emailText.placeholder = @"请输入您的注册邮箱";
    m_emailText.returnKeyType = UIReturnKeyDone;
    m_emailText.keyboardType = UIKeyboardTypeEmailAddress;
    m_emailText.delegate = self;
    m_emailText.textAlignment = NSTextAlignmentRight;
    m_emailText.font = [UIFont boldSystemFontOfSize:15.0];
    m_emailText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_emailText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_emailText];

    UIButton* emailButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 115 + startX, 300, 40)];
    [emailButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [emailButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [emailButton setTitle:@"重置密码" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    emailButton.backgroundColor = [UIColor clearColor];
    [emailButton addTarget:self action:@selector(emailButtonOK:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailButton];

}

- (void)emailButtonOK:(id)sender
{
    if (![[GameCommon shareGameCommon] isValidateEmail:m_emailText.text]) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入正确的邮箱格式！" buttonTitle:@"确定"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark textField and touch delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (m_phoneNumText == textField) {
        if (m_phoneNumText.text.length >= 11 && range.length == 0)//只允许输入11位
        {
            return  NO;
        }
        else//只允许输入数字
        {
            if (range.length == 1)//如果是输入字符，range的length会为0,删除字符为1
            {//判断如果是删除字符，就直接返回yes
                return YES;
            }
            NSCharacterSet *cs;
            cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            BOOL canChange = [string isEqualToString:filtered];
            
            return canChange;
        }
    }
    else if(m_verCodeText == textField)
    {
        if (range.length == 1)//如果是输入字符，range的length会为0,删除字符为1
        {//判断如果是删除字符，就直接返回yes
            return YES;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
        BOOL canChange = [string isEqualToString:filtered];
        
        return canChange;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
