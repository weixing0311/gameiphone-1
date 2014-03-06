//
//  IntroduceViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "IntroduceViewController.h"
#import "LoginViewController.h"


@interface IntroduceViewController ()
{
    UIScrollView*   m_myScrollView;
    NSTimer*        m_timer;
    
    NSInteger       m_currentPage;//当前页码
    
    float           diffH;
}
@end

@implementation IntroduceViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(m_timer != nil)
	{
		[m_timer invalidate];
		m_timer = nil;
	}

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(m_timer != nil)
	{
		[m_timer invalidate];
		m_timer = nil;
	}
	else
	{
		m_timer = [NSTimer scheduledTimerWithTimeInterval:(3.0) target:self selector:@selector(refreshLeftTime)
												 userInfo:nil repeats:YES];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;

    diffH = [GameCommon diffHeight:self];

    m_myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, kScreenHeigth - ((diffH == 0) ? 20 : 0))];

    
    NSLog(@"%@", NSStringFromCGRect(m_myScrollView.frame));
    m_myScrollView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 5; i++) {
        UIImageView* bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, m_myScrollView.frame.size.height)];
        if (i == 0 || i == 4) {
            if (i == 0) {
                bgImage.image = KUIImage(@"first_3.jpg");
            }
            else
                bgImage.image = KUIImage(@"first_1.jpg");
        }
        else
        {
            NSString* imageName = [NSString stringWithFormat:@"first_%d.jpg", i];
            bgImage.image = KUIImage(imageName);
        }
        bgImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [m_myScrollView addSubview:bgImage];
    }
    m_myScrollView.pagingEnabled = YES;
    m_myScrollView.scrollEnabled = YES;
    m_myScrollView.contentSize = CGSizeMake(320 * 5, kScreenHeigth - ((diffH == 0) ? 20 : 0));

    
    
    m_myScrollView.showsHorizontalScrollIndicator = NO;
    m_myScrollView.showsVerticalScrollIndicator = NO;
    m_myScrollView.delegate = self;
    m_myScrollView.contentOffset = CGPointMake(320, KISHighVersion_7 ? 20 : 0);//开始展示第2页
    m_myScrollView.bounces = NO;
    [self.view addSubview:m_myScrollView];
    
    m_currentPage = 1;
    
    UIButton* loginButton = [[UIButton alloc] initWithFrame:CGRectMake(25, m_myScrollView.frame.size.height - 60, 120, 35)];
    [loginButton setBackgroundImage:KUIImage(@"login_button_normal") forState:UIControlStateNormal];
    [loginButton setBackgroundImage:KUIImage(@"login_button_click") forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIButton* registerButton = [[UIButton alloc] initWithFrame:CGRectMake(175, m_myScrollView.frame.size.height - 60, 120, 35)];
    [registerButton setBackgroundImage:KUIImage(@"register_button_normal") forState:UIControlStateNormal];
    [registerButton setBackgroundImage:KUIImage(@"register_button_click") forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
}

- (void)refreshLeftTime
{
//    CGRect newRect;
    if (m_currentPage == 3) {//最后一页
        m_myScrollView.contentOffset = CGPointMake(320, 0);
        m_currentPage = 1;
    }
    else
    {
        m_myScrollView.contentOffset = CGPointMake(320 * (m_currentPage + 1), 0);
        m_currentPage++;
    }
}

#pragma mark button click
- (void)loginButtonClick:(id)sender
{
    LoginViewController* vc = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)registerButtonClick:(id)sender
{
    RegisterViewController* vc = [[RegisterViewController alloc] init];
    vc.delegate = self.delegate;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark scrollView 手动划
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	CGPoint offsetofScrollView = scrollView.contentOffset;
    
    //[m_pageController setCurrentPage:offsetofScrollView.x / self.scroll.frame.size.width];
    
	NSInteger page = offsetofScrollView.x / m_myScrollView.frame.size.width;
	
    if(0 == page || 4 == page)
	{
        CGRect rect;
        if (0 == page)
        {
            rect = CGRectMake(3 * m_myScrollView.frame.size.width, 0, m_myScrollView.frame.size.width, m_myScrollView.frame.size.height);
            m_currentPage = 3;
        }
        else
        {
            rect = CGRectMake(m_myScrollView.frame.size.width, 0, m_myScrollView.frame.size.width, m_myScrollView.frame.size.height);
            m_currentPage = 1;
        }
        [m_myScrollView scrollRectToVisible:rect animated:NO];
    }
    else
    {
        CGRect rect = CGRectMake(page * m_myScrollView.frame.size.width, 0,
                                 m_myScrollView.frame.size.width, m_myScrollView.frame.size.height);
        [m_myScrollView scrollRectToVisible:rect animated:NO];
        m_currentPage = page;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
