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

#import "MLNavigationController.h"
#import "Custom_tabbar.h"

#import "LocationManager.h"


#define kStartViewShowTime  (1.0f) //开机页面 显示时长

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
    
    NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
    NSString *path1 = [RootDocPath stringByAppendingPathComponent:@"OpenImages"];
    NSFileManager *fm1 = [NSFileManager defaultManager];
    if([fm1 fileExistsAtPath:path1] == NO)
    {
        [fm1 createDirectoryAtPath:path1 withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *openImgPath = [NSString stringWithFormat:@"%@/openImage.jpg",path1];
    
    if (openImgStr) {
        
        NSData * nsData= [NSData dataWithContentsOfFile:openImgPath];
        UIImage * openPic= [UIImage imageWithData:nsData];
        if (openPic) {
            splashImageView=[[UIImageView alloc]initWithImage:openPic];
            splashImageView.frame=CGRectMake(0, 0, 320, 568);
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OpenImg"];
            if (iPhone5) {
                splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start_2.png"]];
                splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
            else
            {
                splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start.png"]];
                splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
            }
        }
        
    }
    else
    {
        if (iPhone5) {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start_2.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
        else
        {
            splashImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"start.png"]];
            splashImageView.frame=CGRectMake(0, 0, 320, self.view.frame.size.height);
        }
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
        MessagePageViewController* fist  = [[MessagePageViewController alloc] init];
        fist.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_First = [[UINavigationController alloc] initWithRootViewController:fist];
        navigationController_First.navigationBarHidden = YES;

        FriendPageViewController* second = [[FriendPageViewController alloc] init];
        second.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Second = [[UINavigationController alloc] initWithRootViewController:second];
        navigationController_Second.navigationBarHidden = YES;

        FindPageViewController* third = [[FindPageViewController alloc] init];
        third.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Third = [[UINavigationController alloc] initWithRootViewController:third];
        navigationController_Third.navigationBarHidden = YES;

        MePageViewController* fourth = [[MePageViewController alloc] init];
        fourth.hidesBottomBarWhenPushed = YES;
        UINavigationController* navigationController_Fourth = [[UINavigationController alloc] initWithRootViewController:fourth];
        navigationController_Fourth.navigationBarHidden = YES;

        Custom_tabbar*  ryc_tabbarController = [[Custom_tabbar alloc] init];
        ryc_tabbarController.viewControllers = [NSArray arrayWithObjects:navigationController_First,navigationController_Second, navigationController_Third, navigationController_Fourth, nil];
        [self presentViewController:ryc_tabbarController animated:NO completion:^{
            
        }];
    
//    }
//    else
//    {
//        IntroduceViewController* vc = [[IntroduceViewController alloc] init];
//        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:vc];
//        [self presentViewController:navi animated:NO completion:^{
//        }];
//    }
//    AppDelegate* mainDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [mainDelegate showLoading:Nil];
//
//    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
//    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (!window)
//    {
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    }
//    window.rootViewController =
}

#pragma mark 开机联网
-(void)firtOpen
{
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
//    NSMutableDictionary * userInfoDict = [NSMutableDictionary dictionary];
//    [postDict setObject:userInfoDict forKey:@"params"];
    [postDict setObject:@"103" forKey:@"method"];
  
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self openSuccessWithInfo:responseObject From:@"firstOpen"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fff");
    }];
}

-(void)openSuccessWithInfo:(NSDictionary *)dict From:(NSString *)where
{
    if (([where isEqualToString:@"open"])||([where isEqualToString:@"firstOpen"])) {
        NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
        
        if ([[[dict objectForKey:@"version"] objectForKey:@"gameproVersion"] floatValue] > [version floatValue]) {
            NSString* appStoreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
            [[NSUserDefaults standardUserDefaults] setObject:appStoreURL forKey:@"IOSURL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检测到新版本，您要升级吗?" delegate:self cancelButtonTitle:@"立刻升级" otherButtonTitles:@"取消", nil];
            alert.tag = 21;
            [alert show];
        }
//        appStoreURL = [[dict objectForKey:@"version"] objectForKey:@"iosurl"];
//        [[NSUserDefaults standardUserDefaults] setObject:appStoreURL forKey:@"IOSURL"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSString * receivedImgStr = [dict objectForKey:@"firstImage"];
//        NSString * openImgStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"OpenImg"];
//        if (!openImgStr||![receivedImgStr isEqualToString:openImgStr]) {
//            [self downloadImageWithID:receivedImgStr Type:@"open" PicName:nil];
//        }
        if ([KISDictionaryHaveKey(dict, @"wow_realms") isKindOfClass:[NSDictionary class]]) {//注册服务器数据
            [[GameCommon shareGameCommon].wow_realms addEntriesFromDictionary:[dict objectForKey:@"wow_realms"]];
        }
        if ([KISDictionaryHaveKey(dict, @"wow_characterclasses") isKindOfClass:[NSArray class]]) {
            [[GameCommon shareGameCommon].wow_clazzs addObjectsFromArray:[dict objectForKey:@"wow_characterclasses"]];
        }
        
    }
    //    NSString * verifyCodeStatus = [dict objectForKey:@"verifyCode"];
    //    NSString * vd = @"shouldSend";
    //    if (verifyCodeStatus) {
    //        if ([verifyCodeStatus isEqualToString:@"disable"]) {
    //            vd = @"doNotSend";
    //        }
    //    }
    //    [[NSUserDefaults standardUserDefaults] setObject:vd forKey:@"verifyCode"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (21 == alertView.tag) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"IOSURL"]) {
                [[UIApplication sharedApplication] openURL:[[NSUserDefaults standardUserDefaults] objectForKey:@"IOSURL"]];
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
