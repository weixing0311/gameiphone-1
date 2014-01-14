//
//  DSDynamicFriends.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSDynamicFriends : NSManagedObject

@property (nonatomic, retain) NSString * articleImgID;
@property (nonatomic, retain) NSString * articleOverview;
@property (nonatomic, retain) NSString * articleTitle;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * dynamicContent;
@property (nonatomic, retain) NSString * dynamicFilesID;
@property (nonatomic, retain) NSString * dynamicFileType;
@property (nonatomic, retain) NSString * dynamicID;
@property (nonatomic, retain) NSString * dynamicLocation;
@property (nonatomic, retain) NSDate * dynamicTime;
@property (nonatomic, retain) NSString * dynamicType;
@property (nonatomic, retain) NSString * dynamicURL;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * userName;

@end
