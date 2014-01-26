//
//  ReplyCell.m
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "ReplyCell.h"

@implementation ReplyCell

+ (float)getContentHeigthWithStr:(NSString*)contStr
{
    CGSize cSize = [contStr sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(250, 300) lineBreakMode:NSLineBreakByWordWrapping];
    
    return cSize.height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.headImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        self.headImageV.backgroundColor = [UIColor clearColor];
        [self.headImageV addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.headImageV];

        self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 25)];
        [self.nickNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nickNameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.nickNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nickNameLabel setTextColor:kColorWithRGB(51, 51, 200, 1.0)];
        [self addSubview:self.nickNameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 0, 80, 25)];
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.timeLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:kColorWithRGB(153, 153, 153, 1.0)];
        [self addSubview:self.timeLabel];
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 23, 250, 20)];
        self.commentLabel.numberOfLines = 0;
        [self.commentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.commentLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        [self.commentLabel setTextColor:kColorWithRGB(153, 153, 153, 1.0)];
        [self addSubview:self.commentLabel];
    }
    return self;
}

- (void)refreshCell
{
    float heigth = [ReplyCell getContentHeigthWithStr:self.commentStr];
    self.commentLabel.frame = CGRectMake(70, 23, 250, heigth);
}

- (void)headButtonClick
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(CellHeardButtonClick:)]) {
        [self.myDelegate CellHeardButtonClick:self.rowIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
