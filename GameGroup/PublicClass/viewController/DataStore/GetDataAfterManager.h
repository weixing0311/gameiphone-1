//
//  GetDataAfterManager.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-17.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

#define kNewMessageReceived @"newMessageReceived"
#define kFriendHelloReceived @"friendHelloReceived"

#define kDeleteAttention @"deleteAttentionReceived"
#define kOtherMessage    @"otherMessage"
#define kRecommendFriendReceived @"recommendFriendReceived"

#define kMessageAck @"messageAck"

@interface GetDataAfterManager : NSObject

@property(nonatomic,strong)AppDelegate* appDel;

+ (GetDataAfterManager*)shareManageCommon;

@end
