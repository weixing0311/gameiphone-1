//
//  XMPPManager.h
//  GameGroup
//
//  Created by wangxr on 14-2-26.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPManager : NSObject
+(XMPPManager *) sharedInstance;//得到单例
-(void)connect:(NSString *)theaccount password:(NSString *)thepassword host:(NSString *)host success:(CallBackBlock)Success fail:(CallBackBlockErr)Fail;//登陆
-(void)disconnect;//下线
@end
