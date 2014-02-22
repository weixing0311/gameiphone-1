//
//  CharaDaCell.h
//  GameGroup
//
//  Created by admin on 14-2-22.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharaDaCell : UITableViewCell
@property(nonatomic,strong)UIImageView *titleImgView;
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UILabel *CountLabel;//具体数字
@property(nonatomic,strong)UIImageView *topImgView;//皇冠的那个
@property(nonatomic,strong)UILabel *rankingLabel;//排名数字
@property(nonatomic,strong)UIImageView *upDowmImgView;//上升下降
@end
