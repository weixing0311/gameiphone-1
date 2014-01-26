//
//  TextLabelTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "TextLabelTableCell.h"

@implementation TextLabelTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.vAuthImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.vAuthImg.image = KUIImage(@"v_auth");
        [self addSubview:self.vAuthImg];
        self.vAuthImg.hidden = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        self.nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self addSubview:self.nameLabel];
        
        self.disLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 20)];
        self.disLabel.backgroundColor = [UIColor clearColor];
        self.disLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.disLabel.font = [UIFont boldSystemFontOfSize:14.0];
        self.disLabel.numberOfLines = 0;
        [self addSubview:self.disLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
