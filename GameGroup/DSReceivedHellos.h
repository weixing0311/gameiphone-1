//
//  DSReceivedHellos.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSReceivedHellos : NSManagedObject

@property (nonatomic, retain) NSString * acceptStatus;
@property (nonatomic, retain) NSString * addtionMsg;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * ifFriend;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSDate * receiveTime;
@property (nonatomic, retain) NSString * unreadCount;
@property (nonatomic, retain) NSString * userName;

@end
