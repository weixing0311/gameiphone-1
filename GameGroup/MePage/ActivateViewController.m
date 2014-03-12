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
#import "DataStoreManager.h"
#import "AddContactViewController.h"
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
    
    UITextView * lable2 = [[UITextView alloc]initWithFrame:CGRectMake(10, 240, 300, 60)];
    lable2.userInteractionEnabled = NO;
    lable2.backgroundColor = [UIColor clearColor];
    lable2.textColor = [UIColor grayColor];
    lable2.font = [UIFont boldSystemFontOfSize:16];
    lable2.text = @"由于您没有达到封测资格，您可以通过以下任意一种方式来激活账户";
    [scV addSubview:lable2];
    
    
    UIButton * addFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    addFriend.frame = CGRectMake(83, 310, 154, 30);
    [addFriend setBackgroundImage:KUIImage(@"add_friend_normal_.png") forState:UIControlStateNormal];
    [addFriend setBackgroundImage:KUIImage(@"add_friend_click_.png") forState:UIControlStateHighlighted];

    [addFriend addTarget:self action:@selector(addFriends:) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:addFriend];
    
    UILabel * lable4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, 170, 20)];
    lable4.backgroundColor = [UIColor clearColor];
    lable4.textColor = [UIColor grayColor];
    lable4.font = [UIFont boldSystemFontOfSize:16];
    lable4.text = @"如您有角色位于服务器";
    [scV addSubview:lable4];
    
    UILabel * lable5 = [[UILabel alloc]initWithFrame:CGRectMake(180, 350, 40, 20)];
    lable5.backgroundColor = [UIColor clearColor];
    lable5.textColor = UIColorFromRGBA(0x16a3f0, 1);
    lable5.font = [UIFont boldSystemFontOfSize:16];
    lable5.text = @"前十";
    [scV addSubview:lable5];

    UILabel * lable6 = [[UILabel alloc]initWithFrame:CGRectMake(220, 350, 100, 20)];
    lable6.backgroundColor = [UIColor clearColor];
    lable6.textColor = [UIColor grayColor];
    lable6.font = [UIFont boldSystemFontOfSize:16];
    lable6.text = @"，请点击";
    [scV addSubview:lable6];

    UIButton * bangdingB = [UIButton buttonWithType:UIButtonTypeCustom];
    bangdingB.frame = CGRectMake(83, 380, 154, 30);
    [bangdingB setBackgroundImage:KUIImage(@"binding_normal.png") forState:UIControlStateNormal];
    [bangdingB setBackgroundImage:KUIImage(@"binding_click.png") forState:UIControlStateHighlighted];
    
    [bangdingB addTarget:self action:@selector(boundRole) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:bangdingB];
    
    
    
    UILabel * lable7 = [[UILabel alloc]initWithFrame:CGRectMake(10, 420, 65, 20)];
    lable7.backgroundColor = [UIColor clearColor];
    lable7.numberOfLines = 0;
    lable7.textColor = [UIColor grayColor];
    lable7.font = [UIFont boldSystemFontOfSize:16];
    lable7.text = @"如果您是";
    [scV addSubview:lable7];
    
    UILabel * lable8 = [[UILabel alloc]initWithFrame:CGRectMake(74, 420, 40, 20)];
    lable8.backgroundColor = [UIColor clearColor];
    lable8.numberOfLines = 0;
    lable8.textColor = UIColorFromRGBA(0x16a3f0, 1);
    lable8.font = [UIFont boldSystemFontOfSize:16];
    lable8.text = @"妹子";
    [scV addSubview:lable8];

    
    UILabel * lable9 = [[UILabel alloc]initWithFrame:CGRectMake(114, 420, 100, 20)];
    lable9.backgroundColor = [UIColor clearColor];
    lable9.numberOfLines = 0;
    lable9.textColor = [UIColor grayColor];
    lable9.font = [UIFont boldSystemFontOfSize:16];
    lable9.text = @",可点击";
    [scV addSubview:lable9];

    
    UIButton * meiziB = [UIButton buttonWithType:UIButtonTypeCustom];
    meiziB.frame = CGRectMake(83, 450, 154, 30);
    [meiziB setBackgroundImage:KUIImage(@"girl_ certification_normal") forState:UIControlStateNormal];
    [meiziB setBackgroundImage:KUIImage(@"girl_ girl_certification_click") forState:UIControlStateHighlighted];
    meiziB.titleLabel.font =[UIFont boldSystemFontOfSize:16];
    [meiziB setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [meiziB addTarget:self action:@selector(ImGirl) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:meiziB];
    
    
//    UIImageView * photo1 = [[UIImageView alloc]initWithFrame:CGRectMake(90, 420, 141, 117)];
//    photo1.image = [UIImage imageNamed:@"gril1"];
//    [scV addSubview:photo1];
    
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
-(void)addFriends:(UIButton *)sender
{
    AddContactViewController * addV = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addV animated:YES];
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
        [DataStoreManager reSetMyAction:YES];
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
