//
//  FriendRecommendViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendCell.h"
#import "PullUpRefreshView.h"

@interface FriendRecommendViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, RecommendDelegate,PullUpDelegate>

@end
