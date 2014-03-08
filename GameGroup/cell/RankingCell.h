//
//  RankingCell.h
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface RankingCell : UITableViewCell
@property(nonatomic,strong)EGOImageView *titleImageView;
@property(nonatomic,strong)UILabel *CountOfLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *serverLabel;
@property(nonatomic,strong)UILabel *NumLabel;
@property(nonatomic,strong)UIImageView *sexImageView;
@property(nonatomic,strong)UIImageView *NumImageView;
@property(nonatomic,strong)UIButton    *bgButton;
@property(nonatomic,strong)NSIndexPath  *myIndexPath;
@property(nonatomic,strong)UIImageView  *bgImageView1;
@property(nonatomic,strong)UIImageView  *bgImageView2;
@end
