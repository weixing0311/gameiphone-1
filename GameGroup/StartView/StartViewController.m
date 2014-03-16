//
//  StartViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "StartViewController.h"
#import "AppDelegate.h"
#import "IntroduceViewController.h"
#import "MessagePageViewController.h"
#import "FriendPageViewController.h"
#import "FindPageViewController.h"
#import "MePageViewController.h"
#import "NewFindViewController.h"

#import "MLNavigationController.h"
#import "Custom_tabbar.h"

#import "LocationManager.h"
#import "TempData.h"

#import "MLNavigationController.h"
#define kStartViewShowTime  (2.0f) //开机页面 显示时长

@interface StartViewController ()
{
    UIImageView* splashImageView;
}

@end

@implementation StartViewController

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
    
    [self firtOpen];
    
    if (iPhone5) {
        splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start_2.jpg"]];
        splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    else
    {
        splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start.jpg"]];
        splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
    }
    [self.view addSubview:splashImageView];
    [self performSelector:@selector(showLoading:) withObject:nil afterDelay:kStartViewShowTime];
    
    [[LocationManager sharedInstance] initLocation];//定位
    [self getUserLocation];
}

#pragma mark 首页或介绍页
- (void)showLoading:(id)sender
{
    [splashImageView removeFromSuperview];
//    if ([self isHaveLogin]){
    //消息页面
        MessagePageViewController* fist  = [[MessagePageViewController alloc] init];
        fist.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_First = [[UINavigationController alloc] initWithRootViewController:fist];
        navigationController_First.navigationBarHidden = YES;
//好友页面
        FriendPageViewController* second = [[FriendPageViewController alloc] init];
        second.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Second = [[UINavigationController alloc] initWithRootViewController:second];
        navigationController_Second.navigationBarHidden = YES;
//发现页面
        NewFindViewController* third = [[NewFindViewController alloc] init];
        third.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Third = [[UINavigationController alloc] initWithRootViewController:third];
        navigationController_Third.navigationBarHidden = YES;
//我的页面
        MePageViewController* fourth = [[MePageViewController alloc] init];
        fourth.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Fourth = [[UINavigationController alloc] initWithRootViewController:fourth];
        navigationController_Fourth.navigationBarHidden = YES;

        Custom_tabbar*  ryc_tabbarController = [[Custom_tabbar alloc] init];
        ryc_tabbarController.viewControllers = [NSArray arrayWithObjects:navigationController_First,navigationController_Second, navigationController_Third, navigationController_Fourth, nil];
        [self presentViewController:ryc_tabbarController animated:NO completion:^{
            
        }];
}

#pragma mark 开机联网
-(void)firtOpen
{
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kOpenData]) {
        NSDictionary* tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:kOpenData];
        [paramsDic setObject:KISDictionaryHaveKey(tempDic, @"gamelist_millis") forKey:@"gamelist_millis"];
        [paramsDic setObject:KISDictionaryHaveKey(tempDic, @"wow_realms_millis") forKey:@"wow_realms_millis"];
        [paramsDic setObject:KISDictionaryHaveKey(tempDic, @"wow_characterclasses_millis") forKey:@"wow_characterclasses_millis"];
    }
    else
    {
        [paramsDic setObject:@"" forKey:@"gamelist_millis"];
        [paramsDic setObject:@"" forKey:@"wow_realms_millis"];
        [paramsDic setObject:@"" forKey:@"wow_characterclasses_millis"];
    }
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramsDic forKey:@"params"];
    [postDict setObject:@"142" forKey:@"method"];
  
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self openSuccessWithInfo:responseObject From:@"firstOpen"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

-(void)openSuccessWithInfo:(NSDictionary *)dict From:(NSString *)where
{
//    NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [[TempData sharedInstance] setRegisterNeedMsg:[KISDictionaryHaveKey(dict, @"registerNeedMsg") doubleValue]];
    if ([KISDictionaryHaveKey(dict, @"clientUpdate") doubleValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:KISDictionaryHaveKey(dict, @"clientUpdateUrl") forKey:@"IOSURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立刻升级", nil];
        alert.tag = 21;
        [alert show];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IOSURL"];
    }
    NSMutableDictionary* openData = [[NSUserDefaults standardUserDefaults] objectForKey:kOpenData] ? [[NSUserDefaults standardUserDefaults] objectForKey:kOpenData] : [NSMutableDictionary dictionaryWithCapacity:1];
    if ([KISDictionaryHaveKey(dict, @"gamelist_update") boolValue]) {
        [openData setObject:KISDictionaryHaveKey(dict, @"gamelist") forKey:@"gamelist"];
        [openData setObject:KISDictionaryHaveKey(dict, @"gamelist_millis") forKey:@"gamelist_millis"];
    }
    if ([KISDictionaryHaveKey(dict, @"wow_characterclasses_update") boolValue]) {
        [openData setObject:KISDictionaryHaveKey(dict, @"wow_characterclasses") forKey:@"wow_characterclasses"];
        [openData setObject:KISDictionaryHaveKey(dict, @"wow_characterclasses_millis") forKey:@"wow_characterclasses_millis"];
    }
    if ([KISDictionaryHaveKey(dict, @"wow_realms_update") boolValue]) {
        [openData setObject:KISDictionaryHaveKey(dict, @"wow_realms") forKey:@"wow_realms"];
        [openData setObject:KISDictionaryHaveKey(dict, @"wow_realms_millis") forKey:@"wow_realms_millis"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:openData forKey:kOpenData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([KISDictionaryHaveKey(openData, @"wow_realms") isKindOfClass:[NSDictionary class]]) {//注册服务器数据
        [[GameCommon shareGameCommon].wow_realms addEntriesFromDictionary:KISDictionaryHaveKey(openData, @"wow_realms")];
    }
    if ([KISDictionaryHaveKey(openData, @"wow_characterclasses") isKindOfClass:[NSArray class]]) {
        [[GameCommon shareGameCommon].wow_clazzs addObjectsFromArray:KISDictionaryHaveKey(openData, @"wow_characterclasses")];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (21 == alertView.tag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IOSURL"]) {
                NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"IOSURL"]];
                if([[UIApplication sharedApplication] canOpenURL:url])
                {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
    }
}
#pragma mark 下载开机图
-(void)downloadImageWithID:(NSString *)imageId Type:(NSString *)theType PicName:(NSString *)picName
{
    [NetManager downloadImageWithBaseURLStr:imageId ImageId:@"" success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        if ([theType isEqualToString:@"open"]) {
            NSString *path = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:path] == NO)
            {
                [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage.jpg",path];
            
            if ([UIImageJPEGRepresentation(image, 1.0) writeToFile:openImgPath atomically:YES]) {
                NSLog(@"success///");
                [[NSUserDefaults standardUserDefaults] setObject:imageId forKey:@"OpenImg"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSLog(@"fail");
            }
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
    }];
}

#pragma mark 获取用户位置
-(void)getUserLocation
{
    [[LocationManager sharedInstance] startCheckLocationWithSuccess:^(double lat, double lon) {
        [[TempData sharedInstance] setLat:lat Lon:lon];
        if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {//自动登录
            [self upLoadUserLocationWithLat:lat Lon:lon];
        }
    } Failure:^{
        NSLog(@"开机定位失败");
    }];
}

-(void)upLoadUserLocationWithLat:(double)userLatitude Lon:(double)userLongitude
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    NSDictionary * locationDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",userLongitude],@"longitude",[NSString stringWithFormat:@"%f",userLatitude],@"latitude", nil];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
//    [postDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict setObject:@"108" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [postDict setObject:locationDict forKey:@"params"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
