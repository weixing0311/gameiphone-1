//
//  EditMessageViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "EditMessageViewController.h"

@interface EditMessageViewController ()
{
    UITextView*   m_contentTextView;
    
    UILabel*       m_ziNumLabel;
    
    NSInteger      m_maxZiShu;
    
    UIDatePicker* m_birthDayPick;
}
@end

@implementation EditMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0];

    switch (self.editType) {
        case EDIT_TYPE_nickName:
        {
            [self setTopViewWithTitle:@"昵称" withBackButton:YES];
            m_maxZiShu = 6;
        } break;
        case EDIT_TYPE_birthday:
        {
            [self setTopViewWithTitle:@"生日" withBackButton:YES];
            m_maxZiShu = 8;

        } break;
        case EDIT_TYPE_signature:
        {
            [self setTopViewWithTitle:@"个性签名" withBackButton:YES];
            m_maxZiShu = 20;
        } break;
        case EDIT_TYPE_hobby:
        {
            [self setTopViewWithTitle:@"个人标签" withBackButton:YES];
            m_maxZiShu = 5;
        } break;
        default:
            break;
    }
    m_contentTextView = [[UITextView alloc] initWithFrame: CGRectMake(10, 10 + startX, 300, 90)];
    m_contentTextView.backgroundColor = [UIColor whiteColor];
    m_contentTextView.font = [UIFont boldSystemFontOfSize:15.0];
    m_contentTextView.delegate = self;
    m_contentTextView.layer.cornerRadius = 5;
    m_contentTextView.layer.masksToBounds = YES;
    [self.view addSubview:m_contentTextView];
    [m_contentTextView becomeFirstResponder];
    
    if (self.editType == EDIT_TYPE_birthday) {
        m_birthDayPick = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        [m_birthDayPick setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        m_birthDayPick.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 280, 320, 236);
        m_birthDayPick.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        m_birthDayPick.datePickerMode = UIDatePickerModeDate;
        m_contentTextView.inputView = m_birthDayPick;//点击弹出的是pickview
        
        UIToolbar* toolbar_server = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbar_server.tintColor = [UIColor blackColor];
        UIBarButtonItem*rb_server = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectBirthdayOK)];
        rb_server.tintColor = [UIColor blackColor];
        toolbar_server.items = @[rb_server];
        m_contentTextView.inputAccessoryView = toolbar_server;//跟着pickview上移
    }
    
    m_ziNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 105 + startX, 150, 20)];
    m_ziNumLabel.textColor = [UIColor grayColor];
    m_ziNumLabel.textAlignment = NSTextAlignmentRight;
    m_ziNumLabel.font = [UIFont systemFontOfSize:12.0f];
    m_ziNumLabel.backgroundColor = [UIColor clearColor];
    m_ziNumLabel.text = [NSString stringWithFormat:@"还可输入%d个字", m_maxZiShu];
    [self.view addSubview:m_ziNumLabel];
    
    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 130 + startX, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [okButton setTitle:@"完 成" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"修改中...";
}

- (void)refreshZiLabelText
{
    NSInteger ziNum = m_maxZiShu - [[GameCommon shareGameCommon] unicodeLengthOfString:m_contentTextView.text];
    
    if(ziNum >= 0)
    {
        m_ziNumLabel.text = [NSString stringWithFormat:@"还可以输入%d字", ziNum];
        m_ziNumLabel.textColor = [UIColor grayColor];
    }
    else
    {
        m_ziNumLabel.text = [NSString stringWithFormat:@"已超过%d字", [[GameCommon shareGameCommon] unicodeLengthOfString:m_contentTextView.text] - m_maxZiShu];
        m_ziNumLabel.textColor = [UIColor redColor];
    }
}


- (void)okButtonClick:(id)sender
{
    [m_contentTextView resignFirstResponder];
    if (KISEmptyOrEnter(m_contentTextView.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入有效的文字！" buttonTitle:@"确定"];
        return;
    }
    NSInteger ziNum = m_maxZiShu - [[GameCommon shareGameCommon] unicodeLengthOfString:m_contentTextView.text];
    if (ziNum < 0) {
        [self showAlertViewWithTitle:@"提示" message:@"输入字数超过上限，请修改！" buttonTitle:@"确定"];
        return;
    }
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    switch (self.editType) {
        case EDIT_TYPE_nickName:
            [paramDict setObject:m_contentTextView.text forKey:@"nickname"];
            break;
        case EDIT_TYPE_birthday:
            [paramDict setObject:m_contentTextView.text forKey:@"birthdate"];
            break;
        case EDIT_TYPE_signature:
            [paramDict setObject:m_contentTextView.text forKey:@"signature"];
            break;
        case EDIT_TYPE_hobby:
            [paramDict setObject:m_contentTextView.text forKey:@"remark"];
            break;
        default:
            break;
    }
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"104" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        
        [DataStoreManager saveUserInfo:responseObject];
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

#pragma mark 返回
- (void)backButtonClick:(id)sender
{
    if (KISEmptyOrEnter(m_contentTextView.text)) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"警告"
                                                    message:@"您这样返回是没有保存的喔！"
                                                   delegate:self
                                          cancelButtonTitle:@"返回"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = 345;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 345) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 生日
- (void)selectBirthdayOK
{
    [m_contentTextView resignFirstResponder];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSString* newDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate: m_birthDayPick.date]];
    NSLog(@"newDate:%@", newDate);
    m_contentTextView.text = newDate;
}

#pragma mark textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshZiLabelText];
}

#pragma mark 手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [m_contentTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
