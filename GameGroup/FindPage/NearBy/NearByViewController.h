//
//  NearByViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "NotConnectDelegate.h"
@interface NearByViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate,NotConnectDelegate>
@property (strong,nonatomic) AppDelegate * appDel;
@end
