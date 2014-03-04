//
//  HostInfo.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "HostInfo.h"
/*
 characters =     {
 1 =         (游戏
 {
 clazz = 0;
 content = " ";
 failedmsg = " ";
 failednum = 0;
 filepath = "/home/appusr/characters/\U77f3\U722a\U5cf0/\U9f99\U6218\U4e5d\U5929.zip";
 gender = 0;
 guild = "Dark Legion";工会
 guildRealm = "\U77f3\U722a\U5cf0";服务器
 id = 5448;
 iscatch = 1;
 lastModified = 0;
 level = 0;角色等级
 mountsnum = 0;
 name = "\U9f99\U6218\U4e5d\U5929";角色名
 pveScore = 0;战斗力
 realm = "\U77f3\U722a\U5cf0";服务器
 totalHonorableKills = 0;荣誉击杀数
 
 titlesObj =                     (//头衔
 {
 characterid = 1802;   //游戏角色ID
 
 hasDate = 1387870544000;
 hide = 0;
 id = 379;
 rarememo = 9;
 realm = "\U77f3\U722a\U5cf0";
 sortnum = 3;
 titleObj =                             {
 createDate = 1387853956000;
 evolution = 0;
 gameid = 1;
 id = 6;
 img = " ";
 rarenum = 1;
 remark = " ";
 simpletitle = "\U670d\U52a1\U5668\U5341\U5927\U6218\U795e";
 sortnum = 1;
 title = "\U670d\U52a1\U5668\U5341\U5927\U6218\U795e";
 titlekey = "wow_pvescore_realm";
 };
 titleid = 6;
 userimg = " ";
 },
 }
 );
 
 */
@implementation HostInfo
- (id)initWithHostInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        
        self.characters = KISDictionaryHaveKey(info, @"characters");//角色
        
        self.achievementArray = KISDictionaryHaveKey(info, @"title");//头衔
        
        self.state = KISDictionaryHaveKey(info, @"dynamicmsg");//动态

//获取游戏角色列表
        //NSDictionary *charaDic = KISDictionaryHaveKey(info, @"dynamicmsg");
        if (![self.state isKindOfClass:[NSDictionary class]]) {
            ;
        }else{
         NSDictionary *dic =KISDictionaryHaveKey(self.state, @"titleObj");
        if ([dic isKindOfClass:[NSDictionary class]]) {
           
            
            NSLog(@"charaDic%@",dic);
            
             self.gameid = [GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"gameid")];
             self.characterid = [GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"characterid")];
            
            NSLog(@"各种ID%@--%@",self.gameid,self.characterid);

        }else{
            NSLog(@"字典为空");

        }
        }
        self.zanNum = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"zannum")];
        self.fanNum = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"fansnum")];

        NSDictionary* userInfo = KISDictionaryHaveKey(info, @"user");
        if (![userInfo isKindOfClass:[NSDictionary class]]) {
            return self;
        }
        self.infoDic = userInfo;
        if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"active")] intValue] == 2) {
            self.active = YES;
        }else
        {
            self.active = NO;
        }
        self.superstar = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"superstar")];
        self.superremark = KISDictionaryHaveKey(userInfo, @"superremark");
        self.updateTime = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"updateUserLocationDate")];
        self.distrance = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"distance")];
        
        
        self.relation = [NSString stringWithFormat:@"%@",KISDictionaryHaveKey(info, @"shiptype")];// 1 好友，2 关注 3 粉丝 4 陌生人
        
        self.createTime = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"createTime")];
        self.starSign = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"constellation")];
        
        self.birthdate = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"birthdate")];
        self.alias = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"alias")];

        self.clazzId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"clazz")];
        
        self.userName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"username")];
        self.userId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"id")];
        self.nickName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"nickname")];
        self.telNumber = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"phoneNumber")];
        self.gender = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"gender")];
        self.age = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"age")];
        
        self.signature = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"signature")];
        self.hobby = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"remark")];//说明、标签
        self.latitude = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"latitude")];
        self.longitude = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"longitude")];
        self.region = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"city")];

        self.headImgStr = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"img")];
        [self getHead:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"img"]]];
    
        self.backgroundImg = [GameCommon getNewStringWithId:KISDictionaryHaveKey(userInfo, @"backgroundImg")];
    }
    return self;
}

//- (void)getTitleObj//头衔
//{
//    NSArray* characterArray = KISDictionaryHaveKey(self.characters, @"1");//魔兽世界的角色
//    if (![characterArray isKindOfClass:[NSArray class]]) {
//        return;
//    }
//    NSMutableDictionary* allTitleDic = [NSMutableDictionary dictionaryWithCapacity:1];
//    for (NSDictionary* info in characterArray) {
//        NSArray* titleObj = KISDictionaryHaveKey(info, @"titlesObj");
//        if (![titleObj isKindOfClass:[NSArray class]]) {
//            return;
//        }
//        if ([titleObj count] > 0) {
//            for (NSDictionary* oneTitleObj in titleObj) {
////                NSString* key = [GameCommon getNewStringWithId: KISDictionaryHaveKey(oneTitleObj, @"sortnum")];//顺序
//                NSString* key = KISDictionaryHaveKey(oneTitleObj, @"sortnum");//顺序
//
//                NSMutableDictionary* infoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:KISDictionaryHaveKey(oneTitleObj, @"hide"),@"hide",KISDictionaryHaveKey(oneTitleObj, @"hasDate"),@"hasDate",[GameCommon getNewStringWithId:KISDictionaryHaveKey(oneTitleObj, @"titleid")],@"titleid",[GameCommon getNewStringWithId:KISDictionaryHaveKey(oneTitleObj, @"sortnum")],@"sortnum", KISDictionaryHaveKey(KISDictionaryHaveKey(oneTitleObj, @"titleObj"), @"title"),@"title", KISDictionaryHaveKey(KISDictionaryHaveKey(oneTitleObj, @"titleObj"), @"img"),@"img",nil];
//               
//                [allTitleDic setObject:infoDic forKey:key];
//            }
//            
//        }
//    }
////    NSArray* keySort = [allTitleDic keysSortedByValueUsingSelector:@selector(compare:)];
//    NSArray* keySort = [[allTitleDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
//    
//    self.achievementArray = [NSMutableArray arrayWithCapacity:1];
//    if ([keySort count] > 0) {
//        for (int i = 0; i < [keySort count]; i++) {
//            [self.achievementArray addObject:[allTitleDic objectForKey:[keySort objectAtIndex:i]]];
//        }
//    }
//    NSLog(@"头衔： %@", self.achievementArray);
//}

- (NSArray *)getHeadImgArray:(NSString *)headImgStr
{
    NSRange range=[headImgStr rangeOfString:@","];
    if (range.location!=NSNotFound) {
        NSArray *imageArray = [headImgStr componentsSeparatedByString:@","];
        return imageArray;
    }
    else if(headImgStr.length>0)
    {
        NSArray * imageArray = [NSArray arrayWithObject:headImgStr];
        return imageArray;
    }
    else
        return nil;
    
    
}
-(void)getHead:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>0) {
        for (NSString* a in i) {
            if (![a isEqualToString:@""]) {
                [littleHeadArray addObject:a];
            }
        }
    }//动态大图ID数组和小图ID数组
    self.headImgArray = littleHeadArray;
}

@end

