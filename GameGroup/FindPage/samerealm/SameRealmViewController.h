//
//  SameRealmViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "SelectView.h"
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"

@interface SameRealmViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, SelectViewDelegate, PullUpDelegate, SRRefreshDelegate>

@end
