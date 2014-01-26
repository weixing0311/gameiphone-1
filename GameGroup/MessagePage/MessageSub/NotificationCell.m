//
//  NotificationCell.m
//  PetGroup
//
//  Created by Tolecen on 13-11-7.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageV = [[EGOImageButton alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headImageV];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 250, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [self.contentView addSubview:self.nameLabel];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
        self.dotImageV = [[UIImageView alloc] initWithFrame:CGRectMake(295, 10, 15, 15)];
        [self.dotImageV setImage:[UIImage imageNamed:@"redpot.png"]];
        [self.contentView addSubview:self.dotImageV];

        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, 100, 20)];
        [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.timeLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        
        self.contentImageV = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 80, 80)];
        [self.contentImageV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:self.contentImageV];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(225, 15, 70, 70)];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self.contentLabel setNumberOfLines:0];
        [self.contentView addSubview:self.contentLabel];
        
        self.replyBgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 80, 80)];
        [self.replyBgImageV setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
        [self.contentView addSubview:self.replyBgImageV];
        
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, 150, 20)];
        self.replyLabel.backgroundColor = [UIColor clearColor];
//        [self.replyLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.replyLabel setNumberOfLines:0];
        self.replyLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.replyLabel];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
