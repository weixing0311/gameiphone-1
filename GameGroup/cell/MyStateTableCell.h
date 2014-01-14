//
//  MyStateTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MyStateTableCell : UITableViewCell

@property (strong,nonatomic) EGOImageView * headImageV;
@property (strong,nonatomic) UIImageView* notiBgV;
@property (strong,nonatomic) UILabel* titleLabel;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UILabel* timeLabel;

@property (strong,nonatomic) UIButton * cellButton;

@property (strong,nonatomic) UILabel* fansLabel;
@property (nonatomic,strong) UILabel* zanLabel;
@property (strong,nonatomic) NSString* fansNum;
@property (strong,nonatomic) NSString* zanNum;

//- (void)refreshCell;

@end
