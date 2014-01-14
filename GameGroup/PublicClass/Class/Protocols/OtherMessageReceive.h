//
//  OtherMessageReceive.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OtherMessageReceive <NSObject>

@optional

-(void)otherMessageReceived:(NSDictionary *)info;

@end
