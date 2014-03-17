 //
//  XMPPHelper.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "XMPPHelper.h"
#import "XMPP.h"
#import "ChatDelegate.h"
#import "AddReqDelegate.h"
#import "CommentDelegate.h"
#import "NotConnectDelegate.h"
#import "DeletePersonDelegate.h"
#import "OtherMessageReceive.h"
#import "RecommendFriendDelegate.h"
#import "XMPPAutoPing.h"
#import "XMPPRoster.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPvCardTemp.h"
#import "XMPPvCardTempModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPJID.h"
#import "TempData.h"
#import "XMPPReconnect.h"
#import "JSON.h"
@implementation XMPPHelper
//@synthesize xmppStream,xmppvCardStorage,xmppvCardTempModule,xmppvCardAvatarModule,xmppvCardTemp,account,password,buddyListDelegate,chatDelegate,xmpprosterDelegate,processFriendDelegate,xmpptype,success,fail,regsuccess,regfail,xmppRosterscallback,myVcardTemp,xmppRosterMemoryStorage,xmppRoster;

-(void)setupStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    self.xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    self.xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:self.xmppRosterMemoryStorage];
    [self.xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppRoster activate:self.xmppStream];
    self.xmppStream.enableBackgroundingOnSocket = YES;
//    self.xmppReconnect = [[XMPPReconnect alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    [self.xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    [self.xmppReconnect activate:self.xmppStream];
//    self.xmppAutoPing = [[XMPPAutoPing alloc] initWithDispatchQueue:dispatch_get_main_queue()];
//    self.xmppAutoPing.pingInterval = 10;
//    [_xmppAutoPing activate:self.xmppStream];
}
- (void)goOnline {
	XMPPPresence *presence = [XMPPPresence presence];
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline {
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}
-(BOOL)connect:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail{

    NSArray* hostArray = [host componentsSeparatedByString:@":"];
    host = [hostArray objectAtIndex:0];
//    host = @"192.168.0.133";
    
//    host = @"221.122.114.219";
//    theaccount = @"15100000000@52pet.net";
//    thepassword = @"0AB89AC5C55D40198EF10B39257DA1C4";
    [self setupStream];
    self.password=thepassword;
    self.success=Success;
    
    self.fail=Fail;
    if (![self.xmppStream isDisconnected]) {
        return YES;
    }
    
    if (theaccount == nil) {
        return NO;
    }
    
    [self.xmppStream setMyJID:[XMPPJID jidWithString:theaccount]];
    [self.xmppStream setHostName:host];
    
    if ([hostArray count] > 1) {
        UInt16 b = (UInt16)([[hostArray objectAtIndex:1] integerValue] & 0xffff);
        [self.xmppStream setHostPort:b];//端口号
    }

    NSLog(@"connecting 帐号%@ 密码%@ 地址%@",theaccount, thepassword, host);

    //连接服务器
    NSError *err = nil;
    if (![self.xmppStream connectWithTimeout:30 error:&err]) {
        NSLog(@"cant connect 帐号%@ 密码%@ 地址%@",theaccount, thepassword, host);
        Fail(err);
        return NO;
    }
    
    return YES;
}

-(void) reg:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)thesuccess fail:(CallBackBlockErr)thefail{
    self.xmpptype=reg;
    self.account=[theaccount stringByAppendingString:[[TempData sharedInstance] getDomain]];
    self.password=thepassword;
    self.regsuccess=thesuccess;
    self.regfail=thefail;
    [self connect:self.account password:thepassword host:host success:thesuccess fail:thefail];
}

-(void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}
-(BOOL)ifXMPPConnected
{
    return [self.xmppStream getStateOfXMPP];
}
-(BOOL)isDisconnected
{
    return [self.xmppStream isDisconnected];
}
-(BOOL)isConnecting
{
    return [self.xmppStream isConnecting];
}
-(BOOL)isConnected
{
    return [self.xmppStream isConnected];
}
//获取所有联系人
-(void)getCompleteRoster:(XMPPRosterMemoryStorageCallBack)callback{
    self.xmppRosterscallback=callback;
    [self.xmppRoster fetchRoster];
}
-(void)getIt
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
//    [iq addAttributeWithName:@"id" stringValue:[self generateID]];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}

- (void)updateVCard:(XMPPvCardTemp *)vcard success:(CallBackBlock)thesuccess fail:(CallBackBlockErr)thefail{
    self.success=thesuccess;
    self.fail=thefail;
    [self.xmppvCardTempModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.xmppvCardTempModule updateMyvCardTemp:vcard];
    
}

-(XMPPvCardTemp *)getmyvcard{
    self.xmppvCardTemp =[self.xmppvCardTempModule myvCardTemp];
    return self.xmppvCardTemp;
}

-(XMPPvCardTemp *)getvcard:(NSString *)Account{
    [self.xmppvCardTempModule fetchvCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:[[TempData sharedInstance] getDomain]]]];
    return [self.xmppvCardTempModule vCardTempForJID:[XMPPJID jidWithString:[Account stringByAppendingString:[[TempData sharedInstance] getDomain]]] shouldFetch:YES];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid
{
    NSLog(@"%@",vCardTemp);
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule{
    NSLog(@"%@",vCardTempModule);
    self.success();
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error{
    NSLog(@"%@",error);
    NSError *err=[[NSError alloc] initWithDomain:[[TempData sharedInstance] getDomain] code:-1000 userInfo:nil];
    self.fail(err);
}

//添加好友
-(BOOL)addFriend:(NSString *)user{
    if (![self ifXMPPConnected]) {
        return NO;
    }
    else
    {
        NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
        [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]] withNickname:nickName];
        return YES;
    }
    
}
-(void)addFriend:(NSString *)user WithMsg:(NSString *)msg HeadID:(NSString *)headID{
    NSString * nickName = [SFHFKeychainUtils getPasswordForUsername:USERNICKNAME andServiceName:LOCALACCOUNT error:nil];
    [self.xmppRoster addUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]] withNickname:nickName Msg:msg HeadID:headID];
}
#pragma mark- 删除好友
-(void)delFriend:(NSString *)user{
    [self.xmppRoster removeUser:[XMPPJID jidWithString:[user stringByAppendingString:[[TempData sharedInstance] getDomain]]]];
}

#pragma mark- 处理加好友
-(void)addOrDenyFriend:(Boolean)issubscribe user:(NSString *)user{
    XMPPJID *jid=[XMPPJID jidWithString:[NSString stringWithFormat:@"%@%@",user,[[TempData sharedInstance] getDomain]]];
    if(issubscribe){
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }else{
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:jid];
    }
}
//===========XMPP委托事件============

//此方法在stream开始连接服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"connected");
    NSError *error = nil;
    
    if(self.xmpptype==reg){
        [[self xmppStream] setMyJID:[XMPPJID jidWithString:self.account]];
        NSError *error=nil;
        if (![[self xmppStream] registerWithPassword:self.password error:&error])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        
    }else{
        //验证密码
        [[self xmppStream] authenticateWithPassword:self.password error:&error];
        if(error!=nil)
        {
            self.fail(error);
        }
    }
}

//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"disconnected。。。：%@",error);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_disconnect" object:nil userInfo:nil];
}

// 2.关于验证的
//验证失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"not authenticated %@",error);
    NSError *err=[[NSError alloc] initWithDomain:@"WeShare" code:-100 userInfo:@{@"detail": @"ot-authorized"}];
    self.fail(err);
 //   [self.notConnect notConnectted];
}


//验证成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    self.xmppvCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    self.xmppvCardTempModule=[[XMPPvCardTempModule alloc]initWithvCardStorage:self.xmppvCardStorage];
    self.xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:self.xmppvCardTempModule];
    [self.xmppvCardTempModule   activate:self.xmppStream];
    [self.xmppvCardAvatarModule activate:self.xmppStream];
    [self getmyvcard];
    NSLog(@"authenticated");
    [self goOnline];
    self.success();
}

-(BOOL)sendMessage:(NSXMLElement *)message
{
    if (![self ifXMPPConnected]) {
        return NO;
    }
    else
    {
        [self.xmppStream sendElement:message];
        return YES;
    }
}

- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	
//	roster = [sender sortedUsersByAvailabilityName];
}
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    if (!self.rosters) {
        self.rosters = [NSMutableArray array];
    }
    [self.rosters removeAllObjects];
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
            NSArray *items = [query children];
            for (NSXMLElement *item in items) {
                NSString *jid = [item attributeStringValueForName:@"jid"];
                NSRange range = [jid rangeOfString:@"@"];
                if (range.length == 0) {
                    return NO;
                }
                NSString * sender = [jid substringToIndex:range.location];
               // XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                if ([[item attributeStringValueForName:@"subscription"] isEqualToString:@"both"]||[[item attributeStringValueForName:@"subscription"] isEqualToString:@"to"]) {
                    [self.rosters addObject:sender];
                }
            }
        }
        
    }
    return YES;
}
// 3.关于通信的
- (void)comeBackDelivered:(NSString*)sender msgId:(NSString*)msgId//发送送达消息
{
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:msgId,@"src_id",@"true",@"received",@"Delivered",@"msgStatus", nil];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[dic JSONRepresentation]];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"id" stringValue:msgId];
    [mes addAttributeWithName:@"msgtype" stringValue:@"msgStatus"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"normal"];
    
    //发送给谁
    [mes addAttributeWithName:@"to" stringValue:sender];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[DataStoreManager getMyUserID] stringByAppendingString:[[TempData sharedInstance] getDomain]]];
    
    //    [mes addAttributeWithName:@"msgtype" stringValue:@"normalchat"];
    [mes addAttributeWithName:@"msgTime" stringValue:[GameCommon getCurrentTime]];
    //    NSString* uuid = [[GameCommon shareGameCommon] uuid];
    //    [mes addAttributeWithName:@"id" stringValue:uuid];
    //    NSLog(@"消息uuid ~!~~ %@", uuid);
    //组合
    [mes addChild:body];
    if (![self sendMessage:mes]) {
        return;
    }
}
#pragma mark 收到消息后调用
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSLog(@"message =====%@",message);

    if(msg==nil){
        return;
    }
    NSString *msgtype = [[message attributeForName:@"msgtype"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *msgId = [[message attributeForName:@"id"] stringValue];
    NSRange range = [from rangeOfString:@"@"];
    NSString * fromName = [from substringToIndex:(range.location == NSNotFound) ? 0 : range.location];
    
    NSString *type = [[message attributeForName:@"type"] stringValue];
    
    NSString *msgTime = [[message attributeForName:@"msgTime"] stringValue]?[[message attributeForName:@"msgTime"] stringValue]:@"0";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    [dict setObject:msgId forKey:@"msgId"];
    
    //消息接收到的时间
    [dict setObject: msgTime forKey:@"time"];
    
    NSLog(@"theDict%@",dict);
    if ([type isEqualToString:@"chat"])
    {
        if ([msgtype isEqualToString:@"normalchat"]) {//聊天的 或动态聊天消息
            NSString* payload = [GameCommon getNewStringWithId:[[message elementForName:@"payload"] stringValue]];//是否含payload标签
            if (payload.length > 0&&[payload JSONValue][@"title"]) {
                [dict setObject:payload forKey:@"payload"];
                
                [dict setObject:@"payloadchat" forKey:@"msgType"];
            }else if (payload.length > 0&&[payload JSONValue][@"active"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"wxr_myActiveBeChanged" object:nil userInfo:[payload JSONValue]];
                [dict setObject:@"normalchat" forKey:@"msgType"];
            }else{
                [dict setObject:@"normalchat" forKey:@"msgType"];
            }
            [dict setObject:msgId?msgId:@"" forKey:@"msgId"];
            
            [self.chatDelegate newMessageReceived:dict];
        }
        else if ([msgtype isEqualToString:@"sayHello"]){//打招呼的
            [dict setObject:@"sayHello" forKey:@"msgType"];
            
            NSString * shiptype = [GameCommon getNewStringWithId:[[message elementForName:@"payload"] stringValue]];
            if (shiptype.length > 0) {
                [dict setObject:KISDictionaryHaveKey([shiptype JSONValue], @"shiptype") forKey:@"shiptype"];
            }
            else
                [dict setObject:@""  forKey:@"shiptype"];
             [self.deletePersonDelegate newAddReq:dict];
            [self comeBackDelivered:from msgId:msgId];
        }
        else if([msgtype isEqualToString:@"deletePerson"])//取消关注
        {
            [dict setObject:@"deletePerson" forKey:@"msgType"];
            
            NSString * shiptype = [GameCommon getNewStringWithId:[[message elementForName:@"payload"] stringValue]];
            if (shiptype.length > 0) {
                [dict setObject:KISDictionaryHaveKey([shiptype JSONValue], @"shiptype") forKey:@"shiptype"];
            }
            else
                [dict setObject:@""  forKey:@"shiptype"];

            
            [self.deletePersonDelegate deletePersonReceived:dict];
            [self comeBackDelivered:from msgId:msgId];
        }
        else if ([msgtype isEqualToString:@"character"] || [msgtype isEqualToString:@"pveScore"] || [msgtype isEqualToString:@"title"])//角色信息改变
        {
            [dict setObject:msgtype forKey:@"msgType"];
            NSString *title = [[message elementForName:@"payload"] stringValue];
            title = KISDictionaryHaveKey([title JSONValue],@"title");
            [dict setObject:title?title:@"" forKey:@"title"];
            [self.otherMsgReceiveDelegate otherMessageReceived:dict];
            [self comeBackDelivered:from msgId:msgId];
        }
        else if ([msgtype isEqualToString:@"recommendfriend"])//好友推荐
        {
            [dict setObject:msgtype forKey:@"msgType"];
            
            NSArray* arr = [msg JSONValue];
            NSString* dis = @"";
            if ([arr isKindOfClass:[NSArray class]]) {
                if ([arr count] != 0) {
                    NSMutableDictionary* dic = [arr objectAtIndex:0];
                    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"1"]) {
                        dis = [NSString stringWithFormat:@"获得通讯录好友%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"2"]) {
                        dis = [NSString stringWithFormat:@"获得明星好友%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"3"]) {
                        dis = [NSString stringWithFormat:@"获得公会好友%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"4"])
                    {
                        dis = [NSString stringWithFormat:@"同服务器激活女性%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"5"])
                    {
                        dis = [NSString stringWithFormat:@"服务器达人%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                    else if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"type")] isEqualToString:@"6"])
                    {
                        dis = [NSString stringWithFormat:@"激活女性%@", KISDictionaryHaveKey(dic, @"nickname")];
                    }
                }
            }
            [dict setObject:dis forKey:@"disStr"];
            [self.recommendReceiveDelegate recommendFriendReceived:dict];
            [self comeBackDelivered:from msgId:msgId];
        }
        else if([msgtype isEqualToString:@"frienddynamicmsg"] || [msgtype isEqualToString:@"mydynamicmsg"])//动态
        {
            if ([msgtype isEqualToString:@"frienddynamicmsg"]) {
                NSString* payload = [GameCommon getNewStringWithId:[[message elementForName:@"payload"] stringValue]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"frienddunamicmsgChange_WX" object:nil userInfo:[payload JSONValue]];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:haveMyNews];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[GameCommon shareGameCommon] displayTabbarNotification];
            }
            [self comeBackDelivered:from msgId:msgId];
        }
        else if([msgtype isEqualToString:@"dailynews"])//新闻
        {
            [dict setObject:msgtype forKey:@"msgType"];
            NSString *title = [[message elementForName:@"payload"] stringValue];
            [dict setObject:title?title:@"" forKey:@"title"];
            [self.chatDelegate dailynewsReceived:dict];
            [self comeBackDelivered:from msgId:msgId];
        }
    }
    if ([type isEqualToString:@"normal"]&& [msgtype isEqualToString:@"msgStatus"])
    {
        NSDictionary* bodyDic = [msg JSONValue];
        if ([bodyDic isKindOfClass:[NSDictionary class]]) {
            NSString* src_id = KISDictionaryHaveKey(bodyDic, @"src_id");
            if (src_id.length <= 0) {
                return;
            }
            if ([KISDictionaryHaveKey(bodyDic, @"msgStatus") isEqualToString:@"Delivered"]) {//是否送达
                [DataStoreManager refreshMessageStatusWithId:src_id status:[KISDictionaryHaveKey(bodyDic, @"received") boolValue] ? @"3" : @"0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMessageAck object:nil userInfo:bodyDic];
            }
            else if ([KISDictionaryHaveKey(bodyDic, @"msgStatus") isEqualToString:@"Displayed"]) {//是否已读
                [DataStoreManager refreshMessageStatusWithId:src_id status:[KISDictionaryHaveKey(bodyDic, @"received") boolValue] ? @"4" : @"0"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kMessageAck object:nil userInfo:bodyDic];
            }
        }
    }
    if ([type isEqualToString:@"normal"] && [fromName isEqualToString:@"messageack"])//消息发送服务器状态告知
    {
        msg = [msg stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        NSDictionary* msgData = [msg JSONValue];
        NSString* src_id = KISDictionaryHaveKey(msgData, @"src_id");
        if (src_id.length <= 0) {
            return;
        }
        [DataStoreManager refreshMessageStatusWithId:src_id status:[KISDictionaryHaveKey(msgData, @"received") boolValue] ? @"1" : @"0"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kMessageAck object:nil userInfo:msgData];
    }
    
}

//注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    self.regsuccess();
}

//注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    NSError *err=[[NSError alloc] initWithDomain:@"WeShare" code:-100 userInfo:@{@"detail": @"reg fail"}];
    self.regfail(err);
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
//    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    NSString *fromnickName = [presence fromName];
//    NSString *additionMsg = [presence additionMsg];
//    NSString *headID = [presence headID];
//    NSLog(@"presenceType:%@,fromNickName:%@,additionMsg:%@",presenceType,fromnickName,additionMsg);
//    NSDictionary * uDict = [NSDictionary dictionaryWithObjectsAndKeys:presenceFromUser,@"fromUser",fromnickName,@"fromNickname",additionMsg,@"addtionMsg",headID,@"headID", nil];
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    if ([presenceType isEqualToString:@"subscribe"]) {
//        [self.addReqDelegate newAddReq:uDict];
    }
    
   // [self.addReq newAddReq:@""];
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
}

//接受到好友状态更新
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    
    NSLog(@"presenceType:%@",presenceType);
 //   NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
//    [self.addReqDelegate newAddReq:presenceFromUser];
    
    
    // [self.addReq newAddReq:@""];
//    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
    if ([presenceType isEqualToString:@"subscribed"]) {
        [self.processFriendDelegate processFriend:presence];
  //      [self.addReqDelegate newAddReq:presenceFromUser];
        // [self.addReq newAddReq:@""];
//        XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
//        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    }
//    else if([presenceType isEqualToString:@"error"]){
//        NSLog(@"错误");
//    }
//    else{
//        //当前用户
//        NSString *userId = [[sender myJID] user];
//        //在线用户
//        NSString *presenceFromUser = [[presence from] user];
//        if (![presenceFromUser isEqualToString:userId]) {
//            //在线状态
//            if ([presenceType isEqualToString:@"available"]) {
//                //用户列表委托(后面讲)
//                [self.buddyListDelegate newBuddyOnline:[NSString stringWithFormat:@"%@", presenceFromUser]];
//                
//            }else if ([presenceType isEqualToString:@"unavailable"]) {
//                //用户列表委托(后面讲)
//                //[self.buddyListDelegate buddyWentOffline:[NSString stringWithFormat:@"%@", presenceFromUser]];
//                [self.buddyListDelegate newBuddyOnline:[[NSString stringWithFormat:@"%@", presenceFromUser]stringByAppendingString:@"[不在线]"]];
//            }
//        }
//    }
}

//fetchRoster后，将结果回调方式传来。
- (void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender{
    if(self.xmppRosterscallback){
        self.xmppRosterscallback(sender);
    }
    NSLog(@"%@",sender);
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
    NSLog(@"didReceiveError:%@",error);
    DDXMLNode *errorNode = (DDXMLNode *)error;
    //遍历错误节点
    for(DDXMLNode *node in [errorNode children])
    {
        //若错误节点有【冲突】
        if([[node name] isEqualToString:@"conflict"])
        {
            //停止轮训检查链接状态
            //[_timer invalidate];
            //弹出登陆冲突,点击OK后logout
            NSString *message = [NSString stringWithFormat:@"在其他地方登陆"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 9999;
            [alert show];
        }
    }
}

@end
