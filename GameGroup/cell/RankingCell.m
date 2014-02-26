//
//  RankingCell.m
//  GameGroup
//
//  Created by admin on 14-2-24.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "RankingCell.h"

@implementation RankingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.NumLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.NumLabel.backgroundColor = [UIColor orangeColor];
        self.NumLabel.textColor = [UIColor whiteColor];
        self.NumLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.NumLabel];
        self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 10, 50, 50)];
        [self addSubview:self.titleImageView];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 120, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.backgroundColor =[ UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.serverLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 37, 100, 20)];
        self.serverLabel.font =[UIFont systemFontOfSize:14];
        self.serverLabel.textColor = [UIColor grayColor];
        self.serverLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serverLabel];
        
        self.CountOfLabel =[[UILabel alloc]initWithFrame:CGRectMake(250, 0, 100, 60)];
        self.CountOfLabel.font = [UIFont systemFontOfSize:20];
        self.CountOfLabel.backgroundColor =[UIColor clearColor];
        self.CountOfLabel.textColor =[UIColor blueColor];
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
