//
//  TempData.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempData : NSObject
{
    BOOL panned;//是否是手势返回？
    BOOL needConnectChatServer;
    NSString * serverAddress;
    NSString * serverDomain;

    double latitude;
    double longitude;
    
    BOOL loggedIn;
    BOOL ifNeedChat;
    
    BOOL opened;
    
    NSString * needChatUserName;
    
}
@property (retain,nonatomic)NSString* myUserID;
@property (assign,nonatomic)BOOL newFriendsReq;
@property (nonatomic,assign)BOOL needDisplayPushNotification;//是否展示推送的消息
@property (nonatomic,assign)BOOL registerNeedMsg;//是否需要验证码
@property (nonatomic,assign)BOOL passBindingRole;//注册时是否跳过绑定角色
@property (nonatomic,assign)BOOL wxAlreadydidClickniehe;//捏合返回首页手势提示
@property (nonatomic,retain)NSString * characterID;
+ (id)sharedInstance;
-(void)setOpened:(BOOL)haveOpened;
-(BOOL)ifOpened;
-(void)Panned:(BOOL)pan;
-(BOOL)ifPanned;
-(void)needConnectChatServer:(BOOL)flag;
-(BOOL)ifNeedConnectChatServer;
-(NSString *)getServer;
-(NSString *)getDomain;
-(void)SetServer:(NSString *)server TheDomain:(NSString *)domain;
-(void)setLat:(double)lat Lon:(double)lon;
-(double)returnLat;//经度
-(double)returnLon;//纬度
-(void)makeLogged:(BOOL)logged;
-(BOOL)LoggedIn;
-(void)setNeedChatToUser:(NSString *)user;
-(void)setNeedChatNO;
-(BOOL)needChat;
-(NSString *)getNeedChatUser;
-(NSString*)getMyUserID;
@end
