//
//  TitleObjDetailViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-26.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "TitleSortTableCell.h"
#import "PullUpRefreshView.h"
#import "PullDownRefreshView.h"
#import "TableViewDatasourceDidChange.h"

@interface TitleObjDetailViewController : BaseViewController
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
TitleSortCellDelegate,
PullUpDelegate,
PullDowmDelegate,
UIActionSheetDelegate,
TableViewDatasourceDidChange
>

@property(nonatomic, strong)NSArray*  titleObjArray;
@property(nonatomic, assign)NSInteger showIndex;//展示第几个 从0开始

@property(nonatomic, assign)BOOL      isFriendTitle;//从好友详情页进入 只展示一个头衔 排名去掉好友排名

@end
