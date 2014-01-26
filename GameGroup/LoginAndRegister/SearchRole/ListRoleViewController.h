//
//  ListRoleViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-30.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@protocol ListRoleDelegate <NSObject>

- (void)selectRoleOKWithName:(NSString*)role;

@end

@interface ListRoleViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property(nonatomic, assign) id<ListRoleDelegate> myDelegate;
@property(nonatomic, strong) NSDictionary* dataDic;
@property(nonatomic, strong) NSString* guildStr;
@end
