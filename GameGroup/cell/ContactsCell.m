//
//  ContactsCell.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-5.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "ContactsCell.h"

@implementation ContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code 65
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
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 200, 20)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [bgV addSubview:self.nameLabel];
//        [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];

        self.sexBg = [[UIView alloc] initWithFrame:CGRectMake(80, 26, 50, 18)];
        self.sexBg.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
        self.sexBg.layer.cornerRadius = 3;
        self.sexBg.layer.masksToBounds=YES;
        [bgV addSubview:self.sexBg];
        
        self.ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, 30, 20)];
        [self.ageLabel setTextColor:[UIColor whiteColor]];
        [self.ageLabel setFont:[UIFont systemFontOfSize:14]];
        [self.ageLabel setBackgroundColor:[UIColor clearColor]];
        [bgV addSubview:self.ageLabel];
        
        self.gameImg_one = [[UIImageView alloc] initWithFrame:CGRectMake(140, 26, 18, 18)];
        self.gameImg_one.backgroundColor = [UIColor clearColor];
        [bgV addSubview:self.gameImg_one];
        
        self.sexImg = [[UIImageView alloc] initWithFrame:CGRectMake(82, 29, 13, 13)];
        self.sexImg.backgroundColor = [UIColor clearColor];
        [bgV addSubview:self.sexImg];
        
        self.distLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 240, 20)];
        [self.distLabel setTextColor:[UIColor blackColor]];
        [self.distLabel setFont:[UIFont systemFontOfSize:14]];
        [self.distLabel setBackgroundColor:[UIColor clearColor]];
        [bgV addSubview:self.distLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
