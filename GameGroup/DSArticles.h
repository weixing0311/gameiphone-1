//
//  DSArticles.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-12.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSArticles : NSManagedObject

@property (nonatomic, retain) NSString * articleDetail;
@property (nonatomic, retain) NSString * articleID;
@property (nonatomic, retain) NSString * articleImgID;
@property (nonatomic, retain) NSString * articleOverview;
@property (nonatomic, retain) NSString * articleTitle;
@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * senderName;
@property (nonatomic, retain) NSString * senderNickname;
@property (nonatomic, retain) NSDate * senTime;

@end
