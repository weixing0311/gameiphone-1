//
//  NormalTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-16.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalTableCell : UITableViewCell

@property(nonatomic, strong)UIImageView*   leftImageView;
@property(nonatomic, strong)UILabel*       titleLable;
@property (strong,nonatomic) UIImageView* notiBgV;
@property (strong,nonatomic) UILabel * unreadCountLabel;

@end
