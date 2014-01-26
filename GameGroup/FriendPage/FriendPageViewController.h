//
//  FriendPageViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-5.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "SRRefreshView.h"
#import "PullUpRefreshView.h"

@interface FriendPageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate, SRRefreshDelegate, PullUpDelegate>

@end
