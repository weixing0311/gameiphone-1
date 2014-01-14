//
//  DataStoreManager.m
//  PetGroup
//
//  Created by Tolecen on 13-8-15.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "DataStoreManager.h"
#import "MagicalRecord.h"

@implementation DataStoreManager
-(void)nothing
{}
+(void)setDefaultDataBase:(NSString *)dataBaseName AndDefaultModel:(NSString *)modelName
{
    [MagicalRecord cleanUp];
    [MagicalRecord setDefaultModelNamed:[NSString stringWithFormat:@"%@.momd",modelName]];
    [MagicalRecord setupCoreDataStackWithStoreNamed:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
}
#pragma mark - 存储消息相关
+(void)storeNewMsgs:(NSDictionary *)msg senderType:(NSString *)sendertype
{
    NSRange range = [[msg objectForKey:@"sender"] rangeOfString:@"@"];
    NSString * sender = [[msg objectForKey:@"sender"] substringToIndex:range.location];
    NSString * senderNickname = [msg objectForKey:@"nickname"];
    NSString * msgContent = [msg objectForKey:@"msg"];
    NSString * msgType = [msg objectForKey:@"msgType"];

    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[msg objectForKey:@"time"] doubleValue]];
    
//    NSString * receiver;
//    if ([msg objectForKey:@"receicer"]) {
//        NSRange range2 = [[msg objectForKey:@"receicer"] rangeOfString:@"@"];
//        receiver = [[msg objectForKey:@"receicer"] substringToIndex:range2.location];
//    }
    
    //普通用户消息存储到DSCommonMsgs和DSThumbMsgs两个表里
    if ([sendertype isEqualToString:COMMONUSER]) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];//所有消息
            commonMsg.sender = sender;
            commonMsg.senderNickname = senderNickname?senderNickname:@"";
            commonMsg.msgContent = msgContent?msgContent:@"";
            commonMsg.senTime = sendTime;
            

            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];//消息页展示的内容
            if (!thumbMsgs) 
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];    
            thumbMsgs.sender = sender;
            thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            thumbMsgs.msgType = msgType;
            thumbMsgs.messageuuid = @"";
//            if (![self ifHaveThisFriend:sender]) {
//                [self addFriendToLocal:sender];
//            }
            
        }];
    }
    //公共账号消息存储到DSThumbPuclicMsgs和DSPublicMsgs里面
    else if ([sendertype isEqualToString:PUBLICACCOUNT]){
        
    }
    //订阅号信息存储到DSThumbSubscribedMsgs和DSSubscribedMsgs里面
    else if ([sendertype isEqualToString:SUBSCRIBEDACCOUNT]){
        
    }
    else if ([sendertype isEqualToString:SYSTEMNOTIFICATION]){
    }
    else if([sendertype isEqualToString:SAYHELLOS])//关注 或取消关注
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"1234"];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
            thumbMsgs.sender = @"1234";
            thumbMsgs.senderNickname = @"有新关注信息";
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            thumbMsgs.msgType = msgType;
            int unread = [thumbMsgs.unRead intValue];
            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            thumbMsgs.messageuuid = @"";
        }];
    }
    else if([sendertype isEqualToString:OTHERMESSAGE])//头衔、角色、战斗力
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {

            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"1"];

            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
    //        if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];

//            if ([msgType isEqualToString:@"character"]) {
                thumbMsgs.sender = @"1";
//            }
//            else if([msgType isEqualToString:@"pveScore"])
//            {
//                thumbMsgs.sender = @"2";
//            }
//            else if([msgType isEqualToString:@"title"])
//            {
//                thumbMsgs.sender = @"3";
//            }
            thumbMsgs.senderNickname = [msg objectForKey:@"title"];
            thumbMsgs.msgContent = msgContent;
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            thumbMsgs.msgType = msgType;
            thumbMsgs.sendTimeStr = [msg objectForKey:@"time"];
            thumbMsgs.unRead = @"1";
            thumbMsgs.messageuuid = [[GameCommon shareGameCommon] uuid];
        }];
    }
    else if([sendertype isEqualToString:RECOMMENDFRIEND])//推荐好友
    {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"12345"];
            
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            if (!thumbMsgs)
                thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
            thumbMsgs.sender = @"12345";
            thumbMsgs.senderNickname = @"推荐好友";
            thumbMsgs.msgContent = KISDictionaryHaveKey(msg, @"disStr");
            thumbMsgs.sendTime = sendTime;
            thumbMsgs.senderType = sendertype;
            thumbMsgs.msgType = msgType;
//            int unread = [thumbMsgs.unRead intValue];
//            thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
            thumbMsgs.unRead = @"1";
            thumbMsgs.messageuuid = [[GameCommon shareGameCommon] uuid];
        }];
    }
}
+(void)storeMyMessage:(NSDictionary *)message
{
    NSString * receicer = [message objectForKey:@"receiver"];
    NSString * sender = [message objectForKey:@"sender"];
    NSString * senderNickname = [message objectForKey:@"nickname"];
    NSString * msgContent = [message objectForKey:@"msg"];
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
        commonMsg.sender = sender;
        commonMsg.senderNickname = senderNickname?senderNickname:@"";
        commonMsg.msgContent = msgContent?msgContent:@"";
        commonMsg.senTime = sendTime;
        commonMsg.receiver = receicer;
        
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",receicer];
        
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        if (!thumbMsgs)
            thumbMsgs = [DSThumbMsgs MR_createInContext:localContext];
        thumbMsgs.sender = receicer;
        thumbMsgs.senderNickname = senderNickname?senderNickname:@"";
        thumbMsgs.msgContent = msgContent;
        thumbMsgs.sendTime = sendTime;
        thumbMsgs.senderType = COMMONUSER;
        thumbMsgs.msgType = @"normalchat";
        int unread = [thumbMsgs.unRead intValue];
        thumbMsgs.unRead = [NSString stringWithFormat:@"%d",unread+1];
        thumbMsgs.messageuuid = @"";
    }];

}
+(void)blankMsgUnreadCountForUser:(NSString *)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",username];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        if (thumbMsgs) {
            thumbMsgs.unRead = @"0";
        }
    }];
}
+(NSArray *)queryUnreadCountForCommonMsg
{
    NSMutableArray * unreadArray = [NSMutableArray array];
    NSArray * allUnreadArray = [DSThumbMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    for (int i = 0; i<allUnreadArray.count; i++) {
        [unreadArray addObject:[[allUnreadArray objectAtIndex:i]unRead]];
    }
    return unreadArray;
}
+(void)deleteThumbMsgWithSender:(NSString *)sender
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        [thumbMsgs MR_deleteInContext:localContext];
    }];
}

+(void)deleteThumbMsgWithUUID:(NSString *)uuid
{
//    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[theTime doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"messageuuid==[c]%@",uuid];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        if (thumbMsgs) {
            [thumbMsgs MR_deleteInContext:localContext];
        }
        
    }];
}

+(void)deleteMsgsWithSender:(NSString *)sender Type:(NSString *)senderType
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        if ([senderType isEqualToString:COMMONUSER]) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",sender];
            DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
            [thumbMsgs MR_deleteInContext:localContext];
            NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"sender==[c]%@ OR receiver==[c]%@",sender,sender];
            NSArray * commonMsgs = [DSCommonMsgs MR_findAllWithPredicate:predicate2];
            for (int i = 0; i<commonMsgs.count; i++) {
                DSCommonMsgs * rH = [commonMsgs objectAtIndex:i];
                [rH MR_deleteInContext:localContext];
            }
        }

        
    }];
}

+(void)deleteAllThumbMsg
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * thumbMsgs = [DSThumbMsgs MR_findAllInContext:localContext];
        for (DSThumbMsgs* msg in thumbMsgs) {
            [msg deleteInContext:localContext];
        }
    }];
}

+(NSMutableArray *)qureyAllCommonMessages:(NSString *)username
{
    NSMutableArray * allMsgArray = [NSMutableArray array];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@ OR receiver==[c]%@",username,username];
    NSArray * commonMsgsArray = [DSCommonMsgs MR_findAllSortedBy:@"senTime" ascending:YES withPredicate:predicate];
    //取前20条...
    for (int i = (commonMsgsArray.count>20?(commonMsgsArray.count-20):0); i<commonMsgsArray.count; i++) {
        NSMutableDictionary * thumbMsgsDict = [NSMutableDictionary dictionary];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] sender] forKey:@"sender"];
        //        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] senderNickname] forKey:@"nickname"];
        [thumbMsgsDict setObject:[[commonMsgsArray objectAtIndex:i] msgContent] forKey:@"msg"];
        NSDate * tt = [[commonMsgsArray objectAtIndex:i] senTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [thumbMsgsDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [allMsgArray addObject:thumbMsgsDict];
        
    }
    return allMsgArray;
}

+(void)deleteCommonMsg:(NSString *)content Time:(NSString *)theTime
{
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[theTime doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"msgContent==[c]%@ OR senTime==[c]%@",content,sendTime];
        DSCommonMsgs * commonMsgs = [DSCommonMsgs MR_findFirstWithPredicate:predicate];
        if (commonMsgs) {
            [commonMsgs MR_deleteInContext:localContext];
        }
     
    }];
}

+(void)refreshThumbMsgsAfterDeleteCommonMsg:(NSDictionary *)message ForUser:(NSString *)username ifDel:(BOOL)del
{
    NSString * msgContent = [message objectForKey:@"msg"];
    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[[message objectForKey:@"time"] doubleValue]];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate;

        predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",username];

        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];

        if (thumbMsgs){
            if (del) {
                [thumbMsgs MR_deleteInContext:localContext];
            }
            else
            {
                thumbMsgs.msgContent = msgContent;
                thumbMsgs.sendTime = sendTime;
            }
        }
        
    }];
}

+(NSArray *)qureyAllThumbMessages
{
    NSMutableArray * allMsgArray = [NSMutableArray array];
    NSArray * thumbCommonMsgsArray = [DSThumbMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    for (int i = 0; i<thumbCommonMsgsArray.count; i++) {
        NSMutableDictionary * thumbMsgsDict = [NSMutableDictionary dictionary];
        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] sender] forKey:@"sender"];
//        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] senderNickname] forKey:@"nickname"];
        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] msgContent] forKey:@"msg"];
        NSDate * tt = [[thumbCommonMsgsArray objectAtIndex:i] sendTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [thumbMsgsDict setObject:[NSString stringWithFormat:@"%.f", uu] forKey:@"time"];

        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] messageuuid] forKey:@"messageuuid"];
        [thumbMsgsDict setObject:[[thumbCommonMsgsArray objectAtIndex:i] msgType] forKey:@"msgType"];

        [allMsgArray addObject:thumbMsgsDict];
    }
    return allMsgArray;  
}

+(NSArray *)queryAllThumbPublicMsgs
{
    NSArray * thumbPublicMsgs = [DSThumbPublicMsgs MR_findAllSortedBy:@"sendTime" ascending:NO];
    return thumbPublicMsgs;
}

+(NSDictionary *)queryLastPublicMsg
{
    NSArray * publicMsgs = [DSThumbPublicMsgs MR_findAllSortedBy:@"sendTime" ascending:YES];
    NSMutableDictionary * lastMsgDict = [NSMutableDictionary dictionary];
    [lastMsgDict setObject:@"公众账号" forKey:@"sender"];
    if (publicMsgs.count>0) {
        DSThumbPublicMsgs * lastRecHello = [publicMsgs lastObject];
        NSDate * tt = [lastRecHello sendTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%@给您发了一条消息",[lastRecHello senderNickname]] forKey:@"msg"];
    }
    else
    {
        NSTimeInterval uu = [[NSDate date] timeIntervalSince1970];
        [lastMsgDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastMsgDict setObject:@"暂时还没有公众账号消息" forKey:@"msg"];
    }
    return lastMsgDict;
}

#pragma mark - 存储“好友”的关注人列表
+(void)saveUserAttentionWithFriendList:(NSString*)userName
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    
    NSString * myUserName = [GameCommon getNewStringWithId:dFriend.userName];
    NSString * nickName = [GameCommon getNewStringWithId:dFriend.nickName];
    NSString * gender = [GameCommon getNewStringWithId:dFriend.gender];
    NSString * headImgID = [GameCommon getNewStringWithId:dFriend.headImgID];
    NSString * age = [GameCommon getNewStringWithId:dFriend.age];
    NSString * userId = [GameCommon getNewStringWithId:dFriend.userId];
    NSString * alias = [GameCommon getNewStringWithId:dFriend.remarkName];//别名
    NSString * refreshTime = [GameCommon getNewStringWithId:dFriend.refreshTime];
    NSString * distance = [GameCommon getNewStringWithId:dFriend.distance];
    NSString * title = [GameCommon getNewStringWithId:dFriend.achievement];
    NSString * titleLevel = [GameCommon getNewStringWithId:dFriend.achievementLevel];
    
    NSDictionary* titleData = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",titleLevel,@"rarenum", nil];
    NSDictionary* titleObjDic = [NSDictionary dictionaryWithObject:titleData forKey:@"titleObj"];

    NSMutableDictionary* myDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDic setObject:myUserName forKey:@"username"];
    [myDic setObject:nickName forKey:@"nickname"];
    [myDic setObject:gender forKey:@"gender"];
    [myDic setObject:headImgID forKey:@"img"];
    [myDic setObject:age forKey:@"age"];
    [myDic setObject:userId forKey:@"id"];
    [myDic setObject:alias forKey:@"alias"];
    [myDic setObject:refreshTime forKey:@"updateUserLocationDate"];
    [myDic setObject:distance forKey:@"distance"];
    [myDic setObject:titleObjDic forKey:@"title"];

    [DataStoreManager saveUserAttentionInfo:myDic];
}

+(void)saveUserAttentionInfo:(NSDictionary *)myInfo
{
    NSString * myUserName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"username"]];
    NSString * nickName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nickname"]];
    NSString * gender = [GameCommon getNewStringWithId:[myInfo objectForKey:@"gender"]];
    NSString * headImgID = [GameCommon getNewStringWithId:[myInfo objectForKey:@"img"]];
    NSString * age = [GameCommon getNewStringWithId:[myInfo objectForKey:@"age"]];
    NSString * userId = [GameCommon getNewStringWithId:[myInfo objectForKey:@"id"]];
//    NSString * achievement = [GameCommon getNewStringWithId:[myInfo objectForKey:@"achievement"]];
    NSString * alias = [GameCommon getNewStringWithId:[myInfo objectForKey:@"alias"]];//别名
//    NSString * nameIndex = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nameindex"]];
    NSString * refreshTime = [GameCommon getNewStringWithId:[myInfo objectForKey:@"updateUserLocationDate"]];
    double distance = [KISDictionaryHaveKey(myInfo, @"distance") doubleValue];
    if (distance == -1) {//若没有距离赋最大值
        distance = 9999000;
    }
    
    NSString * titleObj = @"";
    NSString * titleObjLevel = @"";
    NSDictionary* titleDic = KISDictionaryHaveKey(myInfo, @"title");
    if ([titleDic isKindOfClass:[NSDictionary class]]) {
        titleObj = KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"title");
        titleObjLevel = [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"rarenum")];
    }
    else
    {
        titleObj = @"暂无头衔";
        titleObjLevel = @"6";
    }
    if (myUserName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myUserName];
            DSAttentions * dFriend = [DSAttentions MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSAttentions MR_createInContext:localContext];
            dFriend.sex = gender ? gender : @"";//0 男 1女
            dFriend.userName = myUserName;
            dFriend.nickName = nickName?(nickName.length>1?nickName:[nickName stringByAppendingString:@" "]):@"";
            dFriend.userId = userId?userId:@"";
            dFriend.headImgID = headImgID?headImgID:@"";
            dFriend.age = age?age:@"";
            dFriend.remarkName = alias?alias:@"";
            dFriend.achievement = titleObj;
            dFriend.achievementLevel = titleObjLevel;
            
            dFriend.refreshTime = refreshTime;
            dFriend.distance = [NSNumber numberWithDouble:distance];

            NSString* pinYin = [alias isEqualToString:@""] ? nickName : alias;
            NSString * nameIndex;
            NSString * nameKey;
            if (nickName.length>=1) {
                nameKey = [[DataStoreManager convertChineseToPinYin:pinYin] stringByAppendingFormat:@"+%@",pinYin];
                dFriend.nameKey = nameKey;
                nameIndex = [[nameKey substringToIndex:1] uppercaseString];
                dFriend.nameIndex = nameIndex;
            }
            if (![myUserName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                if (nickName.length>=1) {
                    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                    DSAttentionNameIndex * dFname = [DSAttentionNameIndex MR_findFirstWithPredicate:predicate2];
                    if (!dFname)
                        dFname = [DSAttentionNameIndex MR_createInContext:localContext];
                    
                    dFname.index = nameIndex;
                }
            }
        }];
    }
}

+(NSMutableArray *)queryAttentionSections
{
    NSMutableArray * sectionArray = [NSMutableArray array];
    NSArray * nameIndexArray2 = [DSAttentionNameIndex MR_findAll];
    NSMutableArray * nameIndexArray = [NSMutableArray array];
    for (int i = 0; i<nameIndexArray2.count; i++) {
        DSAttentionNameIndex * di = [nameIndexArray2 objectAtIndex:i];
        [nameIndexArray addObject:di.index];
    }
    [nameIndexArray sortUsingSelector:@selector(compare:)];
    for (int i = 0; i<nameIndexArray.count; i++) {
        NSMutableArray * array = [NSMutableArray array];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",[nameIndexArray objectAtIndex:i]];
        NSArray * fri = [DSAttentions MR_findAllSortedBy:@"nameKey" ascending:YES withPredicate:predicate];
        NSMutableArray * nameKeyArray = [NSMutableArray array];
        for (int i = 0; i<fri.count; i++) {
            NSString * thename = [[fri objectAtIndex:i]userName];
            NSString * nameK = [[fri objectAtIndex:i]nameKey];
            if (![thename isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                [nameKeyArray addObject:nameK];
            }
            
        }
        [array addObject:[nameIndexArray objectAtIndex:i]];
        [array addObject:nameKeyArray];
        [sectionArray addObject:array];
    }
    return sectionArray;
    
}


+(NSMutableDictionary *)queryAllAttention
{
    NSArray * fri = [DSAttentions MR_findAll];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser_attention:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] sex];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔
        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//
        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * friendDict = [NSMutableDictionary dictionary];
            [friendDict setObject:userName forKey:@"username"];
            [friendDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (![remarkName isEqualToString:@""]) {
                [friendDict setObject:remarkName forKey:@"displayName"];
            }
            else if(![nickName isEqualToString:@""]){
                [friendDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [friendDict setObject:userName forKey:@"displayName"];
            }
            [friendDict setObject:headImg?headImg:@"" forKey:@"img"];
            [friendDict setObject:age ? age:@"" forKey:@"age"];
            [friendDict setObject:sex ? sex:@"" forKey:@"sex"];
            [friendDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [friendDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [friendDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [friendDict setObject:[NSString stringWithFormat:@"%.f", distance] forKey:@"distance"];

            [theDict setObject:friendDict forKey:nameK];
        }
    }
    return theDict;
}

+(NSMutableArray*)queryAllAttentionWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend
{
    NSArray * fri = [DSAttentions MR_findAllSortedBy:sorttype ascending:ascend];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableArray * theArr = [NSMutableArray array];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser_attention:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] sex];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔
        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//

        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
            [theDict setObject:userName forKey:@"username"];
            [theDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (![remarkName isEqualToString:@""]) {
                [theDict setObject:remarkName forKey:@"displayName"];
            }
            else if(![nickName isEqualToString:@""]){
                [theDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [theDict setObject:userName forKey:@"displayName"];
            }
            [theDict setObject:headImg?headImg:@"" forKey:@"img"];
            [theDict setObject:age ? age:@"" forKey:@"age"];
            [theDict setObject:sex ? sex:@"" forKey:@"sex"];
            [theDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [theDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [theDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [theDict setObject:[NSString stringWithFormat:@"%.f", distance] forKey:@"distance"];

            [theArr addObject:theDict];
        }
    }
    return theArr;
}

+(NSString *)queryFirstHeadImageForUser_attention:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"no";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSAttentions * dFriend = [DSAttentions MR_findFirstWithPredicate:predicate];
    if (dFriend.headImgID) {
        NSRange range=[dFriend.headImgID rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [dFriend.headImgID componentsSeparatedByString:@","];
            
//            NSArray *arr = [[imageArray objectAtIndex:0] componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return [imageArray objectAtIndex:0];
        }
        else
        {
//            NSArray *arr = [dFriend.headImgID componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return dFriend.headImgID;
        }
    }
    else
        return @"no";
}
+(void)deleteAttentionWithUserName:(NSString*)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSAttentions * attention = [DSAttentions MR_findFirstWithPredicate:predicate];
        if (attention) {
            [attention MR_deleteInContext:localContext];
            
            [DataStoreManager cleanIndexWithType:2 nameIndex:attention.nameIndex];
        }
    }];
}

+ (BOOL)ifIsAttentionWithUserName:(NSString*)userName
{
    if (userName) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSAttentions * dFriends = [DSAttentions MR_findFirstWithPredicate:predicate];
        if (dFriends) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;

}

+(void)saveAttentionRemarkName:(NSString*)remarkName userName:(NSString*)userName//存备注名
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSAttentions * dFriend = [DSAttentions MR_findFirstWithPredicate:predicate];

        if (dFriend) {
            dFriend.remarkName = remarkName;
        }
        NSString* oldNameIndex = dFriend.nameIndex;

        NSString * nameIndex;
        NSString * nameKey;
        if (remarkName.length>=1) {
            nameKey = [[DataStoreManager convertChineseToPinYin:remarkName] stringByAppendingFormat:@"+%@",remarkName];
            dFriend.nameKey = nameKey;
            nameIndex = [[nameKey substringToIndex:1] uppercaseString];
            dFriend.nameIndex = nameIndex;
        }
        if (remarkName.length>=1) {
            NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
            DSAttentionNameIndex * dFname = [DSAttentionNameIndex MR_findFirstWithPredicate:predicate2];
            if (!dFname)
                dFname = [DSAttentionNameIndex MR_createInContext:localContext];
            
            dFname.index = nameIndex;
        }
        [DataStoreManager cleanIndexWithType:2 nameIndex:oldNameIndex];
    }];
}

+ (void)cleanAttentionList//清空
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dFriend = [DSAttentions MR_findAllInContext:localContext];
        for (DSAttentions* friend in dFriend) {
                [friend deleteInContext:localContext];
        }
        NSArray * dFriend_index = [DSAttentionNameIndex MR_findAllInContext:localContext];
        for (DSAttentionNameIndex* friendIndex in dFriend_index) {
            [friendIndex deleteInContext:localContext];
        }
    }];
}

#pragma mark - 存储“好友”的粉丝人列表
+(void)saveUserFansInfo:(NSDictionary *)myInfo
{
    NSString * myUserName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"username"]];
    NSString * nickName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nickname"]];
    NSString * gender = [GameCommon getNewStringWithId:[myInfo objectForKey:@"gender"]];
    NSString * headImgID = [GameCommon getNewStringWithId:[myInfo objectForKey:@"img"]];
    NSString * age = [GameCommon getNewStringWithId:[myInfo objectForKey:@"age"]];
    NSString * userId = [GameCommon getNewStringWithId:[myInfo objectForKey:@"id"]];
//    NSString * achievement = [GameCommon getNewStringWithId:[myInfo objectForKey:@"achievement"]];
    NSString * alias = [GameCommon getNewStringWithId:[myInfo objectForKey:@"alias"]];//别名
//    NSString * nameIndex = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nameindex"]];
    NSString * refreshTime = [GameCommon getNewStringWithId:[myInfo objectForKey:@"updateUserLocationDate"]];
    double distance = [KISDictionaryHaveKey(myInfo, @"distance") doubleValue];
    if (distance == -1) {//若没有距离赋最大值
        distance = 9999000;
    }
    NSString * titleObj = @"";
    NSString * titleObjLevel = @"";
    
    NSDictionary* titleDic = KISDictionaryHaveKey(myInfo, @"title");
    if ([titleDic isKindOfClass:[NSDictionary class]]) {
        titleObj = KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"title");
        titleObjLevel = [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"rarenum")];
    }
    else
    {
        titleObj = @"暂无头衔";
        titleObjLevel = @"6";
    }
    if (myUserName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myUserName];
            DSFans * dFriend = [DSFans MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFans MR_createInContext:localContext];
            dFriend.sex = gender ? gender : @"";//0 男 1女
            dFriend.userName = myUserName;
            dFriend.nickName = nickName?(nickName.length>1?nickName:[nickName stringByAppendingString:@" "]):@"";
            dFriend.userId = userId?userId:@"";
            dFriend.headImgID = headImgID?headImgID:@"";
            dFriend.age = age?age:@"";
     
            dFriend.refreshTime = refreshTime;
            dFriend.distance = [NSNumber numberWithDouble:distance];
            
            dFriend.achievement = titleObj;
            dFriend.achievementLevel = titleObjLevel;
            
            NSString* pinYin = [alias isEqualToString:@""] ? nickName : alias;
            NSString * nameIndex;
            NSString * nameKey;
            if (nickName.length>=1) {
                nameKey = [[DataStoreManager convertChineseToPinYin:pinYin] stringByAppendingFormat:@"+%@",pinYin];
                dFriend.nameKey = nameKey;
                nameIndex = [[nameKey substringToIndex:1] uppercaseString];
                dFriend.nameIndex = nameIndex;
            }
            if (![myUserName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                if (nickName.length>=1) {
                    NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                    DSFansNameIndex * dFname = [DSFansNameIndex MR_findFirstWithPredicate:predicate2];
                    if (!dFname)
                        dFname = [DSFansNameIndex MR_createInContext:localContext];
                    
                    dFname.index = nameIndex;
                }
            }
        }];
    }
}

+(NSMutableArray *)queryFansSections
{
    NSMutableArray * sectionArray = [NSMutableArray array];
    NSArray * nameIndexArray2 = [DSFansNameIndex MR_findAll];
    NSMutableArray * nameIndexArray = [NSMutableArray array];
    for (int i = 0; i<nameIndexArray2.count; i++) {
        DSFansNameIndex * di = [nameIndexArray2 objectAtIndex:i];
        [nameIndexArray addObject:di.index];
    }
    [nameIndexArray sortUsingSelector:@selector(compare:)];
    for (int i = 0; i<nameIndexArray.count; i++) {
        NSMutableArray * array = [NSMutableArray array];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",[nameIndexArray objectAtIndex:i]];
        NSArray * fri = [DSFans MR_findAllSortedBy:@"nameKey" ascending:YES withPredicate:predicate];
        NSMutableArray * nameKeyArray = [NSMutableArray array];
        for (int i = 0; i<fri.count; i++) {
            NSString * thename = [[fri objectAtIndex:i]userName];
            NSString * nameK = [[fri objectAtIndex:i]nameKey];
            if (![thename isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                [nameKeyArray addObject:nameK];
            }
            
        }
        [array addObject:[nameIndexArray objectAtIndex:i]];
        [array addObject:nameKeyArray];
        [sectionArray addObject:array];
    }
    return sectionArray;
    
}

+(NSMutableArray*)queryAllFansWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend
{
    NSArray * fri = [DSFans MR_findAllSortedBy:sorttype ascending:ascend];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableArray * theArr = [NSMutableArray array];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser_fans:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] sex];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔
        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//
        NSLog(@"昵称：%@ 距离：%.f",nickName, distance);
        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
            [theDict setObject:userName forKey:@"username"];
            [theDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (remarkName && ![remarkName isEqualToString:@""]) {
                [theDict setObject:remarkName forKey:@"displayName"];
            }
            else if(nickName && ![nickName isEqualToString:@""]){
                [theDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [theDict setObject:userName forKey:@"displayName"];
            }
            [theDict setObject:headImg?headImg:@"" forKey:@"img"];
            [theDict setObject:age ? age:@"" forKey:@"age"];
            [theDict setObject:sex ? sex:@"" forKey:@"sex"];
            [theDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [theDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [theDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [theDict setObject:[NSString stringWithFormat:@"%.f",distance] forKey:@"distance"];
            
            [theArr addObject:theDict];
        }
    }
    return theArr;
}


+(NSMutableDictionary *)queryAllFans
{
    NSArray * fri = [DSFans MR_findAll];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser_fans:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] sex];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔
        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//
        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * friendDict = [NSMutableDictionary dictionary];
            [friendDict setObject:userName forKey:@"username"];
            [friendDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (remarkName && ![remarkName isEqualToString:@""]) {
                [friendDict setObject:remarkName?remarkName:@"" forKey:@"displayName"];
            }
            else if(nickName && ![nickName isEqualToString:@""]){
                [friendDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [friendDict setObject:userName ? userName : @"" forKey:@"displayName"];
            }
            [friendDict setObject:headImg?headImg:@"" forKey:@"img"];
            [friendDict setObject:age ? age:@"" forKey:@"age"];
            [friendDict setObject:sex ? sex:@"" forKey:@"sex"];
            [friendDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [friendDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [friendDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [friendDict setObject:[NSString stringWithFormat:@"%.f", distance] forKey:@"distance"];

            [theDict setObject:friendDict forKey:nameK];
        }
    }
    return theDict;
}

+(NSString *)queryFirstHeadImageForUser_fans:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"no";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFans * dFriend = [DSFans MR_findFirstWithPredicate:predicate];
    if (dFriend.headImgID) {
        NSRange range=[dFriend.headImgID rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [dFriend.headImgID componentsSeparatedByString:@","];
            
//            NSArray *arr = [[imageArray objectAtIndex:0] componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return [imageArray objectAtIndex:0];
        }
        else
        {
//            NSArray *arr = [dFriend.headImgID componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return dFriend.headImgID;
        }
    }
    else
        return @"no";
}
+(void)deleteFansWithUserName:(NSString*)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSFans * fans = [DSFans MR_findFirstWithPredicate:predicate];
        if (fans) {
            [fans MR_deleteInContext:localContext];
            
            [DataStoreManager cleanIndexWithType:3 nameIndex:fans.nameIndex];
        }
    }];
}
+(BOOL)ifIsFansWithUserName:(NSString*)userName
{
    if (userName) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSFans * dFriends = [DSFans MR_findFirstWithPredicate:predicate];
        if (dFriends) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+ (void)cleanFansList//清空
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dFriend = [DSFans MR_findAllInContext:localContext];
        for (DSFans* friend in dFriend) {
            [friend deleteInContext:localContext];
        }
        NSArray * dFriend_index = [DSFansNameIndex MR_findAllInContext:localContext];
        for (DSFansNameIndex* friendIndex in dFriend_index) {
            [friendIndex deleteInContext:localContext];
        }
    }];
}
#pragma mark - 是否存在这个联系人
+(BOOL)ifHaveThisUser:(NSString *)userName
{
    if (userName) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriends) {
            return YES;
        }
//        DSAttentions * dAttention = [DSAttentions MR_findFirstWithPredicate:predicate];
//        if (dAttention) {
//            return YES;
//        }
//        DSAttentions * dFans = [DSAttentions MR_findFirstWithPredicate:predicate];
//        if (dFans) {
//            return YES;
//        }
        return NO;
    }
    else
        return NO;
}

#pragma mark - 存储好友相关
+(BOOL)ifHaveThisFriend:(NSString *)userName
{
    if (userName) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriends) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;

}

+(BOOL)ifFriendHaveNicknameAboutUser:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSFriends * dFriends = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriends) {
        if (dFriends.nickName.length>1) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+(NSMutableArray *)querySections
{
    NSMutableArray * sectionArray = [NSMutableArray array];
    NSArray * nameIndexArray2 = [DSNameIndex MR_findAll];
    NSMutableArray * nameIndexArray = [NSMutableArray array];
    for (int i = 0; i<nameIndexArray2.count; i++) {
        DSNameIndex * di = [nameIndexArray2 objectAtIndex:i];
        [nameIndexArray addObject:di.index];//+,M
    }
    [nameIndexArray sortUsingSelector:@selector(compare:)];
    for (int i = 0; i<nameIndexArray.count; i++) {
        NSMutableArray * array = [NSMutableArray array];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",[nameIndexArray objectAtIndex:i]];
        NSArray * fri = [DSFriends MR_findAllSortedBy:@"nameKey" ascending:YES withPredicate:predicate];
        NSMutableArray * nameKeyArray = [NSMutableArray array];
        for (int i = 0; i<fri.count; i++) {
            NSString * thename = [[fri objectAtIndex:i]userName];
            NSString * nameK = [[fri objectAtIndex:i]nameKey];
            if (![thename isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                [nameKeyArray addObject:nameK];//
            }
        
        }
        [array addObject:[nameIndexArray objectAtIndex:i]];//M
        [array addObject:nameKeyArray];//数组（Marss+Marss）
        [sectionArray addObject:array];
    }
    NSLog(@"sectionArray %@", sectionArray);
    return sectionArray;

}

+ (void)saveFriendRemarkName:(NSString*)remarkName userName:(NSString*)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriend) {
            dFriend.remarkName = remarkName;
        }
        
        NSString* oldNameIndex = dFriend.nameIndex;
        
        NSString * nameIndex;
        NSString * nameKey;
        if (remarkName.length>=1) {
            nameKey = [[DataStoreManager convertChineseToPinYin:remarkName] stringByAppendingFormat:@"+%@",remarkName];
            dFriend.nameKey = nameKey;
            nameIndex = [[nameKey substringToIndex:1] uppercaseString];
            dFriend.nameIndex = nameIndex;
        }
        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
            if (remarkName.length>=1) {
                NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                DSNameIndex * dFname = [DSNameIndex MR_findFirstWithPredicate:predicate2];
                if (!dFname)
                    dFname = [DSNameIndex MR_createInContext:localContext];
                
                dFname.index = nameIndex;
            }
        }
        [DataStoreManager cleanIndexWithType:1 nameIndex:oldNameIndex];
    }];
}

+(NSMutableArray *)queryAllFriendsNickname
{
    NSMutableArray * array = [NSMutableArray array];
    NSArray * fri = [DSFriends MR_findAll];
    for (DSFriends * ggf in fri) {
        NSArray * arry = [NSArray arrayWithObjects:ggf.nickName?ggf.nickName:@"1",ggf.userName, nil];
        [array addObject:arry];
    }
    return array;
}

+(NSMutableArray*)queryAllFriendsWithOtherSortType:(NSString*)sorttype ascend:(BOOL)ascend
{
    NSArray * fri = [DSFriends MR_findAllSortedBy:sorttype ascending:ascend];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableArray * theArr = [NSMutableArray array];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] gender];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔
        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//

        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK)
        {
            NSMutableDictionary* theDict = [NSMutableDictionary dictionary];

            [theDict setObject:userName forKey:@"username"];
            [theDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (![remarkName isEqualToString:@""]) {
                [theDict setObject:remarkName forKey:@"displayName"];
            }
            else if(![nickName isEqualToString:@""]){
                [theDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [theDict setObject:userName forKey:@"displayName"];
            }
            [theDict setObject:headImg ? headImg:@"" forKey:@"img"];
            [theDict setObject:age ? age:@"" forKey:@"age"];
            [theDict setObject:sex ? sex:@"" forKey:@"sex"];
            [theDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [theDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [theDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [theDict setObject:[NSString stringWithFormat:@"%.f", distance] forKey:@"distance"];

            [theArr addObject:theDict];
        }
    }
    return theArr;
}

+(NSMutableDictionary *)queryAllFriends
{
    NSArray * fri = [DSFriends MR_findAll];
    NSMutableArray * nameKeyArray = [NSMutableArray array];
    NSMutableDictionary * theDict = [NSMutableDictionary dictionary];
    for (int i = 0; i<fri.count; i++) {
        NSString * nameK = [[fri objectAtIndex:i]nameKey];
        if (nameK)
            [nameKeyArray addObject:nameK];
        NSString * userName = [[fri objectAtIndex:i] userName];
        NSString * nickName = [[fri objectAtIndex:i] nickName];
        NSString * remarkName = [[fri objectAtIndex:i] remarkName];
        NSString * headImg = [DataStoreManager queryFirstHeadImageForUser:userName];
        NSString * age = [[fri objectAtIndex:i] age];
        NSString * sex = [[fri objectAtIndex:i] gender];//性别
        NSString * achievement = [[fri objectAtIndex:i] achievement];//头衔
        NSString * achievementLevel = [[fri objectAtIndex:i] achievementLevel];//头衔

        NSString * modTime = [[fri objectAtIndex:i] refreshTime];//
        double distance = [[[fri objectAtIndex:i] distance] doubleValue];//

        if (![userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]&&nameK) {
            NSMutableDictionary * friendDict = [NSMutableDictionary dictionary];
            [friendDict setObject:userName forKey:@"username"];
            [friendDict setObject:nickName?nickName:@"" forKey:@"nickname"];
            if (![remarkName isEqualToString:@""]) {
                [friendDict setObject:remarkName forKey:@"displayName"];    
            }
            else if(![nickName isEqualToString:@""]){
                [friendDict setObject:nickName forKey:@"displayName"];
            }
            else
            {
                [friendDict setObject:userName forKey:@"displayName"];
            }
            [friendDict setObject:headImg ? headImg:@"" forKey:@"img"];
            [friendDict setObject:age ? age:@"" forKey:@"age"];
            [friendDict setObject:sex ? sex:@"" forKey:@"sex"];
            [friendDict setObject:achievement ? achievement:@"" forKey:@"achievement"];
            [friendDict setObject:achievementLevel ? achievementLevel:@"" forKey:@"achievementLevel"];
            [friendDict setObject:modTime ? modTime:@"" forKey:@"updateUserLocationDate"];
            [friendDict setObject:[NSString stringWithFormat:@"%.f", distance] forKey:@"distance"];

            
            [theDict setObject:friendDict forKey:nameK];
        }
    }
    return theDict;
}

+(void)deleteFriendWithUserName:(NSString*)username;
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSFriends * dsfriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dsfriend) {
            [dsfriend MR_deleteInContext:localContext];
            [DataStoreManager cleanIndexWithType:1 nameIndex:dsfriend.nameIndex];
        }
    }];
}

#pragma mark -
+(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSString * dd = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return dd;
}

+(void)addFriendToLocal:(NSString *)username
{
    if ([DataStoreManager ifIsAttentionWithUserName:username]) {
        [DataStoreManager deleteAttentionWithUserName:username];
    }
    else if([DataStoreManager ifIsFansWithUserName:username]) {
        [DataStoreManager deleteFansWithUserName:username];
    }

    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * mypostDict = [NSMutableDictionary dictionary];
    [paramDict setObject:username forKey:@"username"];
    
    [mypostDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [mypostDict setObject:paramDict forKey:@"params"];
    [mypostDict setObject:@"106" forKey:@"method"];
    [mypostDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStrNoController:BaseClientUrl Parameters:mypostDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * recDict = responseObject;
        [DataStoreManager saveUserInfo:[recDict objectForKey:@"user"]];
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        NSLog(@"fail");
    }];
//    [NetManager requestWithURLStr:BaseClientUrl Parameters:mypostDict TheController:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * recDict = responseObject;
//        [DataStoreManager saveUserInfo:recDict];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@" shibai");
//    }];
//
/*
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext];
            dFriend.userName = username;
            if (dFriend.nameKey.length<1) {
//                NSString * nameKey = [[DataStoreManager convertChineseToPinYin:username] stringByAppendingFormat:@"+%@",username];
//                dFriend.nameKey = nameKey;
//                dFriend.nameIndex = [[nameKey substringToIndex:1] uppercaseString];
//                NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",dFriend.nameIndex];
//                DSNameIndex * dFname = [DSNameIndex MR_findFirstWithPredicate:predicate2];
//                if (!dFname)
//                    dFname = [DSNameIndex MR_createInContext:localContext];
//                
//                dFname.index = dFriend.nameIndex;
            }
            
        }];
 */
}

+(void)updateFriendInfo:(NSDictionary *)userInfoDict ForUser:(NSString *)username
{
    NSString * nickName = [userInfoDict objectForKey:@"nickname"];
 

    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (dFriend) {
            dFriend.userName = username;
            dFriend.nickName = nickName;
            dFriend.signature = [userInfoDict objectForKey:@"signature"];
        }

    }];

}
+(NSString *)getMyUserID
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        return dFriend.userId;
    }
    else
        return @"";
}
+(void)storeMyUserID:(NSString *)theID
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];//［c］忽略大小写
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (!dFriend)
            dFriend = [DSFriends MR_createInContext:localContext];
        dFriend.userName = [SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil];
        dFriend.userId = theID;
    }];
}
+(NSString *)queryNickNameForUser:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"圈子通知";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {//不是好友 就去粉丝列表查
        if (dFriend.nickName.length>1) {
            return dFriend.nickName;
        }
        else
            return dFriend.userName;
    }
    DSFans* dFans = [DSFans MR_findFirstWithPredicate:predicate];
    if (dFans)
    {
        if (dFans.nickName.length>1) {
            return dFans.nickName;
        }
        else
            return dFans.userName;
    }
    else
        return userName;
}

+(NSString *)getOtherMessageTitleWithUUID:(NSString*)uuid type:(NSString*)type
{
//    NSDate * sendTime = [NSDate dateWithTimeIntervalSince1970:[times doubleValue]];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"messageuuid==[c]%@ AND msgType==[c]%@",uuid,type];
    DSThumbMsgs *msg = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
    if (msg) {
        return msg.senderNickname;
    }
    return @"";
}

+(NSString *)queryRemarkNameForUser:(NSString *)userName
{
    if ([userName isEqualToString:@"1234"]) {
        return @"有新的关注消息";
    }
    if ([userName isEqualToString:@"12345"]) {
        return @"好友推荐";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {//不是好友 就去粉丝、关注列表查
        if (dFriend.remarkName && ![dFriend.remarkName isEqualToString:@""]) {
            return dFriend.remarkName;
        }
        else if(dFriend.nickName && ![dFriend.nickName isEqualToString:@""])
            return dFriend.nickName;
        else
            return userName;
    }
    DSFans* dFans = [DSFans MR_findFirstWithPredicate:predicate];
    if (dFans)
    {
        if (dFans.remarkName && ![dFans.remarkName isEqualToString:@""]) {
            return dFans.remarkName;
        }
        else if(dFans.nickName && ![dFans.nickName isEqualToString:@""])
            return dFans.nickName;
        else
            return userName;
    }
    DSAttentions* dAttention = [DSAttentions MR_findFirstWithPredicate:predicate];
    if (dAttention)
    {
        if (dAttention.remarkName && ![dAttention.remarkName isEqualToString:@""]) {
            return dAttention.remarkName;
        }
        else if(dAttention.nickName && ![dAttention.nickName isEqualToString:@""])
            return dAttention.nickName;
        else
            return userName;
    }
    
    return @"";
}

+(NSString *)queryFirstHeadImageForUser:(NSString *)userName
{
    if ([userName isEqualToString:@"123456789"]) {
        return @"no";
    }
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend.headImgID) {
        NSRange range=[dFriend.headImgID rangeOfString:@","];
        if (range.location!=NSNotFound) {
            NSArray *imageArray = [dFriend.headImgID componentsSeparatedByString:@","];

//            NSArray *arr = [[imageArray objectAtIndex:0] componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return [imageArray objectAtIndex:0];
        }
        else
        {
//            NSArray *arr = [dFriend.headImgID componentsSeparatedByString:@"_"];
//            if (arr.count>1) {
//                return [arr objectAtIndex:0];
//            }
//            else
                return dFriend.headImgID;
        }
    }
    else
        return @"no";
}
#pragma mark - 存储个人信息
+(void)saveUserFriendWithAttentionList:(NSString*)userName
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSAttentions * dAttention = [DSFriends MR_findFirstWithPredicate:predicate];
    
    NSString * myUserName = [GameCommon getNewStringWithId:dAttention.userName];
    NSString * nickName = [GameCommon getNewStringWithId:dAttention.nickName];
    NSString * gender = [GameCommon getNewStringWithId:dAttention.sex];
    NSString * headImgID = [GameCommon getNewStringWithId:dAttention.headImgID];
    NSString * age = [GameCommon getNewStringWithId:dAttention.age];
    NSString * userId = [GameCommon getNewStringWithId:dAttention.userId];
    NSString * alias = [GameCommon getNewStringWithId:dAttention.remarkName];//别名
    NSString * refreshTime = [GameCommon getNewStringWithId:dAttention.refreshTime];
    NSString * distance = [GameCommon getNewStringWithId:dAttention.distance];
    NSString * title = [GameCommon getNewStringWithId:dAttention.achievement];
    NSString * titleLevel = [GameCommon getNewStringWithId:dAttention.achievementLevel];
    
    NSDictionary* titleData = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",titleLevel,@"rarenum", nil];
    NSDictionary* titleObjDic = [NSDictionary dictionaryWithObject:titleData forKey:@"titleObj"];
    
    NSMutableDictionary* myDic = [NSMutableDictionary dictionaryWithCapacity:1];
    [myDic setObject:myUserName forKey:@"username"];
    [myDic setObject:nickName forKey:@"nickname"];
    [myDic setObject:gender forKey:@"gender"];
    [myDic setObject:headImgID forKey:@"img"];
    [myDic setObject:age forKey:@"age"];
    [myDic setObject:userId forKey:@"id"];
    [myDic setObject:alias forKey:@"alias"];
    [myDic setObject:refreshTime forKey:@"updateUserLocationDate"];
    [myDic setObject:distance forKey:@"distance"];
    [myDic setObject:titleObjDic forKey:@"title"];
    
    [DataStoreManager saveUserInfo:myDic];
}
+(void)saveUserInfo:(NSDictionary *)myInfo
{
    NSString * myUserName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"username"]];
    NSString * background = [GameCommon getNewStringWithId:[myInfo objectForKey:@"backgroundImg"]];
    NSString * nickName = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nickname"]];
    NSString * gender = [GameCommon getNewStringWithId:[myInfo objectForKey:@"gender"]];
    NSString * headImgID = [GameCommon getNewStringWithId:[myInfo objectForKey:@"img"]];
    NSString * signature = [GameCommon getNewStringWithId:[myInfo objectForKey:@"signature"]];
    
    NSString * age = [GameCommon getNewStringWithId:[myInfo objectForKey:@"age"]];
    NSString * userId = [GameCommon getNewStringWithId:[myInfo objectForKey:@"id"]];
    NSString * achievement = [GameCommon getNewStringWithId:[myInfo objectForKey:@"achievement"]];
    NSString * alias = [GameCommon getNewStringWithId:[myInfo objectForKey:@"alias"]];//别名
    
    NSString * starSign = [GameCommon getNewStringWithId:[myInfo objectForKey:@"constellation"]];
    NSString * hobby = [GameCommon getNewStringWithId:[myInfo objectForKey:@"remark"]];
    NSString * birthday = [GameCommon getNewStringWithId:[myInfo objectForKey:@"birthdate"]];
    NSString * createTime = [GameCommon getNewStringWithId:[myInfo objectForKey:@"createTime"]];
//    NSString * nameIndex = [GameCommon getNewStringWithId:[myInfo objectForKey:@"nameindex"]];
    NSString * refreshTime = [GameCommon getNewStringWithId:[myInfo objectForKey:@"updateUserLocationDate"]];
    double distance = [KISDictionaryHaveKey(myInfo, @"distance") doubleValue];
    if (distance == -1) {//若没有距离赋最大值
        distance = 9999000;
    }
    NSString * titleObj = @"";
    NSString * titleObjLevel = @"";
    
    NSDictionary* titleDic = KISDictionaryHaveKey(myInfo, @"title");
    if ([titleDic isKindOfClass:[NSDictionary class]]) {
        titleObj = KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"title");
        titleObjLevel = [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(titleDic, @"titleObj"), @"rarenum")];
    }
    else
    {
        titleObj = @"暂无头衔";
        titleObjLevel = @"6";
    }

    NSString * superstar = [GameCommon getNewStringWithId:KISDictionaryHaveKey(myInfo, @"superstar")];//是否为明星用户
    NSString * superremark = [GameCommon getNewStringWithId:KISDictionaryHaveKey(myInfo, @"superremark")];
    if (myUserName) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",myUserName];
            DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
            if (!dFriend)
                dFriend = [DSFriends MR_createInContext:localContext]; 
            dFriend.userName = myUserName;
            dFriend.nickName = nickName?(nickName.length>1?nickName:[nickName stringByAppendingString:@" "]):@"";
            dFriend.gender = gender?gender:@"";
            dFriend.userId = userId?userId:@"";
            dFriend.headImgID = headImgID?headImgID:@"";
            dFriend.signature = signature?signature:@"";
            dFriend.age = age?age:@"";
            dFriend.backgroundImg = background;
            dFriend.achievement = achievement?achievement:@"";
            
            dFriend.starSign = starSign?starSign:@"";
            dFriend.hobby = hobby?hobby:@"";
            dFriend.birthday = birthday?birthday:@"";
            dFriend.createTime = createTime?createTime:@"";
            dFriend.remarkName = alias?alias:@"";
            
            dFriend.superstar = superstar?superstar:@"";
            dFriend.superremark = superremark?superremark:@"";

            dFriend.achievement = titleObj;
            dFriend.achievementLevel = titleObjLevel;
            dFriend.refreshTime = refreshTime;
            dFriend.distance = [NSNumber numberWithDouble:distance];

            NSString* pinYin = [alias isEqualToString:@""] ? nickName : alias;
            NSString * nameIndex;
            NSString * nameKey;
            if (nickName.length>=1) {
                nameKey = [[DataStoreManager convertChineseToPinYin:pinYin] stringByAppendingFormat:@"+%@",pinYin];
                dFriend.nameKey = nameKey;
                nameIndex = [[nameKey substringToIndex:1] uppercaseString];
                dFriend.nameIndex = nameIndex;
            }
            if (![myUserName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {
                if (nickName.length>=1) {
                NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                DSNameIndex * dFname = [DSNameIndex MR_findFirstWithPredicate:predicate2];
                if (!dFname)
                    dFname = [DSNameIndex MR_createInContext:localContext];
                
                dFname.index = nameIndex;
                }
            }
        }];
      }
}

+ (void)cleanFriendList
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dFriend = [DSFriends MR_findAllInContext:localContext];
        for (DSFriends* friend in dFriend) {
            NSLog(@"%@", friend.userName);
            if (![friend.userName isEqualToString:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]]) {//本人不清
                [friend deleteInContext:localContext];
            }
        }
        NSArray * dFriend_index = [DSNameIndex MR_findAllInContext:localContext];
        for (DSNameIndex* friendIndex in dFriend_index) {
            [friendIndex deleteInContext:localContext];
        }
    }];
}

+(void)saveMyBackgroungImg:(NSString*)backgroundImg
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
        if (!dFriend)
            dFriend = [DSFriends MR_createInContext:localContext];
        dFriend.backgroundImg = backgroundImg;
    }];
}

/*
+(void)storePetInfo:(NSDictionary *)myInfo
{
//    NSArray * petArray = [myInfo objectForKey:@"petInfoViews"];
//
//    for (int i = 0; i<petArray.count; i++) {
//        NSString * hostName = [myInfo objectForKey:@"username"];
//        NSString * hostNickName = [myInfo objectForKey:@"nickname"];
//        NSString * nickName = [[petArray objectAtIndex:i] objectForKey:@"nickname"];
//        NSString * gender = [[petArray objectAtIndex:i] objectForKey:@"gender"];
//        NSString * headImgID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"img"]];
//        NSString * trait = [[petArray objectAtIndex:i] objectForKey:@"trait"];
//        NSString * type = [self toString:[[petArray objectAtIndex:i] objectForKey:@"type"]];
//        NSString * age = [self toString:[[petArray objectAtIndex:i] objectForKey:@"birthdate"]];
//        NSString * petID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"id"]];
//        NSString * userID = [self toString:[[petArray objectAtIndex:i] objectForKey:@"userid"]];
//        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
//            DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
//            if (!dPet)
//                dPet = [DSPets MR_createInContext:localContext];
//            dPet.friendName = hostName?hostName:@"";
//            dPet.friendNickname = hostNickName?hostNickName:@"";
//            dPet.petNickname = nickName?nickName:@"";
//            dPet.petGender = gender?gender:@"";
//            dPet.petHeadImgID = headImgID?headImgID:@"";
//            dPet.petTrait = trait?trait:@"";
//            dPet.petType = type?type:@"";
//            dPet.petAge = age?age:@"";
//            dPet.petID = petID?petID:@"";
//            dPet.userID = userID?userID:@"";
//        }];
//    }
}

+(void)storeOnePetInfo:(NSDictionary *)petInfo
{

//    NSString * nickName = [petInfo objectForKey:@"nickname"];
//    NSString * gender = [petInfo objectForKey:@"gender"];
//    NSString * headImgID = [self toString:[petInfo objectForKey:@"img"]];
//    NSString * trait = [petInfo objectForKey:@"trait"];
//    NSString * type = [self toString:[petInfo objectForKey:@"type"]];
//    NSString * age = [self toString:[petInfo objectForKey:@"birthdate"]];
//    NSString * petID = [self toString:[petInfo objectForKey:@"id"]];
//    NSString * userID = [self toString:[petInfo objectForKey:@"userid"]];
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
//        DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
//        if (!dPet)
//            dPet = [DSPets MR_createInContext:localContext];
//        dPet.petNickname = nickName?nickName:@"";
//        dPet.petGender = gender?gender:@"";
//        dPet.petHeadImgID = headImgID?headImgID:@"";
//        dPet.petTrait = trait?trait:@"";
//        dPet.petType = type?type:@"";
//        dPet.petAge = age?age:@"";
//        dPet.petID = petID?petID:@"";
//        dPet.userID = userID?userID:@"";
//    }];
}

+(void)deleteOnePetForPetID:(NSString *)petID
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"petID==[c]%@",petID];
        DSPets * dPet = [DSPets MR_findFirstWithPredicate:predicate];
        if (dPet) {
            [dPet MR_deleteInContext:localContext];
        }
    }];
}*/

+(NSMutableDictionary *)queryOneFriendInfoWithUserName:(NSString *)userName
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        [dict setObject:dFriend.userName forKey:@"username"];
        [dict setObject:dFriend.userId?dFriend.userId:@"" forKey:@"userid"];
        [dict setObject:dFriend.nickName?dFriend.nickName:@"" forKey:@"nickname"];
        [dict setObject:dFriend.gender?dFriend.gender:@"" forKey:@"gender"];
        [dict setObject:dFriend.signature?dFriend.signature:@"" forKey:@"signature"];
        [dict setObject:@"0" forKey:@"latitude"];
        [dict setObject:@"0" forKey:@"longitude"];
        [dict setObject:dFriend.age?dFriend.age:@"" forKey:@"birthdate"];
        [dict setObject:dFriend.headImgID?dFriend.headImgID:@"" forKey:@"img"];
//        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"friendName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
//        NSArray * tempArray = [DSPets MR_findAllWithPredicate:predicate2];
//        NSMutableArray * petArray = [NSMutableArray array];
//        for (DSPets * petThis in tempArray) {
//            NSMutableDictionary * petDict = [NSMutableDictionary dictionary];
//            [petDict setObject:petThis.petNickname forKey:@"nickname"];
//            [petDict setObject:petThis.petType forKey:@"type"];
//            [petDict setObject:petThis.petTrait forKey:@"trait"];
//            [petDict setObject:petThis.petGender forKey:@"gender"];
//            [petDict setObject:petThis.petAge forKey:@"birthdate"];
//            [petDict setObject:petThis.petHeadImgID forKey:@"img"];
//            [petArray addObject:petDict];
//        }
//        [dict setObject:petArray forKey:@"petInfoViews"];
        
    }
    return dict;
    
}


+(NSDictionary *)queryMyInfo
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    if (dFriend) {
        [dict setObject:dFriend.userName forKey:@"username"];
        [dict setObject:dFriend.userId forKey:@"id"];
        [dict setObject:dFriend.nickName forKey:@"nickname"];
        [dict setObject:dFriend.gender forKey:@"gender"];
        [dict setObject:dFriend.signature forKey:@"signature"];
        [dict setObject:@"0" forKey:@"latitude"];
        [dict setObject:@"0" forKey:@"longitude"];
        [dict setObject:dFriend.age forKey:@"birthdate"];
        [dict setObject:dFriend.headImgID forKey:@"img"];
//        [dict setObject:dFriend.theCity forKey:@"city"];
//        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"userID==[c]%@",dFriend.userId];
//        NSArray * tempArray = [DSPets MR_findAllWithPredicate:predicate2];
//        NSMutableArray * petArray = [NSMutableArray array];
//        for (DSPets * petThis in tempArray) {
//            NSMutableDictionary * petDict = [NSMutableDictionary dictionary];
//            [petDict setObject:petThis.petNickname forKey:@"nickname"];
//            [petDict setObject:petThis.petType forKey:@"type"];
//            [petDict setObject:petThis.petTrait forKey:@"trait"];
//            [petDict setObject:petThis.petID forKey:@"id"];
//            [petDict setObject:petThis.petGender forKey:@"gender"];
//            [petDict setObject:petThis.petAge forKey:@"birthdate"];
//            [petDict setObject:petThis.petHeadImgID forKey:@"img"];
//            [petArray addObject:petDict];
//            if (petArray.count>=8) {
//                break;
//            }
//        }
//        [dict setObject:petArray forKey:@"petInfoViews"];
        [dict setObject:dFriend.backgroundImg forKey:@"backgroundImg"];
        
    }
    return dict;
}

//- (NSString*)getAgeWithBirthday:(NSString*)birthDay
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    
//    
//    NSTimeInterval dateDiff = [birthDate timeIntervalSinceNow];
//    int age=trunc(dateDiff/(60*60*24))/365;
//    
//
//}

+(NSString *)toString:(id)object
{
    return [NSString stringWithFormat:@"%@",object?object:@""];
}

#pragma mark -清理索引
+ (NSString*)getMyNameIndex
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userId==[c]%@",[DataStoreManager getMyUserID]];
    NSArray * dFriend = [DSFriends MR_findAllWithPredicate:predicate];
    if ([dFriend count] != 0) {
        return [[dFriend objectAtIndex:0] nameIndex];
    }
    return @"";
}

+ (void)cleanIndexWithType:(NSInteger)type nameIndex:(NSString*)nameIndex
{
    if (type == 1) {//好友
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",nameIndex];
        NSArray * dFriend = [DSFriends MR_findAllWithPredicate:predicate];
        if ([dFriend count] == 0 || ([dFriend count] == 1 && [nameIndex isEqualToString:[DataStoreManager getMyNameIndex]])) {
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSPredicate* predicateIndex = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                DSNameIndex* name = [DSNameIndex MR_findFirstWithPredicate:predicateIndex];
                [name MR_deleteInContext:localContext];
            }];
        }
    }
    else if(type == 2)//关注
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",nameIndex];
        NSArray * dFriend = [DSAttentions MR_findAllWithPredicate:predicate];
        if ([dFriend count] == 0) {
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSPredicate* predicateIndex = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                DSAttentionNameIndex* name = [DSAttentionNameIndex MR_findFirstWithPredicate:predicateIndex];
                [name MR_deleteInContext:localContext];
            }];
        }
    }
    else//粉丝
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nameIndex==[c]%@",nameIndex];
        NSArray * dFriend = [DSFans MR_findAllWithPredicate:predicate];
        if ([dFriend count] == 0) {
            
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                NSPredicate* predicateIndex = [NSPredicate predicateWithFormat:@"index==[c]%@",nameIndex];
                DSFansNameIndex* name = [DSFansNameIndex MR_findFirstWithPredicate:predicateIndex];
                [name MR_deleteInContext:localContext];
            }];
        }
    }
}


#pragma mark - 动态
//@dynamic heardImgId;
//@dynamic newsId;
//@dynamic bigTitle;
//@dynamic msg;
//@dynamic imageStr;
//@dynamic detailPageId;
//@dynamic createDate;
//@dynamic nickName;
//@dynamic commentObj;
//@dynamic urlLink;
//@dynamic img userid
+(void)saveMyNewsWithData:(NSDictionary*)dataDic
{
    NSString * heardImgId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"userimg"]];
    NSString * newsId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"id"]];
    NSString * bigTitle = [GameCommon getNewStringWithId:[dataDic objectForKey:@"title"]];
    NSString * msg = [GameCommon getNewStringWithId:[dataDic objectForKey:@"msg"]];
//    NSString * imageStr = [GameCommon getNewStringWithId:[dataDic objectForKey:@"hide"]];
    NSString * detailPageId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"detailPageId"]];
    NSString * createDate = [GameCommon getNewStringWithId:[dataDic objectForKey:@"createDate"]];
    NSString * nickName = [GameCommon getNewStringWithId:[dataDic objectForKey:@"alias"]];
    if ([nickName isEqualToString:@""]) {
        nickName = [GameCommon getNewStringWithId:[dataDic objectForKey:@"nickname"]];
    }
    NSString * type = [GameCommon getNewStringWithId:[dataDic objectForKey:@"type"]];
    NSString * commentObj = [GameCommon getNewStringWithId:[dataDic objectForKey:@"commentObj"]];
    NSString * urlLink = [GameCommon getNewStringWithId:[dataDic objectForKey:@"urlLink"]];
    NSString * img = [GameCommon getNewStringWithId:[dataDic objectForKey:@"img"]];
    NSString * zannum = [GameCommon getNewStringWithId:[dataDic objectForKey:@"zannum"]];
    NSString * userid = [GameCommon getNewStringWithId:[dataDic objectForKey:@"userid"]];
    NSString * username = [GameCommon getNewStringWithId:[dataDic objectForKey:@"username"]];

    if (newsId) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"newsId==[c]%@",newsId];
            DSMyNewsList * dMyNews = [DSMyNewsList MR_findFirstWithPredicate:predicate];
            if (!dMyNews)
                dMyNews = [DSMyNewsList MR_createInContext:localContext];
            dMyNews.heardImgId = heardImgId;
            dMyNews.newsId = newsId;
            dMyNews.bigTitle = bigTitle;
            dMyNews.msg = msg;
            dMyNews.detailPageId = detailPageId;
            dMyNews.createDate = createDate;
            dMyNews.nickName = nickName;
            dMyNews.type = type;
            dMyNews.commentObj = commentObj;
            dMyNews.urlLink = urlLink;
            dMyNews.img = img;
            dMyNews.zannum = zannum;
            dMyNews.userid = userid;
            dMyNews.username = username;
        }];
    }
}

+(void)cleanMyNewsList
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dMyNews = [DSMyNewsList MR_findAllInContext:localContext];
        for (DSMyNewsList* news in dMyNews) {
            [news deleteInContext:localContext];
        }
    }];
}

+(void)saveFriendsNewsWithData:(NSDictionary*)dataDic
{
    NSString * heardImgId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"userimg"]];
    NSString * newsId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"id"]];
    NSString * bigTitle = [GameCommon getNewStringWithId:[dataDic objectForKey:@"title"]];
    NSString * msg = [GameCommon getNewStringWithId:[dataDic objectForKey:@"msg"]];
    //    NSString * imageStr = [GameCommon getNewStringWithId:[dataDic objectForKey:@"hide"]];
    NSString * detailPageId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"detailPageId"]];
    NSString * createDate = [GameCommon getNewStringWithId:[dataDic objectForKey:@"createDate"]];
    NSString * nickName = [GameCommon getNewStringWithId:[dataDic objectForKey:@"nickname"]];
    NSString * type = [GameCommon getNewStringWithId:[dataDic objectForKey:@"type"]];
    NSString * commentObj = [GameCommon getNewStringWithId:[dataDic objectForKey:@"commentObj"]];
    NSString * urlLink = [GameCommon getNewStringWithId:[dataDic objectForKey:@"urlLink"]];
    NSString * img = [GameCommon getNewStringWithId:[dataDic objectForKey:@"img"]];
    NSString * zannum = [GameCommon getNewStringWithId:[dataDic objectForKey:@"zannum"]];
    NSString * userid = [GameCommon getNewStringWithId:[dataDic objectForKey:@"userid"]];
    NSString * username = [GameCommon getNewStringWithId:[dataDic objectForKey:@"username"]];

    if (newsId) {
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"newsId==[c]%@",newsId];
            DSFriendsNewsList * dFriendsNews = [DSFriendsNewsList MR_findFirstWithPredicate:predicate];
            if (!dFriendsNews)
                dFriendsNews = [DSMyNewsList MR_createInContext:localContext];
            dFriendsNews.heardImgId = heardImgId;
            dFriendsNews.newsId = newsId;
            dFriendsNews.bigTitle = bigTitle;
            dFriendsNews.msg = msg;
            //            dMyNews.imageStr = sortnum;
            dFriendsNews.detailPageId = detailPageId;
            dFriendsNews.createDate = createDate;
            dFriendsNews.nickName = nickName;
            dFriendsNews.type = type;
            dFriendsNews.commentObj = commentObj;
            dFriendsNews.urlLink = urlLink;
            dFriendsNews.img = img;
            dFriendsNews.zannum = zannum;
            dFriendsNews.userid = userid;
            dFriendsNews.username = username;
        }];
    }
}

+(void)cleanFriendsNewsList
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dFriendsNews = [DSMyNewsList MR_findAllInContext:localContext];
        for (DSMyNewsList* news in dFriendsNews) {
            [news deleteInContext:localContext];
        }
    }];
}

//+(void)saveCharacterWithData:(NSDictionary*)dataDic
//{
//    NSString * name = [GameCommon getNewStringWithId:[dataDic objectForKey:@"name"]];
//    NSString * characterId = [GameCommon getNewStringWithId:[dataDic objectForKey:@"id"]];
//    NSString * gameid = [GameCommon getNewStringWithId:[dataDic objectForKey:@"gameid"]];
//    NSString * realm = [GameCommon getNewStringWithId:[dataDic objectForKey:@"realm"]];
//    NSString * clazzid = [GameCommon getNewStringWithId:[dataDic objectForKey:@"clazz"]];
//    NSString * pveScore = [GameCommon getNewStringWithId:[dataDic objectForKey:@"pveScore"]];
//    NSString * auth = [GameCommon getNewStringWithId:[dataDic objectForKey:@"auth"]];
//    
//    if (characterId) {
//        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"characterId==[c]%@",characterId];
//            DSCharacterList * dCharacter = [DSCharacterList MR_findFirstWithPredicate:predicate];
//            if (!dCharacter)
//                dCharacter = [DSCharacterList MR_createInContext:localContext];
//            dCharacter.name = name;
//            dCharacter.characterId = characterId;
//            dCharacter.gameid = gameid;
//            dCharacter.realm = realm;
//            dCharacter.clazzid = clazzid;
//            dCharacter.pveScore = pveScore;
//            dCharacter.auth = auth;//是否认证
//        }];
//    }
//}
//
//+(void)cleanCharacterList
//{
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        NSArray * dCharacter = [DSCharacterList MR_findAllInContext:localContext];
//        for (DSCharacterList* character in dCharacter) {
//                [character deleteInContext:localContext];
//        }
//    }];
//}



#pragma mark - 打招呼存储相关
+(void)deleteAllHello
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSArray * dReceived = [DSReceivedHellos MR_findAllInContext:localContext];
        for (DSReceivedHellos* received in dReceived) {
            [received deleteInContext:localContext];
        }
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"1234"];
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        if (thumbMsgs)
        {
            [thumbMsgs deleteInContext:localContext];
        }
    }];
}

+(void)deleteReceivedHelloWithUserName:(NSString *)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        NSArray * received = [DSReceivedHellos MR_findAllWithPredicate:predicate];
        for (int i = 0; i<received.count; i++) {
            DSReceivedHellos * rH = [received objectAtIndex:i];
            [rH MR_deleteInContext:localContext];
        }
    }];

}

+(void)deleteReceivedHelloWithUserName:(NSString *)userName withTime:(NSString *)times
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@ OR receiveTime==[c]%@",userName,times];
        NSArray * received = [DSReceivedHellos MR_findAllWithPredicate:predicate];
        for (int i = 0; i<received.count; i++) {
            DSReceivedHellos * rH = [received objectAtIndex:i];
            [rH MR_deleteInContext:localContext];
        }
    }];

}

+(NSString *)qureyUnreadForReceivedHellos
{
//    DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
//    int theUnread = [unread.receivedHellosUnread intValue];
    NSArray * allReceived = [DSReceivedHellos MR_findAll];
    int theUnread = 0;
    for (int i = 0; i<allReceived.count; i++) {
        theUnread = theUnread + [[[allReceived objectAtIndex:i] unreadCount] intValue];
    }
    return [NSString stringWithFormat:@"%d",theUnread];
}

+(void)blankReceivedHellosUnreadCount
{
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
//        unread.receivedHellosUnread = @"0";
//    }];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"sender==[c]%@",@"1234"];
        
        DSThumbMsgs * thumbMsgs = [DSThumbMsgs MR_findFirstWithPredicate:predicate];
        thumbMsgs.unRead = @"0";
     }];
}

+(NSDictionary*)addPersonToReceivedHellosWithFriend:(NSString*)userName//从好友表取内容
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFriends * dFriend = [DSFriends MR_findFirstWithPredicate:predicate];
    
    NSString * userNickname = [GameCommon getNewStringWithId:dFriend.remarkName];
    if ([userNickname isEqualToString:@""]) {
        userNickname = [GameCommon getNewStringWithId:dFriend.nickName];
    }
    NSString * headID = [GameCommon getHeardImgId:[GameCommon getNewStringWithId:dFriend.headImgID]];
    return [NSDictionary dictionaryWithObjectsAndKeys:userNickname,@"fromNickname",headID,@"headID", nil];
}

+(NSDictionary*)addPersonToReceivedHellosWithAttention:(NSString*)userName//从好友表取内容
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSAttentions * dAttention = [DSAttentions MR_findFirstWithPredicate:predicate];
    
    NSString * userNickname = [GameCommon getNewStringWithId:dAttention.remarkName];
    if ([userNickname isEqualToString:@""]) {
        userNickname = [GameCommon getNewStringWithId:dAttention.nickName];
    }
    NSString * headID = [GameCommon getHeardImgId:[GameCommon getNewStringWithId:dAttention.headImgID]];
    return [NSDictionary dictionaryWithObjectsAndKeys:userNickname,@"fromNickname",headID,@"headID", nil];
}

+(NSDictionary*)addPersonToReceivedHellosWithFans:(NSString*)userName//从粉丝表取内容
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
    DSFans * dfans = [DSFans MR_findFirstWithPredicate:predicate];
    
    NSString * userNickname = [GameCommon getNewStringWithId:dfans.remarkName];
    if ([userNickname isEqualToString:@""]) {
        userNickname = [GameCommon getNewStringWithId:dfans.nickName];
    }
    NSString * headID = [GameCommon getHeardImgId:[GameCommon getNewStringWithId:dfans.headImgID]];
    return [NSDictionary dictionaryWithObjectsAndKeys:userNickname,@"fromNickname",headID,@"headID", nil];
}

+(void)addPersonToReceivedHellos:(NSDictionary *)userInfoDict
{
    NSString * userName = [userInfoDict objectForKey:@"fromUser"];
    NSString * userNickname = [userInfoDict objectForKey:@"fromNickname"];
    NSString * addtionMsg = [userInfoDict objectForKey:@"addtionMsg"];
    NSString * headID = [self toString:[userInfoDict objectForKey:@"headID"]];
//    NSString * msgType = [userInfoDict objectForKey:@"msgType"];

    NSDate * receiveTime = [NSDate date];
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
//        if (!dReceivedHellos)
//        {
            dReceivedHellos = [DSReceivedHellos MR_createInContext:localContext];
//        }
        dReceivedHellos.userName = userName;
        dReceivedHellos.nickName = userNickname?userNickname:@"";
        dReceivedHellos.addtionMsg = addtionMsg?addtionMsg:@"";
        dReceivedHellos.headImgID = headID?headID:@"";
        dReceivedHellos.receiveTime = receiveTime;
        dReceivedHellos.acceptStatus = @"waiting";
        if (dReceivedHellos.unreadCount.length>0) {
            dReceivedHellos.unreadCount = [NSString stringWithFormat:@"%d",[dReceivedHellos.unreadCount intValue]+1];
        }
        else
            dReceivedHellos.unreadCount = @"1";
        
//        DSCommonMsgs * commonMsg = [DSCommonMsgs MR_createInContext:localContext];
//        commonMsg.sender = userName;
//        commonMsg.senderNickname = userNickname?userNickname:@"";
//        commonMsg.msgContent = addtionMsg?addtionMsg:@"";
//        commonMsg.senTime = receiveTime;
        
//        DSUnreadCount * unread = [DSUnreadCount MR_findFirst];
//        if (!unread) {
//            unread = [DSUnreadCount MR_createInContext:localContext];
//            unread.receivedHellosUnread = @"1";
//        }
//        else
//        {
//            int theUnread = [unread.receivedHellosUnread intValue];
//            unread.receivedHellosUnread = [NSString stringWithFormat:@"%d",theUnread+1];
//        }
        
    }];
}

+(void)blankUnreadCountReceivedHellosForUser:(NSString *)username
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
        DSReceivedHellos * dr = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (dr) {
            dr.unreadCount = @"0";
        }
    }];
}

+(NSArray *)queryAllReceivedHellos
{
    NSArray * rechellos = [DSReceivedHellos MR_findAllSortedBy:@"receiveTime" ascending:NO];
    NSMutableArray * hellosArray = [NSMutableArray array];
    for (int i = 0; i<rechellos.count; i++) {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:[[rechellos objectAtIndex:i] userName] forKey:@"userName"];
        [dict setObject:[[rechellos objectAtIndex:i] nickName] forKey:@"nickName"];
        //        NSRange range=[[[rechellos objectAtIndex:i] headImgID] rangeOfString:@","];
        //        if (range.location!=NSNotFound) {
        ////            NSArray *imageArray = [[[rechellos objectAtIndex:i] headImgID] componentsSeparatedByString:@","];
        //            [dict setObject:[[rechellos objectAtIndex:i] headImgID] forKey:@"headImgID"];
        //        }
        //        else
        [dict setObject:[[rechellos objectAtIndex:i] headImgID] forKey:@"headImgID"];
        [dict setObject:[[rechellos objectAtIndex:i] addtionMsg] forKey:@"addtionMsg"];
        [dict setObject:[[rechellos objectAtIndex:i] acceptStatus] forKey:@"acceptStatus"];
        [dict setObject:[[rechellos objectAtIndex:i] receiveTime] forKey:@"receiveTime"];
        [dict setObject:[[rechellos objectAtIndex:i] unreadCount] forKey:@"unread"];
        
        [hellosArray addObject:dict];
    }
    return hellosArray;
}

+(NSDictionary *)qureyLastReceivedHello
{
    NSArray * rechellos = [DSReceivedHellos MR_findAllSortedBy:@"receiveTime" ascending:YES];
    NSMutableDictionary * lastHelloDict = [NSMutableDictionary dictionary];
    [lastHelloDict setObject:ZhaoHuLan forKey:@"sender"];
    if (rechellos.count>0) {
        DSReceivedHellos * lastRecHello = [rechellos lastObject];
        NSDate * tt = [lastRecHello receiveTime];
        NSTimeInterval uu = [tt timeIntervalSince1970];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
        [lastHelloDict setObject:[NSString stringWithFormat:@"%@:%@",[lastRecHello nickName],[lastRecHello addtionMsg]] forKey:@"msg"];
    }
    //    else
    //    {
    //        NSTimeInterval uu = [[NSDate date] timeIntervalSince1970];
    //        [lastHelloDict setObject:[NSString stringWithFormat:@"%f",uu] forKey:@"time"];
    //        [lastHelloDict setObject:@"暂时还没有新朋友" forKey:@"msg"];
    //    }
    return lastHelloDict;
}

+(BOOL)ifSayHellosHaveThisPerson:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
    if (dReceivedHellos) {
        return YES;
    }
    else
        return NO;
}
+(BOOL)checkSayHelloPersonIfHaveNickNameForUsername:(NSString *)username
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",username];
    DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
    if (dReceivedHellos) {
        if (dReceivedHellos.nickName.length>1) {
            return YES;
        }
        else
            return NO;
    }
    else
        return NO;
}

+(void)updateReceivedHellosStatus:(NSString *)theStatus ForPerson:(NSString *)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSReceivedHellos * dReceivedHellos = [DSReceivedHellos MR_findFirstWithPredicate:predicate];
        if (dReceivedHellos)
        {
            dReceivedHellos.acceptStatus = theStatus;
        }
    }];
}

#pragma mark 好友推荐
//@property (nonatomic, retain) NSString * fromStr;
//@property (nonatomic, retain) NSString * state;
//@property (nonatomic, retain) NSString * fromID;
//@property (nonatomic, retain) NSString * headImgID;
//@property (nonatomic, retain) NSString * nickName;
//@property (nonatomic, retain) NSString * userName;
//{"regtime":1387173496000,"username":"13371669965","remark":null,"nickname":"Fan","userid":"00000006","type":3,"guild":"黎明之翼"}
+(void)saveRecommendWithData:(NSDictionary*)userInfoDict
{
    NSString * userName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfoDict, @"username")];
    NSString * userNickname = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfoDict, @"nickname")];
    NSString * fromID = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfoDict, @"type")];
    NSArray* headArr = [[GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfoDict, @"img")] componentsSeparatedByString:@","];
    NSString * headImgID = [headArr count] != 0 ? [headArr objectAtIndex:0] : @"";
    NSString * fromStr = @"";
    if([fromID isEqualToString:@"1"])
    {
      fromStr = @"手机通讯录";
    }
    else if ([fromID isEqualToString:@"2"])
    {
        fromStr = @"明星";
    }
    else if ([fromID isEqualToString:@"3"])
    {
        fromStr = [NSString stringWithFormat:@"%@公会", [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfoDict, @"guild")]];
    }
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
        DSRecommendList * Recommend = [DSRecommendList MR_findFirstWithPredicate:predicate];
        if (!Recommend)
        {
            Recommend = [DSRecommendList MR_createInContext:localContext];
        }
        Recommend.userName = userName;
        Recommend.nickName = userNickname;
        if ([DataStoreManager ifHaveThisFriend:userName] || [DataStoreManager ifIsAttentionWithUserName:userName]) {
            Recommend.state = @"1";
        }
        else
            Recommend.state = @"0";

        Recommend.headImgID = headImgID;
        Recommend.fromStr = fromStr;
        Recommend.fromID = fromID;
    }];

}

+(void)updateRecommendStatus:(NSString *)theStatus ForPerson:(NSString *)userName
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",userName];
         DSRecommendList * Recommend = [DSRecommendList MR_findFirstWithPredicate:predicate];
        if (Recommend)
        {
            Recommend.state = theStatus;
        }
    }];
}

@end
