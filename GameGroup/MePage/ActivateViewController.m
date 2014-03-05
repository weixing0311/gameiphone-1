//
//  ActivateViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-3.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "ActivateViewController.h"
#import "ImGrilViewController.h"
#import "AddCharacterViewController.h"
#import "MBProgressHUD.h"

@interface ActivateViewController ()
{
    UIScrollView * scV ;
    UITextField * textF;
    MBProgressHUD * hud;
}

@end

@implementation ActivateViewController

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
    scV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeyboard)];
    [scV addGestureRecognizer:tap];
    [self.view addSubview:scV];
    [self setTopViewWithTitle:@"激活账户" withBackButton:YES];
    
    UILabel * lable1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 300, 20)];
    lable1.backgroundColor = [UIColor clearColor];
    lable1.textColor = [UIColor grayColor];
    lable1.font = [UIFont boldSystemFontOfSize:18];
    lable1.text = @"请输入激活码:";
    [scV addSubview:lable1];
    
    UIImageView * image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"text_bg"]];
    image.frame = CGRectMake(10 , 120, 300, 40);
    [scV addSubview:image];
    
    textF = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, 280, 20)];
    [scV addSubview:textF];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(10, 180, 300, 40)];
    [button setTitle:@"激活账户" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_updata_normol"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_updata_click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(activateUser) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:button];
    
    UILabel * lable2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 240, 300, 20)];
    lable2.backgroundColor = [UIColor clearColor];
    lable2.textColor = [UIColor grayColor];
    lable2.font = [UIFont boldSystemFontOfSize:16];
    lable2.text = @"若您没有激活码,亲尝试以下激活方式:";
    [scV addSubview:lable2];
    
    UILabel * numL1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 280, 20, 20)];
    numL1.textColor = [UIColor grayColor];
    numL1.backgroundColor = [UIColor clearColor];
    numL1.text = @"1.";
    numL1.font = [UIFont boldSystemFontOfSize:16];
    [scV addSubview:numL1];
    
    UILabel * lable3 = [[UILabel alloc]initWithFrame:CGRectMake(30, 280, 50, 20)];
    lable3.backgroundColor = [UIColor clearColor];
    lable3.textColor = [UIColor grayColor];
    lable3.font = [UIFont boldSystemFontOfSize:16];
    lable3.text = @"请优先";
    [scV addSubview:lable3];
    
    UIButton * bangdingB = [UIButton buttonWithType:UIButtonTypeCustom];
    bangdingB.frame = CGRectMake(70, 280, 50, 20);
    [bangdingB setTitle:@"绑定" forState:UIControlStateNormal];
    bangdingB.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [bangdingB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [bangdingB addTarget:self action:@selector(boundRole) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:bangdingB];
    
    UILabel * lable4 = [[UILabel alloc]initWithFrame:CGRectMake(112, 280, 190, 20)];
    lable4.backgroundColor = [UIColor clearColor];
    lable4.textColor = [UIColor grayColor];
    lable4.font = [UIFont boldSystemFontOfSize:16];
    lable4.text = @"您的主要角色,若此角色为";
    [scV addSubview:lable4];
    
    UILabel * lable5 = [[UILabel alloc]initWithFrame:CGRectMake(30, 300, 270, 40)];
    lable5.backgroundColor = [UIColor clearColor];
    lable5.numberOfLines = 0;
    lable5.textColor = [UIColor grayColor];
    lable5.font = [UIFont boldSystemFontOfSize:16];
    lable5.text = @"服务器前10名,系统将会自动激活您的账号.";
    [scV addSubview:lable5];
    
    UILabel * numL2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 340, 20, 20)];
    numL2.textColor = [UIColor grayColor];
    numL2.backgroundColor = [UIColor clearColor];
    numL2.text = @"2.";
    numL2.font = [UIFont boldSystemFontOfSize:16];
    [scV addSubview:numL2];
    
    UILabel * lable6 = [[UILabel alloc]initWithFrame:CGRectMake(30, 340, 270, 40)];
    lable6.backgroundColor = [UIColor clearColor];
    lable6.numberOfLines = 0;
    lable6.textColor = [UIColor grayColor];
    lable6.font = [UIFont boldSystemFontOfSize:16];
    lable6.text = @"当您拥有8为好友时,系统将会自动激活您的账号.";
    [scV addSubview:lable6];
    
    UILabel * numL3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, 20, 20)];
    numL3.textColor = [UIColor grayColor];
    numL3.backgroundColor = [UIColor clearColor];
    numL3.text = @"3.";
    numL3.font = [UIFont boldSystemFontOfSize:16];
    [scV addSubview:numL3];
    
    UILabel * lable7 = [[UILabel alloc]initWithFrame:CGRectMake(30, 380, 170, 20)];
    lable7.backgroundColor = [UIColor clearColor];
    lable7.numberOfLines = 0;
    lable7.textColor = [UIColor grayColor];
    lable7.font = [UIFont boldSystemFontOfSize:16];
    lable7.text = @"如果您是妹子,可以通过";
    [scV addSubview:lable7];
    
    UIButton * meiziB = [UIButton buttonWithType:UIButtonTypeCustom];
    meiziB.frame = CGRectMake(187, 380, 80, 20);
    [meiziB setTitle:@"妹子认证" forState:UIControlStateNormal];
    meiziB.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [meiziB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [meiziB addTarget:self action:@selector(ImGirl) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:meiziB];
    
    UILabel * lable8 = [[UILabel alloc]initWithFrame:CGRectMake(260, 380, 40, 20)];
    lable8.backgroundColor = [UIColor clearColor];
    lable8.numberOfLines = 0;
    lable8.textColor = [UIColor grayColor];
    lable8.font = [UIFont boldSystemFontOfSize:16];
    lable8.text = @"激活.";
    [scV addSubview:lable8];
    
    UIImageView * photo1 = [[UIImageView alloc]initWithFrame:CGRectMake(90, 420, 141, 117)];
    photo1.image = [UIImage imageNamed:@"gril1"];
    [scV addSubview:photo1];
    
    scV.contentSize = CGSizeMake(320, 560);
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"激活中...";
}
- (void)ImGirl
{
    ImGrilViewController * grilV = [[ImGrilViewController alloc]init];
    [self.navigationController pushViewController:grilV animated:YES];
}
- (void)boundRole
{
    AddCharacterViewController* addVC = [[AddCharacterViewController alloc] init];
    addVC.viewType = CHA_TYPE_Add;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)activateUser
{
    [textF resignFirstResponder];
    if (!textF.text.length>0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入激活码" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:textF.text forKey:@"invitationCode"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"156" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    hud.labelText = @"获取中...";
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self showMessageWindowWithContent:@"激活成功" imageType:0];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"acta" object:nil userInfo:nil];
        
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
-  (void)cancelKeyboard
{
    [textF resignFirstResponder];
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
