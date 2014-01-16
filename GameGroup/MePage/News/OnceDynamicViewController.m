//
//  OnceDynamicViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "OnceDynamicViewController.h"
#import "EGOImageButton.h"
#import "PhotoViewController.h"
#import "ReplyViewController.h"
#import "MyProfileViewController.h"
#import "PersonDetailViewController.h"

@interface OnceDynamicViewController ()
{
    UIView* inPutView;
    UIButton* inputButton;
    
    NSInteger  allPL;//总评论数
    
    double  webViewHeight;
}
@property(nonatomic, strong)NSDictionary* dataDic;
@property(nonatomic, strong)NSArray*      headImgArray;
@property (strong,nonatomic) HPGrowingTextView *textView;

@end

@implementation OnceDynamicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:Nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:Nil];

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self setTopViewWithTitle:@"详情" withBackButton:YES];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
    
    [self getDataByNet];
}


- (void)getDataByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:self.messageid forKey:@"messageid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"136" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            self.dataDic = responseObject;
            
            allPL = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(responseObject, @"commentnum")] integerValue];
            
            self.messageid = KISDictionaryHaveKey(responseObject, @"id");
            
            [self getHead:KISDictionaryHaveKey(responseObject, @"img")];
            [self setUpView];
            [self setButtomView];
            
            [self.view bringSubviewToFront:hud];
        }
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

- (void)setUpView
{
    UIImageView* bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, + startX, kScreenWidth, 60)];
    bg.image = KUIImage(@"detail_top_bg");
    [self.view addSubview:bg];
    
    EGOImageButton* headBtn = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10 + startX, 40, 40)];
    headBtn.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
    headBtn.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,[GameCommon getHeardImgId:KISDictionaryHaveKey(self.dataDic, @"userimg")]]];
    headBtn.layer.cornerRadius = 5;
    [headBtn addTarget:self action:@selector(heardImgClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    
    UILabel* nickLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(60, 8+ startX, 180, 20) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:15.0] text:[[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.dataDic, @"alias")] isEqualToString:@""]?KISDictionaryHaveKey(self.dataDic, @"nickname"):KISDictionaryHaveKey(self.dataDic, @"alias") textAlignment:NSTextAlignmentLeft];
    [self.view addSubview:nickLabel];
    
    NSDictionary* titleDic = KISDictionaryHaveKey(self.dataDic, @"titleObj");
    if ([titleDic isKindOfClass:[NSDictionary class]]) {
        UILabel* titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(60, 33+ startX, 180, 20) textColor:[GameCommon getAchievementColorWithLevel:[[KISDictionaryHaveKey(titleDic, @"titleObj") objectForKey:@"rarenum"] integerValue]] font:[UIFont boldSystemFontOfSize:14.0] text:[KISDictionaryHaveKey(titleDic, @"titleObj") objectForKey:@"title"] textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:titleLabel];
    }
    else
    {
        UILabel* titleLabel_no = [CommonControlOrView setLabelWithFrame:CGRectMake(60, 33+ startX, 150, 20) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:13.0] text:@"暂无头衔" textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:titleLabel_no];
    }
    
    UIButton* zanButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 15+ startX, 76, 30)];
    [zanButton setBackgroundImage:KUIImage(@"zan_normal") forState:UIControlStateNormal];
    [zanButton setBackgroundImage:KUIImage(@"zan_click") forState:UIControlStateSelected];
    [zanButton setTitle:[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.dataDic, @"zannum")] forState:UIControlStateNormal];
    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.dataDic, @"zan")] isEqualToString:@"1"]) {
        [zanButton setTitleColor:kColorWithRGB(204, 204, 204, 1.0) forState:UIControlStateNormal];
        zanButton.selected = YES;
        [zanButton setBackgroundImage:KUIImage(@"zan_hig_1") forState:UIControlStateHighlighted];
    }
    else
    {
        [zanButton setTitleColor:kColorWithRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
        [zanButton setBackgroundImage:KUIImage(@"zan_hig_2") forState:UIControlStateHighlighted];
        zanButton.selected = NO;
    }
    zanButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    zanButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanButton];
}

- (void)heardImgClick:(id)sender
{
    if ([KISDictionaryHaveKey(self.dataDic, @"userid") isEqualToString:[DataStoreManager getMyUserID]]) {
        MyProfileViewController * myP = [[MyProfileViewController alloc] init];
        [self.navigationController pushViewController:myP animated:YES];
    }
    else
    {
        PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
        detailV.userName = KISDictionaryHaveKey(self.dataDic, @"username");
        detailV.nickName = KISDictionaryHaveKey(self.dataDic, @"nickname");
        detailV.isChatPage = NO;
        [self.navigationController pushViewController:detailV animated:YES];
    }
}

#pragma mark button
- (void)zanButtonClick:(id)sender
{
    NSLog(@"我要赞啦～～～～");
    if ([KISDictionaryHaveKey(self.dataDic, @"userid") isEqualToString:[DataStoreManager getMyUserID]]) {
        [self showAlertViewWithTitle:@"提示" message:@"您不能对自己进行赞" buttonTitle:@"确定"];
        return;
    }
    UIButton* zanBtn = (UIButton*)sender;
    
    zanBtn.userInteractionEnabled = NO;
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"4" forKey:@"type"];
    [paramDict setObject:self.messageid forKey:@"messageid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"134" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        zanBtn.userInteractionEnabled = YES;

        zanBtn.selected = !zanBtn.selected;
        if(zanBtn.selected)
        {
            [zanBtn setBackgroundImage:KUIImage(@"zan_hig_1") forState:UIControlStateHighlighted];
        }
        else
        {
            [zanBtn setBackgroundImage:KUIImage(@"zan_hig_2") forState:UIControlStateHighlighted];
        }
    
        double allZan = [KISDictionaryHaveKey(responseObject, @"zannum") doubleValue];
        [zanBtn setTitle:[NSString stringWithFormat:@"%.f", allZan] forState:UIControlStateNormal];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListJustReload)])
            [self.delegate dynamicListJustReload];//上个页面刷新
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        zanBtn.userInteractionEnabled = YES;
    }];

}

#pragma mark html

- (NSString*)htmlContentWithTitle:(NSString*)title time:(NSString*)time content:(NSString*)content
{//;width:100%%;height:100%%<div style=\"background-color:#f7f7f7\">
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSString* str = [NSString stringWithFormat:@"<body bgcolor=\"#f7f7f7\"><font size=\"3\" color=\"#444444\"><center><b>%@</b></center></font><p align=\"right\"><font size=\"3\" color=\"#444444\">%@</font></p><p><font size=\"3\" color=\"#444444\" style=\"line-height:25px\">%@</font></p></body>", title, time, content];
    return str;
}

- (NSString*)imageHtmlWithId:(NSString*)imageid
{
//    NSString* imageStr = [NSString stringWithFormat:@"<img src=\"%@%@\\305\" width=\"305\"></img>", BaseImageUrl, imageid];
    NSString* imageStr = [NSString stringWithFormat:@"<a href=\"myimage:%@\"><img src=\"%@%@\\305\" width=\"305\"></img></a>", imageid,BaseImageUrl, imageid];

    return imageStr;
}

- (void)setButtomView
{
    if ([self.urlLink isEqualToString:@""]) {
//        UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startX + 60, kScreenWidth, kScreenHeigth - 50 - startX - 60)];
//        scroll.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:scroll];
        
        NSString* loadStr = [self htmlContentWithTitle:KISDictionaryHaveKey(self.dataDic, @"title") time:[NSString stringWithFormat:@"(%@ 发表)", [self getDataWithTime]] content:KISDictionaryHaveKey(self.dataDic, @"msg")];
        for(int i = 0; i < [self.headImgArray count]; i++)
        {
            loadStr = [loadStr stringByAppendingString:[self imageHtmlWithId:[self.headImgArray objectAtIndex:i]]];
        }
        
        UIWebView* contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, startX + 60, kScreenWidth, kScreenHeigth - 50 - startX - 60-(KISHighVersion_7?0:20))];
        contentView.scalesPageToFit = NO;
        contentView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
//        contentView.dataDetectorTypes = UIDataDetectorTypeAll;
//        contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        contentView.delegate = self;
        [contentView loadHTMLString:loadStr baseURL:nil];
        UIScrollView *scroller = [contentView.subviews objectAtIndex:0];//去掉阴影
        if (scroller) {
            for (UIView *v in [scroller subviews]) {
                if ([v isKindOfClass:[UIImageView class]]) {
                    [v removeFromSuperview];
                }
            }
        }
//        contentView.scrollView.scrollEnabled = NO;
        [self.view addSubview:contentView];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tapGesture.delegate = self;
        [contentView addGestureRecognizer:tapGesture];
        
        /*
        CGSize titleSize = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.dataDic, @"title")] sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:CGSizeMake(310, INT_MAX)];

        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, titleSize.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.text = KISDictionaryHaveKey(self.dataDic, @"title");
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [scroll addSubview:titleLabel];
        
        UILabel* timeLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(210, 10+titleSize.height, 100, 15) textColor:kColorWithRGB(102, 102, 102, 1.0) font:[UIFont boldSystemFontOfSize:12.0] text:[NSString stringWithFormat:@"(%@ 发表)", [self getDataWithTime]] textAlignment:NSTextAlignmentRight];
        [scroll addSubview:timeLabel];

        CGSize contentSize = [KISDictionaryHaveKey(self.dataDic, @"msg") sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(310, INT_MAX)];
        
        UITextView* contentView = [[UITextView alloc] initWithFrame:CGRectMake(5, 30 + titleSize.height, 310, (contentSize.height + 25) < scroll.frame.size.height ? scroll.frame.size.height : (contentSize.height + 25))];
        contentView.text = KISDictionaryHaveKey(self.dataDic, @"msg");
        contentView.textColor = kColorWithRGB(102, 102, 102, 1.0);
        contentView.font = [UIFont systemFontOfSize:15.0];
        contentView.editable = NO;
        contentView.scrollEnabled = NO;
        contentView.backgroundColor = [UIColor clearColor];
        contentView.showsVerticalScrollIndicator = NO;
        [scroll addSubview:contentView];
        
        
        for(int i = 0; i < [self.headImgArray count]; i++)
        {
            NSInteger line = i/3;
            EGOImageButton* imageBtn = [[EGOImageButton alloc] initWithFrame:CGRectMake(10 + (290/3.0 + 5)*(i%3), 25 + contentSize.height +(290.0/3 + 5)*line, 290.0/3, 290.0/3)];
            imageBtn.placeholderImage = KUIImage(@"placeholder");
            imageBtn.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImageUrl,[self.headImgArray objectAtIndex:i]]];
            imageBtn.tag = i;
            [imageBtn addTarget:self action:@selector(imageClick:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:imageBtn];
        }
        
        scroll.contentSize = CGSizeMake(kScreenWidth, titleSize.height + 25 + contentSize.height + ([self.headImgArray count]/3 + 1) * (290.0/3 + 5));*/
    }
    else
    {
        UIWebView* mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, startX + 60, kScreenWidth, kScreenHeigth - 50 - startX - 60-(KISHighVersion_7?0:20))];
//        mWebView.scalesPageToFit = YES;
        mWebView.delegate = self;
        NSURL *requestUrl = [NSURL URLWithString:self.urlLink];
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
        [mWebView loadRequest:request];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        tapGesture.delegate = self;
        [mWebView addGestureRecognizer:tapGesture];
        
        [self.view addSubview:mWebView];
    }
    
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    [self.view addSubview:inPutView];

    self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 7, 240, 35)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
	self.textView.returnKeyType = UIReturnKeySend; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor clearColor];
    
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_input.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(10, 7, 240, 35);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"inputbg.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, inPutView.frame.size.width, inPutView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [inPutView addSubview:imageView];
    [inPutView addSubview:entryImageView];
    [inPutView addSubview:self.textView];
    
    inputButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 8, 60, 35)];
    [inputButton setBackgroundImage:KUIImage(@"blue_small_3_normal") forState:UIControlStateNormal];
    [inputButton setBackgroundImage:KUIImage(@"blue_small_3_click") forState:UIControlStateHighlighted];
    [inputButton setTitle:[NSString stringWithFormat:@"评论 %d", allPL] forState:UIControlStateNormal];
    inputButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [inputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [inputButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [inPutView addSubview:inputButton];
}

-(void)getHead:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>0) {
        for (NSString* a in i) {
            if (a.length > 0 && ![a isEqualToString:@" "]) {
                [littleHeadArray addObject:a];
            }
        }
    }//动态大图ID数组和小图ID数组
    self.headImgArray = littleHeadArray;//47,39
}

- (void)imageClick:(UIButton*)imageButton
{
    PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.headImgArray indext:imageButton.tag];
    [self presentViewController:photoV animated:NO completion:^{
        
    }];
}

#pragma mark 手势
- (void)tapClick:(id)sender
{
    [self.textView resignFirstResponder];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark 详情
- (NSString*)getDataWithTime
{
    NSString* messageTime = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.dataDic, @"createDate")];
    NSString* currentString = [GameCommon getCurrentTime];
    if (messageTime.length < 10 || currentString.length < 10) {
        return @"未知";
    }
    NSString * finalTime;
    NSString* curStr = [currentString substringToIndex:messageTime.length-3];
    NSString* mesStr = [messageTime substringToIndex:messageTime.length-3];
    
    double theCurrentT = [curStr doubleValue];
    double theMessageT = [mesStr doubleValue];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    
    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
    int yesterdayBegin = currentDayBegin-3600*24;
    
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
        finalTime = [NSString stringWithFormat:@"%@",msgT];
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
        finalTime = [NSString stringWithFormat:@"昨天 %@",msgT];
    }
    //今年
    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
        finalTime = [NSString stringWithFormat:@"%@月%@日 %@",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8], msgT];
    }
    else
        finalTime = [NSString stringWithFormat:@"%@年%@月%@日 %@",[[messageDateStr substringFromIndex:0] substringToIndex:4] ,[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8], msgT];
    return finalTime;
}

#pragma mark 发表 或评论
- (void)okButtonClick:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* tempBtn = (UIButton*)sender;

        if ([tempBtn.titleLabel.text isEqualToString:@"发表"]) {//发表
            [self send];
        }
        else
        {
            ReplyViewController * VC = [[ReplyViewController alloc] init];
            VC.messageid = self.messageid;
            VC.delegate = self;
            VC.isHaveArticle = NO;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}

- (void)dynamicListJustReload//新评论
{
    allPL ++;
    [inputButton setTitle:[NSString stringWithFormat:@"评论 %d", allPL] forState:UIControlStateNormal];
    
    [self.delegate dynamicListJustReload];
}

- (void)send
{
    if (KISEmptyOrEnter(self.textView.text)) {
        [self showAlertViewWithTitle:@"提示" message:@"请输入评论内容" buttonTitle:@"确定"];
        return;
    }
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"5" forKey:@"type"];
    [paramDict setObject:self.textView.text forKey:@"msg"];
    [paramDict setObject:self.messageid forKey:@"messageid"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"134" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self.textView resignFirstResponder];
        self.textView.text = @"";
        
        allPL ++;//评论数加1
        [inputButton setTitle:[NSString stringWithFormat:@"评论 %d", allPL] forState:UIControlStateNormal];

//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            [self addNewNewsToStore:responseObject];
//            if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListAddOneDynamic:)])
//                [self.delegate dynamicListAddOneDynamic:responseObject];
//        }
        ReplyViewController * VC = [[ReplyViewController alloc] init];
        VC.messageid = self.messageid;
        VC.isHaveArticle = NO;
        VC.delegate = self;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

//- (void)addNewNewsToStore:(NSDictionary*)dic
//{
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        NSArray * dMyNews = [DSMyNewsList MR_findAllInContext:localContext];
//        if ([dMyNews count] >= 20) {
//            DSMyNewsList* news = [dMyNews lastObject];
//            [news deleteInContext:localContext];//删除最后面一个
//        }
//    }];
//    [DataStoreManager saveMyNewsWithData:dic];
//}

#pragma mark 输入
#pragma mark HPExpandingTextView delegate
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inPutView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inPutView.frame = r;
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self send];
//    [self.textView resignFirstResponder];
    return YES;
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
    
    [inputButton setTitle:@"发表" forState:UIControlStateNormal];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:0];
    
    [inputButton setTitle:[NSString stringWithFormat:@"评论 %d", allPL] forState:UIControlStateNormal];
}

-(void) autoMovekeyBoard: (float) h{
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2];
	//inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);
    
    
    CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (h + containerFrame.size.height);
	// animations settings
    
	
	// set views with new info
	inPutView.frame = containerFrame;
    
}

#pragma mark touch
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    [self.textView resignFirstResponder];
//}

#pragma mark web
//加载完后获取高度
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSString *htmlHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"foo\").offsetHeight;"];
//    webViewHeight = [htmlHeight doubleValue];
//    NSLog(@"%@", htmlHeight);
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [hud show:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//    [hud hide:YES];
    [webView stopLoading];
}

- (BOOL)webView:(UIWebView *)webViewLocal shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSString *myURL = [[request URL] absoluteString];
    //    NSLog(@"%@", myURL);//进来时：about:blank  http://www.ruyicai.com/
    if([myURL hasPrefix:@"http:"] && [self.urlLink isEqualToString:@""])
	{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:myURL]];
        return NO;
    }
    else if([myURL hasPrefix:@"myimage:"])
    {
        NSRange range = [myURL rangeOfString:@":"];
        if (range.length == 0) {
            return NO;
        }
        NSString * imageId = [myURL substringFromIndex:range.location+1];
        PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:[NSArray arrayWithObject:imageId] indext:0];
        [self presentViewController:photoV animated:NO completion:^{
            
        }];
        return NO;
    }
	return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end