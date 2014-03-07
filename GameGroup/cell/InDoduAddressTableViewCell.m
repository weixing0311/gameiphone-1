//
//  InDoduAddressTableViewCell.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "InDoduAddressTableViewCell.h"

@implementation InDoduAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.headerImage = [[EGOImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _headerImage.placeholderImage = [UIImage imageNamed:@"people_man"];
        [self.contentView addSubview:_headerImage];
        self.nameL = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, 200, 20)];
        _nameL.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameL];
        self.photoNoL = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 200, 20)];
        _photoNoL.backgroundColor = [UIColor clearColor];
        _photoNoL.textColor = [UIColor grayColor];
        _photoNoL.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_photoNoL];
        self.addFriendB = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addFriendB.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addFriendB addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
        _addFriendB.frame = CGRectMake(234, 18, 66, 24);
        [self.contentView addSubview:_addFriendB];
    }
    return self;
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
- (void)inviteFriend
{
    if (self.delegate&& [_delegate respondsToSelector:@selector(DodeAddressCellTouchButtonWithIndexPath:)]) {
        [_delegate DodeAddressCellTouchButtonWithIndexPath:self.indexPath];
    }
}
@end
