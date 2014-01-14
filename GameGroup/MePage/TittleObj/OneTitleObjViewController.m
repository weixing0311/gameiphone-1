//
//  OneTitleObjViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-30.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "OneTitleObjViewController.h"
#import "TitleObjUpView.h"

#define degreesToRadians(x) (M_PI*(x)/180.0)//弧度

@interface OneTitleObjViewController ()
{
    NSDictionary*   m_dataDic;
    UIButton*      m_backButton;
}
@end

@implementation OneTitleObjViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
    self.view.bounds = CGRectMake(0.0, 0.0, kScreenHeigth, kScreenWidth);

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self getTitleObjDetailByNet];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"查询中...";
    [self.view addSubview:hud];
}

- (void)getTitleObjDetailByNet
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    
    [params setObject:self.titleId forKey:@"dynamicmsgId"];

    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"133" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];

    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
    
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        m_dataDic = responseObject;
        [self setMainView];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if ([[error objectForKey:kFailErrorCodeKey] isEqualToString:@"100031"]) {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                alert.tag = 123;
                [alert show];
            }
            else
            {

                [self setTopViewWithTitle:@"头衔详情" withBackButton:YES];
            }
        }
        [hud hide:YES];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setMainView
{
    TitleObjUpView* oneView = [[TitleObjUpView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeigth, kScreenWidth)];
    NSDictionary* titleDic = KISDictionaryHaveKey(m_dataDic, @"titleObj");
    if (![titleDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    oneView.rightImageId = KISDictionaryHaveKey(titleDic, @"img");
    oneView.gameId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(titleDic, @"gameid")];
    oneView.rarenum= [GameCommon getNewStringWithId:KISDictionaryHaveKey(titleDic, @"rarenum")];//稀有度
    oneView.titleName= KISDictionaryHaveKey(titleDic, @"title");
    oneView.characterName= KISDictionaryHaveKey(m_dataDic, @"charactername");
    oneView.remark= KISDictionaryHaveKey(titleDic, @"remark");
    
    oneView.rarememo= KISDictionaryHaveKey(titleDic, @"rarememo");//%
    
    oneView.detailDis= KISDictionaryHaveKey(titleDic, @"remark");//查看详情内容
    [oneView setMainView];
    [self.view addSubview:oneView];
    
    m_backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [m_backButton setBackgroundImage:KUIImage(@"back") forState:UIControlStateNormal];
    [m_backButton setBackgroundImage:KUIImage(@"back_click") forState:UIControlStateHighlighted];
    m_backButton.backgroundColor = [UIColor clearColor];
    [m_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_backButton];
}

#pragma mark 手势
- (void)tapClick:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        //        if (topView.center.y < 0) {
        //            topView.center = CGPointMake(kScreenHeigth/2, 22);
        //        }
        //        else
        //            topView.center = CGPointMake(kScreenHeigth/2, -22);
        if (m_backButton.center.y < 0) {
            m_backButton.center = CGPointMake(25, 22);
        }
        else
        {
            m_backButton.center = CGPointMake(25, -22);
        }
    } completion:^(BOOL finished) {
        
    }];
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
