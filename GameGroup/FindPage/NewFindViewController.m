//
//  NewFindViewController.m
//  GameGroup
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "NewFindViewController.h"
#import "NearByViewController.h"
#import "NormalTableCell.h"
#import "SameRealmViewController.h"
#import "CanRankTitleObjViewController.h"
#import "NewsViewController.h"
#import "EncoXHViewController.h"
#import <QuartzCore/QuartzCore.h>


#import "FindSubView.h"
#import "FinderView.h"
@interface NewFindViewController ()
{
    UIButton    *dynamicBtn;//动态
    UIButton    *nearByBtn;//附近
    UIButton    *samerealmBtn;//同F
    UIButton    *phoneBtn;//通讯录
    UIButton    *girlBtn;//魔女榜
    UIButton    *meetBtn;//邂逅
}
@end

@implementation NewFindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[Custom_tabbar showTabBar] hideTabBar:NO];
    
    if (![self isHaveLogin]) {
        [[Custom_tabbar showTabBar] when_tabbar_is_selected:0];
        return;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"发现" withBackButton:NO];
    
    
//    FindSubView *find = [[FindSubView alloc]initWithFrame:CGRectMake(0, startX, self.view.bounds.size.width, self.view.bounds.size.height-startX)];
//    [self.view addSubview:find];
    
    UIImageView *imageView =[[ UIImageView alloc]initWithFrame:CGRectMake(0, 0, 162, 191)];
    imageView.center =CGPointMake(154, 219+startX);
    imageView.image = KUIImage(@"finder_line");
    [self.view addSubview:imageView];
    
    meetBtn = [FinderView setButtonWithFrame:CGRectMake(0, 0, 102, 102) center:CGPointMake(154, 219+startX) backgroundNormalImage:@"meet_normal" backgroundHighlightImage:@"meet_click" setTitle:nil nextImage:nil nextImage:nil];
    meetBtn.layer.masksToBounds = YES;
    meetBtn.layer.cornerRadius = 51;

    [meetBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:meetBtn];
    
    
    dynamicBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 59, 59)];
    dynamicBtn.center =CGPointMake(105, 96+startX);
    [dynamicBtn setBackgroundImage:KUIImage(@"friendp_normal.png") forState:UIControlStateNormal];
    dynamicBtn.layer.masksToBounds = YES;
    dynamicBtn.layer.cornerRadius = 59/2;
    [dynamicBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:dynamicBtn];
    
    UILabel *friendLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 53, 16)];
    //friendLb.backgroundColor
    friendLb.center = CGPointMake(109, 139+startX);
    
    nearByBtn = [FinderView setButtonWithFrame:CGRectMake(0, 0, 41, 41) center:CGPointMake(252, 147+startX) backgroundNormalImage:@"nearby_normal" backgroundHighlightImage:@"nearby_click" setTitle:@"附近" nextImage:nil nextImage:nil];
    nearByBtn.layer.masksToBounds = YES;
    nearByBtn.layer.cornerRadius = 41/2;

    [nearByBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:nearByBtn];
    
    
    samerealmBtn = [FinderView setButtonWithFrame:CGRectMake(0, 0, 41, 41) center:CGPointMake(53, 193+startX) backgroundNormalImage:@"nearby_normal" backgroundHighlightImage:@"nearby_click" setTitle:@"同服" nextImage:@"nil" nextImage:@"nil"];
    samerealmBtn.layer.masksToBounds = YES;
    samerealmBtn.layer.cornerRadius = 41/2;

    [samerealmBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:samerealmBtn];
    
    
    
    girlBtn = [FinderView setButtonWithFrame:CGRectMake(0, 0, 56, 56) center:CGPointMake(252, 290+startX) backgroundNormalImage:@"girl_normal" backgroundHighlightImage:@"girl_click" setTitle:@"魔女榜" nextImage:nil nextImage:nil];
    girlBtn.layer.masksToBounds = YES;
    girlBtn.layer.cornerRadius = 56/2;

    [girlBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:girlBtn];
    
    
    phoneBtn = [FinderView setButtonWithFrame:CGRectMake(0, 0, 65, 65) center:CGPointMake(85, 333+startX) backgroundNormalImage:@"phone_normal" backgroundHighlightImage:@"phone_click" setTitle:@"通讯录" nextImage:nil nextImage:nil];
    phoneBtn.layer.masksToBounds = YES;
    phoneBtn.layer.cornerRadius = 65/2;

    [phoneBtn addTarget:self action:@selector(didClickenterMeet:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:phoneBtn];

    
    
	// Do any additional setup after loading the view.
}


-(void)didClickenterMeet:(UIButton *)sender
{
    NSLog(@"点击");
    
    if (sender ==meetBtn) {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        EncoXHViewController *enco = [[EncoXHViewController alloc]init];
        [self.navigationController pushViewController:enco animated:YES];

    }
    if (sender ==dynamicBtn) {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        NewsViewController* VC = [[NewsViewController alloc] init];
        VC.myViewType = FRIEND_NEWS_TYPE;
        VC.userId = [DataStoreManager getMyUserID];//好友动态
        [self.navigationController pushViewController:VC animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:haveFriendNews];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[GameCommon shareGameCommon] displayTabbarNotification];
 ;
    }
    if (sender ==girlBtn) {
        NSLog(@"魔女榜");
    }
    if (sender ==nearByBtn) {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        NearByViewController* VC = [[NearByViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];

    }
    if (sender ==samerealmBtn) {
        [[Custom_tabbar showTabBar] hideTabBar:YES];
        SameRealmViewController* realmsVC = [[SameRealmViewController alloc] init];
        [self.navigationController pushViewController:realmsVC animated:YES];

    }
    if (sender ==phoneBtn) {
        NSLog(@"手机通讯录");
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
