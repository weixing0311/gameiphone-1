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
        self.NumLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 18, 30, 30)];
        self.NumLabel.backgroundColor = [UIColor orangeColor];
        self.NumLabel.textColor = [UIColor whiteColor];
        self.NumLabel.textAlignment = NSTextAlignmentCenter;
        self.NumLabel.layer.masksToBounds = YES;
        self.NumLabel.layer.cornerRadius = 6.0;
        self.NumLabel.layer.borderWidth = 0.1;
        
        int i = [self.NumLabel.text intValue];
        if (i>99) {
            self.NumLabel.font = [UIFont systemFontOfSize:15];
        }
        self.NumLabel.font = [UIFont boldSystemFontOfSize:18];
        self.NumLabel.layer.borderColor = [[UIColor blackColor] CGColor];

        
        
        [self addSubview:self.NumLabel];
        self.titleImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(50, 10, 50, 50)];
        self.titleImageView.layer.masksToBounds = YES;
        self.titleImageView.layer.cornerRadius = 6.0;
        self.titleImageView.layer.borderWidth = 0.1;
        self.titleImageView.layer.borderColor = [[UIColor blackColor] CGColor];

        [self addSubview:self.titleImageView];
        
        self.titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 150, 18)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        self.titleLabel.backgroundColor =[ UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.serverLabel =[[UILabel alloc]initWithFrame:CGRectMake(110, 37, 130, 18)];
        self.serverLabel.font = [UIFont boldSystemFontOfSize:14];
        self.serverLabel.textColor = [UIColor grayColor];
        self.serverLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.serverLabel];
        
        self.CountOfLabel =[[UILabel alloc]initWithFrame:CGRectMake(250, 0, 100, 60)];
        self.CountOfLabel.font = [UIFont boldSystemFontOfSize:20];
        self.CountOfLabel.backgroundColor =[UIColor clearColor];
        self.CountOfLabel.textColor =UIColorFromRGBA(0x636363, 1);
        self.CountOfLabel.font = [UIFont fontWithName:@"DigifaceWide" size:14];
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
