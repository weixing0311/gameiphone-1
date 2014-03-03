//
//  TitleObjDetailViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-26.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "TitleObjDetailViewController.h"
#import "TitleObjUpView.h"
#import "PersonDetailViewController.h"
#import "SendNewsViewController.h"

#define degreesToRadians(x) (M_PI*(x)/180.0)//弧度

#define kSegmentFriend (0)
#define kSegmentRealm (1)
#define kSegmentCountry (2)

@interface TitleObjDetailViewController ()
{
//    UIView*        topView;
    UIButton*      m_backButton;
    UIButton*      m_shareButton;
    
    UIScrollView*  upScroll;
    UIScrollView*  downScroll;
    
    UIPageControl*  pageControl;
    
    UIButton*       sortButton;
    UIButton*       backUpButton;

    UIButton*       m_friendButton;
    UIButton*       m_realmButton;
    UIButton*       m_countryButton;
    
    NSInteger       m_segmentClickIndex;
    
    UILabel*        m_sortTypeLabel;
    
    NSInteger       m_lastPageIndex;
    NSInteger       m_begainPageIndex;
    NSInteger       m_tableShowIndex;
    
    UITableView*    m_sortTableView;
    NSMutableArray* m_sortDataArray;
    
    PullUpRefreshView      *refreshView;
    PullDownRefreshView    *pullDownView;
    
    BOOL            isGetForData;//获取前面的数据
    
    BOOL            isShowSend;//是否提示发布成功
    
    UIView*         bgView;//action出来时另外半边
    
    UIView*         m_warnView;//发表成功提示语
}
@end

@implementation TitleObjDetailViewController

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
    
    if (isShowSend)
    {
//        [self showMessageWithContent:@"发表成功" point:CGPointMake(kScreenHeigth/2, kScreenWidth - 50)];
        [self showWarnView];
        isShowSend = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
//    self.view.bounds = CGRectMake(0.0, 0.0, kScreenWidth, kScreenHeigth);
//    self.view.frame = CGRectMake(0.0, 0.0, kScreenHeigth, kScreenWidth);
    NSLog(@"haizai %@=%@=%f,%f",NSStringFromCGRect(self.view.frame),
          NSStringFromCGRect(self.view.bounds),kScreenWidth,kScreenHeigth);
    
    upScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeigth, kScreenWidth)];
    upScroll.backgroundColor = [UIColor grayColor];
    upScroll.scrollEnabled = YES;
    upScroll.delegate = self;
    upScroll.bounces = NO;
    upScroll.pagingEnabled = YES;
    upScroll.showsHorizontalScrollIndicator = NO;
    upScroll.contentSize = CGSizeMake(kScreenHeigth * [self.titleObjArray count], kScreenWidth);
    upScroll.contentOffset = CGPointMake(kScreenHeigth * self.showIndex, 0);
    [self.view addSubview:upScroll];
//
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    tapGesture.delegate = self;
//    [upScroll addGestureRecognizer:tapGesture];
//    
    downScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenWidth, kScreenHeigth, kScreenWidth)];
    downScroll.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downScroll];
    
//    UITapGestureRecognizer * tapGesture_dowm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    tapGesture_dowm.delegate = self;
//    [downScroll addGestureRecognizer:tapGesture_dowm];
    
    m_segmentClickIndex = kSegmentFriend;
    
    [self setTopView];
    [self setUpView];
   // [self setDownView];
   // [self setTableTopView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
}

- (void)showWarnView
{
    if (m_warnView != nil) {
        [m_warnView removeFromSuperview];
    }
    m_warnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 100)];
    m_warnView.center = CGPointMake(kScreenHeigth/2, kScreenWidth/2);
    m_warnView.backgroundColor = [UIColor blackColor];
    m_warnView.layer.cornerRadius = 5;
    m_warnView.layer.masksToBounds = YES;
    m_warnView.alpha = 0.7;
    [self.view addSubview:m_warnView];
    
    UIImageView* warnImage = [[UIImageView alloc] initWithFrame:CGRectMake(95.0/2, 25, 25, 25)];
    warnImage.backgroundColor = [UIColor clearColor];
    [m_warnView addSubview:warnImage];
    warnImage.image = KUIImage(@"show_success");

    UILabel* showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 120, 25)];
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.font = [UIFont boldSystemFontOfSize:15.0];
    showLabel.textColor = [UIColor whiteColor];
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.text = @"发表成功";
    [m_warnView addSubview:showLabel];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideView) object:nil];//取消该方法的调用
    [self performSelector:@selector(hideView) withObject:nil afterDelay:2.0f];
}

- (void)hideView
{
    m_warnView.frame = CGRectZero;
}

- (void)setTopView
{
//    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeigth, 44)];
////    topView.backgroundColor = kColorWithRGB(23, 161, 240, 1.0);
//    topView.backgroundColor = [UIColor clearColor];
//    topView.alpha = 0.8;
//    [self.view addSubview:topView];
    
//    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kScreenHeigth - 100, 44)];
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = @"头衔详情";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    [topView addSubview:titleLabel];
    
    m_backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [m_backButton setBackgroundImage:KUIImage(@"back_2") forState:UIControlStateNormal];
    [m_backButton setBackgroundImage:KUIImage(@"back_click") forState:UIControlStateHighlighted];
    m_backButton.backgroundColor = [UIColor clearColor];
    [m_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_backButton];
    
    m_shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
    m_shareButton.frame=CGRectMake(kScreenHeigth - 50, 0, 50, 44);
    [m_shareButton setBackgroundImage:KUIImage(@"share_normal2") forState:UIControlStateNormal];
    [m_shareButton setBackgroundImage:KUIImage(@"share_click") forState:UIControlStateHighlighted];
    [self.view addSubview:m_shareButton];
    [m_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark 分享
- (void)shareButtonClick:(id)sender
{
    if (bgView != nil) {
        [bgView removeFromSuperview];
    }
    bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(328, 0, kScreenHeigth-320, kScreenWidth);
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self.view addSubview:bgView];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"分享到"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:Nil
                                  otherButtonTitles:@"我的动态", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];
    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"分享到我的动态", nil];
//    [alert show];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        sortButton.hidden = YES;
        backUpButton.hidden = YES;
        pageControl.hidden = YES;
        m_backButton.hidden = YES;
        m_shareButton.hidden = YES;
        [self performSelector:@selector(pushSendNews) withObject:nil afterDelay:1.0];
    }
    if (bgView != nil) {
        [bgView removeFromSuperview];
    }
}

- (void)pushSendNews
{
    //http://www.dapps.net/dev/iphone/iphone-ipad-screenshots-tips.html
//    CGImageRef UIGetScreenImage();
//    CGImageRef img = UIGetScreenImage();
//    UIImage* scImage=[UIImage imageWithCGImage:img];
    UIGraphicsBeginImageContext(CGSizeMake(kScreenHeigth, kScreenWidth));
//    if(upScroll.center.y < 0)
//    {
//        [downScroll.layer renderInContext:UIGraphicsGetCurrentContext()];
//    }
//    else
//    {
//        CGContextRef cm = UIGraphicsGetCurrentContext();
//        CGContextTranslateCTM(cm, 200, 0.0);
//        [upScroll.layer renderInContext:cm];
//    }
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDictionary* tempDic = [self.titleObjArray objectAtIndex:self.showIndex];
    NSDictionary* tempDic_small = KISDictionaryHaveKey([self.titleObjArray objectAtIndex:self.showIndex], @"titleObj");
    sortButton.hidden = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic_small, @"rank")] isEqualToString:@"1"] ? NO : YES;

    backUpButton.hidden = NO;
    pageControl.hidden = NO;
    m_backButton.hidden = NO;
    m_shareButton.hidden = NO;
    if (self.isFriendTitle) {
        pageControl.hidden = YES;
    }
    SendNewsViewController* VC = [[SendNewsViewController alloc] init];
    VC.titleImage = viewImage;
    VC.delegate = self;
    if(upScroll.center.y < 0)
    {
        VC.defaultContent = [NSString stringWithFormat:@"分享%@的%@排名", KISDictionaryHaveKey(tempDic, @"charactername"), KISDictionaryHaveKey(tempDic_small, @"titletype")];
    }
    else
    {
        VC.defaultContent = [NSString stringWithFormat:@"分享%@的头衔：%@", KISDictionaryHaveKey(tempDic, @"charactername"), KISDictionaryHaveKey(tempDic_small, @"title")];
    }
    [self.navigationController pushViewController:VC animated:NO];
}

- (void)setUpView
{
    for (int i = 0; i < [self.titleObjArray count]; i++) {
        NSDictionary* tempDic = [self.titleObjArray objectAtIndex:i];
        TitleObjUpView* oneView = [[TitleObjUpView alloc] initWithFrame:CGRectMake(kScreenHeigth * i, 0, kScreenHeigth, kScreenWidth)];
        NSDictionary* titleDic = KISDictionaryHaveKey(tempDic, @"titleObj");
        if (![titleDic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        oneView.rightImageId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(titleDic, @"img")];
        oneView.gameId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(titleDic, @"gameid")];
        oneView.rarenum= [GameCommon getNewStringWithId:KISDictionaryHaveKey(titleDic, @"rarenum")];//稀有度
        oneView.titleName= KISDictionaryHaveKey(titleDic, @"title");
        oneView.characterName= KISDictionaryHaveKey(tempDic, @"charactername");
        oneView.remark= KISDictionaryHaveKey(titleDic, @"remark");
//        oneView.remark= @"董建华发达和韩国阿迪法阿发荣阿呆发风能发热i阿凡达过那把你家呢温饱女阿警方分噶";

        oneView.rarememo= KISDictionaryHaveKey(titleDic, @"rarememo");//%

        oneView.detailDis= KISDictionaryHaveKey(titleDic, @"remarkDetail");//查看详情内容
//        oneView.detailDis= @"呀呀呀阿呀呀呀啊哟哟啊哟哟啊哟哟押运员";//查看详情内容

        [oneView setMainView];
        [upScroll addSubview:oneView];
    }
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    pageControl.center = CGPointMake(upScroll.contentOffset.x + kScreenHeigth/2, kScreenWidth - 30);
    pageControl.numberOfPages = [self.titleObjArray count];
    pageControl.currentPage = self.showIndex;
    [upScroll addSubview:pageControl];
    
    sortButton = [CommonControlOrView setButtonWithFrame:CGRectMake(0, 0, 65, 65) title:@"" fontSize:nil textColor:nil bgImage:KUIImage(@"sort_button_normal") HighImage:KUIImage(@"sort_button_click") selectImage:nil];
    sortButton.center = CGPointMake(upScroll.contentOffset.x + kScreenHeigth - 65/2, kScreenWidth - 40);
    [sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [upScroll addSubview:sortButton];
    
    NSDictionary* tempDic = KISDictionaryHaveKey([self.titleObjArray objectAtIndex:self.showIndex], @"titleObj");
    sortButton.hidden = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"rank")] isEqualToString:@"1"] ? NO : YES;
    
    if (self.isFriendTitle) {
        pageControl.hidden = YES;
    }
}

/*
- (void)setDownView
{
    float buttonWidth = (kScreenHeigth - 30)/3;
    m_friendButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, buttonWidth, 40)];
    [m_friendButton setBackgroundImage:KUIImage(@"black_tab_normal") forState:UIControlStateNormal];
    [m_friendButton setBackgroundImage:KUIImage(@"black_tab_click") forState:UIControlStateSelected];
    [m_friendButton setTitle:@"好友" forState:UIControlStateNormal];
    [m_friendButton setTitleColor:kColorWithRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
    [m_friendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    m_friendButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_friendButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [downScroll addSubview:m_friendButton];
    m_friendButton.selected = YES;

    m_realmButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + buttonWidth, 10, buttonWidth, 40)];
    [m_realmButton setBackgroundImage:KUIImage(@"black_tab_normal") forState:UIControlStateNormal];
    [m_realmButton setBackgroundImage:KUIImage(@"black_tab_click") forState:UIControlStateSelected];
    [m_realmButton setTitle:@"全服" forState:UIControlStateNormal];
    [m_realmButton setTitleColor:kColorWithRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
    [m_realmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    m_realmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_realmButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [downScroll addSubview:m_realmButton];
    
    m_countryButton = [[UIButton alloc] initWithFrame:CGRectMake(25 + buttonWidth * 2, 10, buttonWidth, 40)];
    [m_countryButton setBackgroundImage:KUIImage(@"black_tab_normal") forState:UIControlStateNormal];
    [m_countryButton setBackgroundImage:KUIImage(@"black_tab_click") forState:UIControlStateSelected];
    [m_countryButton setTitle:@"全国" forState:UIControlStateNormal];
    [m_countryButton setTitleColor:kColorWithRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
    [m_countryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    m_countryButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [m_countryButton addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventTouchUpInside];
    [downScroll addSubview:m_countryButton];
    
    if (self.isFriendTitle) {
        m_friendButton.hidden = YES;
        m_realmButton.frame = CGRectMake(5, 10, (kScreenHeigth-20)/2, 40);
        m_countryButton.frame = CGRectMake(15 + (kScreenHeigth-20)/2, 10, (kScreenHeigth-20)/2, 40);
        m_realmButton.selected = YES;
        
        m_segmentClickIndex = kSegmentRealm;
    }
    else
    {
        m_segmentClickIndex = kSegmentFriend;
    }
    m_sortDataArray = [[NSMutableArray alloc] init];
    isGetForData = NO;
    m_lastPageIndex = -1;
    m_tableShowIndex = 0;
    
    m_sortTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 85, kScreenHeigth - 10, kScreenWidth - 90)];
    m_sortTableView.backgroundColor = kColorWithRGB(238, 238, 238, 1.0);
    m_sortTableView.dataSource = self;
    m_sortTableView.delegate = self;
    [downScroll addSubview:m_sortTableView];
    
    pullDownView = [[PullDownRefreshView alloc] initWithFrame:CGRectMake(kScreenHeigth - 400, - REFRESH_HEADER_HEIGHT, kScreenHeigth - 10, REFRESH_HEADER_HEIGHT)];
    pullDownView.pullDownDelegate = self;
    [m_sortTableView addSubview:pullDownView];
    pullDownView.myScrollView = m_sortTableView;
    [pullDownView stopLoading:NO];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(kScreenHeigth - 400, kScreenWidth - 90, kScreenHeigth - 10, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_sortTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_sortTableView;
    [refreshView stopLoading:NO];
    
    backUpButton = [CommonControlOrView setButtonWithFrame:CGRectMake(0, 0, 65, 65) title:@"" fontSize:nil textColor:nil bgImage:KUIImage(@"back_top_normal") HighImage:KUIImage(@"back_top_click") selectImage:nil];
    backUpButton.center = CGPointMake(downScroll.contentOffset.x + kScreenHeigth - 65/2, kScreenWidth - 40);
    [backUpButton addTarget:self action:@selector(backUpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [downScroll bringSubviewToFront:backUpButton];
    [downScroll addSubview:backUpButton];
}

- (void)setTableTopView
{
    UIButton* topSortButton = [CommonControlOrView setButtonWithFrame:CGRectMake(5, 50, 80, 35) title:@"名次" fontSize:[UIFont boldSystemFontOfSize:13.0] textColor:[UIColor whiteColor] bgImage:KUIImage(@"blue_small2_normal") HighImage:KUIImage(@"blue_small2_click") selectImage:Nil];
    topSortButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [topSortButton addTarget:self action:@selector(tableSortClick:) forControlEvents:UIControlEventTouchUpInside];
    [downScroll addSubview:topSortButton];
    
    UIImageView* topImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 23/2.0, 12, 12)];
    topImage.image = KUIImage(@"sort_up");
    topImage.backgroundColor = [UIColor clearColor];
    [topSortButton addSubview:topImage];
    
    UIImageView* line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(86, 50, 1, 35)];
    line_1.image = KUIImage(@"line_2");
    [downScroll addSubview:line_1];
    
    float buttonWidth = (kScreenHeigth - 170)/3;
    UIImageView * topBg = [[UIImageView alloc] initWithFrame:CGRectMake(85, 50, kScreenHeigth - 90, 35)];
    topBg.image = KUIImage(@"table_top_bg");
    [downScroll addSubview:topBg];
    
    UILabel* chaLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(85, 50, buttonWidth, 35) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:13.0] text:@"角色名" textAlignment:NSTextAlignmentCenter];
    [downScroll addSubview:chaLabel];
    
    UIImageView* line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(85 + buttonWidth, 50, 1, 35)];
    line_2.image = KUIImage(@"line_2");
    [downScroll addSubview:line_2];
    
    UILabel* clazzLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(85 + buttonWidth, 50, 80, 35) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:13.0] text:@"职业" textAlignment:NSTextAlignmentCenter];
    [downScroll addSubview:clazzLabel];
    
    UIImageView* line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(85 + buttonWidth + 80, 50, 1, 35)];
    line_3.image = KUIImage(@"line_2");
    [downScroll addSubview:line_3];
    
    UILabel* nickLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(85 + buttonWidth + 80, 50, buttonWidth, 35) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:13.0] text:@"所属用户" textAlignment:NSTextAlignmentCenter];
    [downScroll addSubview:nickLabel];
    
    UIImageView* line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(85 + buttonWidth * 2 + 80, 50, 1, 35)];
    line_4.image = KUIImage(@"line_2");
    [downScroll addSubview:line_4];
    
    NSDictionary* tempDic = KISDictionaryHaveKey([self.titleObjArray objectAtIndex:self.showIndex], @"titleObj");
    NSString* sortType = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"titletype")];

    m_sortTypeLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(85 + buttonWidth * 2 + 80, 50, buttonWidth, 35) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:13.0] text:sortType textAlignment:NSTextAlignmentCenter];
    [downScroll addSubview:m_sortTypeLabel];
}


- (void)tableSortClick:(id)sender
{
    //请求第一页
    isGetForData = NO;
    m_lastPageIndex = 0;
    [m_sortDataArray removeAllObjects];
    [m_sortTableView reloadData];
    
    [self getSortDataByNet];
}

- (void)refreshDownView
{
    NSDictionary* tempDic = KISDictionaryHaveKey([self.titleObjArray objectAtIndex:self.showIndex], @"titleObj");
    NSString* sortType = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"titletype")];
    m_sortTypeLabel.text = sortType;
    
    isGetForData = NO;
    m_lastPageIndex = -1;
    [m_sortDataArray removeAllObjects];
    [m_sortTableView reloadData];
    
    [m_realmButton setTitle:KISDictionaryHaveKey([self.titleObjArray objectAtIndex:self.showIndex], @"realm") forState:UIControlStateNormal];
    
    [self getSortDataByNet];
}

- (void)segmentChanged:(UIButton*)segButton
{
    if (segButton.selected) {
        return;
    }
    if (segButton == m_friendButton) {
        m_friendButton.selected = YES;
        m_realmButton.selected = NO;
        m_countryButton.selected = NO;
        m_segmentClickIndex = kSegmentFriend;
    }
    else if(segButton == m_realmButton)
    {
        m_friendButton.selected = NO;
        m_realmButton.selected = YES;
        m_countryButton.selected = NO;
        m_segmentClickIndex = kSegmentRealm;
    }
    else
    {
        m_friendButton.selected = NO;
        m_realmButton.selected = NO;
        m_countryButton.selected = YES;
        m_segmentClickIndex = kSegmentCountry;
    }
    
    [m_sortDataArray removeAllObjects];
    [m_sortTableView reloadData];
    
    isGetForData = NO;
    m_lastPageIndex = -1;
    [self getSortDataByNet];
}

#pragma mark 手势
//- (void)tapClick:(id)sender
//{
//    [UIView animateWithDuration:0.5 animations:^{
////        if (topView.center.y < 0) {
////            topView.center = CGPointMake(kScreenHeigth/2, 22);
////        }
////        else
////            topView.center = CGPointMake(kScreenHeigth/2, -22);
//        if (m_backButton.center.y < 0) {
//            m_backButton.center = CGPointMake(25, 22);
//            m_shareButton.center = CGPointMake(kScreenHeigth - 25, 22);
//        }
//        else
//        {
//            m_backButton.center = CGPointMake(25, -22);
//            m_shareButton.center = CGPointMake(kScreenHeigth - 25, -22);
//        }
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        return NO;
//    }
//    return YES;
//}
#pragma mark 发表动态
-(void)dynamicListAddOneDynamic:(NSDictionary*)dynamic
{
    isShowSend = YES;
}

#pragma mark 请求
- (void)getSortDataByNet
{
    NSDictionary* bigTitleDic = [self.titleObjArray objectAtIndex:self.showIndex];
    NSDictionary* smallTitleDic = KISDictionaryHaveKey(bigTitleDic, @"titleObj");
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(smallTitleDic, @"gameid")] forKey:@"gameid"];
    switch (m_segmentClickIndex) {
        case kSegmentFriend:
            [paramDict setObject:@"1" forKey:@"ranktype"];
            break;
        case kSegmentRealm:
        {
            [paramDict setObject:@"2" forKey:@"ranktype"];
            [paramDict setObject:KISDictionaryHaveKey(bigTitleDic, @"realm") forKey:@"realm"];
            [paramDict setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(bigTitleDic, @"clazz")] forKey:@"classid"];
        } break;
        case kSegmentCountry:
        {
            [paramDict setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(bigTitleDic, @"clazz")] forKey:@"classid"];
            [paramDict setObject:@"3" forKey:@"ranktype"];
        }break;
        default:
            break;
    }
    [paramDict setObject:[GameCommon getNewStringWithId:KISDictionaryHaveKey(bigTitleDic, @"characterid")] forKey:@"characterid"];

    [paramDict setObject:KISDictionaryHaveKey(smallTitleDic, @"rankvaltype") forKey:@"rankvaltype"];
    if (isGetForData) {
        [paramDict setObject:[NSString stringWithFormat:@"%d", m_begainPageIndex] forKey:@"pageIndex"];
    }
    else
        [paramDict setObject:[NSString stringWithFormat:@"%d", m_lastPageIndex] forKey:@"pageIndex"];
    [paramDict setObject:@"5" forKey:@"maxSize"];


    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"130" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSLog(@"%@", responseObject);
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
//            if (m_pageIndex < rankNum/5) {//前面排名
            if (isGetForData) {//前面排名
                NSIndexSet* oneSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [responseObject count])];
                [m_sortDataArray insertObjects:responseObject atIndexes:oneSet];
            }
            else//后面
            {
                [m_sortDataArray addObjectsFromArray:responseObject];
            }
            NSDictionary* tempDic_for = [m_sortDataArray firstObject];
            NSInteger rankNum_for = [KISDictionaryHaveKey(tempDic_for, @"rank") integerValue];
            m_begainPageIndex = rankNum_for%5 == 0 ? rankNum_for/5-1 : rankNum_for/5;

            NSDictionary* tempDic = [m_sortDataArray lastObject];
            NSInteger rankNum = [KISDictionaryHaveKey(tempDic, @"rank") integerValue];
            m_lastPageIndex = rankNum%5 == 0 ? rankNum/5-1 : rankNum/5;
            
            [refreshView stopLoading:NO];
            
            [m_sortTableView reloadData];

            [refreshView setRefreshViewFrame];
            
            if (m_begainPageIndex == 0) {
                [pullDownView stopLoading:YES];
            }
            else
            {
                [pullDownView stopLoading:NO];
            }
        }
        else
        {
            if (isGetForData)
                [pullDownView stopLoading:YES];
            else
                [refreshView stopLoading:YES];
        }

    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [refreshView stopLoading:NO];
        
        [pullDownView stopLoading:NO];

        [hud hide:YES];
    }];
}

#pragma mark 按钮
- (void)sortButtonClick:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        upScroll.center = CGPointMake(kScreenHeigth/2, -kScreenWidth/2);
        downScroll.center = CGPointMake(kScreenHeigth/2, kScreenWidth/2);
    }];
    if (m_tableShowIndex != self.showIndex || [m_sortDataArray count] == 0) {
        [self refreshDownView];
    }
    m_tableShowIndex = self.showIndex;
}

- (void)backUpButtonClick:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        upScroll.center = CGPointMake(kScreenHeigth/2, kScreenWidth/2);
        downScroll.center = CGPointMake(kScreenHeigth/2, kScreenWidth + kScreenWidth/2);
    }];
}

- (void)userNameClick:(TitleSortTableCell*)myCell
{
    NSDictionary* tempDic = [m_sortDataArray objectAtIndex:myCell.myIndexPath.row];
    if ([KISDictionaryHaveKey(tempDic, @"username") isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]] || [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"username")] isEqualToString:@""]) {//点自己
        return;
    }
    
    PersonDetailViewController* detailVC = [[PersonDetailViewController alloc] init];
    detailVC.userId = KISDictionaryHaveKey(tempDic, @"userid");
    detailVC.nickName = KISDictionaryHaveKey(tempDic, @"nickname");
    detailVC.isChatPage = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_sortDataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TitleSortTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TitleSortTableCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myDelegate = self;
    cell.myIndexPath = indexPath;
    
    NSDictionary* tempDic = [m_sortDataArray objectAtIndex:indexPath.row];
    NSDictionary* titleDic = [self.titleObjArray objectAtIndex:self.showIndex];
    
    if ([KISDictionaryHaveKey(tempDic, @"charactername") isEqualToString:KISDictionaryHaveKey(titleDic, @"charactername")] && [KISDictionaryHaveKey(tempDic, @"realm") isEqualToString:KISDictionaryHaveKey(titleDic, @"realm")]) {//本头衔
        cell.bgImage.image = KUIImage(@"my_sort");
        cell.numLabel.textColor = kColorWithRGB(204, 0, 0, 1.0);
        cell.characterLabel.textColor = kColorWithRGB(204, 0, 0, 1.0);
        cell.clazzLabel.textColor = kColorWithRGB(204, 0, 0, 1.0);
        [cell.nickNameButton setTitleColor:kColorWithRGB(204, 0, 0, 1.0) forState:UIControlStateNormal];
        cell.pveScoreLabel.textColor = kColorWithRGB(204, 0, 0, 1.0);
    }
    else if([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"userid")] isEqualToString:@""])//未绑定的
    {
        cell.bgImage.image = KUIImage(@"");
        cell.numLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        cell.characterLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        cell.clazzLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        [cell.nickNameButton setTitleColor:kColorWithRGB(102, 102, 102, 1.0) forState:UIControlStateNormal];
        cell.pveScoreLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
    }
    else{
        cell.bgImage.image = KUIImage(@"");
        cell.numLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        cell.characterLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        cell.clazzLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        [cell.nickNameButton setTitleColor:kColorWithRGB(0, 102, 255, 1.0) forState:UIControlStateNormal];
        cell.pveScoreLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
    }
    cell.numLabel.text = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"rank")];
    cell.characterLabel.text = KISDictionaryHaveKey(tempDic, @"charactername");
    cell.clazzLabel.text = KISDictionaryHaveKey(tempDic, @"characterclass");
    
    if([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"userid")] isEqualToString:@""])//未绑定的
    {
        [cell.nickNameButton setTitle:@"暂未绑定" forState:UIControlStateNormal];
    }
    else
    {
        [cell.nickNameButton setTitle:[[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"alias")] isEqualToString:@""] ? KISDictionaryHaveKey(tempDic, @"nickname") : KISDictionaryHaveKey(tempDic, @"alias") forState:UIControlStateNormal];
    }
    cell.pveScoreLabel.text = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"value")];

    return cell;
}
*/
#pragma mark scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == upScroll) {
        CGPoint offsetofScrollView = scrollView.contentOffset;

        NSInteger page = offsetofScrollView.x / upScroll.frame.size.width;
       
        self.showIndex = page;
       
        [pageControl setCurrentPage:page];
        
        CGRect rect = CGRectMake(page * upScroll.frame.size.width, 0,
                                 upScroll.frame.size.width, upScroll.frame.size.height);
        [upScroll scrollRectToVisible:rect animated:YES];
        
        NSDictionary* tempDic = KISDictionaryHaveKey([self.titleObjArray objectAtIndex:page], @"titleObj");
        sortButton.hidden = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"rank")] isEqualToString:@"1"] ? NO : YES;
        if (!sortButton.hidden) {
            sortButton.center = CGPointMake(upScroll.contentOffset.x + kScreenHeigth - 65/2, kScreenWidth - 40);
        }
    }
//    else if(scrollView == downScroll)
//    {
//        backUpButton.center = CGPointMake(downScroll.contentOffset.x + kScreenHeigth - 65/2, kScreenWidth - 40);
//    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == upScroll)
    {
//        CGRect rect = pageControl.frame;
//        pageControl.frame = CGRectMake(260 - scrollView.contentOffset.x, rect.origin.y, rect.size.width, rect.size.height);
        pageControl.center = CGPointMake(upScroll.contentOffset.x + kScreenHeigth/2, kScreenWidth - 30);
    }
//    else if(scrollView == m_sortTableView)
//    {
//        if (m_sortTableView.contentSize.height < m_sortTableView.frame.size.height) {
//            refreshView.viewMaxY = 0;
//        }
//        else
//            refreshView.viewMaxY = m_sortTableView.contentSize.height - m_sortTableView.frame.size.height;
//        [refreshView viewdidScroll:scrollView];
//        
//        [pullDownView viewdidScroll:scrollView];
//    }
}
/*
#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == m_sortTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
        
        [pullDownView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == m_sortTableView)
    {
        [refreshView didEndDragging:scrollView];
        
        [pullDownView didEndDragging:scrollView];
    }
}

- (void)PullUpStartRefresh
{
    NSLog(@"start");
    m_lastPageIndex ++;
    isGetForData = NO;
    [self getSortDataByNet];
}

- (void)PullDowmStartRefresh
{
    m_begainPageIndex--;
    isGetForData = YES;
    [self getSortDataByNet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
*/
@end
