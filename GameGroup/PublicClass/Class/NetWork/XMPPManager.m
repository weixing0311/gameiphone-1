//
//  XMPPManager.m
//  GameGroup
//
//  Created by wangxr on 14-2-26.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "XMPPManager.h"
#import "XMPP.h"
#import "XMPPRosterMemoryStorage.h"
#import "XMPPAutoPing.h"
#import "JSON.h"

@interface XMPPManager()
typedef void (^CallBackBlock) (void);
typedef void (^CallBackBlockErr) (NSError *result);
@property (strong,nonatomic) CallBackBlock success;
@property (strong,nonatomic) CallBackBlockErr fail;
@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPAutoPing * xmppAutoPing;
@property (nonatomic,strong) NSString * password;
@end
@implementation XMPPManager
static XMPPManager * manager = nil;

+(XMPPManager *) sharedInstance
{
    @synchronized(self)
    {
        if(!manager)
        {
            manager=[[self alloc] init];
        }
        return manager;
    }
}
-(void)setupStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
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
-(void)connect:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail{
    
    NSArray* hostArray = [host componentsSeparatedByString:@":"];
    host = [hostArray objectAtIndex:0];
    [self setupStream];
    self.password=thepassword;
    self.success=Success;
    self.fail=Fail;
    
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
    }
}
-(void)disconnect
{
    [self goOffline];
    [self.xmppStream disconnect];
}
-(BOOL)sendMessage:(NSXMLElement *)message
{
    if (![self.xmppStream getStateOfXMPP]) {
        return NO;
    }
    else
    {
        [self.xmppStream sendElement:message];
        return YES;
    }
}
- (void)responseWithID:(NSString*)msgID from:(NSString*)from to:(NSString*)to
{
    //响应消息服务器
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:msgID,@"src_id",@"true",@"received",@"Delivered",@"msgStatus", nil];
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:[dic JSONRepresentation]];
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    [mes addAttributeWithName:@"id" stringValue:msgID];
    [mes addAttributeWithName:@"type" stringValue:@"normal"];
    [mes addAttributeWithName:@"to" stringValue:to];
    [mes addAttributeWithName:@"from" stringValue:from];
    [mes addAttributeWithName:@"msgtype" stringValue:@"msgStatus"];
    [self.xmppStream sendElement:mes];
}
#pragma mark- 消息回调
//此方法在stream开始连接服务器的时候调用
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"校验密码");
    NSError *error = nil;
    //验证密码
    [[self xmppStream] authenticateWithPassword:self.password error:&error];
    if(error!=nil)
    {
        self.fail(error);
    }
}
//此方法在stream连接断开的时候调用
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"断开:%@",error);
//    [self.notConnect notConnectted];
    //发生掉线事
}
//验证失败后调用
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    NSLog(@"not authenticated");
    NSError *err=[[NSError alloc] initWithDomain:@"WeShare" code:-100 userInfo:@{@"detail": @"ot-authorized"}];
    self.fail(err);
    //   [self.notConnect notConnectted];
    //发生掉线
}
//验证成功后调用
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    NSLog(@"验证成功");
    [self goOnline];
    self.success();
}
//iq消息回调
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    NSLog(@"iq 消息回调");
    return YES;
}
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSLog(@"message =====%@",message);
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *msgtype = [[message attributeForName:@"msgtype"] stringValue];
    NSString *to = [[message attributeForName:@"to"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    NSString *msgId = [[message attributeForName:@"id"] stringValue];
    NSString *msgTime = [[message attributeForName:@"msgTime"] stringValue];
    NSString *type = [[message attributeForName:@"type"] stringValue];
    NSRange range = [from rangeOfString:@"@"];
    NSString * fromName = [from substringToIndex:(range.location == NSNotFound) ? 0 : range.location];
    if ([type isEqualToString:@"normal"] && [fromName isEqualToString:@"messageack"]) {
        //消息发送成功
        return;
    }
    if(msg==nil){
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:msg forKey:@"msg"];
    [dict setObject:from forKey:@"sender"];
    //消息接收到的时间
    [dict setObject:[NSString stringWithFormat:@"%.f", [msgTime doubleValue]/1000]  forKey:@"time"];
    if ([msgtype isEqualToString:@"normalchat"])//普通聊天消息
    {
        [self responseWithID:msgId from:to to:from];
        [dict setObject:@"normalchat" forKey:@"msgType"];
        [dict setObject:msgId forKey:@"msgId"];
        
//        [self.chatDelegate newMessageReceived:dict];
    }
    if ([msgtype isEqualToString:@"sayHello"])//打招呼
    {
        
    }
    if ([msgtype isEqualToString:@"System"])//系统消息
    {
        
    }
    if([msgtype isEqualToString:@"deletePerson"])//取消关注
    {
        
    }
    if ([msgtype isEqualToString:@"character"])//角色
    {
        
    }
    if ([msgtype isEqualToString:@"pveScore"])//PVE战斗力
    {
        
    }
    if ([msgtype isEqualToString:@"title"])//好友推荐
    {
        
    }
    if ([msgtype isEqualToString:@"recommendfriend"])//好友推荐
    {
        
    }
    if([msgtype isEqualToString:@"frienddynamicmsg"])//好友动态
    {
        
    }
    if ([msgtype isEqualToString:@"mydynamicmsg"])//我的动态
    {
        
    }
    if ([msgtype isEqualToString:@"msgStatus"])//发送的反馈消息
    {
        
    }
}
@end
