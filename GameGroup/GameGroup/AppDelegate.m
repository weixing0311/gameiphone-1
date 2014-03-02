//
//  AppDelegate.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-3.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "AppDelegate.h"
#import "TempData.h"
#import "StartViewController.h"
#import "XMPPHelper.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "GetDataAfterManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:3.0];//开机图停留秒数
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.startViewController = [[StartViewController alloc] init];
    self.window.rootViewController = self.startViewController;
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];//打印xmpp输出
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.xmppHelper=[[XMPPHelper alloc] init];

    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    [MobClick startWithAppkey:@"52caacec56240b18e2035237"];
//    [MobClick startWithAppkey:@"xxxxxxxxxxxxxxx" reportPolicy:BATCH   channelId:@""];
    
    [GetDataAfterManager shareManageCommon];
    
    //网络变化
    Reachability * reach = [Reachability reachabilityForInternetConnection];
  
    
    [reach startNotifier];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark 推送
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"嘻嘻嘻嘻 My token is: %@", deviceToken);
    NSString* tokenStr = [deviceToken description];
    //NSLog(@"%d", tokenStr.length);
    [GameCommon shareGameCommon].deviceToken = [tokenStr substringWithRange:NSMakeRange(1, tokenStr.length - 2)];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"呜呜呜呜 Failed to get token, error: %@", error);
    [GameCommon shareGameCommon].deviceToken = @"";
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //它是类里自带的方法,这个方法得说下，很多人都不知道有什么用，它一般在整个应用程序加载时执行，挂起进入后也会执行，所以很多时候都会使用到，将小红圈清空
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_BecomeActive" object:nil userInfo:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //推送消息处理
    // NSLog(@"&&&&&&& %@", userInfo);
    //{
    //aps =     {
    //    alert = "This is some fany message.";
    //    badge = 1;
    //    sound = "received5.caf";
    //};
    //     NSLog(@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self.xmppHelper disconnect];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
