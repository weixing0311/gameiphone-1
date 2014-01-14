//
//  NormalTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-16.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "NormalTableCell.h"

@implementation NormalTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 20)/2, 20, 20)];
        self.leftImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftImageView];
        
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 28, 22)];
        [self.notiBgV setImage:[UIImage imageNamed:@"redpot"]];
        [self addSubview:self.notiBgV];
        self.notiBgV.hidden = YES;
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 200, self.frame.size.height)];
        self.titleLable.backgroundColor = [UIColor clearColor];
        self.titleLable.textColor = [UIColor blackColor];
        self.titleLable.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.titleLable];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
