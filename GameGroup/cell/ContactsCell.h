//
//  ContactsCell.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageView.h"
@interface ContactsCell : UITableViewCell

@property (strong,nonatomic) UIImageView * backgroudImageV;
@property (strong,nonatomic) EGOImageView * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;

@property (nonatomic,strong) UIImageView* gameImg_one;
@property (nonatomic,strong) UIImageView* sexImg;
@property (nonatomic,strong) UIView* sexBg;

@property (nonatomic,strong) UILabel*  ageLabel;
@property (strong,nonatomic) UILabel* distLabel;

@end
