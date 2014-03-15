//
//  MessageCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {//65
        // Initialization code
//        self.contentView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 12.5, 45, 45)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self.contentView addSubview:self.headImageV];
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(42, 8, 18, 18)];
        [self.notiBgV setImage:[UIImage imageNamed:@"redCB.png"]];
        self.notiBgV.tag=999;
        [self.contentView addSubview:self.notiBgV];

        self.unreadCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [self.unreadCountLabel setBackgroundColor:[UIColor clearColor]];
        [self.unreadCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.unreadCountLabel setTextColor:[UIColor whiteColor]];
        self.unreadCountLabel.font = [UIFont systemFontOfSize:12.0];
        [self.notiBgV addSubview:self.unreadCountLabel];
        [self.notiBgV setHidden:YES];
        
        self.unreadCountLabel.hidden = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 10, 170, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        [self.contentView addSubview:self.nameLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 28, 230, 40)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.contentLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentLabel setTextColor:[UIColor grayColor]];
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 8, 100, 20)];
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        [self.timeLabel setFont:[UIFont systemFontOfSize:13]];
        [self.timeLabel setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
