//
//  TempData.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempData : NSObject
{
    NSString * serverAddress;
    NSString * serverDomain;

    double latitude;
    double longitude;
    
}
@property (retain,nonatomic)NSString* myUserID;
@property (nonatomic,assign)BOOL registerNeedMsg;//是否需要验证码
@property (nonatomic,assign)BOOL passBindingRole;//注册时是否跳过绑定角色
@property (nonatomic,assign)BOOL wxAlreadydidClickniehe;//捏合返回首页手势提示
@property (nonatomic,retain)NSString * characterID;//注册时的角色ID
@property (nonatomic,retain)NSString * gamerealm;//注册时的服务器名
+ (id)sharedInstance;
-(NSString *)getServer;
-(NSString *)getDomain;
-(void)SetServer:(NSString *)server TheDomain:(NSString *)domain;
-(void)setLat:(double)lat Lon:(double)lon;
-(double)returnLat;//经度
-(double)returnLon;//纬度
-(NSString*)getMyUserID;
@end
