//
//  MagicGirlViewController.m
//  GameGroup
//
//  Created by admin on 14-3-7.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "MagicGirlViewController.h"
#import "TestViewController.h"
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
	// Do any additional setup after loading the view.
    
    contentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (KISHighVersion_7?0:20), 320, self.view.bounds.size.height)];
    contentWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentWebView.delegate = self;
    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[MymonvbangURL stringByAppendingString:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]]]]];
    
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
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)enterPersonInterfaceWithId:(NSString *)userid nickName:(NSString *)nickName
{
    TestViewController *testVC = [[TestViewController alloc]init];
    testVC.userId = userid;
    testVC.nickName = nickName;
    [self.navigationController pushViewController:testVC animated:YES];
}


- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
