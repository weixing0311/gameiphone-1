//
//  AboutViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 14-1-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"关于小伙伴" withBackButton:YES];
    
    [self setMainView];
}

- (void)setMainView
{
    UIImageView* logImg = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-57)/2, startX + 20, 57, 57)];
    logImg.image = KUIImage(@"icon");
    logImg.layer.cornerRadius = 5;
    logImg.layer.masksToBounds = YES;
    [self.view addSubview:logImg];
    
    UILabel *detailLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(0, startX + 100, kScreenWidth, 30) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont systemFontOfSize:13.0] text:[NSString stringWithFormat:@"当前版本号:%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]] textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:detailLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
