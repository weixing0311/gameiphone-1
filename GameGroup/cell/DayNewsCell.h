//
//  DayNewsCell.h
//  GameGroup
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
@interface DayNewsCell : UITableViewCell
@property(nonatomic,strong)EGOImageButton *headImageBtn;
@property(nonatomic,strong)UILabel  * nickNameLabel;
@property(nonatomic,strong)UILabel  * signatureLabel;
@property(nonatomic,strong)EGOImageView *bigImageView;
@property(nonatomic,strong)UILabel  *authorLabel;
@property(nonatomic,strong)UILabel  *NumLabel;
@property(nonatomic,strong)UILabel  *timeLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *topImageView;
@property(nonatomic,strong)UILabel *topTimeLabel;
@property(nonatomic,strong)UIButton *newsOfBtn;
@property(nonatomic,strong)UILabel *bianzheLabel;
@property(nonatomic,strong)UIButton *nickNameBtn;
@end
