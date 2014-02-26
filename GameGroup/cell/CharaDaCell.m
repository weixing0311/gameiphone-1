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
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 32, 100, 30)];
        self.CountLabel.textColor = [UIColor blackColor];
        self.CountLabel.font = [UIFont systemFontOfSize:16];
        self.CountLabel.textAlignment = NSTextAlignmentLeft;
        self.CountLabel.textColor = [UIColor grayColor];
        self.CountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.CountLabel];

        self.topImgView =[[UIImageView alloc]initWithFrame:CGRectMake(190, 26, 18, 18)];
        [self addSubview:self.topImgView];
        
        self.rankingLabel = [[UILabel alloc]initWithFrame:CGRectMake(210, 0, 85, 60)];
        self.rankingLabel.textColor = [UIColor blueColor];
        self.rankingLabel.font = [UIFont fontWithName:@"FZKaTong-M19S" size:20];
        self.rankingLabel.textAlignment = NSTextAlignmentCenter;
        self.rankingLabel.backgroundColor =[UIColor clearColor];
        
        [self addSubview:self.rankingLabel];
        
        self.upDowmImgView = [[UIImageView alloc]initWithFrame:CGRectMake(295, 22, 16, 16)];
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
