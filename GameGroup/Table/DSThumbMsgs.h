//
//  DSThumbMsgs.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-26.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSThumbMsgs : NSManagedObject

@property (nonatomic, retain) NSString * messageuuid;
@property (nonatomic, retain) NSString * msgContent;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * senderimg;
@property (nonatomic, retain) NSString * senderNickname;
@property (nonatomic, retain) NSString * senderType;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * sendTimeStr;
@property (nonatomic, retain) NSString * unRead;

@end
