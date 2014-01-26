//
//  DSThumbPublicMsgs.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSThumbPublicMsgs : NSManagedObject

@property (nonatomic, retain) NSString * msgContent;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSString * receiver;
@property (nonatomic, retain) NSString * sender;
@property (nonatomic, retain) NSString * senderNickname;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * unRead;

@end
