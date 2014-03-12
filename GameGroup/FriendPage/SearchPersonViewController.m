//
//  SearchPersonViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-16.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "SearchPersonViewController.h"
#import "PersonDetailViewController.h"
#import "SearchResultViewController.h"
#import "TestViewController.h"
@interface SearchPersonViewController ()
{
    UITextField * searchContent;
    
    UIScrollView* m_roleView;
    UITextField*  m_gameNameText;
//    UIPickerView* m_serverNamePick;
    UITextField*  m_roleNameText;
    NSInteger    m_pageNum;
//    NSMutableArray* m_realmsArray;//服务器名
}
@end

@implementation SearchPersonViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorWithRGB(246, 246, 246, 1.0);
    
    m_pageNum = 0;
    
    if(self.viewType == SEARCH_TYPE_ROLE)
    {
        [self setTopViewWithTitle:@"搜索角色名" withBackButton:YES];

        [self setRoleView];
        return;
    }
    UILabel* warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + startX, 300, 30)];
    warnLabel.textColor = kColorWithRGB(154, 154, 154, 1.0);
    warnLabel.shadowColor = [UIColor whiteColor];
    [warnLabel setFont:[UIFont systemFontOfSize:15.0]];
    warnLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:warnLabel];
    
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45 + startX, 300, 40)];
    table_top.image = KUIImage(@"text_bg");
    [self.view addSubview:table_top];
    
    searchContent = [[UITextField alloc] initWithFrame:CGRectMake(15, 45 + startX, 290, 40)];
    searchContent.returnKeyType = UIReturnKeyDone;
    searchContent.delegate = self;
    searchContent.font = [UIFont boldSystemFontOfSize:15.0];
    searchContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:searchContent];
    
    switch (self.viewType) {
        case SEARCH_TYPE_ID:
        {
            [self setTopViewWithTitle:@"搜索小伙伴ID" withBackButton:YES];
            warnLabel.text = @"输入小伙伴的ID(可在我的详情页面查看)：";
            searchContent.keyboardType = UIKeyboardTypeNumberPad;
        }   break;
        case SEARCH_TYPE_PHONE:
        {
            [self setTopViewWithTitle:@"搜索手机号" withBackButton:YES];
            warnLabel.text = @"输入手机号进行查询：";
            searchContent.keyboardType = UIKeyboardTypeNumberPad;
        }  break;
        case SEARCH_TYPE_NICKNAME:
        {
            [self setTopViewWithTitle:@"搜索小伙伴昵称" withBackButton:YES];
            warnLabel.text = @"输入小伙伴的昵称";
        } break;
        default:
            break;
    }
    [searchContent becomeFirstResponder];
    
    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 110 + startX, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [okButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okButton];
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"搜索中...";
}

- (void)setRoleView
{
    m_roleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_roleView.backgroundColor = [UIColor clearColor];
//    if (!iPhone5) {
//        m_roleView.contentSize = CGSizeMake(kScreenWidth, kScreenHeigth - startX + 50);
//    }
    [self.view addSubview:m_roleView];
    
    UIImageView* table_top = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    table_top.image = KUIImage(@"table_top");
    [m_roleView addSubview:table_top];
    
    UIImageView* table_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, 36, 12, 8)];
    table_arrow.image = KUIImage(@"arrow_bottom");
    [m_roleView addSubview:table_arrow];
    
    UIImageView* table_middle = [[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 300, 40)];
    table_middle.image = KUIImage(@"table_middle");
    [m_roleView addSubview:table_middle];
    
    UIImageView* table_arrow_two = [[UIImageView alloc] initWithFrame:CGRectMake(290, 76, 12, 8)];
    table_arrow_two.image = KUIImage(@"arrow_bottom");
    [m_roleView addSubview:table_arrow_two];
    
    UIImageView* table_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, 100, 300, 40)];
    table_bottom.image = KUIImage(@"table_bottom");
    [m_roleView addSubview:table_bottom];
    
    UILabel* table_label_one = [[UILabel alloc] initWithFrame:CGRectMake(20, 21, 100, 38)];
    table_label_one.text = @"选择游戏";
    table_label_one.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_one.font = [UIFont boldSystemFontOfSize:15.0];
    [m_roleView addSubview:table_label_one];
    
    UILabel* table_label_two = [[UILabel alloc] initWithFrame:CGRectMake(20, 61, 80, 38)];
    table_label_two.text = @"所在服务器";
    table_label_two.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_two.font = [UIFont boldSystemFontOfSize:15.0];
    [m_roleView addSubview:table_label_two];
    
    UILabel* table_label_three = [[UILabel alloc] initWithFrame:CGRectMake(20, 101, 80, 38)];
    table_label_three.text = @"角色名";
    table_label_three.textColor = kColorWithRGB(102, 102, 102, 1.0);
    table_label_three.font = [UIFont boldSystemFontOfSize:15.0];
    [m_roleView addSubview:table_label_three];
    
    UIImageView* gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(190, 31, 18, 18)];
    gameImg.image = KUIImage(@"wow");
    [m_roleView addSubview:gameImg];
    
    m_gameNameText = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, 180, 40)];
    m_gameNameText.returnKeyType = UIReturnKeyDone;
    m_gameNameText.delegate = self;
    m_gameNameText.text = @"魔兽世界";
    m_gameNameText.textAlignment = NSTextAlignmentRight;
    m_gameNameText.font = [UIFont boldSystemFontOfSize:15.0];
    m_gameNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_gameNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_roleView addSubview:m_gameNameText];

//    if ([[[GameCommon shareGameCommon].wow_realms allKeys] count] != 0) {
//        NSString* firstKey = [[[GameCommon shareGameCommon].wow_realms allKeys] objectAtIndex:0];
//        m_realmsArray = [[GameCommon shareGameCommon].wow_realms objectForKey:firstKey];
//    }
    searchContent = [[UITextField alloc] initWithFrame:CGRectMake(100, 60, 180, 40)];
    searchContent.returnKeyType = UIReturnKeyDone;
    searchContent.textAlignment = NSTextAlignmentRight;
    searchContent.delegate = self;
    searchContent.font = [UIFont boldSystemFontOfSize:15.0];
    searchContent.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_roleView addSubview:searchContent];
    
    UIButton* serverButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 60, 180, 40)];
    serverButton.backgroundColor = [UIColor clearColor];
    [serverButton addTarget:self action:@selector(realmSelectClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_roleView addSubview:serverButton];
//
//    m_serverNamePick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
//    m_serverNamePick.dataSource = self;
//    m_serverNamePick.delegate = self;
//    m_serverNamePick.showsSelectionIndicator = YES;
//    searchContent.inputView = m_serverNamePick;//点击弹出的是pickview
//    
//    UIToolbar* toolbar_server = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
//    toolbar_server.tintColor = [UIColor blackColor];
//    UIBarButtonItem*rb_server = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(selectServerNameOK)];
//    rb_server.tintColor = [UIColor blackColor];
//    toolbar_server.items = @[rb_server];
//    searchContent.inputAccessoryView = toolbar_server;//跟着pickview上移

    m_roleNameText = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 180, 40)];
    m_roleNameText.returnKeyType = UIReturnKeyDone;
    m_roleNameText.delegate = self;
    m_roleNameText.textAlignment = NSTextAlignmentRight;
    m_roleNameText.font = [UIFont boldSystemFontOfSize:15.0];
    m_roleNameText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_roleNameText.clearButtonMode = UITextFieldViewModeWhileEditing;
    [m_roleView addSubview:m_roleNameText];
    
    UIButton* okButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 160, 300, 40)];
    [okButton setBackgroundImage:KUIImage(@"blue_button_normal") forState:UIControlStateNormal];
    [okButton setBackgroundImage:KUIImage(@"blue_button_click") forState:UIControlStateHighlighted];
    [okButton setTitle:@"搜 索" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    okButton.backgroundColor = [UIColor clearColor];
    [okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_roleView addSubview:okButton];

    UILabel* bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, 300, 40)];
    bottomLabel.numberOfLines = 2;
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.font = [UIFont boldSystemFontOfSize:12.0];
    bottomLabel.textColor = kColorWithRGB(128.0, 128, 128, 1.0);
    bottomLabel.text = @"繁体字可使用手写输入法，角色名过于生僻无法输入时，可尝试";
    [m_roleView addSubview:bottomLabel];
    
    UIButton* searchBtn = [CommonControlOrView setButtonWithFrame:CGRectMake(60, 227, 70, 15) title:@"" fontSize:Nil textColor:nil bgImage:KUIImage(@"search_bg") HighImage:KUIImage(@"") selectImage:nil];
    searchBtn.backgroundColor = [UIColor clearColor];
    [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_roleView addSubview:searchBtn];
    

    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"搜索中...";
}

- (void)realmSelectClick:(id)sender
{
    RealmsSelectViewController* realmVC = [[RealmsSelectViewController alloc] init];
    realmVC.realmSelectDelegate = self;
    [self.navigationController pushViewController:realmVC animated:YES];
}
- (void)selectOneRealmWithName:(NSString *)name
{
    searchContent.text = name;
}

#pragma mark 角色查找
- (void)searchButtonClick:(id)semder
{
    SearchRoleViewController* searchVC = [[SearchRoleViewController alloc] init];
    searchVC.searchDelegate = self;
    searchVC.getRealmName = searchContent.text;
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)searchRoleSuccess:(NSString*)roleName realm:(NSString*)realm
{
    m_roleNameText.text = roleName;
    searchContent.text = realm;
}

- (void)okButtonClick:(id)sender
{
    [searchContent resignFirstResponder];
    [m_roleNameText resignFirstResponder];

    if (KISEmptyOrEnter(searchContent.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请把搜索内容填写完整！" buttonTitle:@"确定"];
        return;
    }
    else if(self.viewType == SEARCH_TYPE_ROLE && KISEmptyOrEnter(m_roleNameText.text))
    {
        [self showAlertViewWithTitle:@"提示" message:@"请把搜索内容填写完整！" buttonTitle:@"确定"];
        return;
    }
//    else if(self.viewType ==SEARCH_TYPE_NICKNAME && KISEmptyOrEnter(m_roleNameText.text)){
//        [self showAlertViewWithTitle:@"提示" message:@"请把搜索内容填写完整！" buttonTitle:@"确定"];
//        return;
//    }
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    if (self.viewType ==SEARCH_TYPE_NICKNAME) {
//        [paramDict setObject:searchContent.text forKey:@"nickname"];
//        [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon]getNetCommomDic]];
//        [postDict setObject:paramDict forKey:@"params"];
//        [postDict setObject:@"150" forKey:@"method"];
//        [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
//
//        [hud show:YES];
//        
//        [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [hud hide:YES];
            SearchResultViewController *SV = [[SearchResultViewController alloc]init];
            SV.nickNameList =searchContent.text;
           // SV.responseObject = responseObject;
            [self.navigationController pushViewController:SV animated:YES];
            
            
//        } failure:^(AFHTTPRequestOperation *operation, id error) {
//            if ([error isKindOfClass:[NSDictionary class]]) {
//                NSString* warn = [error objectForKey:kFailMessageKey];
//                if ([[error objectForKey:kFailErrorCodeKey] isEqualToString:@"200002"]) {//用户不存在， 角色存在
//                    warn = @"该角色目前尚未在小伙伴注册，快去邀请他吧，这样你们就可以聊天了!";
//                }
//                if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
//                {
//                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", warn] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                    [alert show];
//                }
//            }
//            [hud hide:YES];
//        }];
//        NSLog(@"11231");
    }else{
        NSLog(@"22231");
    if (self.viewType == SEARCH_TYPE_ID) {
        [paramDict setObject:searchContent.text forKey:@"userid"];
    }
    else if(self.viewType == SEARCH_TYPE_PHONE)
    {
        if (searchContent.text.length<11) {
            [self showAlertViewWithTitle:@"提示" message:@"请输入正确的手机号码" buttonTitle:@"确定"];
            return;
        }
        
        
        [paramDict setObject:searchContent.text forKey:@"username"];
    }
    else
    {
//        NSArray* realms = [searchContent.text componentsSeparatedByString:@" "];
//        if ([realms count] == 2) {
//            [paramDict setObject:[[realms objectAtIndex:0] stringByAppendingString:[realms objectAtIndex:1]] forKey:@"realm"];
//        }
        [paramDict setObject:searchContent.text forKey:@"realm"];
        [paramDict setObject:m_roleNameText.text forKey:@"charactername"];
    }
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
 
    [hud show:YES];

    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
  
        NSLog(@"%@", responseObject);
        NSDictionary * recDict = KISDictionaryHaveKey(responseObject, @"user");
        if ([KISDictionaryHaveKey(recDict, @"username") isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
            [self showAlertViewWithTitle:@"提示" message:@"您不能对自己进行搜索！" buttonTitle:@"确定"];
            return;
        }
//       PersonDetailViewController* VC = [[PersonDetailViewController alloc] init];
        TestViewController* VC = [[TestViewController alloc] init];
        
        VC.userId = KISDictionaryHaveKey(recDict, @"userid");
        VC.nickName = KISDictionaryHaveKey(recDict, @"nickname");
        HostInfo* hostInfo = [[HostInfo alloc] initWithHostInfo:responseObject];
        VC.hostInfo = hostInfo;
        if ([hostInfo.relation isEqualToString:@"1"]) {
            VC.viewType = VIEW_TYPE_FriendPage1;//好友
            
            if (hostInfo.achievementArray && [hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:hostInfo.infoDic];
                [dic setObject:[hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserInfo:dic];
            }
            else
                [DataStoreManager saveUserInfo:hostInfo.infoDic];
        }
        else if([hostInfo.relation isEqualToString:@"2"]) {
            VC.viewType = VIEW_TYPE_AttentionPage1;
            if (hostInfo.achievementArray && [hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:hostInfo.infoDic];
                [dic setObject:[hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserAttentionInfo:dic];
            }
            else
                [DataStoreManager saveUserAttentionInfo:hostInfo.infoDic];
        }
        else if([hostInfo.relation isEqualToString:@"3"]) {
            VC.viewType = VIEW_TYPE_FansPage1;
            if (hostInfo.achievementArray && [hostInfo.achievementArray count] != 0) {
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithCapacity:1];
                [dic addEntriesFromDictionary:hostInfo.infoDic];
                [dic setObject:[hostInfo.achievementArray objectAtIndex:0] forKey:@"title"];
                
                [DataStoreManager saveUserFansInfo:dic];
            }
            else
                [DataStoreManager saveUserFansInfo:hostInfo.infoDic];
        }
        else  {
            VC.viewType = VIEW_TYPE_STRANGER1;
        }
        VC.isChatPage = NO;
        [self.navigationController pushViewController:VC animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            NSString* warn = [error objectForKey:kFailMessageKey];
            if ([[error objectForKey:kFailErrorCodeKey] isEqualToString:@"200002"]) {//用户不存在， 角色存在
                warn = @"该角色目前尚未在小伙伴注册，快去邀请他吧，这样你们就可以聊天了!";
            }
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", warn] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
    }
}

#pragma mark 选择器

#pragma mark textField
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == m_gameNameText) {
        [self showAlertViewWithTitle:@"提示" message:@"暂不支持其他游戏" buttonTitle:@"确定"];
        return NO;
    }
    return YES;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [m_gameNameText resignFirstResponder];
//    [searchContent resignFirstResponder];
//    [m_roleNameText resignFirstResponder];
//}
#pragma mark 手势
- (void)tapTopViewClick:(id)sender
{
    [m_gameNameText resignFirstResponder];
    [searchContent resignFirstResponder];
    [m_roleNameText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
