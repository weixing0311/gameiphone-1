//
//  DataStoreManager.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DSThumbMsgs.h"
#import "DSCommonMsgs.h"

#import "DSReceivedHellos.h"
#import "DSFriends.h"
#import "DSUnreadCount.h"
#import "DSNameIndex.h"

#import "DSAttentions.h"//关注
#import "DSAttentionNameIndex.h"

#import "DSFans.h"//粉丝
#import "DSFansNameIndex.h"

#import "DSMyNewsList.h"
#import "DSFriendsNewsList.h"

#import "DSRecommendList.h"//好友推荐
#import "DSOtherMsgs.h"

@interface DataStoreManager : NSObject
+ (BOOL)savedMsgWithID:(NSString*)msgId//消息是否已存
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName;
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype;
+(void)storeMyMessage:(NSDictionary *)message;
+(void)storeThumbMsgUser:(NSString*)userid nickName:(NSString*)nickName andImg:(NSString*)img;
+(void)storeThumbMsgUser:(NSString*)userid nickName:(NSString*)nickName;//修改别名
+(NSString *)queryMsgRemarkNameForUser:(NSString *)userid;
+(NSString *)queryMsgHeadImageForUser:(NSString *)userid;
+(void)blankMsgUnreadCountForUser:(NSString *)userid;
+(NSArray *)queryUnreadCountForCommonMsg;
+(void)deleteAllThumbMsg;
+(void)deleteThumbMsgWithSender:(NSString *)sender;
+(void)deleteMsgsWithSender:(NSString *)sender Type:(NSString *)senderType;

+(NSMutableArray *)qureyAllCommonMessages:(NSString *)username;
+(void)deleteCommonMsg:(NSString *)content Time:(NSString *)theTime;
+(void)deleteAllCommonMsg;
+(void)refreshThumbMsgsAfterDeleteCommonMsg:(NSDictionary *)message ForUser:(NSString *)userid ifDel:(BOOL)del;
+(NSArray *)qureyAllThumbMessages;
+(void)refreshMessageStatusWithId:(NSString*)messageuuid status:(NSString*)status;

+(NSArray *)queryAllReceivedHellos;
+(NSDictionary *)qureyLastReceivedHello;

//存储“好友”的关注人列表
+(void)saveUserAttentionWithFriendList:(NSString*)userid;//从好友表到关注表
+(void)saveUserAttentionInfo:(NSDictionary *)myInfo;
+(NSMutableArray *)queryAttentionSections;
+(NSMutableArray*)queryAllAttentionWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllAttention;
+(NSString *)queryFirstHeadImageForUser_attention:(NSString *)userName;
+(void)deleteAttentionWithUserName:(NSString*)username;
+(BOOL)ifIsAttentionWithUserName:(NSString*)userName;
+(void)saveAttentionRemarkName:(NSString*)remarkName userid:(NSString*)userid;//存备注名
+(void)cleanAttentionList;//清空

//存储“好友”的粉丝列表
+(void)saveUserFansInfo:(NSDictionary *)myInfo;
+(NSMutableArray *)queryFansSections;
+(NSMutableArray*)queryAllFansWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllFans;
+(NSString *)queryFirstHeadImageForUser_fans:(NSString *)userName;
+(void)deleteFansWithUserid:(NSString*)userid;
+(BOOL)ifIsFansWithUserName:(NSString*)userName;
+ (void)cleanFansList;//清空

//好友
//是否存在这个联系人
+(BOOL)ifHaveThisUser:(NSString *)userId;
+(BOOL)ifHaveThisFriend:(NSString *)userName;
+(BOOL)ifFriendHaveNicknameAboutUser:(NSString *)username;
+(NSMutableArray *)querySections;
+(NSMutableArray*)queryAllFriendsWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllFriends;
+(void)deleteFriendWithUserId:(NSString*)userid;
+(void)saveFriendRemarkName:(NSString*)remarkName userid:(NSString*)userid;//存备注名
+ (void)cleanFriendList;//清空
+(NSString*)getMyNameIndex;
+ (void)cleanIndexWithType:(NSInteger)type nameIndex:(NSString*)nameIndex;//清理索引

+(NSString *)queryNickNameForUser:(NSString *)userName;
+(NSString *)querySelfUserName;
+(NSString *)queryFirstHeadImageForUser:(NSString *)userName;
+(NSString *)queryFirstHeadImageForUserId:(NSString *)userId;
+(void)updateFriendInfo:(NSDictionary *)userInfoDict ForUser:(NSString *)username;
+(NSString *)getOtherMessageTitleWithUUID:(NSString*)uuid type:(NSString*)type;//获取角色等 nickName
+(NSString *)queryRemarkNameForUser:(NSString *)userid;//获得别名

+(NSString *)getMyUserID;
+(void)saveUserFriendWithAttentionList:(NSString*)userName;
+(void)saveUserFriendWithFansList:(NSString*)userName;
+(void)saveUserInfo:(NSDictionary *)myInfo;
+(void)saveMyBackgroungImg:(NSString*)backgroundImg;
//+(void)storeOnePetInfo:(NSDictionary *)petInfo;
//+(void)deleteOnePetForPetID:(NSString *)petID;
+(NSDictionary *)queryMyInfo;
+(NSMutableDictionary *)queryOneFriendInfoWithUserName:(NSString *)userName;
+(NSString *)qureyUnreadForReceivedHellos;
+(void)blankReceivedHellosUnreadCount;

+(void)deleteAllHello;//清除关注表
+(void)deleteReceivedHelloWithUserId:(NSString *)userid withTime:(NSString *)times;
+(void)deleteReceivedHelloWithUserId:(NSString *)userid;
+(NSDictionary*)addPersonToReceivedHellosWithFriend:(NSString*)userId;//从好友表取内容
+(NSDictionary*)addPersonToReceivedHellosWithAttention:(NSString*)userId;//从关注表取内容
+(NSDictionary*)addPersonToReceivedHellosWithFans:(NSString*)userId;//从粉丝表取内容
+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict;
+(void)blankUnreadCountReceivedHellosForUser:(NSString *)userid;
+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userid;
+(NSMutableArray *)queryAllFriendsNickname;
+(void)storeMyUserID:(NSString *)theID;

//动态
+(void)saveMyNewsWithData:(NSDictionary*)dataDic;
+(void)cleanMyNewsList;
+(void)saveFriendsNewsWithData:(NSDictionary*)dataDic;
+(void)cleanFriendsNewsList;

//好友推荐
+(void)saveRecommendWithData:(NSDictionary*)dataDic;
+(void)updateRecommendStatus:(NSString *)theStatus ForPerson:(NSString *)userName;

//角色、头衔、战斗力消息
+(void)saveOtherMsgsWithData:(NSDictionary*)userInfoDict;
+(NSArray *)queryAllOtherMsg;
+(void)cleanOtherMsg;
+(void)deleteOtherMsgWithUUID:(NSString *)uuid;

@end
