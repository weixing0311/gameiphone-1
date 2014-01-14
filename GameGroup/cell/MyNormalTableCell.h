//
//  NormalTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MyNormalTableCell : UITableViewCell

@property(nonatomic,strong)EGOImageView* heardImg;
@property(nonatomic,strong)UILabel*     upLabel;
@property(nonatomic,strong)UILabel*     downLabel;
@end
