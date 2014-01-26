//
//  KKChatController.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-12.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "XMPPFramework.h"
#import "HPGrowingTextView.h"
#import "TempData.h"
#import "StoreMsgDelegate.h"
#import "PersonDetailViewController.h"
#import "MyProfileViewController.h"
#import "selectContactPage.h"
#import "OHASBasicHTMLParser.h"
#import "EmojiView.h"

@class AppDelegate, XMPPHelper;

@interface KKChatController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,StoreMsgDelegate,getContact,UIAlertViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate,AVAudioRecorderDelegate,AVAudioSessionDelegate,AVAudioPlayerDelegate,HPGrowingTextViewDelegate,EmojiViewDelegate>
{
    UILabel    *titleLabel;
    NSString * userName;
   // NSMutableDictionary * userDefaults;
    NSUserDefaults * uDefault;
    NSMutableDictionary * peopleDict;
    UIView * inPutView;
    UILongPressGestureRecognizer *btnLongTap;
    UIButton * tempBtn;
    UIView * popLittleView;
    UIView * btnBG;
    int readyIndex;
    NSIndexPath * indexPathTo;
    NSString * tempStr;
    UIView * clearView;
    BOOL canAdd;
    NSString * currentID;
    UIImageView * inputbg;
    UIButton * senBtn;
    int previousTime;
    int touchTimePre;
    int touchTimeFinal;
    NSMutableDictionary * userInfoDict;
    NSMutableDictionary * postDict;
    NSString * myHeadImg;
    NSDictionary * tempDict;
    
    BOOL ifAudio;
    BOOL ifEmoji;
    
    UIButton * audioBtn;
    UIButton * emojiBtn;
    UIButton * picBtn;
    UIButton * audioRecordBtn;
    
    NSTimeInterval beginTime;
    UIButton * audioplayButton;
    UIImageView *recordAnimationIV;
    
    UIScrollView *m_EmojiScrollView;
    UIPageControl *m_Emojipc;
    UIView * emojiBGV;
    
    EmojiView * theEmojiView;
    
    NSMutableDictionary *recordSetting;
    AVAudioPlayer * audioPlayer;
    NSString * rootRecordPath;
    NSMutableArray * animationOne;
    NSMutableArray * animationTwo;
        
    UIMenuController * menu;
}
@property (strong, nonatomic)  NSString* myHeadImg;
@property (strong, nonatomic)  UITableView *tView;
@property (strong, nonatomic)  NSMutableArray *finalMessageArray;
@property (strong, nonatomic)  NSMutableArray *HeightArray;
@property (strong, nonatomic)  UITextField *messageTextField;
//@property (strong, nonatomic)  UIButton * sendBtn;
@property(nonatomic, retain) NSString *chatWithUser;
@property(nonatomic, assign) BOOL ifFriend;
@property(nonatomic, retain) NSString *nickName;
@property(nonatomic, retain) NSString *friendStatus;
@property(nonatomic, retain) NSString *chatUserImg;
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) HPGrowingTextView *textView;
@property (assign,nonatomic) id<StoreMsgDelegate> msgDelegate;
@property (nonatomic,retain) AVAudioSession *session;
@property (nonatomic,retain) AVAudioRecorder *recorder;
- (void)sendButton:(id)sender;
- (void)closeButton:(id)sender;

@end
