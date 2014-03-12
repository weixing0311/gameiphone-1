//
//  FunsOfOtherViewController.h
//  GameGroup
//
//  Created by admin on 14-3-12.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"
#import "PullUpRefreshView.h"

@interface FunsOfOtherViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate, SRRefreshDelegate, PullUpDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)NSString *userId;
@end
