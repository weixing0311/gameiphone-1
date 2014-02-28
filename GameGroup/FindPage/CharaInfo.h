//
//  CharaInfo.h
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharaInfo : NSObject
/*
 {
 entity =     {
 auth = 0;                   //是否认证 0未认证 1已认证
 classObj =         {         //职业详细信息
 id = 1;                     //职业
 mask = 1;
 name = "\U6218\U58eb";       职业中文名字
 powerType = rage;             系统 比如怒气
 };
 clazz = 1;           职业
 gender = 0;           性别
 guild = " ";         公会
 id = 158169;          角色id 数据库id
 itemlevel = 507;      装等
  = 507; 当前装备装等
 level = 90;           等级
 mountsnum = 79;      坐骑数量
 name = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";   昵称 人物名字
 pveScore = 200;             战斗力pve
 race = 10;                   种族
 raceObj =         {          种族详细
 id = 10;                      种族
 mask = 512;
 name = "\U8840\U7cbe\U7075";   种族中文名称
 side = horde;                  阵营
 sidename = "\U90e8\U843d";     阵营名字
 };
 realm = "\U51b0\U971c\U4e4b\U5203";  服务器
 thumbnail = 14077;             头像
 
 
 totalHonorableKills = 253;
 };
 errorcode = 0;
 sn = EBA906CFA74A42F78430D4B9B5A8E4CC;
 }
 
 PVE战斗力  荣誉击杀数            装备等级         成就点数         PVP竞技场
 pveScore itemlevelequipped
 */
@property(nonatomic,strong)NSDictionary *entity;           //角色数据
@property(nonatomic,strong)NSDictionary *raceObj;           //种族详细
@property(nonatomic,strong)NSDictionary *classObj;         //职业详情

@property(nonatomic,strong)NSDictionary *listContentDic;  //表格里面的数据
@property(nonatomic,strong)NSDictionary *friendOfRanking; //好友中的排名
@property(nonatomic,strong)NSDictionary *nationaOfRanking; //全国中的排名
@property(nonatomic,strong)NSDictionary *serverOfRanking; //服务器中的排名
@property(nonatomic,strong)NSDictionary *titleDic;        //title

@property(nonatomic,strong)NSDictionary *achievementDic1;  //成就
@property(nonatomic,strong)NSDictionary *itemlevelDic1;
@property(nonatomic,strong)NSDictionary *pveScoreDic1;
@property(nonatomic,strong)NSDictionary *pvpscoreDic1;
@property(nonatomic,strong)NSDictionary *KillsDic1;

@property(nonatomic,strong)NSDictionary *achievementDic2;  //成就
@property(nonatomic,strong)NSDictionary *itemlevelDic2;
@property(nonatomic,strong)NSDictionary *pveScoreDic2;
@property(nonatomic,strong)NSDictionary *pvpscoreDic2;
@property(nonatomic,strong)NSDictionary *KillsDic2;

@property(nonatomic,strong)NSDictionary *achievementDic3;  //成就
@property(nonatomic,strong)NSDictionary *itemlevelDic3;
@property(nonatomic,strong)NSDictionary *pveScoreDic3;
@property(nonatomic,strong)NSDictionary *pvpscoreDic3;
@property(nonatomic,strong)NSDictionary *KillsDic3;


@property(nonatomic,copy)NSString *compare1;
@property(nonatomic,copy)NSString *rank1;
@property(nonatomic,copy)NSString *value1;

@property(nonatomic,copy)NSString *compare2;
@property(nonatomic,copy)NSString *rank2;
@property(nonatomic,copy)NSString *value2;

@property(nonatomic,copy)NSString *compare3;
@property(nonatomic,copy)NSString *rank3;
@property(nonatomic,copy)NSString *value3;


@property(nonatomic,copy)NSString *auth;                 // 是否认证 0为未认证 1为认证
@property(nonatomic,copy)NSString *professionalId;       //id职业id -->猎人    1
@property(nonatomic,copy)NSString *mask;
@property(nonatomic,copy)NSString *professionalName;     //职业中文名字         1
@property(nonatomic,copy)NSString *powerType;             //系统 比如怒气       1
@property(nonatomic,copy)NSString *clazz;                 //职业
@property(nonatomic,copy)NSString *gender;                //性别
@property(nonatomic,copy)NSString *guild;                 //公会
@property(nonatomic,copy)NSString *itemlevel;             //装等
@property(nonatomic,copy)NSString *itemlevelequipped;     //当前装等
@property(nonatomic,copy)NSString *level;                 //等级
@property(nonatomic,copy)NSString *roleNickName;          //角色昵称
@property(nonatomic,copy)NSString *pveScore;              //pve战斗力
@property(nonatomic,copy)NSString *race;                  //种族
@property(nonatomic,copy)NSString *raceName;              //种族名称
@property(nonatomic,copy)NSString *side;                  //阵营
@property(nonatomic,copy)NSString *sidename;              //阵营中文名字
@property(nonatomic,copy)NSString *realm;                 //服务器
@property(nonatomic,copy)NSString *thumbnail;             //获取头像标
@property(nonatomic,copy)NSString *mountsnum;             //坐骑数量
@property(nonatomic,copy)NSString *rankvaltype;           //排行类型
@property(nonatomic,copy)NSString *characterid;


@property(nonatomic,strong)NSMutableArray *firstValueArray;
@property(nonatomic,strong)NSMutableArray *firstRankArray;
@property(nonatomic,strong)NSMutableArray *firstCompArray;
@property(nonatomic,strong)NSMutableArray *secondValueArray;
@property(nonatomic,strong)NSMutableArray *secondRankArray;
@property(nonatomic,strong)NSMutableArray *secondCompArray;
@property(nonatomic,strong)NSMutableArray *thirdValueArray;
@property(nonatomic,strong)NSMutableArray *thirdRankArray;
@property(nonatomic,strong)NSMutableArray *thirdCompArray;


- (id)initWithCharaInfo:(NSDictionary*)info;
- (id)initWithReLoadingInfo:(NSDictionary *)info;
@end



/*
 {
 auth = 0;
 //职业
 classObj =     {
 id = 8;
 mask = 128;
 name = "\U6cd5\U5e08";
 powerType = mana;
 };
 
 clazz = 8;
 gender = 1;
 guild = "\U5927\U7ea2\U83b2\U9a91\U58eb\U56e2";
 id = 157811;
 itemlevel = 517;
 itemlevelequipped = 517;
 level = 90;
 mountsnum = 15;
 name = "\U82e6\U82e5\U79cb\U53f6";
 pveScore = 200;
 race = 7;
 
 // 种族
 raceObj =     {
 id = 7;
 mask = 64;
 name = "\U4f8f\U5112";
 side = alliance;
 sidename = "\U8054\U76df";
 };
 
 //表格里面的数据
 ranking =     {
 1 =         {
 achievementPoints =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 itemlevel =             {
 compare = 0;
 rank = 7;
 value = 517;
 };
 pveScore =             {
 compare = 0;
 rank = 7;
 value = 200;
 };
 pvpScore =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 totalHonorableKills =             {
 compare = 0;
 rank = 5;
 value = 1499;
 };
 };
 2 =         {
 achievementPoints =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 itemlevel =             {
 compare = 0;
 rank = 3;
 value = 517;
 };
 pveScore =             {
 compare = 0;
 rank = 2;
 value = 200;
 };
 pvpScore =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 totalHonorableKills =             {
 compare = 0;
 rank = 45;
 value = 1499;
 };
 };
 3 =         {
 achievementPoints =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 itemlevel =             {
 compare = 0;
 rank = 2485;
 value = 517;
 };
 pveScore =             {
 compare = 0;
 rank = 2375;
 value = 200;
 };
 pvpScore =             {
 compare = 0;
 rank = 0;
 value = " ";
 };
 totalHonorableKills =             {
 compare = 0;
 rank = 30903;
 value = 1499;
 };
 };
 rankingtime = 1393214999574;
 };
 realm = "\U963f\U7eb3\U514b\U6d1b\U65af";  服务器
 thumbnail = 13310; 
 
 //角色信息 个人信息
 头像
 title =     {
 characterid = 157811;
 charactername = "\U82e6\U82e5\U79cb\U53f6";
 clazz = 8;
 gameid = 1;
 hasDate = 1392699077000;
 hide = 1;
 id = 160591;
 realm = "\U963f\U7eb3\U514b\U6d1b\U65af";
 sortnum = 7;
 titleObj =         {
 createDate = 1389340897000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 111;
 img = 501;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = itemlevel;
 rarememo = "1.51%";
 rarenum = 6;
 remark = "\U867d\U7136\U6c38\U6052\U5c9b\U5904\U5904\U5145\U6ee1\U5371\U9669\Uff0c\U4f46\U4e5f\U6709\U5f88\U591a\U4e0d\U9519\U7684\U673a\U9047\Uff0c\U5bcc\U8d35\U9669\U4e2d\U6c42\U554a\Uff01";
 remarkDetail = "\U83b7\U53d6\U6761\U4ef6\Uff1a
 \n\U83b7\U53d6\U88c5\U5907\U5230\U8fbe496\U7ea7\U522b
 \n
 \n\U4e0b\U4e00\U5934\U8854\Uff1a
 \n\U88c5\U5907\U7b49\U7ea7\U5230\U8fbe561";
 simpletitle = "\U7d2b\U88c5\U5f00\U59cb!";
 sortnum = 1;
 title = "\U7d2b\U88c5\U5f00\U59cb!";
 titlekey = "wow_itemlevel_496";
 titletype = "\U88c5\U5907\U7b49\U7ea7";
 };
 titleid = 111;
 userid = 10110253;
 userimg = " ";
 };
 totalHonorableKills = 1499;
 }
 */