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
 获得数据：{
 entity =     {
 characters =         {
 };
 dynamicmsg =         {
 alias = " ";
 commentnum = 3;
 createDate = 1392957842000;
 destUser =             {
 alias = " ";
 nickname = "\U96c5\U4f69\U4f69";
 superstar = 0;
 userid = 10110204;
 userimg = "1625,1627,1623,1624,1626,";
 username = 18000109956;
 };
 id = 2588;
 img = " ";
 msg = Iuyiubiubniu;
 nickname = "\U6d4b\U8bd5\U4e13\U7528\U6635\U79f0";
 rarenum = 0;
 showtitle = "\U8bc4\U8bba\U4e86\U8be5\U5185\U5bb9";
 superstar = 0;
 thumb = " ";
 title = " ";
 titleObj = " ";
 type = 5;
 urlLink = " ";
 userid = 10110189;
 userimg = " ";
 username = 18000109941;
 zan = 0;
 zannum = 1;
 };
 fansnum = 0;
 shiptype = unkown;
 title =         (
 );
 user =         {
 age = 27;
 alias = " ";
 appType = 91;
 backgroundImg = " ";
 birthdate = 19860821;
 city = " ";
 constellation = "\U72ee\U5b50\U5ea7";
 createTime = " ";
 deviceToken = "";
 distance = "0.0";
 email = "306750047@qq.com";
 gender = 0;
 hobby = " ";
 id = 10110189;
 ifFraudulent = " ";
 img = " ";
 latitude = "39.83939";
 longitude = "116.390228";
 modTime = " ";
 nickname = "\U6d4b\U8bd5\U4e13\U7528\U6635\U79f0";
 password = "lueSGJZetyySpUndWjMBEg==";
 phoneNumber = " ";
 rarenum = 0;
 realname = " ";
 remark = " ";
 signature = " ";
 superremark = " ";
 superstar = 0;
 title = " ";
 updateUserLocationDate = 1392971080614;
 username = 18000109941;
 };
 zannum = 1;
 };
 errorcode = 0;
 sn = 7DD88E1E9EA44D97AC9C33D1E1A4D76D;
 }
 
 */


