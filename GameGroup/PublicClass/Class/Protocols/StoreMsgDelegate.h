//
//  StoreMsgDelegate.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-8-3.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StoreMsgDelegate <NSObject>
-(void)makeMsgVStoreMsg:(NSDictionary *)messageContent;
@end
