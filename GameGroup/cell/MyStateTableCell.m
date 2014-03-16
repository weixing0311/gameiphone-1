//
//  MyStateTableCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyStateTableCell.h"

@implementation MyStateTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {//80
        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(248, 20, 40, 40)];
        self.headImageV.backgroundColor = [UIColor clearColor];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        [self addSubview:self.headImageV];
        
        self.notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(281, 18, 10, 10)];
        [self.notiBgV setImage:[UIImage imageNamed:@"redCB"]];
        [self addSubview:self.notiBgV];
        self.notiBgV.hidden = YES;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 230, 20)];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        self.titleLabel.textColor = kColorWithRGB(151, 151, 151, 1.0);
        [self addSubview:self.titleLabel];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 220, 40)];
        [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nameLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.textColor = kColorWithRGB(51, 51, 51, 1.0);
        [self addSubview:self.nameLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 20)];
        [self.timeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.timeLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        self.timeLabel.textColor = kColorWithRGB(151, 151, 151, 1.0);
        [self addSubview:self.timeLabel];
        
        UIImageView* arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 40 - 6, 8, 12)];
        arrow.image = KUIImage(@"right_arrow");
        arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:arrow];
        
        self.cellButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [self.cellButton setBackgroundColor:[UIColor clearColor]];
//        [self.cellButton addTarget:self action:@selector(myStateClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cellButton];
        
        UIImageView* lineImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, kScreenWidth, 2)];
        lineImg.image = KUIImage(@"line");
        lineImg.backgroundColor = [UIColor clearColor];
        [self addSubview:lineImg];
        
        UIButton* zanBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 90, 75, 30)];
        [zanBtn setImage:KUIImage(@"detail_zan") forState:UIControlStateNormal];
        zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
        [zanBtn addTarget:self action:@selector(ZanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:zanBtn];

        UIButton* fansBtn = [[UIButton alloc] initWithFrame:CGRectMake(85, 90, 75, 30)];
        [fansBtn setImage:KUIImage(@"detail_fans") forState:UIControlStateNormal];
        fansBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 45);
        [fansBtn addTarget:self action:@selector(FansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fansBtn];

        self.zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 90, 45, 30)];
        self.zanLabel.backgroundColor = [UIColor clearColor];
        self.zanLabel.textColor = kColorWithRGB(151, 151, 151, 1.0);
        self.zanLabel.font = [UIFont systemFontOfSize:12.0];
        self.zanLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.zanLabel];
        
        self.fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(117, 90, 45, 30)];
        self.fansLabel.backgroundColor = [UIColor clearColor];
        self.fansLabel.textColor = kColorWithRGB(151, 151, 151, 1.0);
        self.fansLabel.font = [UIFont systemFontOfSize:12.0];
        self.fansLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.fansLabel];
    }
    return self;
}

- (void)myStateClick:(id)sender
{
    
}

- (void)ZanButtonClick:(id)sender
{
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"获得赞的数量：%@", self.zanLabel.text] delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}

- (void)FansButtonClick:(id)sender
{
    UIAlertView* alter = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"拥有粉丝数量：%@", self.fansLabel.text] message:@"拥有粉丝数量包含好友数量" delegate:Nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alter show];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
