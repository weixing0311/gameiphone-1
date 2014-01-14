//
//  NearByViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"

@interface NearByViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PullUpDelegate, SRRefreshDelegate>

@end
