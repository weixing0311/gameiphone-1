//
//  MyTitleObjViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "MyTitleObjShowCell.h"
#import "MyTitleObjHideCell.h"

@interface MyTitleObjViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, MyTitleEditDelegate, MyTitleShowDelegate>

@end
