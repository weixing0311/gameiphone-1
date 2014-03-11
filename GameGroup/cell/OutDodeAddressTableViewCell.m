//
//  OutDodeAddressTableViewCell.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "OutDodeAddressTableViewCell.h"

@implementation OutDodeAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = kColorWithRGB(246, 246, 246, 1.0);
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        _nameL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameL];
        self.photoNoL = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 20)];
        _photoNoL.backgroundColor = [UIColor clearColor];
        _photoNoL.textColor = [UIColor grayColor];
        _photoNoL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_photoNoL];
        UIButton * inviteV = [UIButton buttonWithType:UIButtonTypeCustom];
        inviteV.titleLabel.font = [UIFont systemFontOfSize:14];
        [inviteV setTitle:@"邀请" forState:UIControlStateNormal];
        [inviteV setBackgroundImage:[UIImage imageNamed:@"invite1"] forState:UIControlStateNormal];
        [inviteV setBackgroundImage:[UIImage imageNamed:@"invite2"] forState:UIControlStateHighlighted];
        [inviteV addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
        inviteV.frame = CGRectMake(250, 18, 48, 24);
        [self.contentView addSubview:inviteV];
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 59, 320, 1)];
        lineV.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:lineV];

    }
    return self;
}
- (void)inviteFriend
{
    if (self.delegate&& [_delegate respondsToSelector:@selector(DodeAddressCellTouchButtonWithIndexPath:)]) {
        [_delegate DodeAddressCellTouchButtonWithIndexPath:self.indexPath];
    }
}
- (void)awakeFromNib
{
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
