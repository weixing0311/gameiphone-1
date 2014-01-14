//
//  AuthViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AuthViewController.h"

@interface AuthViewController ()
{
    NSString*   m_authItemKey;
}
@end

@implementation AuthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"认证游戏角色" withBackButton:YES];
    
    [self setMainView];
    [self getDataByNet];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
}

- (void)getDataByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.realm forKey:@"realm"];
    [paramDict setObject:self.character forKey:@"charactername"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"126" forKey:@"method"];
    if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
        [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    }
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        NSString* authitemStr = @"";
        m_authItemKey = @"";
        if ([responseObject isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < [responseObject count]; i++) {
                NSDictionary* dic = [responseObject objectAtIndex:i];
                if ([[dic allValues] count] == 1) {
                    if (i != [responseObject count] - 1) {
                        authitemStr = [authitemStr stringByAppendingFormat:@"%@，", [[dic allValues] objectAtIndex:0]];
                    }
                    else
                        authitemStr = [authitemStr stringByAppendingString:[[dic allValues] objectAtIndex:0]];
                }
                if ([[dic allKeys] count] == 1) {
                    if (i != [responseObject count] - 1) {
                        m_authItemKey = [m_authItemKey stringByAppendingFormat:@"%@,", [[dic allKeys] objectAtIndex:0]];
                    }
                    else
                        m_authItemKey = [m_authItemKey stringByAppendingString:[[dic allKeys] objectAtIndex:0]];
                }
            }
        }
        UILabel* authitem  = [CommonControlOrView setLabelWithFrame:CGRectMake(10, startX+145, 300, 50) textColor:[UIColor purpleColor] font:[UIFont boldSystemFontOfSize:20.0] text:authitemStr textAlignment:NSTextAlignmentCenter];
        [self.view addSubview:authitem];
       
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 100;
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100 || alertView.tag == 102) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            if (alertView.tag == 102) {//认证成功
                if (self.authDelegate && [self.authDelegate respondsToSelector:@selector(authCharacterSuccess)]) {
                    [self.authDelegate authCharacterSuccess];
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
//    else if(alertView.tag == 101)
//    {
//        [self.authDelegate authCharacterSuccess];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)setMainView
{
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(10, startX, 100, 40)];
    table_label_one.text = @"选择游戏";
    table_label_one.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_one];
    
    UILabel* table_label_two = [[UILabel alloc] initWithFrame:CGRectMake(10, startX+40, 80, 40)];
    table_label_two.text = @"所在服务器";
    table_label_two.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_two.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_two];
    
    UILabel* table_label_three = [[UILabel alloc] initWithFrame:CGRectMake(10, startX+80, 80, 40)];
    table_label_three.text = @"角色名";
    table_label_three.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_three.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_three];

    UIImageView* gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(120, startX+11, 18, 18)];
    if([self.gameId isEqualToString:@"1"])
        gameImg.image = KUIImage(@"wow");
    [self.view addSubview:gameImg];
    
    UILabel* gameName = [CommonControlOrView setLabelWithFrame:CGRectMake(155, startX+0, 100, 40) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0] text:@"魔兽世界" textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:gameName];
    
    UIImageView* lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, startX+40, kScreenWidth, 2)];
    lineImg.image = KUIImage(@"line");
    lineImg.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineImg];
    
    UILabel* realmLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(155, startX+40, 150, 40) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0] text:self.realm textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:realmLabel];
    
    UIImageView* lineImg_2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, startX+80, kScreenWidth, 2)];
    lineImg_2.image = KUIImage(@"line");
    lineImg_2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineImg_2];
    
    UILabel* characterLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(155, startX+80, 150, 40) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0] text:self.character textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:characterLabel];
    
    UIImageView* lineImg_3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, startX+120, kScreenWidth, 2)];
    lineImg_3.image = KUIImage(@"line");
    lineImg_3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineImg_3];
    
    UILabel*  bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, startX+130, 300, 100)];
    bottomLabel.text = @"为验证角色为您所有，请登录游戏取下角色的\n\n\n这两个部位的装备并下线，等待英雄榜更新后点击“认证”按钮。";
    bottomLabel.numberOfLines = 0;
    bottomLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
    bottomLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:bottomLabel];
    
    UIButton* authButton = [[UIButton alloc] initWithFrame:CGRectMake(10, startX+250, 300, 40)];
    [authButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [authButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [authButton setTitle:@"认 证" forState:UIControlStateNormal];
    [authButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    authButton.backgroundColor = [UIColor clearColor];
    [authButton addTarget:self action:@selector(authButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authButton];
}

- (void)authButtonClick:(id)sender
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.gameId forKey:@"gameid"];
    [paramDict setObject:self.realm forKey:@"realm"];
    [paramDict setObject:self.character forKey:@"charactername"];
    [paramDict setObject:m_authItemKey forKey:@"authitem"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"127" forKey:@"method"];
    if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {
        [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    }
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"认证成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 102;
        [alert show];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 101;
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
