//
//  SendArticleViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-1.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "TableViewDatasourceDidChange.h"

@interface SendArticleViewController : BaseViewController

@property (nonatomic,weak)id<TableViewDatasourceDidChange>delegate;

@end
