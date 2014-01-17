//
//  AddCharacterViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-23.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AddCharacterViewController.h"

@interface AddCharacterViewController ()
{
    UITextField*  m_gameNameText;
    UITextField*  m_realmText;
    UITextField*  m_roleNameText;
    
    BOOL          isRefresh;//从认证界面成功后  直接提交
}
@end

@implementation AddCharacterViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isRefresh) {
        isRefresh = NO;
        switch (self.viewType) {
            case CHA_TYPE_Add:
                [self addCharacterByNet];
                break;
            case CHA_TYPE_Change:
                [self changeByNet];
                break;
            default:
                break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [GameCommon shareGameCommon].selectRealm = @"";
    
    isRefresh = NO;
    
    switch (self.viewType) {
        case CHA_TYPE_Add:
            [self setTopViewWithTitle:@"添加角色" withBackButton:YES];
            break;
        case CHA_TYPE_Change:
            [self setTopViewWithTitle:@"修改角色" withBackButton:YES];
            break;
        default:
            break;
    }
    
    [self setMainView];
}

- (void)setMainView
{
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, startX + 20, 300, 40)];
    table_top.image = KUIImage(@"table_top");
    [self.view addSubview:table_top];
    
    UIImageView* table_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, startX + 36, 12, 8)];
    table_arrow.image = KUIImage(@"arrow_bottom");
    [self.view addSubview:table_arrow];
    
    UIImageView* table_middle = [[UIImageView alloc] initWithFrame:CGRectMake(10, startX + 60, 300, 40)];
    table_middle.image = KUIImage(@"table_middle");
    [self.view addSubview:table_middle];
    
    UIImageView* table_arrow_two = [[UIImageView alloc] initWithFrame:CGRectMake(290, startX + 76, 12, 8)];
    table_arrow_two.image = KUIImage(@"arrow_bottom");
    [self.view addSubview:table_arrow_two];
    
    UIImageView* table_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, startX + 100, 300, 40)];
    table_bottom.image = KUIImage(@"table_bottom");
    [self.view addSubview:table_bottom];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, startX + 21, 100, 38)];
    table_label_one.text = @"选择游戏";
    table_label_one.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_one];
    
    UILabel* table_label_two = [[UILabel alloc] initWithFrame:CGRectMake(20, startX + 61, 80, 38)];
    table_label_two.text = @"所在服务器";
    table_label_two.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_two.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_two];
    
    UILabel* table_label_three = [[UILabel alloc] initWithFrame:CGRectMake(20, startX + 101, 80, 38)];
    table_label_three.text = @"角色名";
    table_label_three.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_three.font = [UIFont boldSystemFontOfSize:15.0];
    [self.view addSubview:table_label_three];
    
    UIImageView* gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(190, startX + 31, 18, 18)];
    gameImg.image = KUIImage(@"wow");
    [self.view addSubview:gameImg];

    m_gameNameText = [[UITextField alloc] initWithFrame:CGRectMake(100, startX + 20, 180, 40)];
    m_gameNameText.returnKeyType = UIReturnKeyDone;
    m_gameNameText.delegate = self;
    m_gameNameText.text = @"魔兽世界";
    m_gameNameText.textAlignment = NSTextAlignmentRight;
    m_gameNameText.font = [UIFont boldSystemFontOfSize:15.0];
    m_gameNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_gameNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_gameNameText];
    
    m_realmText = [[UITextField alloc] initWithFrame:CGRectMake(100, 60 + startX, 180, 40)];
    m_realmText.returnKeyType = UIReturnKeyDone;
    m_realmText.delegate = self;
    m_realmText.textAlignment = NSTextAlignmentRight;
    m_realmText.font = [UIFont boldSystemFontOfSize:15.0];
    m_realmText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_realmText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_realmText];
    
    UIButton* serverButton = [[UIButton alloc] initWithFrame:CGRectMake(100, startX + 60, 180, 40)];
    serverButton.backgroundColor = [UIColor clearColor];
    [serverButton addTarget:self action:@selector(realmSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:serverButton];
    
    m_roleNameText = [[UITextField alloc] initWithFrame:CGRectMake(100, startX + 100, 180, 40)];
    m_roleNameText.returnKeyType = UIReturnKeyDone;
    m_roleNameText.delegate = self;
    m_roleNameText.textAlignment = NSTextAlignmentRight;
    m_roleNameText.font = [UIFont boldSystemFontOfSize:15.0];
    m_roleNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_roleNameText.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    m_roleNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:m_roleNameText];
    
    UILabel* bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, startX + 150, 300, 40)];
    bottomLabel.numberOfLines = 2;
    bottomLabel.font = [UIFont boldSystemFontOfSize:12.0];
    bottomLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
    bottomLabel.text = @"繁体字可使用手写输入法，角色名过于生僻无法输入时，可尝试";
    bottomLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomLabel];
    
    UIButton* searchBtn = [CommonControlOrView setButtonWithFrame:CGRectMake(60, startX + 172, 70, 15) title:@"" fontSize:Nil textColor:nil bgImage:KUIImage(@"search_bg") HighImage:KUIImage(@"") selectImage:nil];
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, startX + 200, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    switch (self.viewType) {
        case CHA_TYPE_Add:
            [okButton setTitle:@"添 加" forState:UIControlStateNormal];
            break;
        case CHA_TYPE_Change:
        {
            [okButton setTitle:@"修 改" forState:UIControlStateNormal];
            m_realmText.text = self.realm;
            m_roleNameText.text = self.character;
        } break;
        default:
            break;
    }
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
}

- (void)realmSelectClick:(id)sender
{
    RealmsSelectViewController* realmVC = [[RealmsSelectViewController alloc] init];
    realmVC.realmSelectDelegate = self;
    [self.navigationController pushViewController:realmVC animated:YES];
}

-(void)selectOneRealmWithName:(NSString *)name
{
    m_realmText.text = name;
}

- (void)okButtonClick:(id)sender
{
    [m_realmText resignFirstResponder];
    [m_roleNameText resignFirstResponder];
    
    if (KISEmptyOrEnter(m_realmText.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请选择服务器！" buttonTitle:@"确定"];
        return;
    }
    if (KISEmptyOrEnter(m_roleNameText.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入角色名！" buttonTitle:@"确定"];
        return;
    }
    switch (self.viewType) {
        case CHA_TYPE_Add:
            [self addCharacterByNet];
            break;
        case CHA_TYPE_Change:
            [self changeByNet];
            break;
        default:
            break;
    }
}

- (void)addCharacterByNet
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"gameid"];
    [params setObject:m_realmText.text forKey:@"gamerealm"];
    [params setObject:m_roleNameText.text forKey:@"gamename"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"115" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [hud hide:YES];
        NSDictionary* dic = responseObject;
        
        hud.labelText = @"添加中...";
        
        NSMutableDictionary* params_two = [[NSMutableDictionary alloc]init];
        [params_two setObject:@"1" forKey:@"gameid"];
        [params_two setObject:KISDictionaryHaveKey(dic, @"id") forKey:@"characterid"];
        
        NSMutableDictionary* body_two = [[NSMutableDictionary alloc]init];
        [body_two addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
        [body_two setObject:params_two forKey:@"params"];
        [body_two setObject:@"118" forKey:@"method"];
        [body_two setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
        
        [NetManager requestWithURLStr:BaseClientUrl Parameters:body_two TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [hud hide:YES];

            NSLog(@"%@", responseObject);
            [self showMessageWindowWithContent:@"添加成功" pointY:kScreenHeigth-100];
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
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if ([[error objectForKey:kFailErrorCodeKey] isEqualToString:@"100014"]) {//已被绑定
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"认证", nil];
                alert.tag = 18;
                [alert show];
            }
            else if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

#pragma mark 角色查找
- (void)searchButtonClick:(id)semder
{
    SearchRoleViewController* searchVC = [[SearchRoleViewController alloc] init];
    searchVC.searchDelegate = self;
    searchVC.getRealmName = m_realmText.text;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)searchRoleSuccess:(NSString*)roleName realm:(NSString*)realm
{
    m_roleNameText.text = roleName;
    m_realmText.text = realm;
}

- (void)changeByNet
{
    hud.labelText = @"修改中...";
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:@"1" forKey:@"gameid"];
    [params setObject:self.characterId forKey:@"characterid"];
    
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"119" forKey:@"method"];//删除
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [hud hide:YES];
        
        [self addCharacterByNet];//添加
        
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

#pragma mark alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 18) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            AuthViewController* authVC = [[AuthViewController alloc] init];

            authVC.gameId = @"1";
            authVC.realm = m_realmText.text;
            authVC.character = m_roleNameText.text;
            authVC.authDelegate = self;
            [self.navigationController pushViewController:authVC animated:YES];
        }
    }
}

-(void)authCharacterSuccess
{
    isRefresh = YES;
}

#pragma mark textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == m_gameNameText) {
//        if (self.viewType == CHA_TYPE_Add) {
        [self showAlertViewWithTitle:@"提示" message:@"暂不支持其他游戏" buttonTitle:@"确定"];
//        }
        return NO;
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@aaa", textField.text);
    return YES;
}

#pragma mark 手势
- (void)tapTopViewClick:(id)sender
{
    [m_roleNameText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
