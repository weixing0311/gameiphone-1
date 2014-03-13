//
//  RankingViewController.h
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "NotConnectDelegate.h"
#import "SendNewsViewController.h"
#import "RankingCell.h"
@interface RankingViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,UIScrollViewDelegate,TableViewDatasourceDidChange>
@property(nonatomic,copy)NSString *custType;//职业
@property(nonatomic,copy)NSString *characterid;//角色
@property(nonatomic,copy)NSString *characterName;//角色名称
@property(nonatomic,copy)NSString *cRankvaltype;//排名方位  服务器 全国 好友
@property(nonatomic,copy)NSString *dRankvaltype;//排名类型
@property(nonatomic, assign)NSInteger showIndex;//展示第几个 从0开始
@property(nonatomic,assign)NSString *server;//服务器
@property(nonatomic,copy)NSString *COME_FROM;
@property(nonatomic,copy)NSString *titleOfRanking;//表头
@property(nonatomic,assign)NSInteger     pageCount1;
@property(nonatomic,assign)NSInteger     pageCount2;
@property(nonatomic,assign)NSInteger     pageCount3;
@property(nonatomic,copy)NSString *userId;
@end
