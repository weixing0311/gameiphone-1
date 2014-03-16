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
        
        self.topTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 5, 60, 20)];
        //self.topTimeLabel.center = CGPointMake(160, 15);
        self.topTimeLabel.backgroundColor = [UIColor colorWithRed:180/225.0f green:180/225.0f blue:180/225.0f alpha:1];
        self.headImageBtn.layer.cornerRadius = 10;
        self.headImageBtn.layer.masksToBounds=YES;
        self.topTimeLabel.textColor = [UIColor whiteColor];
        self.topTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        self.topTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.topTimeLabel];
        
        self.topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 310, 400)];
        self.topImageView.image =KUIImage(@"bg_cell");
        self.topImageView.userInteractionEnabled = YES;
        [self  addSubview:self.topImageView];
        
        
        
        self.headImageBtn = [[EGOImageButton alloc]initWithFrame:CGRectMake(20, 15, 32, 32)];
        self.headImageBtn.layer.cornerRadius = 5;
        self.headImageBtn.layer.masksToBounds=YES;
        [self.headImageBtn setBackgroundImage:KUIImage(@"moren_people") forState:UIControlStateNormal];
        //self.headImageBtn.backgroundColor = [UIColor grayColor];
        [self.topImageView addSubview:self.headImageBtn];
        
        
        self.nickNameLabel = [FinderView setLabelWithFrame:CGRectMake(62, 15, 120, 15) backgroundColor:[UIColor clearColor] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16]];
        [self.topImageView addSubview:self.nickNameLabel];
        
        
        UILabel *bianzheLabel = [FinderView setLabelWithFrame:CGRectMake(152, 15, 70, 15) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x868686, 1) font:[UIFont systemFontOfSize:13]];
        [self.topImageView addSubview:bianzheLabel];
        bianzheLabel.text = @"编者语";
        
        self.signatureLabel = [FinderView setLabelWithFrame:CGRectMake(62, 27, 234, 60) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x6d6d6d, 1) font:[UIFont systemFontOfSize:14]];
        [self.signatureLabel setNumberOfLines:2];
        [self.topImageView addSubview:self.signatureLabel];
        
        self.bigImageView =[[EGOImageView alloc]initWithFrame:CGRectMake(20, 83, 270, 180)];
        self.bigImageView.layer.cornerRadius = 5;
        self.bigImageView.layer.masksToBounds=YES;

        self.bigImageView.backgroundColor = [UIColor grayColor];
        [self.topImageView addSubview:self.bigImageView];
        UIImageView *bgauthView =[[ UIImageView alloc]initWithFrame:CGRectMake(0, 150,270, 30)];
        bgauthView.image = KUIImage(@"text_bg_cell.png");
        [self.bigImageView addSubview:bgauthView];
        
        
        self.authorLabel = [FinderView setLabelWithFrame:CGRectMake(165, 0, 100,30) backgroundColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:13]];
        self.authorLabel.textAlignment = NSTextAlignmentRight;
        [bgauthView addSubview:self.authorLabel];
        
        self.NumLabel =[FinderView setLabelWithFrame:CGRectMake(20, 300, 57, 55) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x5aacf0, 1) font:[UIFont fontWithName:@"汉仪菱心体简" size:70]];
        self.NumLabel.textAlignment = NSTextAlignmentCenter;
        [self.topImageView addSubview:self.NumLabel];
        
        
        self.timeLabel =[FinderView setLabelWithFrame:CGRectMake(20, 350, 60, 20) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x77777, 1) font:[UIFont systemFontOfSize:12]];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.topImageView addSubview:self.timeLabel];

        
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(80, 283, 1, 90)];
        shuView.backgroundColor = UIColorFromRGBA(0xcecece, 1);
        [self.topImageView addSubview:shuView];
        self.newsOfBtn = [[UIButton alloc]initWithFrame:CGRectMake(10,300,300,100)];
        [self.topImageView addSubview:self.newsOfBtn];
        
        
        self.titleLabel =[FinderView setLabelWithFrame:CGRectZero backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x333333, 1) font:[UIFont systemFontOfSize:15]];
        [self.timeLabel setNumberOfLines:2];
        self.titleLabel.frame =CGRectMake(90, 290, 200, 20);
        [self.topImageView addSubview:self.titleLabel];

        self.contentLabel=[FinderView setLabelWithFrame:CGRectMake(85, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, 200, 70) backgroundColor:[UIColor clearColor] textColor:UIColorFromRGBA(0x6d6d6d, 1) font:[UIFont systemFontOfSize:14]];
        self.contentLabel.userInteractionEnabled = NO;
        self.contentLabel.numberOfLines = 3;
        [self.topImageView addSubview:self.contentLabel];

        
        
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
