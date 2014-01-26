//
//  RecommendFriendDelegate.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-1.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RecommendFriendDelegate <NSObject>

@optional
-(void)recommendFriendReceived:(NSDictionary *)info;
@end
