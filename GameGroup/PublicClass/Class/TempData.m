//
//  TempData.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-23.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "TempData.h"

@implementation TempData
static TempData *sharedInstance=nil;

+(TempData *) sharedInstance
{
    @synchronized(self)
    {
        if(!sharedInstance)
        {
            sharedInstance=[[self alloc] init];
            [sharedInstance initThis];
        }
        return sharedInstance;
    }
}
-(void)initThis
{
    self.wxAlreadydidClickniehe = YES;
    serverAddress = @"";
    serverDomain = @"";
    latitude = 0;
    longitude = 0;
    self.registerNeedMsg = YES;
    self.passBindingRole = NO;
}
-(void)SetServer:(NSString *)server TheDomain:(NSString *)idomain
{
    serverAddress = server;
    serverDomain = idomain;
}
-(NSString *)getServer
{
    NSLog(@"地址：%@", serverAddress);
//    return @"192.168.0.133:5222";
    return serverAddress;
}

-(NSString *)getDomain
{
    NSLog(@"域名 %@", serverDomain);
    return [NSString stringWithFormat:@"%@",serverDomain];
}

-(void)setLat:(double)lat Lon:(double)lon
{
    latitude = lat;
    longitude = lon;
}
-(double)returnLat
{
    return latitude;
}
-(double)returnLon
{
    return longitude;
}
-(NSString*)getMyUserID
{
    if (!self.myUserID) {
        self.myUserID = [DataStoreManager getMyUserID];
    }
    return self.myUserID;
}
@end
