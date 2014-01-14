//
//  DSRecommendList.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSRecommendList : NSManagedObject

@property (nonatomic, retain) NSString * fromStr;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * fromID;
@property (nonatomic, retain) NSString * headImgID;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * userName;

@end
