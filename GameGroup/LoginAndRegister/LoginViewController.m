//
//  LoginViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-6.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MessagePageViewController.h"
#import "FriendPageViewController.h"
#import "FindPageViewController.h"
#import "MePageViewController.h"
#import "Custom_tabbar.h"
#import "FindPasswordViewController.h"

#define kLabelFont (14.0)

@interface LoginViewController ()
{
    UITextField* phoneTextField;
    UITextField* passwordTextField;
}
@end

@implementation LoginViewController

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

    [self setTopViewWithTitle:@"用户登录" withBackButton:YES];
    [self setMainView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"登录中...";
}

- (void)setMainView
{
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15 + startX, 300, 40)];
    table_top.image = KUIImage(@"table_top");
    [self.view addSubview:table_top];
    
    UIImageView* table_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 31 + startX, 12, 8)];
    table_arrow.image = KUIImage(@"arrow_bottom");
    [self.view addSubview:table_arrow];
    
    UIImageView* table_middle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 55 + startX, 300, 40)];
    table_middle.image = KUIImage(@"table_middle");
    [self.view addSubview:table_middle];
    
    UIImageView* table_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95 + startX, 300, 40)];
    table_bottom.image = KUIImage(@"table_bottom");
    [self.view addSubview:table_bottom];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 16 + startX, 100, 38)];
    table_label_one.text = @"中国(+86)";
    table_label_one.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:kLabelFont];
    [self.view addSubview:table_label_one];
    
    UILabel* table_label_two = [[UILabel alloc] initWithFrame:CGRectMake(20, 56 + startX, 80, 38)];
    table_label_two.text = @"手机号";
    table_label_two.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_two.font = [UIFont boldSystemFontOfSize:kLabelFont];
    [self.view addSubview:table_label_two];
    
    UILabel* table_label_three = [[UILabel alloc] initWithFrame:CGRectMake(20, 96 + startX, 80, 38)];
    table_label_three.text = @"密 码";
    table_label_three.textColor = kColorWithRGB(128, 128, 128, 1.0);
    table_label_three.font = [UIFont boldSystemFontOfSize:kLabelFont];
    [self.view addSubview:table_label_three];
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 55 + startX, 240, 40)];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.returnKeyType = UIReturnKeyDone;
    phoneTextField.delegate = self;
    phoneTextField.textAlignment = NSTextAlignmentRight;
    phoneTextField.font = [UIFont boldSystemFontOfSize:15.0];
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:phoneTextField];
    
    phoneTextField.text = [SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
    
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 95 + startX, 240, 40)];
    passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.delegate = self;
    passwordTextField.textAlignment = NSTextAlignmentRight;
    passwordTextField.font = [UIFont boldSystemFontOfSize:15.0];
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:passwordTextField];
    
    UIButton* loginButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 150 + startX, 300, 40)];
    [loginButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [loginButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor clearColor];
    [loginButton addTarget:self action:@selector(hitLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton* findPasButton = [[UIButton alloc] initWithFrame:CGRectMake(70, 210 + startX, 80, 40)];
    [findPasButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [findPasButton setTitleColor:kColorWithRGB(128, 128, 128, 1.0) forState:UIControlStateNormal];
    findPasButton.backgroundColor = [UIColor clearColor];
    findPasButton.titleLabel.font = [UIFont boldSystemFontOfSize:kLabelFont];
    [findPasButton addTarget:self action:@selector(hitFindSectetButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findPasButton];
    
    UIButton* registerButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 210 + startX, 100, 40)];
    [registerButton setTitle:@"|    新用户注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:kColorWithRGB(128, 128, 128, 1.0) forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor clearColor];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:kLabelFont];
    [registerButton addTarget:self action:@selector(hitRegisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

}

#pragma mark 登陆
- (void)hitLoginButton:(id)sender
{
    [self hideKeyBoard];
    
    if (KISEmptyOrEnter(phoneTextField.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入手机号！" buttonTitle:@"确定"];
        return;
    }
    if (KISEmptyOrEnter(passwordTextField.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入密码！" buttonTitle:@"确定"];
        return;
    }
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];

    [params setObject:phoneTextField.text forKey:@"username"];
    [params setObject:passwordTextField.text forKey:@"password"];
//    [params setObject:@"15811212096" forKey:@"username"];
//    [params setObject:@"111111" forKey:@"password"];

//    NSString * deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:PushDeviceToken];
    [params setObject:[GameCommon shareGameCommon].deviceToken forKey:@"deviceToken"];
    [params setObject:appType forKey:@"appType"];

    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"101" forKey:@"method"];

    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];

        [[NSUserDefaults standardUserDefaults] setValue:phoneTextField.text forKey:PhoneNumKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDictionary* dic = responseObject;
        [SFHFKeychainUtils storeUsername:LOCALTOKEN andPassword:[[dic objectForKey:@"token"] objectForKey:@"token"] forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:ACCOUNT andPassword:phoneTextField.text forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
        [SFHFKeychainUtils storeUsername:PASSWORD andPassword:passwordTextField.text forServiceName:LOCALACCOUNT updateExisting:YES error:nil];
      
        [DataStoreManager setDefaultDataBase:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] AndDefaultModel:@"LocalStore"];
        [DataStoreManager storeMyUserID:[[dic objectForKey:@"token"] objectForKey:@"userid"]];
        
        [[TempData sharedInstance] SetServer:[[dic objectForKey:@"chatServer"] objectForKey:@"address"] TheDomain:[[dic objectForKey:@"chatServer"] objectForKey:@"name"]];//得到域名
        
        [GameCommon cleanLastData];//因1.0是用username登陆xmpp 后面版本是userid 必须清掉聊天消息和关注表

        [self upLoadUserLocationWithLat:[[TempData sharedInstance] returnLat] Lon:[[TempData sharedInstance] returnLon]];
        [self loginSuccess];

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

- (void)loginSuccess
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
//    NSLog(<#NSString *format, ...#>)
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 上传用户位置 经度 纬度
-(void)upLoadUserLocationWithLat:(double)userLatitude Lon:(double)userLongitude
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSDictionary * locationDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",userLongitude],@"longitude",[NSString stringWithFormat:@"%f",userLatitude],@"latitude", nil];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict setObject:@"108" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];

    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
}

#pragma mark 注册
- (void)hitRegisterButton:(id)sender
{
    [self hideKeyBoard];
    
    RegisterViewController *viewController = [[RegisterViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 找回密码
- (void)hitFindSectetButton:(id)sender
{
    [self hideKeyBoard];
    
//    UIActionSheet* actionSheet = [[UIActionSheet alloc]
//                                  initWithTitle:@"找回密码"
//                                  delegate:self
//                                  cancelButtonTitle:@"取消"
//                                  destructiveButtonTitle:Nil
//                                  otherButtonTitles:@"通过手机号找回密码", @"通过邮箱找回密码", nil];
//    [actionSheet showInView:self.view];
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"找回密码"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"通过手机号找回密码", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    FindPasswordViewController *viewController = [[FindPasswordViewController alloc]init];
    viewController.hidesBottomBarWhenPushed = YES;
    if (buttonIndex == 0) {
        viewController.viewType = FINDPAS_TYPE_PHONENUM;
    }
//    else if(buttonIndex == 1){
//        viewController.viewType = FINDPAS_TYPE_EMAIL;
//    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark 隐藏键盘
- (void)hideKeyBoard
{
    [phoneTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

#pragma mark textField and touch delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (phoneTextField == textField) {
        if (phoneTextField.text.length >= 11 && range.length == 0)//只允许输入11位
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
