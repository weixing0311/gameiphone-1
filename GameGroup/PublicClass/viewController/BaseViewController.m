//
//  BaseViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-3.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UILabel* showLabel;//黑底白字 提示文字
    UILabel* showWindowLabel;//黑底白字 提示文字 window
}
@end

@implementation BaseViewController

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
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = kColorWithRGB(246, 246, 246, 1.0);

    startX = KISHighVersion_7 ? 64 : 44;
}

- (void)setTopViewWithTitle:(NSString*)titleStr withBackButton:(BOOL)hasBacButton
{
    UIImageView* topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, KISHighVersion_7 ? 64 : 44)];
//    topImageView.image = KUIImage(@"top");
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = kColorWithRGB(23, 161, 240, 1.0);
    [self.view addSubview:topImageView];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopViewClick:)];
    tapGesture.delegate = self;
    [topImageView addGestureRecognizer:tapGesture];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KISHighVersion_7 ? 20 : 0, 220, 44)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    if (hasBacButton) {
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KISHighVersion_7 ? 20 : 0, 50, 44)];
        [backButton setBackgroundImage:KUIImage(@"back") forState:UIControlStateNormal];
        [backButton setBackgroundImage:KUIImage(@"back_click") forState:UIControlStateHighlighted];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:backButton];
    }
}

- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 黑底白字提示
- (void)showMessageWithContent:(NSString*)content point:(CGPoint)point
{
    if (showLabel != nil) {
        [showLabel removeFromSuperview];
    }
    CGSize contentSize = [content sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(300, 100)];
    
    float width = MIN(contentSize.width + 10, 300);
//    float showstartX = MAX((320.0 - width)/2, 10.0);//取大者
    
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, contentSize.height + 20)];
    showLabel.center = point;
    showLabel.backgroundColor = [UIColor blackColor];
    showLabel.alpha = 0.8;
    showLabel.font = [UIFont boldSystemFontOfSize:15.0];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.layer.cornerRadius = 5;
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.text = content;

//    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];
//    
//    UIWindow* window = [UIApplication sharedApplication].keyWindow;
//    if (!window)
//    {
//        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
//    }
//    [window addSubview:showLabel];
    [self.view addSubview:showLabel];

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0f];
}

- (void)hideView
{
    showLabel.frame = CGRectZero;
}

#pragma mark window提示
- (void)showMessageWindowWithContent:(NSString*)content pointY:(float)pointY
{
    if (showWindowLabel != nil) {
        [showWindowLabel removeFromSuperview];
    }
    CGSize contentSize = [content sizeWithFont:[UIFont boldSystemFontOfSize:18.0] constrainedToSize:CGSizeMake(300, 100)];
    
    float width = MIN(contentSize.width + 10, 300);
    float showstartX = MAX((320.0 - width)/2, 10.0);//取大者
    
    showWindowLabel = [[UILabel alloc] initWithFrame:CGRectMake(showstartX, pointY, width, contentSize.height + 20)];
    showWindowLabel.backgroundColor = [UIColor blackColor];
    showWindowLabel.alpha = 0.7;
    showWindowLabel.font = [UIFont boldSystemFontOfSize:18.0];
    showWindowLabel.textColor = [UIColor whiteColor];
    showWindowLabel.layer.cornerRadius = 5;
    showWindowLabel.textAlignment = NSTextAlignmentCenter;
    showWindowLabel.text = content;
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:showWindowLabel];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(hideWindowView) withObject:nil afterDelay:3.0f];
}

- (void)hideWindowView
{
    showWindowLabel.frame = CGRectZero;
}

#pragma mark 弹出显示框
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)bTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:bTitle otherButtonTitles:nil];
    alert.tag = 99999;
    [alert show];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark 是否登陆
- (BOOL)isHaveLogin
{
//    if ([SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil]) {//登录
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PhoneNumKey] && ![[[NSUserDefaults standardUserDefaults] objectForKey:PhoneNumKey] isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

#pragma mark 手势
- (void)tapTopViewClick:(id)sender
{
   
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
