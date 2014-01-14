//
//  NormalTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyNormalTableCell.h"

@implementation MyNormalTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.heardImg = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        self.heardImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.heardImg];
        
        self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 150, 20)];
        self.upLabel.backgroundColor = [UIColor clearColor];
        self.upLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.upLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:self.upLabel];
        
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 30, 250, 20)];
        self.downLabel.backgroundColor = [UIColor clearColor];
        self.downLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        self.downLabel.font = [UIFont systemFontOfSize:13.0];
        [self addSubview:self.downLabel];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
