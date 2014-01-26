//
//  TempData.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "TempData.h"

@implementation TempData
static TempData *sharedInstance=nil;

+(TempData *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            [sharedInstance initThis];
        }
        return sharedInstance;
    }
}
-(void)initThis
{
    panned = YES;
    needConnectChatServer = NO;
    serverAddress = @"";
    serverDomain = @"";
    latitude = 0;
    longitude = 0;
    self.newFriendsReq = NO;
    loggedIn = NO;
    ifNeedChat = NO;
    needChatUserName = @"";
    opened = NO;
    self.needDisplayPushNotification = NO;
}
-(void)setOpened:(BOOL)haveOpened
{
    opened = haveOpened;
}
-(BOOL)ifOpened
{
    return opened;
}
-(void)makeLogged:(BOOL)logged
{
    loggedIn = logged;
}
-(BOOL)LoggedIn
{
    return loggedIn;
}
-(void)Panned:(BOOL)pan
{
    panned = pan;
}
-(void)needConnectChatServer:(BOOL)flag
{
    needConnectChatServer = flag;
}
-(BOOL)ifPanned
{
    return panned;
}
-(BOOL)ifNeedConnectChatServer
{
    return needConnectChatServer;
}
-(void)SetServer:(NSString *)server TheDomain:(NSString *)idomain
{
    serverAddress = server;
    serverDomain = idomain;
}
-(NSString *)getServer
{
    NSLog(@"地址：%@", serverAddress);
//    return @"192.168.0.133:5222";
    return serverAddress;
}

-(NSString *)getDomain
{
    NSLog(@"域名 %@", serverDomain);
    return [NSString stringWithFormat:@"%@",serverDomain];
}

-(void)setLat:(double)lat Lon:(double)lon
{
    latitude = lat;
    longitude = lon;
}
-(double)returnLat
{
    return latitude;
}
-(double)returnLon
{
    return longitude;
}
-(void)setNeedChatToUser:(NSString *)user
{
    ifNeedChat = YES;
    needChatUserName = user;
}
-(void)setNeedChatNO
{
    ifNeedChat = NO;
}
-(NSString *)getNeedChatUser
{
    return needChatUserName;
}
-(BOOL)needChat
{
    return ifNeedChat;
}
-(NSString*)getMyUserID
{
    if (!self.myUserID) {
        self.myUserID = [DataStoreManager getMyUserID];
    }
    return self.myUserID;
}
@end
