//
//  SetViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
@class AppDelegate, XMPPHelper;
@interface SetViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (strong,nonatomic) AppDelegate * appDel;

@end
