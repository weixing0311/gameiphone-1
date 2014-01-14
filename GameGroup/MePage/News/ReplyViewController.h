//
//  ReplyViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"
#import "HPGrowingTextView.h"
#import "TableViewDatasourceDidChange.h"

@interface ReplyViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, PullUpDelegate, SRRefreshDelegate,CellButtonClickDelegate,HPGrowingTextViewDelegate>

@property (nonatomic,weak)id<TableViewDatasourceDidChange>delegate;

@property (nonatomic, strong)NSString* messageid;
@property (nonatomic, assign)BOOL isHaveArticle;//去原文

@end
