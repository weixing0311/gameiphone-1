//
//  AddReqDelegate.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-2.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddReqDelegate <NSObject>
@optional
-(void)newAddReq:(NSDictionary *)userInfo;

@end
