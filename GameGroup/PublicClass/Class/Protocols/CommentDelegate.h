//
//  NewCommentDelegate.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommentDelegate <NSObject>
@optional
-(void)newCommentReceived:(NSDictionary *)theDict;

@end
