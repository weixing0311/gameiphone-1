//
//  DSNewsMsgs.h
//  GameGroup
//
//  Created by wangxr on 14-3-13.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSNewsMsgs : NSManagedObject

@property (nonatomic, retain) NSString * messageuuid;
@property (nonatomic, retain) NSString * msgcontent;
@property (nonatomic, retain) NSString * msgtype;
@property (nonatomic, retain) NSString * mytitle;
@property (nonatomic, retain) NSDate * sendtime;

@end
