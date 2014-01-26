//
//  NewsViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-27.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"
#import "TableViewDatasourceDidChange.h"
#import "PullUpRefreshView.h"

//动态

typedef enum
{
    ME_NEWS_TYPE = 0,
    FRIEND_NEWS_TYPE,
    ONEPERSON_NEWS_TYPE,
}NewsViewType;

@interface NewsViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, PullUpDelegate, SRRefreshDelegate,  TableViewDatasourceDidChange, CellButtonClickDelegate, PullUpDelegate>

@property(nonatomic, assign)NewsViewType myViewType;

@property(nonatomic, strong)NSString* userId;
@end
