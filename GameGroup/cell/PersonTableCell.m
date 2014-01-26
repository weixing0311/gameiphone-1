//
//  PersonTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-19.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "PersonTableCell.h"

@implementation PersonTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * bgV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgV];
        
        self.backgroudImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [bgV addSubview:self.backgroudImageV];
        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        self.headImageV.backgroundColor = [UIColor whiteColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [bgV addSubview:self.headImageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 90, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
//        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [bgV addSubview:self.nameLabel];
        //        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 5, 130, 20)];
        self.timeLabel.textColor = kColorWithRGB(102, 102, 102, 1.0);
        [self.timeLabel setTextAlignment:NSTextAlignmentRight];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0];
//        [self.timeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [bgV addSubview:self.timeLabel];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        
//        self.sexBg = [[UIImageView alloc] initWithFrame:CGRectMake(80, 25, 50, 20)];
//        self.sexBg.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
//        [bgV addSubview:self.sexBg];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 30, 20)];
        [self.ageLabel setTextColor:[UIColor whiteColor]];
        [self.ageLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        [self.ageLabel setBackgroundColor:[UIColor clearColor]];
        self.ageLabel.layer.cornerRadius = 3;
        self.ageLabel.layer.masksToBounds = YES;
        self.ageLabel.textAlignment = NSTextAlignmentCenter;
        [bgV addSubview:self.ageLabel];
        
        self.gameImg_one = [[UIImageView alloc] initWithFrame:CGRectMake(140, 26, 18, 18)];
        self.gameImg_one.backgroundColor = [UIColor clearColor];
        [bgV addSubview:self.gameImg_one];
        
        self.sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(82, 29, 13, 13)];
        self.sexImg.backgroundColor = [UIColor clearColor];
        [bgV addSubview:self.sexImg];
        
        self.distLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 240, 20)];
        [self.distLabel setTextColor:[UIColor blackColor]];
        [self.distLabel setFont:[UIFont systemFontOfSize:13]];
        [self.distLabel setBackgroundColor:[UIColor clearColor]];
        [bgV addSubview:self.distLabel];
    }
    return self;
}

- (void)refreshCell
{
    CGSize ageSize = [self.ageLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:10.0] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByWordWrapping];
    self.ageLabel.frame = CGRectMake(80, 29, ageSize.width + 5, 12);
    self.gameImg_one.frame = CGRectMake(95 + ageSize.width, 26, 18, 18);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
