//
//  InDoduAddressTableViewCell.h
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DodeAddressCellDelegate.h"
#import "EGOImageView.h"
@interface InDoduAddressTableViewCell : UITableViewCell
@property (nonatomic,assign) id<DodeAddressCellDelegate>delegate;
@property (nonatomic,retain) UILabel * nameL;
@property (nonatomic,retain) UILabel * photoNoL;
@property (nonatomic,retain) EGOImageView * headerImage;
@end
