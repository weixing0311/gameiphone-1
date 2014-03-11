//
//  SwithTableViewCell.m
//  GameGroup
//
//  Created by wangxr on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "SwithTableViewCell.h"
@interface SwithTableViewCell ()
@property (nonatomic,retain)UIImageView * imageV;
@property (nonatomic,retain)UILabel * label1;
@property (nonatomic,retain)UILabel * label2;
@end
@implementation SwithTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 40, 45)];
        _imageV.image = [UIImage imageNamed:@"addressBookIcon"];
        [self.contentView addSubview:_imageV];
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
        _label1.text = @"启动手机通讯录";
        _label1.backgroundColor = [UIColor clearColor];
        _label1.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label1];
        self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 40, 200, 20)];
        _label2.text = @"与通讯录中好友建立联系";
        _label2.backgroundColor = [UIColor clearColor];
        _label2.textColor = [UIColor grayColor];
        _label2.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label2];
        self.swith = [[UISwitch alloc]initWithFrame:CGRectMake(250, 10, 40, 60)];
        [self.contentView addSubview:_swith];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
