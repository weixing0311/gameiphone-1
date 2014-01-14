//
//  GetDataAfterManager.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-17.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "GetDataAfterManager.h"

@implementation GetDataAfterManager

- (void)viewDidLoad
{
    [self addNotification];

}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageReceived:) name:kNewMessageReceived object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFriendHelloReceived:) name:kFriendHelloReceived object:Nil];
}


-(void)storeNewMessage:(NSDictionary *)messageContent
{
    NSString * type = [messageContent objectForKey:@"msgType"];
    type = type?type:@"notype";
    if ([type isEqualToString:@"reply"]||[type isEqualToString:@"zanDynamic"]) {
        //        [DataStoreManager storeNewMsgs:messageContent senderType:SYSTEMNOTIFICATION];//系统消息
    }
    else if([type isEqualToString:@"normalchat"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:COMMONUSER];//普通聊天消息
    }
    else if ([type isEqualToString:@"sayHello"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:COMMONUSER];//打招呼消息 和 普通聊天一样
    }
}

#pragma mark 收到好友消息
- (void)newMessageReceived:(NSNotification*)notification
{
    NSLog(@"newMessageReceived~~~~~");
//    NSDictionary* dataDic = notification.userInfo;
//    [self storeNewMessage:dataDic];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageReceived object:nil userInfo:dataDic];
}

#pragma mark 收到好友验证消息
- (void)newFriendHelloReceived:(NSNotification*)notification
{
    NSLog(@"newFriendHelloReceived~~~~~");
}

@end
