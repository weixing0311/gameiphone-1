//
//  EnteroCell.m
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "EnteroCell.h"

@implementation EnteroCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headerImageView =[[UIImageView alloc]initWithFrame:CGRectMake(22, 13, 34, 34)];
        [self addSubview:self.headerImageView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 12, 100, 20)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:self.titleLabel];
        
        self.gameTitleImage =[[UIImageView alloc]initWithFrame:CGRectMake(67, 39, 20, 20)];
        self.gameTitleImage.image =KUIImage(@"wow");
        [self addSubview:self.gameTitleImage];
        
        self.serverLabel = [[UILabel alloc]initWithFrame:CGRectMake(88, 39, 100, 20)];
        self.serverLabel.backgroundColor = [UIColor clearColor];
        self.serverLabel.textColor = [UIColor whiteColor];
        self.serverLabel.font = [UIFont boldSystemFontOfSize:13];
        [self addSubview:self.serverLabel];

        
        self.jtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(204, 23, 18, 25)];
        self.jtImageView.image = KUIImage(@"xh_jt");
        [self addSubview:self.jtImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
