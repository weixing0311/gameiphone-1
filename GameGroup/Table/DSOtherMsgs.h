//
//  DSOtherMsgs.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-17.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSOtherMsgs : NSManagedObject

@property (nonatomic, retain) NSString * messageuuid;
@property (nonatomic, retain) NSString * msgContent;
@property (nonatomic, retain) NSString * msgType;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * myTitle;

@end
