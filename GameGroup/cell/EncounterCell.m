//
//  EncounterCell.m
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "EncounterCell.h"

@implementation EncounterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* myView = [[UIView alloc] init];
        
        self.heardImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25.0/2, 35, 35)];
        self.heardImg.backgroundColor = [UIColor clearColor];
        [myView addSubview:self.heardImg];
        
//        self.authBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        self.authBg.backgroundColor = [UIColor clearColor];
//        self.authBg.image = KUIImage(@"chara_auth");
//        [self addSubview:self.authBg];
//        self.authBg.hidden = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 120, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [myView addSubview:self.nameLabel];
        
        self.gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 31, 18, 18)];
        self.gameImg.backgroundColor = [UIColor clearColor];
        [myView addSubview:self.gameImg];
        
        self.realmLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 100, 20)];
        self.realmLabel.backgroundColor = [UIColor clearColor];
        self.realmLabel.textColor = kColorWithRGB(102, 102, 102, 1.0) ;
        self.realmLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [myView addSubview:self.realmLabel];
        
//        UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 1, 40)];
//        lineLabel.backgroundColor = kColorWithRGB(200, 200, 200, 1.0);
//        [myView addSubview:lineLabel];
        
        
//        self.pveLabel = [[UILabel alloc] init];
//        self.pveLabel.frame = CGRectMake(201, 7, 110, 20);
//        self.pveLabel.textColor = UIColorFromRGBA(0x0077ff,1.0);
//        self.pveLabel.textAlignment = NSTextAlignmentCenter;
//        self.pveLabel.font = [UIFont boldSystemFontOfSize:16.0];
//        [myView addSubview:self.pveLabel];
        
        
        self.noCharacterLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 255, 60)];
        self.noCharacterLabel.backgroundColor = [UIColor clearColor];
        self.noCharacterLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.noCharacterLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.noCharacterLabel.text = @"暂无角色";
        self.noCharacterLabel.backgroundColor = [UIColor whiteColor];
        [myView addSubview:self.noCharacterLabel];
        self.noCharacterLabel.hidden = YES;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
