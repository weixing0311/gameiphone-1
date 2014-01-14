//
//  DSUnreadCount.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSUnreadCount : NSManagedObject

@property (nonatomic, retain) NSString * publicUnread;
@property (nonatomic, retain) NSString * receivedHellosUnread;
@property (nonatomic, retain) NSString * subscribedUnread;

@end
