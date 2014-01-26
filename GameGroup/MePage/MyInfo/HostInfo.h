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

@property (strong,nonatomic) NSString * signature;
@property (strong,nonatomic) NSString * hobby;
@property (strong,nonatomic) NSString * region;
@property (strong,nonatomic) NSString * latitude;//位置
@property (strong,nonatomic) NSString * longitude;
@property (strong,nonatomic) NSString * relation;//关系
@property (strong,nonatomic) NSString * createTime;//注册时间
@property (strong,nonatomic) NSDictionary * state;//动态
@property (strong,nonatomic) NSString * clazzId;//职业id 角色图片

@property (strong,nonatomic) NSString * fanNum;//粉丝数
@property (strong,nonatomic) NSString * zanNum;//赞数
@property (strong,nonatomic) NSString * superstar;//1为明星用户
@property (strong,nonatomic) NSString * superremark;//1为明星用户
@property (strong,nonatomic) NSString * updateTime;//更新坐标时间
@property (strong,nonatomic) NSString * distrance;//距离

@property (strong,nonatomic) NSString * headImgStr;//我 里面的头像数组
@property (strong,nonatomic) NSArray * headImgArray;

@property (strong,nonatomic) NSString* backgroundImg;

@property (strong,nonatomic) NSMutableArray* achievementArray;//头衔

@property (strong,nonatomic) NSString* starSign;//星座
@property (strong,nonatomic) NSString* alias;//别名
@property (strong, nonatomic) NSDictionary* characters;//角色

- (id)initWithHostInfo:(NSDictionary*)info;
@end
