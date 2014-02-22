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
@property(nonatomic,strong)NSString *auth;                 // 是否认证 0为未认证 1为认证
@property(nonatomic,strong)NSDictionary *classObj;         //职业详情
@property(nonatomic,strong)NSString *professionalId;       //id职业id -->猎人    1
@property(nonatomic,strong)NSString *mask;
@property(nonatomic,strong)NSString *professionalName;     //职业中文名字         1
@property(nonatomic,strong)NSString *powerType;             //系统 比如怒气       1
@property(nonatomic,strong)NSString *clazz;                 //职业
@property(nonatomic,strong)NSString *gender;                //性别
@property(nonatomic,strong)NSString *guild;                 //公会
@property(nonatomic,strong)NSString *itemlevel;             //装等
@property(nonatomic,strong)NSString *itemlevelequipped;     //当前装等
@property(nonatomic,strong)NSString *level;                 //等级
@property(nonatomic,strong)NSString *roleNickName;          //角色昵称
@property(nonatomic,strong)NSString *pveScore;              //pve战斗力
@property(nonatomic,strong)NSString *race;                  //种族
@property(nonatomic,strong)NSDictionary *raceObj;           //种族详细
@property(nonatomic,strong)NSString *raceName;              //种族名称
@property(nonatomic,strong)NSString *side;                  //阵营
@property(nonatomic,strong)NSString *sidename;              //阵营中文名字
@property(nonatomic,strong)NSString *realm;                 //服务器
@property(nonatomic,strong)NSString *thumbnail;             //获取头像标
@property(nonatomic,strong)NSString *mountsnum;             //坐骑数量
- (id)initWithCharaInfo:(NSDictionary*)info;
@end
