//
//  BaseViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-3.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#define isNieheing @"isssniehe"
#import "TempData.h"
@interface BaseViewController ()
{
    UILabel* showLabel;//黑底白字 提示文字
    UIView* showWindowView;//黑底白字 提示文字 window
    UIImageView *SimageView;
    UIView *nieheImageView;
    BOOL  isAlreadyNiehe;
    BOOL isOKniehe;
    UIView *leftView;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:leftView];
    //添加捏合手势
    if (self.navigationController.viewControllers.count==6&&![[NSUserDefaults standardUserDefaults]objectForKey:isNieheing]&&[[TempData sharedInstance]wxAlreadydidClickniehe]) {
        [self.view bringSubviewToFront:nieheImageView];
        nieheImageView.hidden = NO;
        SimageView.hidden = NO;
        isOKniehe = YES;
        [[TempData sharedInstance]setWxAlreadydidClickniehe:NO];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.view addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(ceshi)]];

    nieheImageView = [[UIView alloc]initWithFrame:self.view.bounds];
    nieheImageView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7];
    [self.view addSubview:nieheImageView];
    
    SimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 230, 300)];
    SimageView.center = nieheImageView.center;
    SimageView.image = [UIImage imageNamed:@"手势---回到首页_03"];
    SimageView.hidden=YES;
    nieheImageView.hidden = YES;
    [nieheImageView addSubview:SimageView];
    
    [nieheImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yincangimage:)]];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = kColorWithRGB(246, 246, 246, 1.0);

    startX = KISHighVersion_7 ? 64 : 44;
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, self.view.bounds.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftView];
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(backTolastPage:)];
    [recognizer delaysTouchesBegan];
    [leftView addGestureRecognizer:recognizer];
    
}
-(void)backTolastPage:(id)sender
{
    NSLog(@"滑动返回");
    if (self.navigationController.viewControllers.count>=1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)yincangimage:(UIGestureRecognizer *)sender
{
    nieheImageView.hidden = YES;
    SimageView.hidden =YES;
}
-(void)ceshi
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:isNieheing];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setTopViewWithTitle:(NSString*)titleStr withBackButton:(BOOL)hasBacButton
{
    UIImageView* topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, KISHighVersion_7 ? 64 : 44)];
//    topImageView.image = KUIImage(@"top");
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = kColorWithRGB(23, 161, 240, 1.0);
    topImageView.image = KUIImage(@"nav_bg");
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
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, KISHighVersion_7 ? 20 : 0, 65, 42)];
        [backButton setBackgroundImage:KUIImage(@"btn_back") forState:UIControlStateNormal];
        [backButton setBackgroundImage:KUIImage(@"btn_back_onclick") forState:UIControlStateHighlighted];
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
- (void)showMessageWindowWithContent:(NSString*)content imageType:(NSInteger)imageType
{
    if (showWindowView != nil) {
        [showWindowView removeFromSuperview];
    }
//    CGSize contentSize = [content sizeWithFont:[UIFont boldSystemFontOfSize:18.0] constrainedToSize:CGSizeMake(300, 100)];
//    
//    float width = MIN(contentSize.width + 10, 300);
//    float showstartX = MAX((320.0 - width)/2, 10.0);//取大者
    showWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    showWindowView.center = self.view.center;
    showWindowView.backgroundColor = [UIColor blackColor];
    showWindowView.layer.cornerRadius = 5;
    showWindowView.layer.masksToBounds = YES;
    showWindowView.alpha = 0.7;
    
    UIImageView* warnImage = [[UIImageView alloc] initWithFrame:CGRectMake(95.0/2, 25, 25, 25)];
    warnImage.backgroundColor = [UIColor clearColor];
    [showWindowView addSubview:warnImage];
    switch (imageType) {
        case 0://成功
            warnImage.image = KUIImage(@"show_success");
            break;
        case 1://加好友
            warnImage.image = KUIImage(@"show_add");
            break;
        case 2:
            warnImage.image = KUIImage(@"show_noadd");
            break;
        case 3://加关注
            warnImage.image = KUIImage(@"show_attention");
            break;
        case 4:
            warnImage.image = KUIImage(@"show_noattention");
            break;
        case 5://赞
            warnImage.image = KUIImage(@"show_zan");
            break;
        case 6:
            warnImage.image = KUIImage(@"show_nozan");
            break;
        default:
            break;
    }
    
    UILabel* showWindowLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 120, 25)];
    showWindowLabel.backgroundColor = [UIColor clearColor];
    showWindowLabel.font = [UIFont boldSystemFontOfSize:15.0];
    showWindowLabel.textColor = [UIColor whiteColor];
    showWindowLabel.textAlignment = NSTextAlignmentCenter;
    showWindowLabel.text = content;
    [showWindowView addSubview:showWindowLabel];
    
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] makeKeyWindow];

    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:showWindowView];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(hideWindowView) withObject:nil afterDelay:1.0f];
}

- (void)hideWindowView
{
//    showWindowView.frame = CGRectZero;
    if (showWindowView != nil) {
        [showWindowView removeFromSuperview];
    }
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
