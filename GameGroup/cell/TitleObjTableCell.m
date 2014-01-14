//
//  TitleObjTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "TitleObjTableCell.h"

@implementation TitleObjTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headImageV];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 50)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.nameLabel];
        
        self.userdButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 15, 80, 20)];
        self.userdButton.backgroundColor = [UIColor clearColor];
        [self.userdButton setTitle:@"当前头衔" forState:UIControlStateNormal];
        [self.userdButton setTitleColor:UIColorFromRGBA(0xa7a7a7,1.0) forState:UIControlStateNormal];
        self.userdButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self addSubview:self.userdButton];
        self.userdButton.hidden = YES;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
