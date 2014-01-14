//
//  MessageCell.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
@interface MessageCell : UITableViewCell

@property (strong,nonatomic) UIImageView * backgroudImageV;
@property (strong,nonatomic) EGOImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel * contentLabel;
@property (strong,nonatomic) UILabel * timeLabel;
@property (strong,nonatomic) UILabel * unreadCountLabel;
@property (strong,nonatomic) UIImageView * notiBgV;
@end
