//
//  TRinkingViewController.h
//  GameGroup 
//
//  Created by admin on 14-3-5.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "TitleSortTableCell.h"
#import "PullUpRefreshView.h"
#import "PullDownRefreshView.h"
#import "TableViewDatasourceDidChange.h"

@interface TRinkingViewController : BaseViewController
<
UIGestureRecognizerDelegate,
UIScrollViewDelegate,
TitleSortCellDelegate,
PullUpDelegate,
PullDowmDelegate,
UIActionSheetDelegate,
TableViewDatasourceDidChange,
UITableViewDataSource,
UITableViewDelegate
>

@property(nonatomic, strong)NSArray*  titleObjArray;
@property(nonatomic, assign)NSInteger showIndex;//展示第几个 从0开始

@property(nonatomic, assign)BOOL      isFriendTitle;//从好友详情页

@end
