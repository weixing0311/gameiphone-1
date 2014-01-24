//
//  GetDataAfterManager.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-17.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "GetDataAfterManager.h"

@implementation GetDataAfterManager

static GetDataAfterManager *my_getDataAfterManager = NULL;

- (id)init
{
    self = [super init];
    if (self) {
        self.appDel = [[UIApplication sharedApplication] delegate];
//        self.appDel.xmppHelper.buddyListDelegate = self;
        self.appDel.xmppHelper.chatDelegate = self;
//        self.appDel.xmppHelper.processFriendDelegate = self;
        self.appDel.xmppHelper.addReqDelegate = self;
        self.appDel.xmppHelper.commentDelegate = self;
        self.appDel.xmppHelper.deletePersonDelegate = self;
        self.appDel.xmppHelper.otherMsgReceiveDelegate = self;
        self.appDel.xmppHelper.recommendReceiveDelegate = self;
    }
    return self;
}

+ (GetDataAfterManager*)shareManageCommon
{
    @synchronized(self)
    {
		if (my_getDataAfterManager == nil)
		{
			my_getDataAfterManager = [[self alloc] init];
		}
	}
	return my_getDataAfterManager;
}

-(void)storeNewMessage:(NSDictionary *)messageContent
{
    NSString * type = KISDictionaryHaveKey(messageContent, @"msgType");
    type = type?type:@"notype";
    if([type isEqualToString:@"normalchat"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:COMMONUSER];//普通聊天消息
    }
    else if([type isEqualToString:@"payloadchat"])
    {
        AudioServicesPlayAlertSound(1007);
        [DataStoreManager storeNewMsgs:messageContent senderType:PAYLOADMSG];//动态消息
    }
    else if ([type isEqualToString:@"sayHello"] || [type isEqualToString:@"deletePerson"])//关注和取消关注
    {
        AudioServicesPlayAlertSound(1007);
        
        [DataStoreManager storeNewMsgs:messageContent senderType:SAYHELLOS];//打招呼消息
    }
    else if([type isEqualToString:@"recommendfriend"])
    {
        [DataStoreManager storeNewMsgs:messageContent senderType:RECOMMENDFRIEND];
    }
}

#pragma mark 收到聊天消息或其他消息
-(void)newMessageReceived:(NSDictionary *)messageContent
{
    NSRange range = [[messageContent objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[messageContent objectForKey:@"sender"] substringToIndex:range.location];
    if (![DataStoreManager ifHaveThisUser:sender]) {//是否为好友 不是就请求资料
        [self requestPeopleInfoWithName:sender ForType:1 Msg:nil];
    }
    [self storeNewMessage:messageContent];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessageReceived object:nil userInfo:messageContent];
}

#pragma mark 收到验证好友请求
-(void)newAddReq:(NSDictionary *)userInfo
{
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
    NSString * shiptype = KISDictionaryHaveKey(userInfo, @"shiptype");
    NSString * msg = KISDictionaryHaveKey(userInfo, @"msg");
    
    [self storeNewMessage:userInfo];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([shiptype isEqualToString:@"1"]) {
        if ([DataStoreManager ifIsAttentionWithUserName:fromUser]) {
            [tempDic addEntriesFromDictionary:[DataStoreManager addPersonToReceivedHellosWithAttention:fromUser]];
            [tempDic setObject:fromUser forKey:@"fromUser"];
            [tempDic setObject:msg forKey:@"addtionMsg"];
            [DataStoreManager addPersonToReceivedHellos:tempDic];
            
            [DataStoreManager saveUserFriendWithAttentionList:fromUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];

            [DataStoreManager deleteAttentionWithUserName:fromUser];//从关注表删除
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
        }
        else
        {
            [self requestPeopleInfoWithName:fromUser ForType:0 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
        }
    }
    else if([shiptype isEqualToString:@"3"])//粉丝
    {
        [self requestPeopleInfoWithName:fromUser ForType:0 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
    }
    else
    {
        [self requestPeopleInfoWithName:fromUser ForType:0 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kFriendHelloReceived object:nil userInfo:userInfo];
}

#pragma mark 收到取消关注 删除好友请求
-(void)deletePersonReceived:(NSDictionary *)userInfo
{
    NSString * fromUser = [userInfo objectForKey:@"sender"];
    NSRange range = [fromUser rangeOfString:@"@"];
    fromUser = [fromUser substringToIndex:range.location];
    NSString * shiptype = KISDictionaryHaveKey(userInfo, @"shiptype");
    NSString * msg = KISDictionaryHaveKey(userInfo, @"msg");
    
    [DataStoreManager deleteThumbMsgWithSender:fromUser];
    
    [self storeNewMessage:userInfo];
    NSMutableDictionary* tempDic = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([shiptype isEqualToString:@"2"]) {//移到关注表
        if ([DataStoreManager ifHaveThisFriend:fromUser])
        {
            [tempDic addEntriesFromDictionary:[DataStoreManager addPersonToReceivedHellosWithFriend:fromUser]];
            [tempDic setObject:fromUser forKey:@"fromUser"];
            [tempDic setObject:msg forKey:@"addtionMsg"];
            [DataStoreManager addPersonToReceivedHellos:tempDic];
            
            [DataStoreManager saveUserAttentionWithFriendList:fromUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

            [DataStoreManager deleteFriendWithUserName:fromUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];

//            [self displayMsgsForDefaultView];
        }
        else
        {
            [self requestPeopleInfoWithName:fromUser ForType:2 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
        }
    }
    else if ([shiptype isEqualToString:@"unkown"])
    {
        if ([DataStoreManager ifIsFansWithUserName:fromUser])
        {
            [tempDic addEntriesFromDictionary:[DataStoreManager addPersonToReceivedHellosWithFans:fromUser]];
            [tempDic setObject:fromUser forKey:@"fromUser"];
            [tempDic setObject:msg forKey:@"addtionMsg"];
            [DataStoreManager addPersonToReceivedHellos:tempDic];
            
            [[GameCommon shareGameCommon] fansCountChanged:NO];
            [DataStoreManager deleteFansWithUserName:fromUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
//            [self displayMsgsForDefaultView];
        }
        else
        {
            [self requestPeopleInfoWithName:fromUser ForType:2 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
        }
    }
    else
    {
        [self requestPeopleInfoWithName:fromUser ForType:2 Msg:KISDictionaryHaveKey(userInfo, @"msg")];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAttention object:nil userInfo:userInfo];
}

#pragma mark - 其他消息 头衔、角色等
-(void)otherMessageReceived:(NSDictionary *)info
{
    AudioServicesPlayAlertSound(1007);
    
    [DataStoreManager storeNewMsgs:info senderType:OTHERMESSAGE];//其他消息
    [DataStoreManager saveOtherMsgsWithData:info];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOtherMessage object:nil userInfo:info];
}

#pragma mark 收到推荐好友
-(void)recommendFriendReceived:(NSDictionary *)info
{
    [DataStoreManager storeNewMsgs:info senderType:RECOMMENDFRIEND];//其他消息
    NSArray* recommendArr = [KISDictionaryHaveKey(info, @"msg") JSONValue];
    
    for (NSDictionary* tempDic in recommendArr) {
        [DataStoreManager saveRecommendWithData:tempDic];
    }
//    [self displayMsgsForDefaultView];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRecommendFriendReceived object:nil userInfo:info];
}

-(void)requestPeopleInfoWithName:(NSString *)userName ForType:(int)type Msg:(NSString *)msg
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"username"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"106" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStrNoController:BaseClientUrl Parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary * recDict = KISDictionaryHaveKey(responseObject, @"user");
        if ([KISDictionaryHaveKey(responseObject, @"title") isKindOfClass:[NSArray class]] && [KISDictionaryHaveKey(responseObject, @"title") count] != 0) {//头衔
            [recDict setObject:[KISDictionaryHaveKey(responseObject, @"title") objectAtIndex:0] forKey:@"title"];
        }
        if (type==0) {//打招呼的 存到粉丝列表里
            if ([DataStoreManager ifIsAttentionWithUserName:userName]) {
                [DataStoreManager deleteAttentionWithUserName:userName];//从关注表删除
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

                [DataStoreManager saveUserInfo:recDict];//存为好友
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
            }
            else
            {
                [[GameCommon shareGameCommon] fansCountChanged:YES];
                [DataStoreManager saveUserFansInfo:recDict];
            }
            
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
        }
        else if (type==1){//聊天消息
            if ([DataStoreManager ifIsAttentionWithUserName:userName]) {
                [DataStoreManager deleteAttentionWithUserName:userName];//从关注表删除
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

                [DataStoreManager saveUserInfo:recDict];//存为好友
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];
            }
            else
            {
                [DataStoreManager saveUserFansInfo:recDict];//存为粉丝
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
            }
            //            [self displayMsgsForDefaultView];
        }
        else if (type == 2)//取消关注 删除
        {
            if ([DataStoreManager ifHaveThisFriend:userName]) {//移到关注表
                [DataStoreManager deleteFriendWithUserName:userName];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"0"];

                [DataStoreManager saveUserAttentionInfo:recDict];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"1"];

            }
            if ([DataStoreManager ifIsFansWithUserName:userName]) {//从粉丝表移出
                [[GameCommon shareGameCommon] fansCountChanged:NO];
                [DataStoreManager deleteFansWithUserName:userName];
                [[NSNotificationCenter defaultCenter] postNotificationName:kReloadContentKey object:@"2"];
            }
            NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:[recDict objectForKey:@"username"],@"fromUser",[recDict objectForKey:@"nickname"],@"fromNickname",msg,@"addtionMsg",[recDict objectForKey:@"img"],@"headID", nil];
            [DataStoreManager addPersonToReceivedHellos:uDict];
            
            //            [self displayMsgsForDefaultView];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
