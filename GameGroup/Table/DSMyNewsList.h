//
//  DSMyNewsList.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-22.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DSMyNewsList : NSManagedObject

@property (nonatomic, retain) NSString * bigTitle;
@property (nonatomic, retain) NSString * commentObj;
@property (nonatomic, retain) NSString * createDate;
@property (nonatomic, retain) NSString * detailPageId;
@property (nonatomic, retain) NSString * heardImgId;
@property (nonatomic, retain) NSString * imageStr;
@property (nonatomic, retain) NSString * img;
@property (nonatomic, retain) NSString * msg;
@property (nonatomic, retain) NSString * newsId;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * superstar;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * urlLink;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * zannum;
@property (nonatomic, retain) NSString * showTitle;

@end
