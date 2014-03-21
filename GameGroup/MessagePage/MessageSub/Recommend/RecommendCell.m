//
//  RecommendCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {//70
        self.headImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.headImageV addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.headImageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 175, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        self.nameLabel.numberOfLines = 3;
        [self addSubview:self.nameLabel];
        
        self.fromImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 43.5, 13, 13)];
        self.fromImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.fromImage];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 150, 20)];
        [self.fromLabel setTextAlignment:NSTextAlignmentLeft];
        [self.fromLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [self.fromLabel setBackgroundColor:[UIColor clearColor]];
        self.fromLabel.textColor = UIColorFromRGBA(0xa7a7a7,1.0);
        [self addSubview:self.fromLabel];
        
        self.statusButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 45.0/2, 60, 25)];
        self.statusButton.layer.cornerRadius = 5;
        self.statusButton.layer.masksToBounds = YES;
        self.statusButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self.statusButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.statusButton];
    }
    return self;
}

- (void)addButtonClick:(id)sender
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(cellAddButtonClick:)])
        [self.myDelegate cellAddButtonClick:self];
}

- (void)headButtonClick
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(cellHeardImgClick:)]) {
        [self.myDelegate cellHeardImgClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
