//
//  CharaInfo.m
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "CharaInfo.h"

@implementation CharaInfo
- (id)initWithCharaInfo:(NSDictionary*)info
{
    self = [super init];
    if (self) {
        //info = KISDictionaryHaveKey(info, @"entity");//角色数据
        
        self.classObj = KISDictionaryHaveKey(info, @"classObj");//职业
        
        self.raceObj = KISDictionaryHaveKey(info, @"raceObj");//种族

        self.auth = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"auth")];//是否认证
        
        self.professionalId = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.classObj, @"id")];
        
        self.professionalName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.classObj, @"name")];
        
        self.powerType = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.classObj, @"powerType")];
        self.roleNickName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"name")];

        
        self.clazz = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"clazz")];//职业
        
        self.gender = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"gender")];//性别
        
        self.guild = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"guild")];//公会
        
        self.itemlevel = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"itemlevel")];//装等
        
        self.itemlevelequipped = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"itemlevelequipped")];//当前装等
        
        self.level = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"level")];//等级
        
        self.pveScore = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"pveScore")];//pve战斗力
        self.race = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"race")];//种族
        
        self.raceName = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.raceObj, @"name")];//种族名字
        
        self.side = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.raceObj, @"side")];//阵营
        
        self.sidename = [GameCommon getNewStringWithId:KISDictionaryHaveKey(self.raceObj, @"sidename")];//阵营名称
        
        self.realm = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"realm")];//服务器
        
        self.thumbnail = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"thumbnail")];//获取头像
        
        self.mountsnum = [GameCommon getNewStringWithId:KISDictionaryHaveKey(info, @"mountsnum")];//坐骑数量
        

        
}
    return self;
}

/*
 {
 auth = 0;
 classObj =     {
 id = 1;
 mask = 1;
 name = "\U6218\U58eb";
 powerType = rage;
 };
 
 
 clazz = 1;
 gender = 0;
 guild = " ";
 id = 158169;
 itemlevel = 507;
 itemlevelequipped = 507;
 level = 90;
 mountsnum = 79;
 name = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 pveScore = 200;
 race = 10;
 raceObj =     {
 id = 10;
 mask = 512;
 name = "\U8840\U7cbe\U7075";
 side = horde;
 sidename = "\U90e8\U843d";
 };
 realm = "\U51b0\U971c\U4e4b\U5203";
 thumbnail = 14077;
 title =     {
 characterid = 158169;
 charactername = "\U4e0b\U4e00\U7ad9\U706c\U505c\U7559";
 clazz = 1;
 gameid = 1;
 hasDate = 1392699103000;
 hide = 0;
 id = 160741;
 realm = "\U51b0\U971c\U4e4b\U5203";
 sortnum = 1;
 titleObj =         {
 createDate = 1388826466000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 66;
 img = 446;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = fengjian;
 rarememo = "0.69%";
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
 totalHonorableKills = 253;
 }
 
 */
@end
