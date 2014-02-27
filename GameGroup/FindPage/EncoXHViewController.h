//
//  EncoXHViewController.h
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@interface EncoXHViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *characterId;//角色
@property(nonatomic,copy)NSString *gameId;
@end
