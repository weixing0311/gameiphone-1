//
//  RankingCell.m
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 1814年 Swallow. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        
        self.NumImageView =[[UIImageView alloc]initWithFrame:CGRectMake(30, 26, 18, 18)];
        self.NumImageView.backgroundColor = [UIColor clearColor];
        self.NumImageView.hidden =YES;
        [self addSubview:self.NumImageView];
        
        
        
        self.NumLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 50, 70)];
        self.NumLabel.backgroundColor = [UIColor clearColor];
        self.NumLabel.textColor = [UIColor grayColor];
        self.NumLabel.textAlignment = NSTextAlignmentCenter;
        self.NumLabel.font = [UIFont fontWithName:@"汉仪菱心体简" size:19];

        //self.NumLabel.font = [UIFont fontWithName:@"液晶数字字体" size:18];
       // self.NumLabel.layer.borderColor = [[UIColor blackColor] CGColor];
        [self addSubview:self.NumLabel];
        
        self.bgImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
        self.bgImageView1.center = CGPointMake(160, 35);
        self.bgImageView1.image = KUIImage(@"other_normal");
        [self.contentView addSubview:self.bgImageView1];
        self.bgImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
        self.bgImageView2.center = CGPointMake(160, 35);
        self.bgImageView2.image = KUIImage(@"other_click");
        
        UIView *aview = [[UIView alloc]init];
        [aview addSubview:self.bgImageView2];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = aview;   //设置选中后cell的背景颜色

        
        
        self.titleImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(60, 15, 40, 40)];
        self.titleImageView.layer.masksToBounds = YES;
        self.titleImageView.layer.cornerRadius = 20;
        self.titleImageView.layer.borderWidth = 0.1;
        self.titleImageView.layer.borderColor = [[UIColor blackColor] CGColor];

        [self addSubview:self.titleImageView];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 14, 150, 18)];
        
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.backgroundColor =[ UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.serverLabel =[[UILabel alloc]initWithFrame:CGRectMake(130, 37, 130, 18)];
        self.serverLabel.font = [UIFont boldSystemFontOfSize:14];
        self.serverLabel.textColor = [UIColor grayColor];
        self.serverLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serverLabel];
        
        self.sexImageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 40, 13, 13)];
        [self addSubview:self.sexImageView];
        
        
        self.CountOfLabel =[[UILabel alloc]initWithFrame:CGRectMake(200, 5, 83, 60)];
        self.CountOfLabel.font = [UIFont boldSystemFontOfSize:20];
        self.CountOfLabel.backgroundColor =[UIColor clearColor];
        self.CountOfLabel.textColor =UIColorFromRGBA(0x636363, 1);
        self.CountOfLabel.textAlignment = NSTextAlignmentRight;
       // self.CountOfLabel.font = [UIFont fontWithName:@"DigifaceWide" size:16];
        self.CountOfLabel.font = [UIFont fontWithName:@"汉仪菱心体简" size:17];
        [self addSubview:self.CountOfLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
