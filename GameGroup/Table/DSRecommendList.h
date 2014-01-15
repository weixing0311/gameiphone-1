//
//  DSRecommendList.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-15.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSRecommendList : NSManagedObject

@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * fromStr;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userid;

@end
