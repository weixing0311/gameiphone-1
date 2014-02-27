//
//  CharaDaCell.m
//  GameGroup
//
//  Created by admin on 14-2-22.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "CharaDaCell.h"

@implementation CharaDaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 12, 32, 32)];
        [self addSubview:self.titleImgView];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 32, 100, 20)];
        self.CountLabel.textColor = UIColorFromRGBA(0x696969, 1);
        self.CountLabel.font = [UIFont boldSystemFontOfSize:14];
        self.CountLabel.textAlignment = NSTextAlignmentLeft;
        self.CountLabel.textColor = [UIColor grayColor];
        self.CountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.CountLabel];

        self.topImgView =[[UIImageView alloc]initWithFrame:CGRectMake(190, 20, 18, 18)];
        [self addSubview:self.topImgView];
        
        self.rankingLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 85, 60)];
        self.rankingLabel.textColor = UIColorFromRGBA(0x636363, 1);
        self.rankingLabel.font = [UIFont fontWithName:@"DigifaceWide" size:17];
        self.rankingLabel.textAlignment = NSTextAlignmentCenter;
        self.rankingLabel.backgroundColor =[UIColor clearColor];
        
        [self addSubview:self.rankingLabel];
        
        self.upDowmImgView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 22, 12, 12)];
        [self addSubview:self.upDowmImgView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
