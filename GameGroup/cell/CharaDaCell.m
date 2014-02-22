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
        self.titleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 12, 35, 35)];
        [self addSubview:self.titleImgView];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 100, 20)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 22, 100, 30)];
        self.CountLabel.textColor = [UIColor blackColor];
        self.CountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];

        self.topImgView =[[UIImageView alloc]initWithFrame:CGRectMake(148, 26, 18, 18)];
        [self addSubview:self.topImgView];
        
        self.rankingLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 20, 120, 40)];
        self.rankingLabel.textColor = [UIColor blueColor];
        self.rankingLabel.font = [UIFont systemFontOfSize:30];
        self.rankingLabel.backgroundColor =[UIColor clearColor];
        self.rankingLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.rankingLabel];
        
        self.upDowmImgView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 26, 13, 13)];
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
