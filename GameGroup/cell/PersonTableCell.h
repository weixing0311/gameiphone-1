//
//  PersonTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"

@interface PersonTableCell : UITableViewCell

@property (strong,nonatomic) UIImageView * backgroudImageV;
@property (strong,nonatomic) EGOImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;

@property (nonatomic,strong) UIImageView* gameImg_one;
@property (nonatomic,strong) UIImageView* sexImg;
@property (nonatomic,strong) UIImageView* sexBg;

@property (nonatomic,strong) UILabel*  ageLabel;
@property (strong,nonatomic) UILabel* distLabel;

@property (strong,nonatomic) UILabel* timeLabel;

- (void)refreshCell;

@end
