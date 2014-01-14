//
//  DataStoreManager.h
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSMyDynamic.h"
#import "DSSayHellos.h"
#import "DSArticles.h"
#import "DSDynamicFriends.h"
#import "DSThumbMsgs.h"
#import "DSThumbPublicMsgs.h"
//#import "DSComments.h"
#import "DSPublicMsgs.h"
#import "DSCommonMsgs.h"
#import "DSReceivedHellos.h"
#import "DSThumbSubscribedMsgs.h"
#import "DSSubscribedMsgs.h"
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

@interface DataStoreManager : NSObject
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName;
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype;
+(void)storeMyMessage:(NSDictionary *)message;
+(void)blankMsgUnreadCountForUser:(NSString *)username;
+(NSArray *)queryUnreadCountForCommonMsg;
+(void)deleteThumbMsgWithSender:(NSString *)sender;
+(void)deleteThumbMsgWithUUID:(NSString *)uuid;
+(void)deleteMsgsWithSender:(NSString *)sender Type:(NSString *)senderType;

+(NSMutableArray *)qureyAllCommonMessages:(NSString *)username;
+(void)deleteCommonMsg:(NSString *)content Time:(NSString *)theTime;
+(void)refreshThumbMsgsAfterDeleteCommonMsg:(NSDictionary *)message ForUser:(NSString *)username ifDel:(BOOL)del;
+(NSArray *)qureyAllThumbMessages;
+(NSDictionary *)queryLastPublicMsg;


+(NSArray *)queryAllReceivedHellos;
+(NSDictionary *)qureyLastReceivedHello;

//存储“好友”的关注人列表
+(void)saveUserAttentionInfo:(NSDictionary *)myInfo;
+(NSMutableArray *)queryAttentionSections;
+(NSMutableArray*)queryAllAttentionWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllAttention;
+(NSString *)queryFirstHeadImageForUser_attention:(NSString *)userName;
+(void)deleteAttentionWithUserName:(NSString*)username;
+(BOOL)ifIsAttentionWithUserName:(NSString*)userName;
+(void)saveAttentionRemarkName:(NSString*)remarkName userName:(NSString*)userNane;//存备注名
+ (void)cleanAttentionList;//清空

//存储“好友”的粉丝列表
+(void)saveUserFansInfo:(NSDictionary *)myInfo;
+(NSMutableArray *)queryFansSections;
+(NSMutableArray*)queryAllFansWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllFans;
+(NSString *)queryFirstHeadImageForUser_fans:(NSString *)userName;
+(void)deleteFansWithUserName:(NSString*)username;
+(BOOL)ifIsFansWithUserName:(NSString*)userName;
+ (void)cleanFansList;//清空

//好友
//是否存在这个联系人
+(BOOL)ifHaveThisUser:(NSString *)userName;
+(BOOL)ifHaveThisFriend:(NSString *)userName;
+(BOOL)ifFriendHaveNicknameAboutUser:(NSString *)username;
+(NSMutableArray *)querySections;
+(NSMutableArray*)queryAllFriendsWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend;
+(NSMutableDictionary *)queryAllFriends;
+(void)deleteFriendWithUserName:(NSString*)username;
+(void)saveFriendRemarkName:(NSString*)remarkName userName:(NSString*)userNane;//存备注名
+ (void)cleanFriendList;//清空
+(NSString*)getMyNameIndex;
+ (void)cleanIndexWithType:(NSInteger)type nameIndex:(NSString*)nameIndex;//清理索引

+(void)addFriendToLocal:(NSString *)username;
+(NSString *)queryNickNameForUser:(NSString *)userName;
+(NSString *)queryFirstHeadImageForUser:(NSString *)userName;
+(void)updateFriendInfo:(NSDictionary *)userInfoDict ForUser:(NSString *)username;
+(NSString *)getOtherMessageTitleWithUUID:(NSString*)uuid type:(NSString*)type;//获取角色等 nickName
+(NSString *)queryRemarkNameForUser:(NSString *)userName;//获得别名

+(NSString *)getMyUserID;
+(void)saveUserInfo:(NSDictionary *)myInfo;
+(void)saveMyBackgroungImg:(NSString*)backgroundImg;
//+(void)storeOnePetInfo:(NSDictionary *)petInfo;
//+(void)deleteOnePetForPetID:(NSString *)petID;
+(NSDictionary *)queryMyInfo;
+(NSMutableDictionary *)queryOneFriendInfoWithUserName:(NSString *)userName;
+(NSString *)qureyUnreadForReceivedHellos;
+(void)blankReceivedHellosUnreadCount;

+(void)deleteAllHello;//清除关注表
+(void)deleteReceivedHelloWithUserName:(NSString *)userName withTime:(NSString *)times;
+(void)deleteReceivedHelloWithUserName:(NSString *)userName;
+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict;
+(void)blankUnreadCountReceivedHellosForUser:(NSString *)username;
+(BOOL)ifSayHellosHaveThisPerson:(NSString *)username;
+(BOOL)checkSayHelloPersonIfHaveNickNameForUsername:(NSString *)username;
+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userName;
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

@end
