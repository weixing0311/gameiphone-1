//
//  MessageAddressViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MessageAddressViewController.h"
#import "SwithTableViewCell.h"

@interface MessageAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL systemAllowGetAddress;
    BOOL appAllowGetAddress;
    UITableView * _tableView;
}
@property (nonatomic,retain)NSMutableArray * addressArray;
@end

@implementation MessageAddressViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined//用户未设置权限
            ||ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized//用户允许设置权限
            )
        {
            systemAllowGetAddress = YES;
        }else
        {
            systemAllowGetAddress = NO;
        }
        NSUserDefaults * userdefaults = [NSUserDefaults standardUserDefaults];
        if ([userdefaults objectForKey:@"wxr_systemAllowGetAddress"]) {
            if ([[userdefaults objectForKey:@"wxr_systemAllowGetAddress"] intValue] == 0) {
                appAllowGetAddress = NO;
            }else
            {
                appAllowGetAddress = YES;
            }
        }else
        {
            appAllowGetAddress = systemAllowGetAddress;
            if (systemAllowGetAddress) {
                [userdefaults setObject:@"1" forKey:@"wxr_systemAllowGetAddress"];
                [userdefaults synchronize];
            }else{
                [userdefaults setObject:@"0" forKey:@"wxr_systemAllowGetAddress"];
                [userdefaults synchronize];
            }
        }
        self.addressArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTopViewWithTitle:@"手机通讯录" withBackButton:YES];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 60;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        if (appAllowGetAddress) {
            return _addressArray.count;
        }else
        {
            return 1;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *identifier = @"inDoduCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }else
    {
        static NSString *identifier = @"inDoduCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)DodeAddressCellTouchButtonWithIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary * dic = _addressArray[indexPath.row];
    [dic setObject:@"1" forKey:@"iCare"];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:dic[@"userid"] forKey:@"frienduserid"];
    [paramDict setObject:@"1" forKey:@"type"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"109" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
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
