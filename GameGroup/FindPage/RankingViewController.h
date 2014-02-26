//
//  RankingViewController.h
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@interface RankingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,copy)NSString *custType;//职业
@property(nonatomic,copy)NSString *characterid;//角色
@property(nonatomic,copy)NSString *cRankvaltype;//排名方位  服务器 全国 好友
@property(nonatomic,copy)NSString *dRankvaltype;//排名类型
@end
