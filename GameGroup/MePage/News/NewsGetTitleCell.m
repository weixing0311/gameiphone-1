//
//  NewsGetTitleCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-27.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "NewsGetTitleCell.h"

@implementation NewsGetTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {//80

        self.headImageV = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headImageV.layer.cornerRadius = 5;
        self.headImageV.layer.masksToBounds=YES;
        self.headImageV.backgroundColor = [UIColor clearColor];
        [self addSubview:self.headImageV];

        self.headButton = [[UIButton alloc] initWithFrame:self.headImageV.frame];
        self.headButton.backgroundColor = [UIColor clearColor];
        [self.headButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.headButton];
        
        self.authImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 5, 20, 20)];
        self.authImage.backgroundColor = [UIColor clearColor];
        self.authImage.hidden = YES;
        [self addSubview:self.authImage];
        
        self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 20)];
        [self.nickNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self.nickNameLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.nickNameLabel setBackgroundColor:[UIColor clearColor]];
        [self.nickNameLabel setTextColor:kColorWithRGB(51, 51, 200, 1.0)];
        [self addSubview:self.nickNameLabel];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 100, 20)];
        [self.typeLabel setTextAlignment:NSTextAlignmentLeft];
        [self.typeLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.typeLabel setBackgroundColor:[UIColor clearColor]];
        [self.typeLabel setTextColor:kColorWithRGB(151, 151, 151, 1.0)];
        [self addSubview:self.typeLabel];
        
        self.nickNameButton = [[UIButton alloc] initWithFrame:self.nickNameLabel.frame];
        self.nickNameButton.backgroundColor = [UIColor clearColor];
        [self.nickNameButton addTarget:self action:@selector(headButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nickNameButton];

        self.bigTitle = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 40)];
        self.bigTitle.numberOfLines = 2;
        [self.bigTitle setTextAlignment:NSTextAlignmentLeft];
        [self.bigTitle setFont:[UIFont boldSystemFontOfSize:14.0]];
        [self.bigTitle setBackgroundColor:[UIColor clearColor]];
        [self.bigTitle setTextColor:kColorWithRGB(51, 51, 51, 1.0)];
        [self addSubview:self.bigTitle];
        
        self.commentBgImage = [[UIButton alloc] initWithFrame:CGRectMake(70, 60, 200, 25)];
        [self.commentBgImage setBackgroundImage:KUIImage(@"comment_click") forState:UIControlStateHighlighted];
        self.commentBgImage.backgroundColor = kColorWithRGB(240, 240, 240, 1.0);
        self.commentBgImage.layer.cornerRadius = 5;
        self.commentBgImage.layer.masksToBounds=YES;
        [self addSubview:self.commentBgImage];
        [self.commentBgImage addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.commentBgImage.hidden = YES;
        
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 60, 190, 25)];
        [self.commentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.commentLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.commentLabel setBackgroundColor:[UIColor clearColor]];
        [self.commentLabel setTextColor:kColorWithRGB(102, 102, 102, 1.0)];
        [self addSubview:self.commentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 60, 15)];
        [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.timeLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:kColorWithRGB(153, 153, 153, 1.0)];
        [self addSubview:self.timeLabel];
        
        self.havePic = [[UIImageView alloc] initWithFrame:CGRectMake(293, 60, 17, 13)];
        self.havePic.image = KUIImage(@"have_picture");
        [self addSubview:self.havePic];
        self.havePic.hidden = YES;
        
        self.zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 30, 30, 15)];
        [self.zanLabel setTextAlignment:NSTextAlignmentCenter];
        self.zanLabel.layer.cornerRadius = 5;
        self.zanLabel.layer.masksToBounds=YES;
        [self.zanLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        [self.zanLabel setBackgroundColor:kColorWithRGB(23, 161, 240, 1.0)];
        [self.zanLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.zanLabel];
    }
    return self;
}

- (void)refreshCell
{
    BOOL isHaveAuth = NO;
    if (self.authImage.image) {
        isHaveAuth = YES;
    }
    
    CGSize nickSize = [self.nickNameLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:12.0] constrainedToSize:CGSizeMake(100, 25)];
    self.nickNameLabel.frame = CGRectMake(70 + (isHaveAuth?25:0), 5, 100, 20);
    self.typeLabel.frame = CGRectMake(self.nickNameLabel.frame.origin.x + nickSize.width + 5, 5, 100, 20);
    
    self.timeLabel.frame = CGRectMake(0, self.rowHeight - 25, 60, 15);
    self.havePic.frame = CGRectMake(293, self.rowHeight - 25, 17, 13);
    
    CGSize titleSize = [self.bigTitle.text sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 40) lineBreakMode:NSLineBreakByWordWrapping];
    self.bigTitle.frame = CGRectMake(70, 28, 200, titleSize.height);
    
    self.commentBgImage.frame = CGRectMake(70, 33+titleSize.height, 200, 25);
    self.commentLabel.frame = CGRectMake(75, 33+titleSize.height, 190, 25);
    
//    if (self.isShowArticle) {
//        [self.bigTitle setFont:[UIFont boldSystemFontOfSize:13.0]];
//    }
//    else
//    {
//        [self.bigTitle setFont:[UIFont systemFontOfSize:13.0]];
//    }
}


- (void)headButtonClick
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(CellHeardButtonClick:)]) {
        [self.myDelegate CellHeardButtonClick:self.rowIndex];
    }
}

-(void)commentButtonClick
{
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(CellOneButtonClick:)]) {
        [self.myDelegate CellOneButtonClick:self.rowIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
