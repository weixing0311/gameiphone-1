//
//  GameCommon.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameCommon : NSObject

@property(nonatomic, strong) NSString*  fansCount;//总粉丝数
@property(nonatomic, assign) BOOL friendTableChanged;//好友表有更新 进入联系人页时是否刷新表单
@property(nonatomic, assign) BOOL attentionTableChanged;//关注表有更新
@property(nonatomic, assign) BOOL fansTableChanged;//粉丝表有更新

@property(nonatomic, assign) BOOL isFirst;//程序第一次启动 注销再登录也为第一次

@property(nonatomic, strong) NSMutableDictionary* wow_realms;//英雄联盟服务器 注册、搜索时用
@property(nonatomic, strong) NSMutableArray* wow_clazzs;//职业

@property(nonatomic, strong) NSString* deviceToken;

@property(nonatomic, assign) int connectTimes;//连接次数 3

+ (NSString*)getNewStringWithId:(id)oldString;//剔除json里的空格字段

+ (GameCommon*)shareGameCommon;
+ (float)diffHeight:(UIViewController *)controller;

-(NSString *)convertChineseToPinYin:(NSString *)chineseName;
-(NSUInteger) unicodeLengthOfString: (NSString *) text;
-(NSUInteger) asciiLengthOfString: (NSString *) text;
- (BOOL)isValidateEmail:(NSString *)email;

-(NSString*) uuid;
- (NSMutableDictionary*)getNetCommomDic;

+(NSString *)getCurrentTime;
+(NSString *)getWeakDay:(NSDate *)datetime;
+(NSString *)CurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;

+ (NSString*)getTimeWithMessageTime:(NSString*)messageTime;

- (NSString*)getDataWithTimeInterval:(NSString*)timeInterval;
+ (NSString*)getTimeAndDistWithTime:(NSString*)time Dis:(NSString*)distrance;

+(UIColor*)getAchievementColorWithLevel:(NSUInteger)level;

+(NSString *)dynamicListCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;
+(NSString *)DynamicCurrentTime:(NSString *)currentTime AndMessageTime:(NSString *)messageTime;

+ (NSString*)getHeardImgId:(NSString*)img;

//是否有网
+ (BOOL)testConnection;

-(void)displayTabbarNotification;

+ (void)loginOut;

@end
