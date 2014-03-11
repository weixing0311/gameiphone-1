//
//  AddAddressBookViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddAddressBookViewController.h"
#import "AddressListViewController.h"
#import "AddSameServerListViewController.h"

@interface AddAddressBookViewController ()<UIAlertViewDelegate>

@end

@implementation AddAddressBookViewController

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
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self setTopViewWithTitle:@"添加通讯录好友" withBackButton:NO];
    
    UIButton * passButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [passButton setTitle:@"跳过" forState:UIControlStateNormal];
    passButton.titleLabel.font = [UIFont systemFontOfSize:13];
    passButton.frame = CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [passButton addTarget:self action:@selector(passUploadAddressBook) forControlEvents:UIControlEventTouchUpInside];
    [passButton setBackgroundImage:[UIImage imageNamed:@"passButton"] forState:UIControlStateNormal];
    [self.view addSubview:passButton];
    
    UIImageView * iconImageV = [[UIImageView alloc]initWithFrame:CGRectMake(140, 100, 48, 46)];
    iconImageV.image = [UIImage imageNamed:@"addressBook"];
    [self.view addSubview:iconImageV];
    
    UILabel * whoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 300, 20)];
    whoL.backgroundColor = [UIColor clearColor];
    whoL.textAlignment = NSTextAlignmentCenter;
    whoL.text = @"找找还有谁在陌游!";
    whoL.textColor = [UIColor grayColor];
    [self.view addSubview:whoL];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.frame = CGRectMake(35, 200, 249, 37);
    [button setBackgroundImage:[UIImage imageNamed:@"upoadAddressBook2"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"upoadAddressBook1"] forState:UIControlStateHighlighted];
    [button setTitle:@"    添加您的通讯录好友" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(uploadAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(35, 270, 249, 100)];
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = @"陌游将请求访问你的手机通讯录,帮您找到已经在陌游的好友.\n\n请放心,您的信息仅用于查找好友,所有信息会被加密并安全保存,防止被不正当使用.";
    [self.view addSubview:label];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"发送中...";
}
- (void)passUploadAddressBook
{
    UIAlertView * alertV = [[UIAlertView alloc]initWithTitle:@"跳过添加通讯录好友?" message:@"开启通讯录有助于您立即找到好友.我们会加密您的通讯录数据以防被不正当使用." delegate:self cancelButtonTitle:nil otherButtonTitles:@"开启通讯录",@"坚持跳过", nil];
    [alertV show];
}
- (NSMutableArray*)getAddressBook
{
    NSMutableArray * addressArray = [NSMutableArray array];
    //取得本地通信录名柄
    
    ABAddressBookRef tmpAddressBook = nil;
    tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema=dispatch_semaphore_create(0);
    ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    //取得本地所有联系人记录
    if (tmpAddressBook==nil) {
        return nil;
    };
    NSArray* tmpPeoples = (__bridge NSArray*)ABAddressBookCopyArrayOfAllPeople(tmpAddressBook);
    for(id tmpPerson in tmpPeoples)
    {
        //获取的联系人单一属性:First name
        NSString* tmpFirstName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonFirstNameProperty);
        NSLog(@"First name:%@", tmpFirstName);
        //获取的联系人单一属性:Last name
        NSString* tmpLastName = (__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonLastNameProperty);
        NSLog(@"Last name:%@", tmpLastName);
        //获取的联系人单一属性:Generic phone number
        ABMultiValueRef tmpPhones = ABRecordCopyValue((__bridge ABRecordRef)(tmpPerson), kABPersonPhoneProperty);
        for(NSInteger j = 0; j < ABMultiValueGetCount(tmpPhones); j++)
        {
            NSString* tmpPhoneIndex = (__bridge NSString*)ABMultiValueCopyValueAtIndex(tmpPhones, j);
            tmpPhoneIndex = [tmpPhoneIndex stringByReplacingOccurrencesOfString:@"-"withString:@""];
            NSLog(@"tmpPhoneIndex%d:%@", j, tmpPhoneIndex);
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            if (tmpLastName&&tmpFirstName) {
                [dic setObject:[NSString stringWithFormat:@"%@%@",tmpLastName,tmpFirstName] forKey:@"name"];
                [dic setObject:tmpPhoneIndex forKey:@"mobileid"];
                [addressArray addObject:dic];
            }else if (tmpLastName)
            {
                 [dic setObject:[NSString stringWithFormat:@"%@",tmpLastName] forKey:@"name"];
                [dic setObject:tmpPhoneIndex forKey:@"mobileid"];
                [addressArray addObject:dic];
            }else if (tmpFirstName)
            {
                 [dic setObject:[NSString stringWithFormat:@"%@",tmpFirstName] forKey:@"name"];
                [dic setObject:tmpPhoneIndex forKey:@"mobileid"];
                [addressArray addObject:dic];
            }
        }
        CFRelease(tmpPhones);
    }
    CFRelease(tmpAddressBook);
    return addressArray;
}
- (void)uploadAddress
{
    NSMutableArray * arr = [self getAddressBook];
    if (!arr) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"您是否禁止本应用访问您的通讯录?如果是请打开!" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (arr.count<=0) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未发现您的通讯录,您可以直接跳过!" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:arr forKey:@"contacts"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"162" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray* array = [NSMutableArray array];
        for (NSDictionary * dic in responseObject) {
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:dic];
            [dict setObject:@"0" forKey:@"iCare"];
            [array addObject:dict];
        }
        NSArray* lingshiArray = [arr copy];
        for (NSMutableDictionary* dict in array) {
            for (NSDictionary* dic in lingshiArray) {
                if ([dic[@"mobileid"]isEqualToString:dict[@"username"]]) {
                    [arr removeObject:dic];
                    [dict setValue:dic[@"name"] forKey:@"addressName"];
                }
            }
        }
        [hud hide:YES];
        AddressListViewController* addListVC = [[AddressListViewController alloc]init];
        addListVC.inDudeArray = array;
        addListVC.outDudeArray = arr;
        [self.navigationController pushViewController:addListVC animated:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self uploadAddress];
    }else
    {
        [self goToNext];
    }
}
- (void)goToNext
{
    if ([[TempData sharedInstance] passBindingRole]) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        AddSameServerListViewController * addSameServerVC = [[AddSameServerListViewController alloc]init];
        [self.navigationController pushViewController:addSameServerVC animated:YES];
    }
}
@end
