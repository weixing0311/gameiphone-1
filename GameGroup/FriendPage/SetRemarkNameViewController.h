//
//  SetRemarkNameViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-18.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@interface SetRemarkNameViewController : BaseViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic)NSString* userId;
@property (strong, nonatomic)NSString* userName;
@property (strong, nonatomic)NSString* nickName;
@property (assign, nonatomic)BOOL      isFriend;//好友或关注的人

@end
