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
#import "PersonDetailViewController.h"
#import "KKNewsCell.h"
#import "OnceDynamicViewController.h"

#ifdef NotUseSimulator
    #import "amrFileCodec.h"
#endif

#define padding 20
#define LocalMessage @"localMessage"
#define NameKeys @"namekeys"
@interface KKChatController (){
    
    NSMutableArray *messages;
    UIMenuItem *copyItem;
    UIMenuItem *copyItem3;
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

    if (![[DataStoreManager queryMsgRemarkNameForUser:self.chatWithUser] isEqualToString:@""]) {
        self.nickName = [DataStoreManager queryMsgRemarkNameForUser:self.chatWithUser];//刷新别名
        titleLabel.text=self.nickName;
        [self.tView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageAck:) name:kMessageAck object:nil];//消息是否发送成功
    
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
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, startX - 44, 120, 44)];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=self.nickName;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLabel];
    
    messages = [[DataStoreManager qureyAllCommonMessages:self.chatWithUser] retain];
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
    
    UIButton *profileButton=[UIButton buttonWithType:UIButtonTypeCustom];
    profileButton.frame=CGRectMake(275, startX - 44, 45, 44);
    [profileButton setBackgroundImage:[UIImage imageNamed:@"user_info_normal.png"] forState:UIControlStateNormal];
    [profileButton setBackgroundImage:[UIImage imageNamed:@"user_info_click.png"] forState:UIControlStateHighlighted];
    [profileButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:profileButton];
    [profileButton addTarget:self action:@selector(userInfoClick) forControlEvents:UIControlEventTouchUpInside];
    
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
    
  /**************   语音图片等
    
    audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioBtn setFrame:CGRectMake(8, inPutView.frame.size.height-12-27, 25, 27)];
    [audioBtn setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
    [inPutView addSubview:audioBtn];
    [audioBtn addTarget:self action:@selector(audioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    audioRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [audioRecordBtn setFrame:CGRectMake(40, inPutView.frame.size.height-42, 200, 35)];
    [audioRecordBtn setBackgroundImage:[UIImage imageNamed:@"yanzhengma_normal.png"] forState:UIControlStateNormal];
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [inPutView addSubview:audioRecordBtn];
    audioRecordBtn.hidden = YES;
    [audioRecordBtn addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchDown];

    [audioRecordBtn addTarget:self action:@selector(buttonUp) forControlEvents:UIControlEventTouchUpInside];
    [audioRecordBtn addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpOutside];
    [audioRecordBtn addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchCancel];
    
    emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [emojiBtn setFrame:CGRectMake(250, inPutView.frame.size.height-12-27, 25, 27)];
    [emojiBtn setImage:[UIImage imageNamed:@"emoji.png"] forState:UIControlStateNormal];
    [inPutView addSubview:emojiBtn];
    [emojiBtn addTarget:self action:@selector(emojiBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [picBtn setFrame:CGRectMake(285, inPutView.frame.size.height-12-27, 25, 27)];
    [picBtn setImage:[UIImage imageNamed:@"picBtn.png"] forState:UIControlStateNormal];
    [inPutView addSubview:picBtn];
    [picBtn addTarget:self action:@selector(picBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
   
   ********/
    
//    senBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [senBtn setFrame:CGRectMake(282, inPutView.frame.size.height-37.5, 28, 27.5)];
//    [senBtn setImage:[UIImage imageNamed:@"chat_send.png"] forState:UIControlStateNormal];
//    [inPutView addSubview:senBtn];
//    [senBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];

    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   // [self.messageTextField becomeFirstResponder];
//    self.appDel.xmppHelper.chatDelegate = self;
    
    btnLongTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongTapAction:)];
    btnLongTap.minimumPressDuration = 1;
    
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    
//    if ([self.chatUserImg isEqualToString:@"no"]) {//没有头像 这个逻辑有问题 应该是回复之后成为朋友 再请求
//        [self getUserInfoWithUserName:self.chatWithUser];
//    }
//  语音初始化
//    rootRecordPath = [RootDocPath stringByAppendingPathComponent:@"localRecord"];
//    self.session = [AVAudioSession sharedInstance];
//    
//    [self initTwoAudioPlayFrame];
    
    theEmojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-253, 320, 253) WithSendBtn:YES];
    theEmojiView.delegate = self;
    [self.view addSubview:theEmojiView];
    theEmojiView.hidden = YES;
    
    copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyMsg)];
//    UIMenuItem *copyItem2 = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(transferMsg)];
    copyItem3 = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(deleteMsg)];
    menu = [UIMenuController sharedMenuController];
    
//    KKAppDelegate *del = [self appDelegate];
//    del.messageDelegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)sendReadedMesg//发送已读消息
{
    NSString* readMagIdString = @"";
    for(NSDictionary* plainEntry in messages)
    {
        NSString *msgType = KISDictionaryHaveKey(plainEntry, @"msgType");
        NSString *status = KISDictionaryHaveKey(plainEntry, @"status");
        NSString *sender = KISDictionaryHaveKey(plainEntry, @"sender");
        if ([msgType isEqualToString:@"normalchat"] && ![status isEqualToString:@"4"] && ![sender isEqualToString:@"you"]) {
            if ([KISDictionaryHaveKey(plainEntry, @"messageuuid") length] > 0) {
                readMagIdString = [readMagIdString stringByAppendingFormat:@"%@,", KISDictionaryHaveKey(plainEntry, @"messageuuid")];
            }
        }
    }
    if (readMagIdString.length > 0) {
        [self comeBackDisplayed:self.chatWithUser msgId:readMagIdString];
    }
}

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
     return (theTitle.length > 0)?[theTitle sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 50)] : CGSizeZero;
}
- (CGSize)getPayloadMsgContentSize:(NSString*)theContent withThumb:(BOOL)haveThumb
{
    return (theContent.length > 0)?[theContent sizeWithFont:[UIFont boldSystemFontOfSize:13.0] constrainedToSize:CGSizeMake(haveThumb ? 160 : 200, 80)] : CGSizeZero;
}
-(void)audioBtnClicked:(UIButton *)sender
{
    if (!ifAudio) {
        self.textView.text = @"";
        ifAudio = YES;
        [sender setImage:[UIImage imageNamed:@"keyboard.png"] forState:UIControlStateNormal];
        audioRecordBtn.hidden = NO;
        self.textView.hidden = YES;
        [self.textView resignFirstResponder];
        if ([clearView superview]) {
            [clearView removeFromSuperview];
        }
        if ([popLittleView superview]) {
            [popLittleView removeFromSuperview];
        }
        canAdd = YES;
        if (ifEmoji) {
            [self autoMovekeyBoard:0];
            ifEmoji = NO;
            [UIView animateWithDuration:0.2 animations:^{
                [theEmojiView setFrame:CGRectMake(0, theEmojiView.frame.origin.y + 260 + startX - 44, 320, 253)];
                
                [m_EmojiScrollView setFrame:CGRectMake(0, m_EmojiScrollView.frame.origin.y+260+startX - 44, 320, 253)];
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
    }
    else
    {
        ifAudio = NO;
        [sender setImage:[UIImage imageNamed:@"audioBtn.png"] forState:UIControlStateNormal];
        self.textView.hidden = NO;
        audioRecordBtn.hidden = YES;
        [self.textView.internalTextView becomeFirstResponder];
    }
}
-(void)emojiBtnClicked:(UIButton *)sender
{
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
-(void)picBtnClicked:(UIButton *)sender
{
    [self getAudioFromNet:@"A598A1E1C3AE4796AD8FF97028518C9E"];
}
-(void)audioRecordBtnClicked:(UIButton *)sender
{
    
}
-(void)initTwoAudioPlayFrame
{
    animationOne=[[NSMutableArray alloc]init] ;
    for(int i=0;i<3;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d.png",i+1];
        UIImage *img=[UIImage imageNamed:str];
        [animationOne addObject:img];
    }
    animationTwo=[[NSMutableArray alloc]init] ;
    for(int i=0;i<3;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"SenderVoiceNodePlaying00%d.png",i+1];
        UIImage *img=[UIImage imageNamed:str];
        [animationTwo addObject:img];
    }
}
-(void)buttonDown
{
    [audioRecordBtn setTitle:@"松开发送您说的话" forState:UIControlStateNormal];
    beginTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"recording voice button touchDown");
    if (audioplayButton == nil) {
        audioplayButton=[UIButton buttonWithType:UIButtonTypeCustom];
        audioplayButton.frame=CGRectMake(80, self.view.frame.size.height/2-80, 160, 160);
        [audioplayButton setImage:[UIImage imageNamed:@"third_xiemessage_record_icon.png"] forState:UIControlStateNormal];
        [self.view addSubview:audioplayButton];
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 160, 20)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setTextAlignment:NSTextAlignmentCenter];
        [textLabel setTextColor:[UIColor whiteColor]];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setText:@"手指移出按钮取消说话"];
        [audioplayButton addSubview:textLabel];
        
    }
    if (recordAnimationIV == nil)
    {
        recordAnimationIV=[[UIImageView alloc]initWithFrame:CGRectMake(180, self.view.frame.size.height/2-55, 50, 100)];
    }
    NSMutableArray *arr=[[NSMutableArray alloc]init] ;
    for(int i=1;i<=24;i++){
        NSString *str=nil;
        str=[NSString stringWithFormat:@"third_xiemessage_record_ani%d.png",i];
        UIImage *img=[UIImage imageNamed:str];
        [arr addObject:img];
    }
    recordAnimationIV.animationImages=arr;
    recordAnimationIV.animationDuration=1.0;
    recordAnimationIV.animationRepeatCount=0;
    [recordAnimationIV startAnimating];
    [self.view addSubview:recordAnimationIV];
    [self beginRecord];
    // beginTime =
}
-(void)buttonUp
{
    [self stopRecording];
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970];
    if(endTime-beginTime>0.5)
    {
        
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"说话时间太短了" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    [recordAnimationIV stopAnimating];
    [recordAnimationIV removeFromSuperview];
    recordAnimationIV = nil;
    [audioplayButton removeFromSuperview];
    audioplayButton = nil;

}
-(void)buttonCancel:(UIButton *)sender
{
    [self stopRecording];
    [audioRecordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [recordAnimationIV stopAnimating];
    [recordAnimationIV removeFromSuperview];
    recordAnimationIV = nil;
    [audioplayButton removeFromSuperview];
    audioplayButton = nil;
}

-(void)showEmojiScrollView
{
    [self.textView resignFirstResponder];
    [inPutView setFrame:CGRectMake(0, self.view.frame.size.height-227-inPutView.frame.size.height, 320, inPutView.frame.size.height)];
 /*   //表情列表如果存在就隐藏
    //if (m_EmojiScrollView==nil)
    //{
    //将面板先于工具栏加入视图，避免遮挡
    UIImageView *sixGridBGV=[[UIImageView alloc]initWithFrame:CGRectMake(-320, 0, 1280, self.view.frame.size.height-227)];//原来是253
    [sixGridBGV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    
    //创建表情视图
    UIScrollView *i_emojiScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,  self.view.frame.size.height-253, 320, self.view.frame.size.height-227)];//原来是227和253
    //设置表情列表scrollview属性
    i_emojiScrollView.backgroundColor=[UIColor yellowColor];
    m_EmojiScrollView = i_emojiScrollView;
    [m_EmojiScrollView addSubview:sixGridBGV];
    m_EmojiScrollView.delegate=self;
    m_EmojiScrollView.bouncesZoom = YES;
    m_EmojiScrollView.pagingEnabled = YES;
    m_EmojiScrollView.showsHorizontalScrollIndicator = NO;
    m_EmojiScrollView.showsVerticalScrollIndicator = NO;
    [m_EmojiScrollView setContentSize:CGSizeMake(960,self.view.frame.size.height-227)];//原来是253
    m_EmojiScrollView.backgroundColor = [UIColor clearColor];
    m_EmojiScrollView.scrollEnabled = YES;
    [self.view addSubview:m_EmojiScrollView];
    [self emojiView];
    //启动pagecontrol
    [self loadPageControl];
    emojiBGV = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45.5-26.5-10, 320, 45.5+26.5+10)];
    emojiBGV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:emojiBGV];
    UIImageView * ebgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 26.5+10, 320, 45.5)];
    [ebgv setImage:[UIImage imageNamed:@"qqqqq_06.png"]];
    [emojiBGV addSubview:ebgv];
    UIButton * backEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backEmojiBtn setFrame:CGRectMake(320-12-49.5, 5, 40.5, 23)];
    [backEmojiBtn setImage:[UIImage imageNamed:@"qqqqq_03.png"] forState:UIControlStateNormal];
    [emojiBGV addSubview:backEmojiBtn];
    [backEmojiBtn addTarget:self action:@selector(backBtnDo) forControlEvents:UIControlEventTouchUpInside];
    UIButton * sendEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendEmojiBtn setFrame:CGRectMake(320-12-71.5, 43.5, 71.5, 32)];
    [sendEmojiBtn setImage:[UIImage imageNamed:@"btn_03.png"] forState:UIControlStateNormal];
    [emojiBGV addSubview:sendEmojiBtn];
    [sendEmojiBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
*/
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


-(void)getUserInfoWithUserName:(NSString *)userNameit
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * mypostDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userNameit forKey:@"username"];
    
    [mypostDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [mypostDict setObject:paramDict forKey:@"params"];
    [mypostDict setObject:@"106" forKey:@"method"];
    [mypostDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:mypostDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary * recDict = responseObject;
//        [DataStoreManager saveUserInfo:recDict];
        self.chatUserImg = [self getHead:[recDict objectForKey:@"img"]];
        self.nickName = [recDict objectForKey:@"nickname"];
        titleLabel.text=self.nickName;
        [self.tView reloadData];
  
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
    
}
-(NSString *)getHead:(NSString *)headStr
{
    NSArray* i = [headStr componentsSeparatedByString:@","];

//    NSArray *arr = [[i objectAtIndex:0] componentsSeparatedByString:@"_"];
//    if (arr.count>1) {
//        return arr[0];
//    }
    if ([i count] > 0) {
        return [i objectAtIndex:0];
    }
    return @"";

}

#pragma mark 用户详情
-(void)userInfoClick
{
    PersonDetailViewController* detailV = [[PersonDetailViewController alloc] init];
    detailV.userId = self.chatWithUser;
    detailV.nickName = self.nickName;
    detailV.isChatPage = YES;
    [self.navigationController pushViewController:detailV animated:YES];
}

-(void)toContactProfile
{
    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
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
    [UIView setAnimationDuration:0.2];
	//inPutView.frame = CGRectMake(0.0f, (float)(self.view.frame.size.height-h-inPutView.frame.size.height), 320.0f, inPutView.frame.size.height);

    
    CGRect containerFrame = inPutView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (h + containerFrame.size.height);
	// animations settings

	
	// set views with new info
	inPutView.frame = containerFrame;
    
	
	// commit animations


//	UITableView *tableView = (UITableView *)[self.view viewWithTag:TABLEVIEWTAG];
//	tableView.frame = CGRectMake(0.0f, 0.0f, 320.0f,(float)(480.0-h-108.0));
    [UIView commitAnimations];
    self.tView.frame = CGRectMake(0.0f, startX, 320.0f, self.view.frame.size.height-startX-inPutView.frame.size.height-h);
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
    [menu setMenuItems:@[]];
    return YES;
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
    
    NSString* rowIndex = KISDictionaryHaveKey(tempDic, @"row");
    NSString* src_id = KISDictionaryHaveKey(tempDic, @"src_id");
    NSString* received = KISDictionaryHaveKey(tempDic, @"received");//{'src_id':'','received':'true'}
    if ([tempDic isKindOfClass:[NSDictionary class]]) {
//        [DataStoreManager refreshMessageStatusWithId:src_id status:[received boolValue] ? @"1" : @"0"];
        if (rowIndex && rowIndex.length > 0) {//超时引起 5秒
            [DataStoreManager refreshMessageStatusWithId:src_id status:[received boolValue] ? @"1" : @"0"];

            NSMutableDictionary *dict = [messages objectAtIndex:[rowIndex integerValue]];
            NSString* status = KISDictionaryHaveKey(dict, @"status");
            if ([status isEqualToString:@"2"] || [status isEqualToString:@"0"]) {//发送中 失败
                [dict setObject:@"0" forKey:@"status"];
                [messages replaceObjectAtIndex:[rowIndex integerValue] withObject:dict];
                
                NSIndexPath* indexpath = [NSIndexPath indexPathForRow:[rowIndex integerValue] inSection:0];
                [self.tView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else
        {
            [messages removeAllObjects];
            [messages addObjectsFromArray:[DataStoreManager qureyAllCommonMessages:self.chatWithUser]];//只能重取 要不然对应不了行号
            [self.tView reloadData];
        }
    }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
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
        //动态消息 只可能接收
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
        if ([GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"thumb")].length > 0 && ![KISDictionaryHaveKey(msgDic, @"thumb") isEqualToString:@"null"]) {
            NSString* imgStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"thumb")];
            NSURL * imgUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@/30",imgStr]];
            cell.thumbImgV.hidden = NO;
            cell.thumbImgV.imageURL = imgUrl;
            [cell.thumbImgV setFrame:CGRectMake(70, 35 + titleSize.height + (titleSize.height > 0 ? 5 : 0), 40, 40)];
            contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"msg")] withThumb:YES];
        }
        else
        {
            cell.thumbImgV.hidden = YES;
            contentSize = [self getPayloadMsgContentSize:[GameCommon getNewStringWithId:KISDictionaryHaveKey(msgDic, @"msg")] withThumb:NO];
        }
        cell.contentLabel.text = KISDictionaryHaveKey(msgDic, @"msg");
        
        UIImage *bgImage = nil;
        
        [cell.headImgV setFrame:CGRectMake(10, padding*2-15, 40, 40)];
        [cell.headImgV addTarget:self action:@selector(chatToBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        cell.headImgV.placeholderImage = [UIImage imageNamed:@"moren_people.png"];
        NSURL * theUrl = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",self.chatUserImg]];
        cell.headImgV.imageURL = theUrl;
        bgImage = [[UIImage imageNamed:@"bubble_03.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:22];
        
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
        
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        if (indexPath.row>0) {
            NSLog(@"mmmm:%d",[time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]);
            if ([time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]<60) {
                cell.senderAndTimeLabel.hidden = YES;
            }
            else
            {
                cell.senderAndTimeLabel.hidden = NO;
            }
        }
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
        
        cell.cellRow = indexPath.row;
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
        
        if (indexPath.row>0) {
            NSLog(@"mmmm:%d",[time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]);
            if ([time intValue]-[[[messages objectAtIndex:(indexPath.row-1)] objectForKey:@"time"] intValue]<60) {
                cell.senderAndTimeLabel.hidden = YES;
            }
            else
            {
                cell.senderAndTimeLabel.hidden = NO;
            }
        }
        previousTime = nowTime;
        NSString * timeStr = [self CurrentTime:[NSString stringWithFormat:@"%d",(int)nowTime] AndMessageTime:[NSString stringWithFormat:@"%d",[time intValue]]];
        if ([sender isEqualToString:@"you"]) {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", @"我", timeStr];
    //        CGRect rect = [self.view convertRect:cell.frame fromView:self.tView];
    //        NSLog(@"dsdsdsdsdsd%@",NSStringFromCGRect(rect));
        }
        else
        {
            cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", self.nickName, timeStr];
    //        CGRect rect = [self.view convertRect:cell.frame fromView:self.tView];
    //        NSLog(@"dsdsdsdsdsd%@",NSStringFromCGRect(rect));
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
//    MyProfileViewController * myP = [[MyProfileViewController alloc] init];
////    myP.hostInfo = [[HostInfo alloc] initWithHostInfo:[DataStoreManager queryMyInfo]];
//    [self.navigationController pushViewController:myP animated:YES];
    PersonDetailViewController * detailV = [[PersonDetailViewController alloc] init];
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
//        if (![self.appDel.xmppHelper sendMessage:mes]) {
//            [KGStatusBar showSuccessWithStatus:@"网络有点问题，稍后再试吧" Controller:self];
//            return;
//        }
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
-(void)displayPopLittleViewWithRectX:(float)originX RectY:(float)originY TheRect:(CGRect)rect
{
    if ([popLittleView superview]) {
        
        [popLittleView removeFromSuperview];
        
    }
    if (![clearView superview]) {
        clearView = [[UIView alloc] initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height-startX-50)];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [self.view addSubview:clearView];
    }


    popLittleView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY+startX - 44, 182, 54.5)];
    UIImageView * popBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 182, 54.5)];
    [popBG setImage:[UIImage imageNamed:@"popview2.png"]];
    [popLittleView addSubview:popBG];
    [self.view addSubview:popLittleView];
//    for (int i = 0; i<3; ++i) {
//        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setFrame:CGRectMake(10+i*50+i*10, 10, 50, 35)];
//        [btn setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
//        [btn setTitle:@"转发" forState:UIControlStateNormal];
//        [popLittleView addSubview:btn];
//    }
    btnBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 182, 45)];
    [btnBG setBackgroundColor:[UIColor clearColor]];
    [popLittleView addSubview:btnBG];
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(10, 10, 50, 25)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn1 setTitle:@"复制" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(copyMsg) forControlEvents:UIControlEventTouchUpInside];

    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(68, 10, 50, 25)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn2 setTitle:@"转发" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(transferMsg) forControlEvents:UIControlEventTouchUpInside];

    UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn3 setFrame:CGRectMake(126, 10, 50, 25)];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"selectednormal-s.png"] forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn3 setTitle:@"删除" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(deleteMsg) forControlEvents:UIControlEventTouchUpInside];
    [btnBG addSubview:btn1];
    [btnBG addSubview:btn2];
    [btnBG addSubview:btn3];
    if (originX+182>320) {
        originX = originX-(originX+182-320);
        [popLittleView setFrame:CGRectMake(originX, originY+startX - 44, 182, 54.5)];
    }
    else if (originX<0)
    {
        [popLittleView setFrame:CGRectMake(0, originY+startX - 44, 182, 54.5)];
    }
    if (originY<startX) {
        originY = originY+54.5+rect.size.height;
        [popLittleView setFrame:CGRectMake(originX, originY+startX - 44, 182, 54.5)];
        CGAffineTransform atransform;
        atransform = CGAffineTransformRotate(popLittleView.transform, M_PI);
        popLittleView.transform =  atransform;
        
        CGAffineTransform atransform2;
        atransform2 = CGAffineTransformRotate(btnBG.transform, M_PI);
        btnBG.transform =  atransform2;
    }
    
//    if (originY-54.5-rect.size.height<44) {
//
//    }


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
-(void)transferMsg
{
    [popLittleView removeFromSuperview];
    if ([clearView superview]) {
        [clearView removeFromSuperview];
    }
    selectContactPage * selectV = [[selectContactPage alloc] init];
    selectV.contactDelegate = self;
    [self presentViewController:selectV animated:YES completion:^{
        
    }];
}
-(void)getContact:(NSDictionary *)userDict
{
    tempDict = userDict;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要转发给%@吗",[userDict objectForKey:@"displayName"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==112) {//删除聊天纪录
//            [DataStoreManager deleteMsgsWithSender:self.chatWithUser Type:COMMONUSER];
//            messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
//            [self normalMsgToFinalMsg];
//            [self.tView reloadData];
        }
        else
            [self sureToTransform:tempDict];
    }
}

#pragma mark 转发
-(void)sureToTransform:(NSDictionary *)userDict
{
//    self.chatWithUser = [userDict objectForKey:@"username"];
//    self.nickName = [userDict objectForKey:@"displayName"];
//    self.chatUserImg = [userDict objectForKey:@"img"];
//    titleLabel.text=self.nickName;
//    
//    self.ifFriend = YES;
//    if (![DataStoreManager ifHaveThisFriend:self.chatWithUser]) {
//        self.ifFriend = NO;
//    }
//    messages = [DataStoreManager qureyAllCommonMessages:self.chatWithUser];
//    [self normalMsgToFinalMsg];
//    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
//    [self sendMsg:tempStr];
//    [self.tView reloadData];
}
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
{if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) 
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
    
    //本地输入框中的信息
    NSString *message = self.textView.text;
    [self sendMsg:message];
  
}
-(void)sendMsg:(NSString *)message
{
    if (message.length > 0 &&![[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
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
    else if (message.length==0)
    {
        return;
    }
    else{
        //如果发送信息为空或者为空格的时候弹框提示
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"不能发送空消息" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        
    }
}

#pragma mark KKMessageDelegate
- (void)newMesgReceived:(NSNotification*)notification
{
    NSDictionary* tempDic = notification.userInfo;
    NSRange range = [KISDictionaryHaveKey(tempDic,  @"sender") rangeOfString:@"@"];
    NSString * sender = [KISDictionaryHaveKey(tempDic,  @"sender") substringToIndex:range.location];
    NSString* msgType = KISDictionaryHaveKey(tempDic, @"msgType");
   
    if ([sender isEqualToString:self.chatWithUser]) {
        [messages addObject:tempDic];
        
        [self normalMsgToFinalMsg];
        [self.tView reloadData];
        if (messages.count>0) {
            [self.tView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        if ([msgType isEqualToString:@"normalchat"]) {
            NSString* msgId = KISDictionaryHaveKey(tempDic, @"msgId");
            [self comeBackDisplayed:sender msgId:msgId];//发送已读消息
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
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:[sender stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[DataStoreManager getMyUserID] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    //    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"fileType" stringValue:@"text"];  //如果发送图片音频改这里
    [mes addAttributeWithName:@"msgTime" stringValue:[GameCommon getCurrentTime]];

    //组合
    [mes addChild:body];
    if (![self.appDel.xmppHelper sendMessage:mes]) {
        return;
    }
    [DataStoreManager refreshMessageStatusWithId:msgId status:@"4"];
}

-(void)makeMsgVStoreMsg:(NSDictionary *)messageContent
{
    
}

- (void)closeButton:(id)sender {
    [[TempData sharedInstance] Panned:NO];
    [self.navigationController popViewControllerAnimated:YES];
   // [self.mlNavigationController mlPopViewController];
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

- (BOOL)beginRecord
{//录音
 /*   NSLog(@"begin record");
	NSError *error;
    [recordSetting setObject:
     [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	// Recording settings
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                              //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                              [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                              [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                              nil];
	
	// File URL
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"localRecord"];
    rootRecordPath = path;
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *localRecordPath = [NSString stringWithFormat:@"%@/audioRecord.caf",path];

	NSURL *url = [NSURL fileURLWithPath:localRecordPath];
	
	// Create recorder
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [recorder recordForDuration:(NSTimeInterval)60];
    [recorder prepareToRecord];
	if (!self.recorder)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	// Initialize degate, metering, etc.
	self.recorder.delegate = self;
	self.recorder.meteringEnabled = YES;
	
	if (![self.recorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
        
		return NO;
	}
	
	if (![self.recorder record])
	{
		NSLog(@"Error: Record failed");
        
		return NO;
	}*/
	return YES;
}
- (void) stopRecording
{
    NSLog(@"stop record");
	// This causes the didFinishRecording delegate method to fire
	[self.recorder stop];
}
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{

    NSLog(@"stop record delegate do");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        #ifdef NotUseSimulator
//        NSString *filePath1 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/recording.caf"];
        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/audioRecord.caf",rootRecordPath];
        
//        NSURL *url = [NSURL fileURLWithPath:localRecordPath];
//        NSString *filePath2 = [NSHomeDirectory() stringByAppendingPathComponent: @"Documents/recording.amr"];
//        NSString  *localRecordPath2 = [NSString stringWithFormat:@"%@/audioRecord.amr",rootRecordPath];
        
        NSURL *url = [NSURL fileURLWithPath:localRecordPath];
//        NSURL *url2 = [NSURL fileURLWithPath:localRecordPath2];
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        NSLog(@"LENGTH:%d",[data length]);
        NSData * data1 =EncodeWAVEToAMR(data,1,16);
        NSLog(@"LENGTH2:%d",[data1 length]);
//        [data1 writeToURL:url2 atomically:YES];
        
        [NetManager uploadAudioFileData:data1 WithURLStr:BaseUploadImageUrl AudioName:@"recording.amr" TheController:self Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *receiveStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary * dict = [receiveStr JSONValue];
            if ([dict objectForKey:@"success"]) {
                NSURL * myRecordPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@/audio_%@.caf",rootRecordPath,[dict objectForKey:@"entity"]]];
                [data writeToURL:myRecordPath atomically:YES];
            }
            else
            {
                NSLog(@"audioUploadError:%@",[dict objectForKey:@"entity"]);
            }
            NSLog(@"audioUploaded:%@",receiveStr);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"audioUploadError:%@",error);
        }];
        #endif
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *succeful=[[UIAlertView alloc]initWithTitle:nil message:@"录音压缩完成,可以上传!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [succeful show];
            
        });
    });


}
-(void)getAudioFromNet:(NSString *)audioID
{
#ifdef NotUseSimulator
    [NetManager downloadAudioFileWithURL:BaseImageUrl FileName:audioID TheController:self Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString  *localRecordPath = [NSString stringWithFormat:@"%@/audio_%@.caf",rootRecordPath,audioID];
        NSData *  wavData = DecodeAMRToWAVE(responseObject);
        [wavData writeToURL:[NSURL URLWithString:localRecordPath] atomically:YES];
        [self playAudioWithAudioID:audioID];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        
    }];
#endif
}
-(void)playAudioWithAudioID:(NSString *)audioID
{
//    NSString  *localRecordPath = [NSString stringWithFormat:@"%@/audio_%@.caf",rootRecordPath,audioID];
//    audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:localRecordPath] error:nil];
//    audioPlayer.delegate = self;
//    audioPlayer.volume=1.0;
//    [audioPlayer prepareToPlay];
//    [audioPlayer play];

}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"audio play done!");
}

-(void)viewWillDisappear:(BOOL)animated
{
    [DataStoreManager blankMsgUnreadCountForUser:self.chatWithUser];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNewMessageReceived object:nil];
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
