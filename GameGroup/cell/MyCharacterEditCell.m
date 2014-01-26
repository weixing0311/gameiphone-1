//
//  MyCharacterEditCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyCharacterEditCell.h"

@implementation MyCharacterEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.heardImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25.0/2, 35, 35)];
        self.heardImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.heardImg];
        
        self.authBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.authBg.backgroundColor = [UIColor clearColor];
        self.authBg.image = KUIImage(@"chara_auth");
        [self addSubview:self.authBg];
        self.authBg.hidden = YES;
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 5, 120, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:self.nameLabel];
        
        self.gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 31, 18, 18)];
        self.gameImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.gameImg];
        
        self.realmLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, 100, 20)];
        self.realmLabel.backgroundColor = [UIColor clearColor];
        self.realmLabel.textColor = kColorWithRGB(102, 102, 102, 1.0) ;
        self.realmLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [self addSubview:self.realmLabel];
        
        UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 10, 1, 40)];
        lineLabel.backgroundColor = kColorWithRGB(200, 200, 200, 1.0);
        [self addSubview:lineLabel];

        self.delBtn = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 28, 41)];
        [self.delBtn setImage:KUIImage(@"chara_del_normal") forState:UIControlStateNormal];
        [self.delBtn setImage:KUIImage(@"chara_del_click") forState:UIControlStateHighlighted];
        [self.delBtn addTarget:self action:@selector(deleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.delBtn];
        
        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 28, 41)];
        [self.editBtn setImage:KUIImage(@"chara_edit_normal") forState:UIControlStateNormal];
        [self.editBtn setImage:KUIImage(@"chara_edit_click") forState:UIControlStateHighlighted];
        [self.editBtn addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.editBtn];
        self.editBtn.hidden = YES;
        
        self.authBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 10, 28, 41)];
        [self.authBtn setImage:KUIImage(@"chara_auth_normal") forState:UIControlStateNormal];
        [self.authBtn setImage:KUIImage(@"chara_auth_click") forState:UIControlStateHighlighted];
        [self.authBtn addTarget:self action:@selector(authButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.authBtn];
        self.authBtn.hidden = YES;
    }
    return self;
}

- (void)authButtonClick:(id)sender
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(authButtonClick:)])
        [self.myDelegate authButtonClick:self];
}

- (void)deleButtonClick:(id)sender
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(deleButtonClick:)])
        [self.myDelegate deleButtonClick:self];
}

- (void)editButtonClick:(id)sender
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(editButtonClick:)])
        [self.myDelegate editButtonClick:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
