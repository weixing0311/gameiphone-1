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
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 300, 50)];
    label1.numberOfLines = 0;
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor grayColor];
    label1.text = @"陌游没能成功开启通讯录.开启通讯录后才能快速添加好友.";
    [scrollV addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 300, 30)];
    label2.backgroundColor =[UIColor clearColor];
    label2.font = [UIFont boldSystemFontOfSize:20];
    label2.text = @"开启方法:";
    label2.textColor = [UIColor grayColor];
    [scrollV addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 300, 20)];
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"1.回到手机桌面,找到手机设置";
    label3.textColor = [UIColor grayColor];
    [scrollV addSubview:label3];
    
    UIImageView * imageV1 = [[UIImageView alloc]initWithFrame:CGRectMake(66, 240, 188.5, 94)];
    imageV1.image = [UIImage imageNamed:@"screenshot1"];
    [scrollV addSubview:imageV1];
    
    UILabel * label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 350, 300, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.text = @"2.打开隐私";
    label4.textColor = [UIColor grayColor];
    [scrollV addSubview:label4];
    
    UIImageView * imageV2 = [[UIImageView alloc]initWithFrame:CGRectMake(66, 390, 188.5, 94)];
    imageV2.image = [UIImage imageNamed:@"screenshot2"];
    [scrollV addSubview:imageV2];
    
    UILabel * label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 500, 300, 20)];
    label5.backgroundColor = [UIColor clearColor];
    label5.text = @"3.选择通讯录";
    label5.textColor = [UIColor grayColor];
    [scrollV addSubview:label5];
    
    UIImageView * imageV3 = [[UIImageView alloc]initWithFrame:CGRectMake(66, 530, 188.5, 94)];
    imageV3.image = [UIImage imageNamed:@"screenshot3"];
    [scrollV addSubview:imageV3];
    
    UILabel * label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 640, 300, 20)];
    label6.backgroundColor = [UIColor clearColor];
    label6.text = @"4.开启陌游的通讯录";
    label6.textColor = [UIColor grayColor];
    [scrollV addSubview:label6];
    
    UIImageView * imageV4 = [[UIImageView alloc]initWithFrame:CGRectMake(66, 670, 188.5, 94)];
    imageV4.image = [UIImage imageNamed:@"screenshot4"];
    [scrollV addSubview:imageV4];
    
    scrollV.contentSize = CGSizeMake(320, 800);
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
