//
//  OutDodeAddressTableViewCell.h
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DodeAddressCellDelegate.h"
@interface OutDodeAddressTableViewCell : UITableViewCell
@property (nonatomic,assign) id<DodeAddressCellDelegate>delegate;
@property (nonatomic,retain) NSIndexPath * indexPath;
@property (nonatomic,retain) UILabel * nameL;
@property (nonatomic,retain) UILabel * photoNoL;
@end
