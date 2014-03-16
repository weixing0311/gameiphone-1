//
//  KKChatController.m
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "KKChatController.h"
#import "MLNavigationController.h"
#import "AppDelegate.h"
#import "XMPPHelper.h"
#import "JSON.h"
#import "HeightCalculate.h"
#import "KKNewsCell.h"
#import "OnceDynamicViewController.h"
#import "ActivateViewController.h"
#import "TestViewController.h"
#ifdef NotUseSimulator
    #import "amrFileCodec.h"
#endif

#define padding 20
#define LocalMessage @"localMessage"
#define NameKeys @"namekeys"
@interface KKChatController ()<UIAlertViewDelegate>
{
    
    NSMutableArray *messages;
    UIMenuItem *copyItem;
    UIMenuItem *copyItem3;
    BOOL myActive;
    
    UILabel* unReadL;
}

@end

@implementation KKChatController

@synthesize myHeadImg;
@synthesize tView;
@synthesize messageTextField;
@synthesize chatWithUser;
@synthesize nickName;
@synthesize session;
@synthesize recorder;

- (id)init
{
    self = [super init];
    if (self) {
        _unreadNo = 0;
    }
    return self;
}
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMesgReceived:) name:kNewMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageAck:) name:kMessageAck object:nil];//消息是否发送成功

    if (![[DataStoreManager queryMsgRemarkNameForUser:self.chatWithUser] isEqualToString:@""]) {
        self.nickName = [DataStoreManager queryMsgRemarkNameForUser:self.chatWithUser];//刷新别名
        titleLabel.text=self.nickName;
        [self.tView reloadData];
    }
}
- (void)changeMyActive:(NSNotification*)notification
{
    if ([notification.userInfo[@"active"] intValue] == 2) {
        myActive = YES;
    }else
    {
        myActive = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMyActive:) name:@"wxr_myActiveBeChanged" object:nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    DSFriends *friend = [DSFriends MR_findFirstWithPredicate:predicate];
    myActive = [friend.action boolValue];
    postDict = [NSMutableDictionary dictionary];
    canAdd = YES;
    previousTime = 0;
    touchTimeFinal = 0;
    touchTimePre = 0;
    uDefault = [NSUserDefaults standardUserDefaults];
    currentID = [uDefault objectForKey:@"account"];
    
    self.appDel = [[UIApplication sharedApplication] delegate];

    UIImageView * bgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    bgV.backgroundColor = kColorWithRGB(246, 246, 246, 1.0);
    [self.view addSubview:bgV];
    messages = [[NSMutableArray alloc] initWithArray:[ DataStoreManager qureyCommonMessagesWithUserID:self.chatWithUser FetchOffset:0]];
    NSLog(@"messages%@",messages);
//    currentPage = 1;
//    historyMsg = [[NSArray alloc] initWithArray:[DataStoreManager qureyAllCommonMessages:self.chatWithUser]];
//    if ([historyMsg count] > 0) {//有记录
//        messages = [[NSMutableArray alloc] initWithArray:[historyMsg objectAtIndex:0]];
//    }
//    else
//    {
//        messages = [[NSMutableArray alloc] initWithCapacity:1];
//    }

//    messages = [[DataStoreManager qureyAllCommonMessages:self.chatWithUser] retain];
    [self normalMsgToFinalMsg];
    [self sendReadedMesg];//发送已读消息
    
    self.myHeadImg = [DataStoreManager queryFirstHeadImageForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    
    self.tView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height-startX-55) style:UITableViewStylePlain];
    [self.view addSubview:self.tView];
    [self.tView setBackgroundColor:[UIColor clearColor]];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    self.tView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    
    ifAudio = NO;
    ifEmoji = NO;
    
    inPutView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, 320, 50)];
    
	self.textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(10, 7, 270, 35)];
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 6;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
	self.textView.returnKeyType = UIReturnKeySend; //just as an example
	self.textView.font = [UIFont systemFontOfSize:15.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor clearColor];
    //    self.inputTF.placeholder = @"Type to see the textView grow!";
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.view addSubview:inPutView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"chat_input.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    entryImageView.frame = CGRectMake(10, 7, 270, 35);
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
    
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(277, inPutView.frame.size.height-12-36, 45, 45)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [inPutView addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, startX - 44, 120, 44)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    [unReadL = [UILabel alloc]initWithFrame:CGRectMake(35, KISHighVersion_7 ? 20 : 0, 40, 42)];
    if (_unreadNo>0) {
        unReadL.text = [NSString stringWithFormat:@"%d",_unreadNo];
    }
    unReadL.backgroundColor = [UIColor clearColor];
    unReadL.textColor = [UIColor whiteColor];
    unReadL.textAlignment = NSTextAlignmentCenter;
    unReadL.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:unReadL];


    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    btnLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongTapAction:)];
    btnLongTap.minimumPressDuration = 1;
    
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    
    theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253) WithSendBtn:YES];
    theEmojiView.delegate = self;
    [self.view addSubview:theEmojiView];
    theEmojiView.hidden = YES;
    
    copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMsg)];
//    UIMenuItem *copyItem2 = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(transferMsg)];
    copyItem3 = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteMsg)];
    menu = [UIMenuController sharedMenuController];
    UIButton *profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [profileButton setBackgroundImage:[UIImage imageNamed:@"user_info_normal.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"user_info_click.png"] forState:UIControlStateHighlighted];
    [profileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:profileButton];
    [self.view bringSubviewToFront:profileButton];
    [profileButton addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];

}

- (void)sendReadedMesg//发送已读消息
{
    for(NSDictionary* plainEntry in messages)
    {
        NSString *msgType = KISDictionaryHaveKey(plainEntry, @"msgType");
        NSString *status = KISDictionaryHaveKey(plainEntry, @"status");
        NSString *sender = KISDictionaryHaveKey(plainEntry, @"sender");
        if ([msgType isEqualToString:@"normalchat"] && ![status isEqualToString:@"4"] && ![sender isEqualToString:@"you"]) {
            NSString*readMagIdString = KISDictionaryHaveKey(plainEntry, @"messageuuid");
            [self comeBackDisplayed:self.chatWithUser msgId:readMagIdString];
        }
    }
}

#pragma mark 计算每条消息高度
-(void)normalMsgToFinalMsg
{
    NSMutableArray* formattedEntries = [NSMutableArray arrayWithCapacity:messages.count];
    NSMutableArray* heightArray = [NSMutableArray array];
    for(NSDictionary* plainEntry in messages)
    {
        NSString *message = [plainEntry objectForKey:@"msg"];
        NSString *msgType = KISDictionaryHaveKey(plainEntry, @"msgType");
        if ([msgType isEqualToString:@"payloadchat"]) {
            NSDictionary* magDic = [KISDictionaryHaveKey(plainEntry, @"payload") JSONValue];
            
            CGSize titleSize = [self getPayloadMsgTitleSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(magDic, @"title")]];
            CGSize contentSize = CGSizeZero;
//            float withF = 0;
            float higF = 0;
            if (([GameCommon getNewStringWithId:KISDictionaryHaveKey(magDic, @"thumb")].length > 0) && ![KISDictionaryHaveKey(magDic, @"thumb") isEqualToString:@"null"]) {
                contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(magDic, @"msg")] withThumb:YES];
//                withF = contentSize.width + 40;
                higF = MAX(contentSize.height, 40);
            }
            else
            {
                contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(magDic, @"msg")] withThumb:NO];
//                withF = contentSize.width;
                higF = contentSize.height;
            }
//            NSNumber * width = [NSNumber numberWithFloat:MAX(titleSize.width, withF)];
            NSNumber * height = [NSNumber numberWithFloat:((titleSize.height > 0 ? (titleSize.height + 5) : titleSize.height) + higF)];
            
            NSArray * hh = [NSArray arrayWithObjects:[NSNumber numberWithFloat:195],height, nil];
            [heightArray addObject:hh];
            
            [formattedEntries addObject:KISDictionaryHaveKey(plainEntry, @"payload")];
        }
        else
        {
            NSMutableAttributedString* mas = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:message];
            
            OHParagraphStyle* paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
            paragraphStyle.textAlignment = kCTJustifiedTextAlignment;
            paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
            paragraphStyle.firstLineHeadIndent = 0.f; // indentation for first line
            paragraphStyle.lineSpacing = 5.f; // increase space between lines by 3 points
            [mas setParagraphStyle:paragraphStyle];
            [mas setFont:[UIFont systemFontOfSize:15]];
            //            [mas setTextColor:[randomColors objectAtIndex:(idx%5)]];
            [mas setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
            CGSize size = [mas sizeConstrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
            NSNumber * width = [NSNumber numberWithFloat:size.width];
            NSNumber * height = [NSNumber numberWithFloat:size.height];
            [formattedEntries addObject:mas];
            NSArray * hh = [NSArray arrayWithObjects:width,height, nil];
            [heightArray addObject:hh];
        }
    }
    self.finalMessageArray = formattedEntries;
    self.HeightArray = heightArray;
}

- (CGSize)getPayloadMsgTitleSize:(NSString*)theTitle
{
     return (theTitle.length > 0)?[theTitle sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(180, 50)] : CGSizeZero;
}
- (CGSize)getPayloadMsgContentSize:(NSString*)theContent withThumb:(BOOL)haveThumb
{
    return (theContent.length > 0)?[theContent sizeWithFont:[UIFont boldSystemFontOfSize:13.0] constrainedToSize:CGSizeMake(haveThumb ? 160 : 180, 80)] : CGSizeZero;
}

-(void)emojiBtnClicked:(UIButton *)sender
{
    if (!myActive) {
        UIAlertView * UnActionAlertV = [[UIAlertView alloc]initWithTitle:@"您尚未激活" message:@"未激活用户不能发送聊天消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去激活", nil];
        [UnActionAlertV show];
        return ;
    }
    if (!ifEmoji) {
        [self.textView resignFirstResponder];
        ifEmoji = YES;
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        [audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        audioRecordBtn.hidden = YES;
        [self showEmojiScrollView];
        
    }
    else
    {
        [self.textView.internalTextView becomeFirstResponder];
        ifEmoji = NO;
        theEmojiView.hidden = YES;
        [m_EmojiScrollView removeFromSuperview];
        [emojiBGV removeFromSuperview];
        [m_Emojipc removeFromSuperview];
        [sender setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    }
}

-(void)showEmojiScrollView
{
    [self.textView resignFirstResponder];
    [inPutView setFrame:CGRectMake(0, self.view.frame.size.height-227-inPutView.frame.size.height, 320, inPutView.frame.size.height)];
    theEmojiView.hidden = NO;
    [theEmojiView setFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253)];
    [self autoMovekeyBoard:253];

}
-(void)backBtnDo
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
    
}
-(void)emojiSendBtnDo
{
    [self sendButton:nil];
}
-(void)loadPageControl
{
	//创建并初始化uipagecontrol
	m_Emojipc=[[UIPageControl alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-70, 280, 20)];
	//设置背景颜色
	m_Emojipc.backgroundColor=[UIColor clearColor];
	//设置pc页数（此时不会同步跟随显示）
	m_Emojipc.numberOfPages=3;
	//设置当前页,为第一张，索引为零
	m_Emojipc.currentPage=0;
	//添加事件处理，btn点击
	[m_Emojipc addTarget:self action:@selector(pagePressed:) forControlEvents:UIControlEventTouchUpInside];
	//将pc添加到视图上
	[self.view addSubview:m_Emojipc];
    NSLog(@"load page control");
}
-(void)emojiView
{
    for (int n = 0; n <=84; n++) {
        UIButton *btn = [[UIButton alloc]init];
        if (n<28) {
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7), (n/7+1)*12+30*(n/7), 30, 30)];
        }
        else if(n>=28&&n<56)
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7)+320, ((n-28)/7+1)*12+30*((n-28)/7), 30, 30)];
        else
            [btn setFrame:CGRectMake(13.75*(n%7+1)+30*(n%7)+640, ((n-56)/7+1)*12+30*((n-56)/7), 30, 30)];
        [btn setBackgroundColor:[UIColor clearColor]];
        NSString * emojiStr = n+1>=10?[NSString stringWithFormat:@"0%d",n+1]:[NSString stringWithFormat:@"00%d",n+1];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"biaoqing%@.png",emojiStr]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(emojiButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:n];
        
        [m_EmojiScrollView addSubview:btn];
    }
}
-(void)emojiButtonPress:(id)sender
{
	//获取对应的button
	UIButton *selectedButton = (UIButton *) sender;
	int  n = selectedButton.tag;
	//根据button的tag获取对应的图片名
	NSString *facefilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionThird.plist"];
	NSDictionary *m_pEmojiDic = [[NSDictionary alloc] initWithContentsOfFile:facefilePath];
	NSString *i_transCharacter = [m_pEmojiDic objectForKey:[NSString stringWithFormat:@"%d",n+1]];
    //提示文字标签隐藏
	//判断输入框是否有内容，追加转义字符
	if (self.textView.text == nil) {
		self.textView.text = [NSString stringWithFormat:@"[%@] ",i_transCharacter];
	}
	else {
		self.textView.text = [self.textView.text stringByAppendingString:[NSString stringWithFormat:@"[%@] ",i_transCharacter]];
	}
    [self autoMovekeyBoard:253];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	float a=m_EmojiScrollView.contentOffset.x;
	int page=floor((a-320/2)/320)+1;
	m_Emojipc.currentPage=page;
}

-(NSString *)getHead:(NSString *)headStr
{
    NSArray* i = [headStr componentsSeparatedByString:@","];

    if ([i count] > 0) {
        return [i objectAtIndex:0];
    }
    return @"";

}

#pragma mark 用户详情
-(void)userInfoClick
{
//    PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
    TestViewController *detailV = [[TestViewController alloc]init];

    detailV.userId = self.chatWithUser;
    detailV.nickName = self.nickName;
    detailV.isChatPage = YES;
    [self.navigationController pushViewController:detailV animated:YES];
}

-(void)toContactProfile
{
    TestViewController * detailV = [[TestViewController alloc] init];
    detailV.userId = self.chatWithUser;
    detailV.nickName = self.nickName;
    detailV.isChatPage = YES;
    [self.navigationController pushViewController:detailV animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButton:nil];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if ([touch view]==clearView) {
        [self.textView resignFirstResponder];
        if (ifEmoji) {
            [self autoMovekeyBoard:0];
            ifEmoji = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [theEmojiView setFrame:CGRectMake(0, theEmojiView.frame.origin.y+260+startX - 44, 320, 253)];
                
                [m_EmojiScrollView setFrame:CGRectMake(0, m_EmojiScrollView.frame.origin.y+260, 320, 253)];
                [emojiBGV setFrame:CGRectMake(0, emojiBGV.frame.origin.y+260+startX - 44, 320, emojiBGV.frame.size.height)];
                [m_Emojipc setFrame:CGRectMake(0, m_Emojipc.frame.origin.y+260+startX - 44, 320, m_Emojipc.frame.size.height)];
            } completion:^(BOOL finished) {
                theEmojiView.hidden = YES;
                [m_EmojiScrollView removeFromSuperview];
                [emojiBGV removeFromSuperview];
                [m_Emojipc removeFromSuperview];
            }];

            [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
        }
        
        [clearView removeFromSuperview];
        if ([popLittleView superview]) {  
            [popLittleView removeFromSuperview];
        }
        canAdd = YES;
    }
    

 
}

- (void)viewDidUnload
{
    [self setTView:nil];
    [self setMessageTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark -
#pragma mark Responding to keyboard events
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(textField == self.messageTextField)
	{
        //		[self moveViewUp];
	}
}

-(void) autoMovekeyBoard: (float) h{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
	//inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);

    
    CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (h + containerFrame.size.height);
	// animations settings

	
	// set views with new info
	inPutView.frame = containerFrame;
    self.tView.frame = CGRectMake(0.0f, startX, 320.0f, self.view.frame.size.height-startX-inPutView.frame.size.height-h-10);

	
	// commit animations


//	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
//	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-108.0));
    [UIView commitAnimations];
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
    if (h>0&&canAdd) {
        canAdd = NO;
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height-startX-inPutView.frame.size.height-h)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, startX, 320, self.view.frame.size.height-startX-inPutView.frame.size.height-h)];
    }


}
#pragma mark -
#pragma mark HPExpandingTextView delegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    if (myActive) {
        [menu setMenuItems:@[]];
        return YES;
    }
    UIAlertView * UnActionAlertV = [[UIAlertView alloc]initWithTitle:@"您尚未激活" message:@"未激活用户不能发送聊天消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去激活", nil];
    [UnActionAlertV show];
    return NO;
}
//改变键盘高度
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = inPutView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	inPutView.frame = r;
    
    if ([clearView superview]) {
        [clearView setFrame:CGRectMake(0, startX, 320, clearView.frame.size.height+diff)];
    }
    self.tView.frame = CGRectMake(0.0f, startX, 320.0f, self.tView.frame.size.height+diff);
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    //    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
    [picBtn setFrame:CGRectMake(285, inPutView.frame.size.height-12-27, 25, 27)];
    [emojiBtn setFrame:CGRectMake(277, inPutView.frame.size.height-12-36, 45, 45)];
    [audioBtn setFrame:CGRectMake(8, inPutView.frame.size.height-12-27, 25, 27)];
}

-(BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendButton:nil];
    return YES;
}
#pragma mark 消息是否发送成功回调
- (void)messageAck:(NSNotification *)notification
{
    NSDictionary* tempDic = notification.userInfo;
    
    NSString* src_id = KISDictionaryHaveKey(tempDic, @"src_id");
//    NSString* received = KISDictionaryHaveKey(tempDic, @"received");//{'src_id':'','received':'true'}
    if ([tempDic isKindOfClass:[NSDictionary class]]) {
            NSString* status = [DataStoreManager queryMessageStatusWithId:src_id];
            NSInteger changeRow = [self getMsgRowWithId:src_id];
            if (changeRow < 0) {
                return;
            }
            NSMutableDictionary *dict = [messages objectAtIndex:changeRow];
            if ([status isEqualToString:@"2"]) {//发送中-> 失败
                [DataStoreManager refreshMessageStatusWithId:src_id status:@"0"];//超时
                [dict setObject:@"0" forKey:@"status"];
            }
            else//送达、已读、失败
            {
                [dict setObject:status forKey:@"status"];
            }
            [messages replaceObjectAtIndex:changeRow withObject:dict];
            
            NSIndexPath* indexpath = [NSIndexPath indexPathForRow:changeRow inSection:0];
            [self.tView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (NSInteger)getMsgRowWithId:(NSString*)msgUUID
{
    if (messages.count>0 && msgUUID && msgUUID.length > 0)
    {
        for (int i = 0; i < [messages count]; i++) {
            NSDictionary* tempDic = [messages objectAtIndex:i];
            if ([KISDictionaryHaveKey(tempDic, @"messageuuid") isEqualToString:msgUUID]) {
                return i;
            }
        }
        return -1;
    }
    return -1;
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    ifEmoji = NO;
    theEmojiView.hidden = YES;
    [m_EmojiScrollView removeFromSuperview];
    [emojiBGV removeFromSuperview];
    [m_Emojipc removeFromSuperview];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    if ([popLittleView superview]) {
        [popLittleView removeFromSuperview];
    }
    canAdd = YES;
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
 

}
-(NSString *)selectedEmoji:(NSString *)ssss
{
	if (self.textView.text == nil) {
		self.textView.text = ssss;
	}
	else {
		self.textView.text = [self.textView.text stringByAppendingString:ssss];
	}

    return 0;
}
-(void)deleteEmojiStr
{
    if (self.textView.text.length>=1) {
//        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
        NSLog(@"%d" , self.textView.text.length);
        if ([self.textView.text hasSuffix:@"] "] && [self.textView.text length] >= 5) {
            self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-5)];
        }
        else
        {
            self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
        }
    }
}
-(void)addEmojiScrollView
{
    if (self.textView.text.length>=1) {
        self.textView.text = [self.textView.text substringToIndex:(self.textView.text.length-1)];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    NSString *sender = KISDictionaryHaveKey(dict, @"sender");
    NSString *time = KISDictionaryHaveKey(dict, @"time");
    NSString *msgType = KISDictionaryHaveKey(dict, @"msgType");
    NSString* status = KISDictionaryHaveKey(dict, @"status");
    NSString* messageuuid = KISDictionaryHaveKey(dict, @"messageuuid");

    if ([msgType isEqualToString:@"payloadchat"]) {
        //动态消息
        static NSString *identifier = @"newsCell";
        KKNewsCell *cell =(KKNewsCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = [[KKNewsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        CGSize size = CGSizeMake([[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:0] floatValue], [[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue]);
        size.width = size.width<20?20:size.width;
        size.height = size.height<20?20:size.height;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary* msgDic = [[self.finalMessageArray objectAtIndex:indexPath.row] JSONValue];

        CGSize titleSize = [self getPayloadMsgTitleSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"title")]];
        CGSize contentSize = CGSizeZero;

        cell.titleLabel.text = KISDictionaryHaveKey(msgDic, @"title");
        if ([sender isEqualToString:@"you"]) {
            [cell.thumbImgV setFrame:CGRectMake(54, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), 40, 40)];
            contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"msg")] withThumb:YES];
        }
        else{
            [cell.thumbImgV setFrame:CGRectMake(70, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), 40, 40)];
            contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"msg")] withThumb:YES];
            
        }
        if ([GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"thumb")].length > 0 && ![KISDictionaryHaveKey(msgDic, @"thumb") isEqualToString:@"null"]) {
            NSString* imgStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"thumb")];
            NSURL * titleImage = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@/30",imgStr]];
            cell.thumbImgV.hidden = NO;
            cell.thumbImgV.imageURL = titleImage;
            
        }
        else
        {
            cell.thumbImgV.image = [UIImage imageNamed:@"dynamicIMG"];
            cell.thumbImgV.imageURL = nil;
        }
        cell.contentLabel.text = KISDictionaryHaveKey(msgDic, @"msg");
        
        UIImage *bgImage = nil;
        
        if ([sender isEqualToString:@"you"]) {
            [cell.headImgV setFrame:CGRectMake(320-10-40, padding*2-15, 40, 40)];
            [cell.headImgV addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
            NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",self.myHeadImg]];
            cell.headImgV.imageURL = theUrl;
            bgImage = [[UIImage imageNamed:@"bubble_05"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
            
            [cell.bgImageView setFrame:CGRectMake(320-size.width - padding-20-10-30, padding*2-15, size.width+25, size.height+20)];
            [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bgImageView setTag:(indexPath.row+1)];
            
            [cell.arrowImage setFrame:CGRectMake(padding-10+45 + size.width+27 + 10, size.height/2+27, 8, 12)];
            
            [cell.titleLabel setFrame:CGRectMake(padding + 50, 33, titleSize.width, titleSize.height+(contentSize.height > 0 ? 0 : 5))];
            if (cell.thumbImgV.hidden) {
                [cell.contentLabel setFrame:CGRectMake(padding + 50, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), contentSize.width, contentSize.height)];
            }
            else
            {
                [cell.contentLabel setFrame:CGRectMake(padding + 50 +28, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), contentSize.width, contentSize.height)];
            }
        }else
        {
            [cell.headImgV setFrame:CGRectMake(10, padding*2-15, 40, 40)];
            [cell.headImgV addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
            NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",self.chatUserImg]];
            cell.headImgV.imageURL = theUrl;
            bgImage = [[UIImage imageNamed:@"bubble_04.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
            
            [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-15, size.width+27, size.height + 20)];
            [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bgImageView setTag:(indexPath.row+1)];
            
            [cell.arrowImage setFrame:CGRectMake(padding-10+45 + size.width+27 + 10, size.height/2+27, 8, 12)];
            
            [cell.titleLabel setFrame:CGRectMake(padding + 50, 33, titleSize.width, titleSize.height+(contentSize.height > 0 ? 0 : 5))];
            if (cell.thumbImgV.hidden) {
                [cell.contentLabel setFrame:CGRectMake(padding + 50, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), contentSize.width, contentSize.height)];
            }
            else
            {
                [cell.contentLabel setFrame:CGRectMake(padding + 50 + 45, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), contentSize.width, contentSize.height)];
            }
        }
        
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        if (indexPath.row>0) {
            if ([time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]<60) {
                cell.senderAndTimeLabel.hidden = YES;
            }
            else
            {
                cell.senderAndTimeLabel.hidden = NO;
            }
        }
        else
            cell.senderAndTimeLabel.hidden = NO;
        previousTime = nowTime;
        NSString * timeStr = [self CurrentTime:[NSString stringWithFormat:@"%d",(int)nowTime] AndMessageTime:[NSString stringWithFormat:@"%d",[time intValue]]];
        if ([sender isEqualToString:@"you"]) {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", @"我", timeStr];
        }
        else
        {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", self.nickName, timeStr];
        }
        return cell;
    }
    else
    {
        //普通聊天消息
        static NSString *identifier = @"msgCell";
        KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        
          cell.messageContentView.attributedText = [self.finalMessageArray objectAtIndex:indexPath.row];
        
        //    CGSize size = [cell.messageContentView sizeThatFits:CGSizeMake(220, CGFLOAT_MAX)];
        CGSize size = CGSizeMake([[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:0] floatValue], [[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue]);
       // CGSize size = [cell.messageContentView.attributedText sizeConstrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
        size.width = size.width<20?20:size.width;
        size.height = size.height<20?20:size.height;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // cell.userInteractionEnabled = NO;
        
        cell.messageuuid = messageuuid;
        
        UIImage *bgImage = nil;

        if ([sender isEqualToString:@"you"]) {
            cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
            NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@", self.myHeadImg]];
            cell.headImgV.imageURL = theUrl;

            [cell.headImgV setFrame:CGRectMake(320-10-40, padding*2-15, 40, 40)];
            bgImage = [[UIImage imageNamed:@"bubble_02.png"]
                       stretchableImageWithLeftCapWidth:15 topCapHeight:22];
            [cell.headBtn setFrame:cell.headImgV.frame];
            
            [cell.headBtn addTarget:self action:@selector(myBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.messageContentView setFrame:CGRectMake(320-size.width - padding-15-10-25, padding*2-4, size.width, size.height)];
            [cell.bgImageView setFrame:CGRectMake(320-size.width - padding-20-10-30, padding*2-15, size.width+25, size.height+20)];
            [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.bgImageView setTag:(indexPath.row+1)];

            [cell.failImage addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
            [cell.failImage addTarget:self action:@selector(offsetButtonTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
            [cell.failImage setTag:(indexPath.row+1)];

            [cell refreshStatusPoint:CGPointMake(320-size.width-padding-60 -15, (size.height+20)/2 + padding*2-15) status:status];
        }else {
            [cell.headImgV setFrame:CGRectMake(10, padding*2-15, 40, 40)];
            [cell.chattoHeadBtn setFrame:cell.headImgV.frame];
            [cell.chattoHeadBtn addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
            NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",self.chatUserImg]];
            cell.headImgV.imageURL = theUrl;
            bgImage = [[UIImage imageNamed:@"bubble_01.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
           
            [cell.messageContentView setFrame:CGRectMake(padding+7+45, padding*2-4, size.width, size.height)];
            
            [cell.bgImageView setFrame:CGRectMake(padding-10+45, padding*2-15, size.width+25, size.height+20)];
            [cell.bgImageView setBackgroundImage:bgImage forState:UIControlStateNormal];
            [cell.bgImageView addTarget:self action:@selector(offsetButtonTouchBegin:) forControlEvents:UIControlEventTouchDown];
            [cell.bgImageView setTag:(indexPath.row+1)];
            [cell refreshStatusPoint:CGPointZero status:@"1"];
        }

        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        
        if (indexPath.row > 0) {
            if ([time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]<60) {
                cell.senderAndTimeLabel.hidden = YES;
            }
            else
            {
                cell.senderAndTimeLabel.hidden = NO;
            }
        }
        else
            cell.senderAndTimeLabel.hidden = NO;
        previousTime = nowTime;
        NSString * timeStr = [self CurrentTime:[NSString stringWithFormat:@"%d",(int)nowTime] AndMessageTime:[NSString stringWithFormat:@"%d",[time intValue]]];
        if ([sender isEqualToString:@"you"]) {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", @"我", timeStr];
        }
        else
        {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", self.nickName, timeStr];
        }
        
        return cell;
    }
}

-(void)chatToBtnClicked
{
    [self toContactProfile];
}
-(void)myBtnClicked
{
    TestViewController * detailV = [[TestViewController alloc] init];
    
    detailV.userId = [DataStoreManager getMyUserID];
    detailV.nickName = [DataStoreManager queryRemarkNameForUser:[DataStoreManager getMyUserID]];
    detailV.isChatPage = YES;
    [self.navigationController pushViewController:detailV animated:YES];
}
-(void)offsetButtonTouchBegin:(UIButton *)sender
{
    touchTimePre = [[NSDate date] timeIntervalSince1970];
    tempBtn = sender;
    NSLog(@"begin");
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(endIt:) userInfo:nil repeats:NO];
}

-(void)offsetButtonTouchEnd:(UIButton *)sender
{
    NSLog(@"%f %d", [[NSDate date] timeIntervalSince1970], touchTimePre);
    if ([[NSDate date] timeIntervalSince1970]-touchTimePre<=1) {//单击
        NSMutableDictionary *dict = [messages objectAtIndex:(tempBtn.tag-1)];
        NSString* msgType = KISDictionaryHaveKey(dict, @"msgType");
        NSString* status = KISDictionaryHaveKey(dict, @"status");
        if ([msgType isEqualToString:@"payloadchat"]) {
            NSDictionary* msgDic = [KISDictionaryHaveKey(dict, @"payload") JSONValue];
            OnceDynamicViewController* detailVC = [[OnceDynamicViewController alloc] init];
            detailVC.messageid = KISDictionaryHaveKey(msgDic, @"messageid");
            detailVC.delegate = nil;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if([msgType isEqualToString:@"normalchat"] && [status isEqualToString:@"0"])//是否重发
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:Nil otherButtonTitles:@"重新发送", nil];
            sheet.tag = 124;
            [sheet showInView:self.view];
        }
    }
    NSLog(@"end");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        ActivateViewController * actVC = [[ActivateViewController alloc]init];
        [self.navigationController pushViewController:actVC animated:YES];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 124) {
        if (buttonIndex == 1) {
            return;
        }
        NSInteger cellIndex = tempBtn.tag-1;
        NSMutableDictionary* dict = [messages objectAtIndex:cellIndex];
        NSString* message = KISDictionaryHaveKey(dict, @"msg");
        NSString* uuid = KISDictionaryHaveKey(dict, @"messageuuid");
        NSString* sendtime = KISDictionaryHaveKey(dict, @"time");
        [dict setObject:@"2" forKey:@"status"];
        
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        [mes addAttributeWithName:@"from" stringValue:[[DataStoreManager getMyUserID] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
        [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
        [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
        [mes addAttributeWithName:@"msgTime" stringValue:sendtime];
        [mes addAttributeWithName:@"id" stringValue:uuid];
        //组合
        [mes addChild:body];
        
        //发送消息
        if (![self.appDel.xmppHelper sendMessage:mes]) {
            [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
            [dict setObject:@"0" forKey:@"status"];
            return;
        }
        [messages replaceObjectAtIndex:cellIndex withObject:dict];
        NSIndexPath* indexpath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        [self.tView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    return (action == @selector(copyMsg));
//    return (action == @selector(transferMsg));
//    return (action == @selector(deleteMsg));
    if (action == @selector(copyMsg) || action == @selector(transferMsg) || action == @selector(deleteMsg))
    {
        return YES;
    }
    else
        return NO;
}
-(void)endIt:(UIButton *)sender
{
    if (tempBtn.highlighted == YES) {//长按
        NSLog(@"haha");
        indexPathTo = [[NSIndexPath indexPathForRow:(tempBtn.tag-1) inSection:0] copy];
        KKMessageCell * cell = (KKMessageCell *)[self.tView cellForRowAtIndexPath:indexPathTo];
        tempStr = [[[messages objectAtIndex:indexPathTo.row] objectForKey:@"msg"] copy];
        CGRect rect = [self.view convertRect:tempBtn.frame fromView:cell.contentView];

        readyIndex = tempBtn.tag-1;

//        [self displayPopLittleViewWithRectX:(rect.origin.x+(rect.size.width-182)/2) RectY:rect.origin.y-54 TheRect:rect];
        
        [self canBecomeFirstResponder];
        [self becomeFirstResponder];
        
        [menu setMenuItems:[NSArray arrayWithObjects:copyItem,copyItem3, nil]];

        [menu setTargetRect:CGRectMake(rect.origin.x, rect.origin.y, 60, 90) inView:self.view];
        [menu setMenuVisible:YES animated:YES];
    }

    //[yy setBackgroundImage:nil forState:UIControlStateNormal];
}

-(void)copyMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = tempStr;
}

#pragma mark 删除
-(void)deleteMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    [DataStoreManager deleteCommonMsg:[[messages objectAtIndex:readyIndex] objectForKey:@"msg"] Time:[[messages objectAtIndex:readyIndex] objectForKey:@"time"]];
     [messages removeObjectAtIndex:readyIndex];
    [self.finalMessageArray removeObjectAtIndex:readyIndex];
    if (messages.count>0) {
        [DataStoreManager refreshThumbMsgsAfterDeleteCommonMsg:[messages lastObject] ForUser:self.chatWithUser ifDel:NO];
    }
    else
        [DataStoreManager refreshThumbMsgsAfterDeleteCommonMsg:[messages lastObject] ForUser:self.chatWithUser ifDel:YES];
    [self normalMsgToFinalMsg];
    [self.tView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPathTo] withRowAnimation:UITableViewRowAnimationRight];
    [self.tView reloadData];

}
-(void)btnLongTapAction:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    NSLog(@"222");
}
-(void)longPress:(UIButton*)sender
{
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float theH = [[[self.HeightArray objectAtIndex:indexPath.row] objectAtIndex:1] floatValue];
    theH += padding*2 + 10;
    
    CGFloat height = theH < 65 ? 65 : theH;
    
    return height;
    
}

#pragma mark -发送
- (void)sendButton:(id)sender {
    
    
    if (self.textView.text.length>255) {
        [self showAlertViewWithTitle:nil message:@"发送字数太多，请分条发送" buttonTitle:@"确定"];
        return;
    }

    //本地输入框中的信息
    NSString *message = self.textView.text;
    [self sendMsg:message];
  
}
-(void)sendMsg:(NSString *)message
{
    NSLog(@"+++++%@",[message class]);
    if (message.length==0)
    {
        return;
    }
    if ([[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        //如果发送信息为空或者为空格的时候弹框提示
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"不能发送空消息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //   [mes addAttributeWithName:@"nickname" stringValue:@"aaaa"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[self.chatWithUser stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //        //由谁发送
    //        [mes addAttributeWithName:@"from" stringValue:[[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[DataStoreManager getMyUserID] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
    [mes addAttributeWithName:@"msgTime" stringValue:[GameCommon getCurrentTime]];
    NSString* uuid = [[GameCommon shareGameCommon] uuid];
    [mes addAttributeWithName:@"id" stringValue:uuid];
    NSLog(@"消息uuid ~!~~ %@", uuid);
    
    //组合
    [mes addChild:body];
    
    //发送消息
    [self.appDel.xmppHelper sendMessage:mes];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:message forKey:@"msg"];
    [dictionary setObject:@"you" forKey:@"sender"];
    [dictionary setObject:[GameCommon getCurrentTime] forKey:@"time"];
    [dictionary setObject:self.chatWithUser forKey:@"receiver"];
    [dictionary setObject:self.nickName forKey:@"nickname"];
    [dictionary setObject:self.chatUserImg forKey:@"img"];
    [dictionary setObject:@"normalchat" forKey:@"msgType"];
    
    [dictionary setObject:uuid forKey:@"messageuuid"];
    [dictionary setObject:@"2" forKey:@"status"];
    
    [messages addObject:dictionary];
    
    [self normalMsgToFinalMsg];
    [DataStoreManager storeMyMessage:dictionary];
    
    //重新刷新tableView
    [self.tView reloadData];
    if (messages.count>0) {
        [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    self.textView.text = @"";
    
}

#pragma mark -
#pragma mark 历史聊天记录展示
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView == self.tView) {
        CGPoint offsetofScrollView = self.tView.contentOffset;
        NSLog(@"%@", NSStringFromCGPoint(offsetofScrollView));
        if (offsetofScrollView.y < - 20) {//向上拉出20个像素高度时加载
            NSArray * array = [DataStoreManager qureyCommonMessagesWithUserID:self.chatWithUser FetchOffset:messages.count];
            for (int i = 0; i < array.count; i++) {
                [messages insertObject:array[i] atIndex:i];
            }
            [self normalMsgToFinalMsg];
            [self.tView reloadData];
            [self performSelector:@selector(scrollToOldMassageRang:) withObject:array afterDelay:0.00000001];
        }
    }
}
- (void)scrollToOldMassageRang:(NSArray *)array
{
    [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:array.count inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}
#pragma mark KKMessageDelegate
- (void)newMesgReceived:(NSNotification*)notification
{
    NSDictionary* tempDic = notification.userInfo;
    NSRange range = [KISDictionaryHaveKey(tempDic,  @"sender") rangeOfString:@"@"];
    NSString * sender = [KISDictionaryHaveKey(tempDic,  @"sender") substringToIndex:range.location];
    if ([sender isEqualToString:self.chatWithUser]) {
        [messages addObject:tempDic];
        
        [self normalMsgToFinalMsg];
        [self.tView reloadData];
        if (messages.count>0) {
            [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        NSString* msgId = KISDictionaryHaveKey(tempDic, @"msgId");
        [self comeBackDisplayed:sender msgId:msgId];//发送已读消息
    }
    else
    {
        _unreadNo++;
        if (_unreadNo>0) {
            unReadL.text = [NSString stringWithFormat:@"%d",_unreadNo];
        }
    }
}

- (void)comeBackDisplayed:(NSString*)sender msgId:(NSString*)msgId//发送已读消息
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:msgId,@"src_id",@"true",@"received",@"Displayed",@"msgStatus", nil];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[dic JSONRepresentation]];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"id" stringValue:msgId];
    [mes addAttributeWithName:@"msgtype" stringValue:@"msgStatus"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"normal"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[sender stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[DataStoreManager getMyUserID] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    //    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"msgTime" stringValue:[GameCommon getCurrentTime]];

    //组合
    [mes addChild:body];
    if (![self.appDel.xmppHelper sendMessage:mes]) {
        return;
    }
    [DataStoreManager refreshMessageStatusWithId:msgId status:@"4"];
}

-(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime
{
    NSString * finalTime;
    int theCurrentT = [currentTime intValue];
    int theMessageT = [messageTime intValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *messageDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString * msgT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theMessageT]];
    NSString * nowT = [dateFormatter2 stringFromDate:[NSDate dateWithTimeIntervalSince1970:theCurrentT]];
//    int msgHour = [[msgT substringToIndex:2] intValue];
    int hours = [[nowT substringToIndex:2] intValue];
    int minutes = [[nowT substringFromIndex:3] intValue];
    // NSLog(@"hours:%d,minutes:%d",hours,minutes);
    int currentDayBegin = theCurrentT-hours*3600-minutes*60;
    int yesterdayBegin = currentDayBegin-3600*24;
//    int qiantianBegin = yesterdayBegin-3600*24;
    //今天
    if ([currentStr isEqualToString:messageDateStr]) {
//        if (msgHour>0&&msgHour<11) {
//            finalTime = [NSString stringWithFormat:@"早上 %@",msgT];
//        }
//        else if (msgHour>=11&&msgHour<13){
//            finalTime = [NSString stringWithFormat:@"中午 %@",msgT];
//        }
//        else if(msgHour>=13&&msgHour<18) {
//            finalTime = [NSString stringWithFormat:@"下午 %@",msgT];
//        }
//        else{
//            finalTime = [NSString stringWithFormat:@"晚上 %@",msgT];
//        }
        finalTime = [NSString stringWithFormat:@"%@",msgT];
    }
    //昨天
    else if(theMessageT>=yesterdayBegin&&theMessageT<currentDayBegin){
//        if (msgHour>0&&msgHour<11) {
//            finalTime = [NSString stringWithFormat:@"昨天早上 %@",msgT];
//        }
//        else if (msgHour>=11&&msgHour<13){
//            finalTime = [NSString stringWithFormat:@"昨天中午 %@",msgT];
//        }
//        else if(msgHour>=13&&msgHour<18) {
//            finalTime = [NSString stringWithFormat:@"昨天下午 %@",msgT];
//        }
//        else{
//            finalTime = [NSString stringWithFormat:@"昨天晚上 %@",msgT];
//        }
        finalTime = [NSString stringWithFormat:@"昨天 %@",msgT];
    }
    //前天
//    else if (theMessageT>=qiantianBegin&&theMessageT<yesterdayBegin)
//    {
//        NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:theMessageT];
//        NSString * weekday = [GameCommon getWeakDay:msgDate];
//        if (msgHour>0&&msgHour<11) {
//            finalTime = [NSString stringWithFormat:@"%@早晨 %@",weekday,msgT];
//        }
//        else if (msgHour>=11&&msgHour<13){
//            finalTime = [NSString stringWithFormat:@"%@中午 %@",weekday,msgT];
//        }
//        else if(msgHour>=13&&msgHour<18) {
//            finalTime = [NSString stringWithFormat:@"%@下午 %@",weekday,msgT];
//        }
//        else{
//            finalTime = [NSString stringWithFormat:@"%@晚上 %@",weekday,msgT];
//        }
//    }
    //今年
//    else if([[messageDateStr substringToIndex:4] isEqualToString:[currentStr substringToIndex:4]]){
//        finalTime = [NSString stringWithFormat:@"%@月%@日 %@",[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8],msgT];
//    }
//    else
//    {
//        finalTime = [NSString stringWithFormat:@"%@ %@",messageDateStr,msgT];
//    }
    else
        finalTime = [NSString stringWithFormat:@"%@年%@月%@日 %@",[[messageDateStr substringFromIndex:0] substringToIndex:4] ,[[messageDateStr substringFromIndex:5] substringToIndex:2],[messageDateStr substringFromIndex:8], msgT];

    return finalTime;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewMessageReceived object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kMessageAck object:nil];
}
//-(KKAppDelegate *)appDelegate{
//    
//    return (KKAppDelegate *)[[UIApplication sharedApplication] delegate];
//}
//
//-(XMPPStream *)xmppStream{
//    
//    return [[self appDelegate] xmppStream];
//}

@end
