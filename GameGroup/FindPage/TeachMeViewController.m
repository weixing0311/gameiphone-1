//
//  TeachMeViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-12.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "TeachMeViewController.h"

@interface TeachMeViewController ()
{
    UIScrollView * scrollV;
}
@end

@implementation TeachMeViewController

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
    scrollV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    scrollV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollV];
    [self setTopViewWithTitle:@"开启通讯录" withBackButton:YES];
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 300, 40)];
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor grayColor];
    label1.text = @"陌游没能成功开启通讯录.开启通讯录后快速添加.";
    [scrollV addSubview:label1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
