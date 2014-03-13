//
//  MagicGirlViewController.m
//  GameGroup
//
//  Created by admin on 14-3-7.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "MagicGirlViewController.h"
#import "TestViewController.h"
#import "FunsOfOtherViewController.h"
@interface MagicGirlViewController ()
{
    UIWebView *contentWebView;
}
@end

@implementation MagicGirlViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    
    contentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (KISHighVersion_7?20:0), 320, self.view.bounds.size.height-(KISHighVersion_7?20:0))];
    contentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentWebView.delegate = self;
    
//    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[MymonvbangURL stringByAppendingString:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]]]]];
    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://58.83.193.119/h5/index.html?0B5DAE32FC15470B862E961E41A8B2E5&from_client_ios"]]];
    
    
    NSLog(@"%@",[MymonvbangURL stringByAppendingString:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]]);
    
    [(UIScrollView *)[[contentWebView subviews] objectAtIndex:0] setBounces:NO];
    [self.view addSubview:contentWebView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在加载网页...";
    // Do any additional setup after loading the view.


}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [hud show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [hud hide:YES];
    [webView stopLoading];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网页加载失败" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"重新加载", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [contentWebView reload];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *urlComps = [urlString
                         componentsSeparatedByString:@"://"];
    if([urlComps count] && [[urlComps objectAtIndex:0]
                            isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps
                                                       objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        NSLog(@"%@",funcStr);
        if (1 == [arrFucnameAndParameter count])
        {
            // 没有参数
            
            
            if([funcStr isEqualToString:@"closeWindows"])
            {
                /*调用本地函数1*/
                NSLog(@"doFunc1");
                [self closeWindows];
            }
        }
        else if(2 == [arrFucnameAndParameter count])
        {
            //有参数的
            if([funcStr isEqualToString:@"closeWindows"] &&
               [arrFucnameAndParameter objectAtIndex:1])
            {
                /*调用本地函数1*/
                NSLog(@"doFunc1:parameter");
            }
        }
        return NO;
    };
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入个人资料界面
-(void)enterPersonInterfaceWithId:(NSString *)userid
{
    TestViewController *testVC = [[TestViewController alloc]init];
    testVC.userId = userid;
    [self.navigationController pushViewController:testVC animated:YES];
}

-(void)enterFansPageWithId:(NSString*)userid
{
    FunsOfOtherViewController *fans = [[FunsOfOtherViewController alloc]init];
    fans.userId = userid;
    [self.navigationController pushViewController:fans animated:YES];
}

- (void)closeWindows
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
