//
//  NotificationCell.h
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@interface NotificationCell : UITableViewCell
@property (strong,nonatomic) EGOImageButton * headImageV;
@property (strong,nonatomic) UIImageView * dotImageV;
@property (strong,nonatomic) UIImageView * contentImageV;
@property (strong,nonatomic) UIImageView * replyBgImageV;
@property (strong,nonatomic) UILabel * contentLabel;
@property (strong,nonatomic) UILabel * replyLabel;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * timeLabel;
@end
