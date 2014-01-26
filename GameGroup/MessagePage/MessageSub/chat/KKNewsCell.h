//
//  KKNewsCell.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"

@interface KKNewsCell : UITableViewCell

@property(nonatomic, retain) EGOImageButton * headImgV;
@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UIButton *bgImageView;
@property(nonatomic, retain) UILabel *titleLabel;
@property(nonatomic, retain) EGOImageView * thumbImgV;
@property(nonatomic, retain) UILabel *contentLabel;
@property(nonatomic, retain) UIImageView* arrowImage;
@end
