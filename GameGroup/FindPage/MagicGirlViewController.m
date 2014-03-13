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
    
    [contentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[MymonvbangURL stringByAppendingString:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]]]]];
    
    
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
    NSString *js = @"document.documentElement.innerHTML";
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:js];
    NSLog(@"======%@",html);
    //移除div
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     //设置方法
     "script.text = \"function myFunction() { "
     //设置div的高度为0px
     "document.body.style.padding='0px';"
     //设置header的高度为0px
     "var headerTitle = document.getElementsByTagName('header')[0];"
     "headerTitle.style.height = '0px';"
     //设置header的字为空
     "headerTitle.innerHTML = '';"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"
    //调用方法
    "document.group.getElementsByTagName('supper')[0].appendChild(bg)"];
    
    
    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];

    
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
    
        NSString *requestString = [[request URL] absoluteString];
        
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSLog(@"-----%@",components);
        NSLog(@"requsetstring%@",requestString);
        if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"lfyprotocol"]) {
            if([(NSString *)[components objectAtIndex:1] isEqualToString:@"http"] || [(NSString *)[components objectAtIndex:1] isEqualToString:@"https"]){
                //这个就是图片的路径
                NSLog(@"+++++++%@",components);
                NSString *path = [NSString stringWithFormat:@"%@:%@",[components objectAtIndex:1],[components objectAtIndex:2]];
                NSLog(@"path%@",path);
            }
            return NO;
        }
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//进入个人资料界面
-(void)enterPersonInterfaceWithId:(NSString *)userid nickName:(NSString *)nickName
{
    TestViewController *testVC = [[TestViewController alloc]init];
    testVC.userId = userid;
    testVC.nickName = nickName;
    [self.navigationController pushViewController:testVC animated:YES];
}

-(void)enterFansPageWithId:(NSString*)userid
{
    FunsOfOtherViewController *fans = [[FunsOfOtherViewController alloc]init];
    fans.userId = userid;
    [self.navigationController pushViewController:fans animated:YES];
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
