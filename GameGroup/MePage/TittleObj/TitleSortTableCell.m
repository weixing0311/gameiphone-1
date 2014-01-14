//
//  TitleSortTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-26.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "TitleSortTableCell.h"

@implementation TitleSortTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeigth - 10, 45)];
        self.bgImage.backgroundColor = kColorWithRGB(238, 238, 238, 1.0);
        [self addSubview:self.bgImage];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 45)];
        [self.numLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.numLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.numLabel];
        
        UIImageView* line_1 = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 1, 45)];
        line_1.image = KUIImage(@"line_2");
        [self addSubview:line_1];
        
        float buttonWidth = (kScreenHeigth - 170)/3;
        self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, buttonWidth, 45)];
        [self.characterLabel setTextAlignment:NSTextAlignmentCenter];
        [self.characterLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.characterLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.characterLabel];
        
        UIImageView* line_2 = [[UIImageView alloc] initWithFrame:CGRectMake(80 + buttonWidth, 0, 1, 45)];
        line_2.image = KUIImage(@"line_2");
        [self addSubview:line_2];
        
        self.clazzLabel = [[UILabel alloc] initWithFrame:CGRectMake(80 + buttonWidth, 0, 80, 45)];
        [self.clazzLabel setTextAlignment:NSTextAlignmentCenter];
        [self.clazzLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.clazzLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.clazzLabel];
        
        UIImageView* line_3 = [[UIImageView alloc] initWithFrame:CGRectMake(160 +  buttonWidth, 0, 1, 45)];
        line_3.image = KUIImage(@"line_2");
        [self addSubview:line_3];
        
        self.nickNameButton = [[UIButton alloc] initWithFrame:CGRectMake(160 + buttonWidth, 0, buttonWidth, 45)];
        self.nickNameButton.backgroundColor = [UIColor clearColor];
        [self.nickNameButton setTitleColor:kColorWithRGB(0, 102, 255, 1.0) forState:UIControlStateNormal];
        self.nickNameButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self.nickNameButton addTarget:self action:@selector(UserNickNameClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nickNameButton];
        
        UIImageView* line_4 = [[UIImageView alloc] initWithFrame:CGRectMake(160 + buttonWidth * 2, 0, 1, 45)];
        line_4.image = KUIImage(@"line_2");
        [self addSubview:line_4];
        
        self.pveScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(160 + buttonWidth * 2, 0, buttonWidth, 45)];
        [self.pveScoreLabel setTextAlignment:NSTextAlignmentCenter];
        [self.pveScoreLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.pveScoreLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.pveScoreLabel];
    }
    return self;
}

- (void)UserNickNameClick:(id)sender
{
    [self.myDelegate userNameClick:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
