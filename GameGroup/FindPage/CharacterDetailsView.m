//
//  CharacterDetailsView.m
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "CharacterDetailsView.h"

@implementation CharacterDetailsView
{
    NSInteger m_pageNum;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.TopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
        self.TopScrollView.contentSize = CGSizeMake(self.bounds.size.width *3, 200);
        self.TopScrollView.pagingEnabled = YES;
        self.TopScrollView.bounces = NO;
        self.TopScrollView.showsHorizontalScrollIndicator =NO;
        self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);

       [self addSubview:self.TopScrollView];
        for (int i = 0; i <3; i++) {
            self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(320*i, 0, 320, 200)];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:KUIImage(@"wowfriend.jpg")];
            [array addObject:KUIImage(@"wowserverwow.jpg")];
            [array addObject:KUIImage(@"wowall.jpg")];
            self.topImageView.image = [array objectAtIndex:i];
            [self.TopScrollView addSubview:self.topImageView];
        }
        [self buildRightView];
        [self buildRoleView];
        self.authView = [[UIView alloc]initWithFrame:CGRectMake(290, 40, 45, 20)];
        self.authView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.authView];
        
        UILabel * authLabel = [[UILabel alloc]initWithFrame:self.authView.bounds ];
        authLabel.backgroundColor = [UIColor clearColor];
        authLabel.textColor = [UIColor whiteColor];
        authLabel.text = @"未认证";
        authLabel.font = [UIFont systemFontOfSize:9];
        [self.authView addSubview:authLabel];

        [self buildButton];
        
        self.listScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 244, 320, 300)];
        self.listScrollView.pagingEnabled = YES;
        self.listScrollView.contentSize = CGSizeMake(320*3, 244);
        self.listScrollView.contentOffset = CGPointMake(m_pageNum*self.listScrollView.bounds.size.width, 0);

        [self addSubview:self.listScrollView];

        
        
        
    }
    return self;
}
//右上view “石爪峰 部落  战士”
-(void)buildRightView
{
    self.rightPView = [[UIView alloc]initWithFrame:CGRectMake(170, 0, 160, 35)];
    self.rightPView.backgroundColor = [UIColor colorWithRed:0/225.0f green:0/225.0f blue:0/225.0f alpha:0.6];
    [self addSubview:self.rightPView];
    //wow图标
    self.gameIdView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    self.gameIdView.image = KUIImage(@"wow");
    [self.rightPView addSubview:self.gameIdView];
    
    self.realmView = [[UILabel alloc]initWithFrame:CGRectMake(30, 2, 120, 30)];
    self.realmView.backgroundColor =[UIColor clearColor];
    self.realmView.textColor = [UIColor whiteColor];
 //   self.realmView.text = @"石爪峰 部落 战士";
    self.realmView.font = [UIFont systemFontOfSize:12];
    [self.rightPView addSubview:self.realmView];
}

-(void)buildRoleView//职业资料条
{
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, 320, 70)];
    self.titleView.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.6];
    [self addSubview:self.titleView];
    //头像
    self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 56, 56)];
    self.headerImageView.image =KUIImage(@"ceshi.jpg");
    [self.titleView addSubview:self.headerImageView];
    
    //角色名
    self.NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 200, 35)];
  //  self.NickNameLabel.text = @"下一站停留";
    self.NickNameLabel.backgroundColor = [UIColor clearColor];
    self.NickNameLabel.textColor = [UIColor whiteColor];
    self.NickNameLabel.font = [UIFont systemFontOfSize:22];
    [self.titleView addSubview:self.NickNameLabel];
    
    //公会
    self.guildLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 40, 230, 25)];
  //  self.guildLabel.text = @"<众神之巅>";
    self.backgroundColor = [UIColor clearColor];
    self.guildLabel.textColor = [UIColor whiteColor];
    self.guildLabel.font = [UIFont systemFontOfSize:16];
    [self.titleView addSubview:self.guildLabel];
    
    //职业图标
    /* clazz_1.png--10 */
    self.clazzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(230, 8, 25, 25)];
 //   self.clazzImageView.image = KUIImage(@"clazz_1");
    [self.titleView addSubview:self.clazzImageView];

    
    //等级
    self.levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(258, 8, 60, 25)];
  //  self.levelLabel.text = @"90级";
    self.backgroundColor = [UIColor clearColor];
    self.levelLabel.textColor = [UIColor whiteColor];
    self.levelLabel.font = [UIFont systemFontOfSize:18];
    [self.titleView addSubview:self.levelLabel];

    //装等
    self.itemlevelView = [[UILabel alloc]initWithFrame:CGRectMake(230, 40, 80, 30)];
  //  self.itemlevelView.text = @"576/576";
    self.backgroundColor = [UIColor clearColor];
    self.itemlevelView.textColor = [UIColor whiteColor];
    self.itemlevelView.font = [UIFont systemFontOfSize:18];
    [self.titleView addSubview:self.itemlevelView];

    
}

-(void)buildButton
{
    self.countryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.countryBtn.frame = CGRectMake(106, 200, 106, 44);
    [self.countryBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    [self.countryBtn setTitle:@"全国" forState:UIControlStateNormal];
    [self.countryBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.countryBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [self addSubview:self.countryBtn];
    
    self.myFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.myFriendBtn.frame = CGRectMake(0, 200, 106,44);
    [self.myFriendBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    [self.myFriendBtn setTitle:@"好友" forState:UIControlStateNormal];
    [self.myFriendBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self.myFriendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [self addSubview:self.myFriendBtn];
    
    self.realmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.realmBtn.frame = CGRectMake(212, 200,106,44);;
    [ self.realmBtn setBackgroundImage:KUIImage(@"tab_bg") forState:UIControlStateNormal];
    [ self.realmBtn setTitle:@"服务器" forState:UIControlStateNormal];
    [ self.realmBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [ self.realmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [self addSubview: self.realmBtn];
    //全国
    [self.countryBtn addTarget:self action:@selector(changePageNational:) forControlEvents:UIControlEventTouchUpInside];
    //好友
    [self.myFriendBtn addTarget:self action:@selector(changePageWithFriend:) forControlEvents:UIControlEventTouchUpInside];
    //全服务器
    [self.realmBtn addTarget:self action:@selector(changePageRealm:) forControlEvents:UIControlEventTouchUpInside];

    self.underListImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 240,106,4)];
    self.underListImageView.image =KUIImage(@"tab_line");
    [self addSubview:self.underListImageView];
}

-(void)changePageWithFriend:(id)sender
{
    NSLog(@"1");
    self.myFriendBtn.selected = NO;
    self.countryBtn.selected = YES;
    self.realmBtn.selected = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    m_pageNum =0;
    self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);
    self.listScrollView.contentOffset = CGPointMake(m_pageNum*self.listScrollView.bounds.size.width, 0);

    self.underListImageView.frame = CGRectMake(0, 240, 106, 4);
    [UIView commitAnimations];
    
    m_pageNum =0;
    self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);

    if (self.myChangeDelegate &&[self.myChangeDelegate respondsToSelector:@selector(changePageNational:)]) {
        [self.myChangeDelegate changePageWithFriend:self];
    }


}
-(void)changePageNational:(id)sender
{
    NSLog(@"2");
    self.myFriendBtn.selected = YES;
    self.countryBtn.selected = NO;
    self.realmBtn.selected = YES;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    m_pageNum =1;
    self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);

    self.listScrollView.contentOffset = CGPointMake(m_pageNum*self.listScrollView.bounds.size.width, 0);

    self.underListImageView.frame = CGRectMake(106, 240, 106, 4);
    [UIView commitAnimations];
    
    m_pageNum =1;
    self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);

    if (self.myChangeDelegate &&[self.myChangeDelegate respondsToSelector:@selector(changePageNational:)]) {
        [self.myChangeDelegate changePageWithCountry:self];
    }
}
-(void)changePageRealm:(id)sender
{
    NSLog(@"3");
    self.myFriendBtn.selected = YES;
    self.countryBtn.selected = YES;
    self.realmBtn.selected = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    m_pageNum =2;
    self.TopScrollView.contentOffset = CGPointMake(m_pageNum*self.TopScrollView.bounds.size.width, 0);

    self.listScrollView.contentOffset = CGPointMake(m_pageNum*self.listScrollView.bounds.size.width, 0);

    self.underListImageView.frame = CGRectMake(212, 240, 106, 4);
    [UIView commitAnimations];
    

    
    if (self.myChangeDelegate &&[self.myChangeDelegate respondsToSelector:@selector(changePageNational:)]) {
        [self.myChangeDelegate changePageWithReaml:self];
    }


}

@end
