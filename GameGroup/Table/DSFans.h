//
//  DSFans.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-8.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSFans : NSManagedObject

@property (nonatomic, retain) NSString * achievement;
@property (nonatomic, retain) NSString * achievementLevel;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * nameIndex;
@property (nonatomic, retain) NSString * nameKey;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * refreshTime;
@property (nonatomic, retain) NSString * remarkName;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;

@end
