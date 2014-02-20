//
//  SearchResultViewController.h
//  GameGroup
//
//  Created by admin on 14-2-20.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullUpRefreshView.h"
#import "SRRefreshView.h"
#import "NotConnectDelegate.h"

#import "BaseViewController.h"

@class AppDelegate, XMPPHelper;
@protocol getContact <NSObject>
-(void)getContact:(NSDictionary *)userDict;
@end

@interface SearchResultViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PullUpDelegate, SRRefreshDelegate,NotConnectDelegate>
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic) id responseObject;
@end
