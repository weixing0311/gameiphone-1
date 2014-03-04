//
//  HostInfo.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostInfo : NSObject

@property (strong,nonatomic) NSDictionary* infoDic;
@property (strong,nonatomic) NSString * userName;
@property (strong,nonatomic) NSString * userId;
@property (strong,nonatomic) NSString * nickName;
@property (assign,nonatomic) BOOL  active;//激活状态
@property (strong,nonatomic) NSString * telNumber;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * age;
@property (strong,nonatomic) NSString * birthdate;
@property (strong,nonatomic) NSString * characterid;//游戏角色ID
@property (strong,nonatomic) NSString * signature;
@property (strong,nonatomic) NSString * hobby;
@property (strong,nonatomic) NSString * region;
@property (strong,nonatomic) NSString * latitude;//位置
@property (strong,nonatomic) NSString * longitude;
@property (strong,nonatomic) NSString * relation;//关系
@property (strong,nonatomic) NSString * createTime;//注册时间
@property (strong,nonatomic) NSDictionary * state;//动态
@property (strong,nonatomic) NSString * clazzId;//职业id 角色图片
@property (strong,nonatomic) NSString * gameid;//游戏id  比如wow
@property (strong,nonatomic) NSString * fanNum;//粉丝数
@property (strong,nonatomic) NSString * zanNum;//赞数
@property (strong,nonatomic) NSString * superstar;//1为明星用户
@property (strong,nonatomic) NSString * superremark;//1为明星用户
@property (strong,nonatomic) NSString * updateTime;//更新坐标时间
@property (strong,nonatomic) NSString * distrance;//距离
@property (strong,nonatomic) NSString *isNull;
@property (strong,nonatomic) NSString * headImgStr;//我 里面的头像数组
@property (strong,nonatomic) NSArray * headImgArray;

@property (strong,nonatomic) NSString* backgroundImg;

@property (strong,nonatomic) NSMutableArray* achievementArray;//头衔

@property (strong,nonatomic) NSString* starSign;//星座
@property (strong,nonatomic) NSString* alias;//别名
@property (strong, nonatomic) NSDictionary* characters;//角色

- (id)initWithHostInfo:(NSDictionary*)info;
@end



/*
 {
 characters =     {
 
 
 1 =         (
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 11;
 mask = 1024;
 name = "\U5fb7\U9c81\U4f0a";
 powerType = mana;
 };
 clazz = 11;
 content = " ";
 failedmsg = 500;
 failednum = 0;
 filepath = "/home/appusr/characters/\U5361\U62c9\U8d5e/MLYY.zip";
 gender = 0;
 guild = "\U7ea2\U5c18\U5ba2\U6808";
 guildRealm = "\U5361\U62c9\U8d5e";
 id = 157723;
 iscatch = 1;
 lastModified = 1387693211000;
 level = 90;
 mountsnum = 77;
 name = MLYY;
 pveScore = 140;
 race = 6;
 raceObj =                 {
 id = 6;
 mask = 32;
 name = "\U725b\U5934\U4eba";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U5361\U62c9\U8d5e";
 thumbnail = " ";
 totalHonorableKills = 0;
 },
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 4;
 mask = 8;
 name = "\U6f5c\U884c\U8005";
 powerType = energy;
 };
 clazz = 4;
 content = " ";
 failedmsg = 500;
 failednum = 0;
 filepath = "/home/appusr/characters/\U5361\U62c9\U8d5e/\U6674\U7a7a\U4e4b\U661f.zip";
 gender = 0;
 guild = "\U50b3\U4e28\U8aaa";
 guildRealm = "\U5361\U62c9\U8d5e";
 id = 156821;
 iscatch = 1;
 lastModified = 1392559410000;
 level = 90;
 mountsnum = 79;
 name = "\U6674\U7a7a\U4e4b\U661f";
 pveScore = 200;
 race = 5;
 raceObj =                 {
 id = 5;
 mask = 16;
 name = "\U4ea1\U7075";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U5361\U62c9\U8d5e";
 thumbnail = 6416;
 totalHonorableKills = 5909;
 },
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 8;
 mask = 128;
 name = "\U6cd5\U5e08";
 powerType = mana;
 };
 clazz = 8;
 content = " ";
 failedmsg = " ";
 failednum = 0;
 filepath = "/home/appusr/characters/\U963f\U7eb3\U514b\U6d1b\U65af/\U82e6\U82e5\U79cb\U53f6.zip";
 gender = 1;
 guild = "\U5927\U7ea2\U83b2\U9a91\U58eb\U56e2";
 guildRealm = "\U963f\U7eb3\U514b\U6d1b\U65af";
 id = 157811;
 iscatch = 1;
 lastModified = 1392297192000;
 level = 90;
 mountsnum = 15;
 name = "\U82e6\U82e5\U79cb\U53f6";
 pveScore = 200;
 race = 7;
 raceObj =                 {
 id = 7;
 mask = 64;
 name = "\U4f8f\U5112";
 side = alliance;
 sidename = "\U8054\U76df";
 };
 realm = "\U963f\U7eb3\U514b\U6d1b\U65af";
 thumbnail = 13310;
 totalHonorableKills = 1499;
 },
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 5;
 mask = 16;
 name = "\U7267\U5e08";
 powerType = mana;
 };
 clazz = 5;
 content = " ";
 failedmsg = 500;
 failednum = 0;
 filepath = "/home/appusr/characters/\U51b0\U971c\U4e4b\U5203/\U6de1\U6de1\U5730\U4f24.zip";
 gender = 1;
 guild = "\U7231\U4e0e\U6b63\U4e49\U7684";
 guildRealm = "\U51b0\U971c\U4e4b\U5203";
 id = 158171;
 iscatch = 1;
 lastModified = 1392631629000;
 level = 90;
 mountsnum = 13;
 name = "\U6de1\U6de1\U5730\U4f24";
 pveScore = 1813;
 race = 10;
 raceObj =                 {
 id = 10;
 mask = 512;
 name = "\U8840\U7cbe\U7075";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U51b0\U971c\U4e4b\U5203";
 thumbnail = 6742;
 totalHonorableKills = 1106;
 },
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 3;
 mask = 4;
 name = "\U730e\U4eba";
 powerType = focus;
 };
 clazz = 3;
 content = " ";
 failedmsg = 500;
 failednum = 0;
 filepath = "/home/appusr/characters/\U5361\U62c9\U8d5e/\U8840\U6027\U706c\U6b87.zip";
 gender = 1;
 guild = "\U8056\U5b89\U5730\U5217\U65af";
 guildRealm = "\U5361\U62c9\U8d5e";
 id = 155846;
 iscatch = 1;
 lastModified = 1392727505000;
 level = 90;
 mountsnum = 79;
 name = "\U8840\U6027\U706c\U6b87";
 pveScore = 720;
 race = 10;
 raceObj =                 {
 id = 10;
 mask = 512;
 name = "\U8840\U7cbe\U7075";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U5361\U62c9\U8d5e";
 thumbnail = 20505;
 totalHonorableKills = 11425;
 },
 
 
 {
 auth = 0;
 battlegroup = " ";
 classObj =                 {
 id = 1;
 mask = 1;
 name = "\U6218\U58eb";
 powerType = rage;
 };
 clazz = 1;
 content = " ";
 failedmsg = 500;
 failednum = 0;
 filepath = "/home/appusr/characters/\U51b0\U971c\U4e4b\U5203/\U4e0b\U4e00\U7ad9\U706c\U505c\U7559.zip";
 gender = 0;
 guild = " ";
 guildRealm = " ";
 id = 158169;
 iscatch = 1;
 lastModified = 1392295715000;
 level = 90;
 mountsnum = 79;
 name = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 pveScore = 200;
 race = 10;
 raceObj =                 {
 id = 10;
 mask = 512;
 name = "\U8840\U7cbe\U7075";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U51b0\U971c\U4e4b\U5203";
 thumbnail = 19575;
 totalHonorableKills = 253;
 }
 );
 
 
 
 };
 
 
 dynamicmsg =     {
 alias = " ";
 commentnum = 0;
 createDate = 1393039577000;
 id = 2658;
 img = "1636,";
 msg = Tsdfsafs;
 nickname = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 rarenum = 0;
 superstar = 0;
 thumb = " ";
 title = " ";
 titleObj =         {
 characterid = 158169;
 charactername = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 clazz = 1;
 gameid = 1;
 hasDate = 1392699103000;
 hide = 0;
 id = 160741;
 realm = "\U51b0\U971c\U4e4b\U5203";
 sortnum = 1;
 titleObj =             {
 createDate = 1388826466000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 66;
 img = 446;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = fengjian;
 rarememo = "0.72%";
 rarenum = 4;
 remark = "\U4ee3\U8868\U7740\U8363\U8000\U4e0e\U8d23\U4efb\U4f20\U8bf4\U6b66\U5668 - \"\U82f1\U96c4, \U613f\U4f60\U62e5\U6709\U4e00\U4efd\U65e0\U6094\U7684\U7231\U60c5!\"";
 remarkDetail = "\U83b7\U5f97\U6761\U4ef6:
 \n\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 simpletitle = "\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 sortnum = 1;
 title = "\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 titlekey = " ";
 titletype = "\U83b7\U53d6\U65f6\U95f4";
 };
 titleid = 66;
 userid = 10110253;
 userimg = " ";
 };
 type = 3;
 urlLink = " ";
 userid = 10110253;
 userimg = "1598,1597,";
 username = 15510106271;
 
 zan = 0;
 zannum = 0;
 };
 
 
 fansnum = 3;
 shiptype = unkown;
 
 
 title =     (
 {
 characterid = 158169;
 charactername = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 clazz = 1;
 gameid = 1;
 hasDate = 1392699103000;
 hide = 0;
 id = 160741;
 realm = "\U51b0\U971c\U4e4b\U5203";
 sortnum = 1;
 titleObj =             {
 createDate = 1388826466000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 66;
 img = 446;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = fengjian;
 rarememo = "0.72%";
 rarenum = 4;
 remark = "\U4ee3\U8868\U7740\U8363\U8000\U4e0e\U8d23\U4efb\U4f20\U8bf4\U6b66\U5668 - \"\U82f1\U96c4, \U613f\U4f60\U62e5\U6709\U4e00\U4efd\U65e0\U6094\U7684\U7231\U60c5!\"";
 remarkDetail = "\U83b7\U5f97\U6761\U4ef6:
 \n\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 simpletitle = "\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 sortnum = 1;
 title = "\U96f7\U9706\U4e4b\U6012\Uff0c\U9010\U98ce\U8005\U7684\U795d\U798f\U4e4b\U5251";
 titlekey = " ";
 titletype = "\U83b7\U53d6\U65f6\U95f4";
 };
 titleid = 66;
 userid = 10110253;
 userimg = " ";
 },
 {
 characterid = 155846;
 charactername = "\U8840\U6027\U706c\U6b87";
 clazz = 3;
 gameid = 1;
 hasDate = 1392693830000;
 hide = 0;
 id = 157853;
 realm = "\U5361\U62c9\U8d5e";
 sortnum = 3;
 titleObj =             {
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
 },
 {
 characterid = 155846;
 charactername = "\U8840\U6027\U706c\U6b87";
 clazz = 3;
 gameid = 1;
 hasDate = 1392693851000;
 hide = 0;
 id = 157934;
 realm = "\U5361\U62c9\U8d5e";
 sortnum = 5;
 titleObj =             {
 createDate = 1388826466000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 53;
 img = 150;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = totalHonorableKills;
 rarememo = "0.68%";
 rarenum = 6;
 remark = "\U72ee\U864e\U730e\U7269\U83b7\U5a01\U540d\Uff0c\U53ef\U4f36\U9e8b\U9e7f\U6709\U8c01\U4f36\Uff1f
 \n\U653e\U773c\U4e16\U754c\U4e94\U5343\U5e74\Uff0c\U4f55\U5904\U82f1\U96c4\U4e0d\U6740\U4eba";
 remarkDetail = "\U83b7\U53d6\U6761\U4ef6:\U8363\U8a89\U51fb\U6740\U6570\U8d85\U8fc710000
 \n
 \n\U4e0b\U4e00\U5934\U8854:\U8363\U8a89\U51fb\U6740\U6570\U8fbe\U5230\U670d\U52a1\U5668\U524d\U5341\U540d";
 simpletitle = "\U6740\U4eba\U5982\U9ebb";
 sortnum = 1;
 title = "\U6740\U4eba\U5982\U9ebb";
 titlekey = "wow_honorablekills_srrm";
 titletype = "\U8363\U8a89\U51fb\U6740\U6570";
 };
 titleid = 53;
 userid = 10110253;
 userimg = " ";
 }
 );
 zannum = 1;
 }
 */


