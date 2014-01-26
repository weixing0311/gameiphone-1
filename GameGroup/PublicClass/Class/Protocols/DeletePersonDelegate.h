//
//  DeletePersonDelegate.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-23.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeletePersonDelegate <NSObject>

@optional
-(void)deletePersonReceived:(NSDictionary *)userInfo;

@end
