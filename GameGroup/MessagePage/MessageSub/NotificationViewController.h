//
//  NotificationViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NotificationCell.h"
#import "TempData.h"
//#import "ArticleViewController.h"
//#import "OnceDynamicViewController.h"

@class AppDelegate;
@interface NotificationViewController : BaseViewController<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
}
@property (strong,nonatomic) UITableView * notiTableV;
@property (strong,nonatomic) NSMutableArray * notiArray;
@property (strong,nonatomic) AppDelegate * appDel;
@end
