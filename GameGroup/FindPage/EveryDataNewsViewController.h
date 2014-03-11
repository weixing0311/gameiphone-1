//
//  EveryDataNewsViewController.h
//  GameGroup
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"
#import "NotConnectDelegate.h"
#import "PullDownRefreshView.h"
#import "SendNewsViewController.h"

@interface EveryDataNewsViewController : BaseViewController
<
UITableViewDataSource,
UITableViewDelegate,
UIActionSheetDelegate,
PullUpDelegate,
SRRefreshDelegate,
UIScrollViewDelegate,
TableViewDatasourceDidChange
>

@end
