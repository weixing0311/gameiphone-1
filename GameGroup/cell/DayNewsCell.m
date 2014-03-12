//
//  DayNewsCell.m
//  GameGroup
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "DayNewsCell.h"
#import "FinderView.h"
@implementation DayNewsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageBtn = [[EGOImageButton alloc]initWithFrame:CGRectMake(10, 15, 32, 32)];
        self.headImageBtn.layer.cornerRadius = 5;
        self.headImageBtn.layer.masksToBounds=YES;
        [self.headImageBtn setBackgroundImage:KUIImage(@"moren_people") forState:UIControlStateNormal];
        //self.headImageBtn.backgroundColor = [UIColor grayColor];
        [self addSubview:self.headImageBtn];
        
        
        self.nickNameLabel = [FinderView setLabelWithFrame:CGRectMake(52, 15, 120, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
        [self addSubview:self.nickNameLabel];
        self.signatureLabel = [FinderView setLabelWithFrame:CGRectMake(52, 27, 258, 35) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:13]];
        
        [self addSubview:self.signatureLabel];
        
        self.bigImageView =[[EGOImageView alloc]initWithFrame:CGRectMake(10, 73, 300, 180)];
        self.bigImageView.layer.cornerRadius = 5;
        self.bigImageView.layer.masksToBounds=YES;

        self.bigImageView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.bigImageView];
        
        self.authorLabel = [FinderView setLabelWithFrame:CGRectMake(190, 250, 110,40) backgroundColor:[UIColor clearColor] textColor:[UIColor grayColor] font:[UIFont systemFontOfSize:13]];
        self.authorLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.authorLabel];
        
        self.NumLabel =[FinderView setLabelWithFrame:CGRectMake(10, 300, 47, 47) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x79b574, 1) font:[UIFont fontWithName:@"汉仪菱心体简" size:50]];
        self.NumLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.NumLabel];
        
        
        self.timeLabel =[FinderView setLabelWithFrame:CGRectMake(10, 350, 60, 20) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x9d9d9d, 1) font:[UIFont systemFontOfSize:12]];
        //self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeLabel];

        self.newsOfBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.timeLabel.bounds.size.width+10, 300,self.bounds.size.width-30-self.NumLabel.bounds.size.width , 105)];
        [self.newsOfBtn setBackgroundImage:KUIImage(@"content_normal") forState:UIControlStateNormal];
        
        [self.newsOfBtn setBackgroundImage:KUIImage(@"contnet_click") forState:UIControlStateHighlighted];
        [self addSubview:self.newsOfBtn];
        
        
        self.titleLabel =[FinderView setLabelWithFrame:CGRectMake(20, 5, 200, 20) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x333333, 1) font:[UIFont systemFontOfSize:17]];
        
        [self.newsOfBtn addSubview:self.titleLabel];

        self.contentLabel=[FinderView setTextViewWithFrame:CGRectMake(20, 26, 200, 80) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x6d6d6d, 1) font:[UIFont systemFontOfSize:14]];
        self.contentLabel.userInteractionEnabled = NO;
        if (self.contentLabel.text.length>10) {
        }
        [self.newsOfBtn addSubview:self.contentLabel];

    }
    return self;
}

-(void)enterTodt:(id)sender
{
    NSLog(@"点击");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
