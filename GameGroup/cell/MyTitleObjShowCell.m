//
//  MyTitleObjShowCell.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyTitleObjShowCell.h"

@implementation MyTitleObjShowCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.heardImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 30, 44)];
        self.heardImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.heardImg];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 20, 44)];
        self.numLabel.backgroundColor = [UIColor clearColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.font = [UIFont boldSystemFontOfSize:15.0];
        self.numLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.numLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 170, 20)];
        self.nameLabel.backgroundColor = [UIColor clearColor];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:15.0];
        [self addSubview:self.nameLabel];
        
        self.gameImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 31, 18, 18)];
        self.gameImg.backgroundColor = [UIColor clearColor];
        [self addSubview:self.gameImg];
        
        self.characterLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 150, 20)];
        self.characterLabel.backgroundColor = [UIColor clearColor];
        self.characterLabel.textColor = kColorWithRGB(102, 102, 102, 1.0) ;
        self.characterLabel.font = [UIFont boldSystemFontOfSize:13.0];
        [self addSubview:self.characterLabel];
        
        UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 10, 1, 40)];
        lineLabel.backgroundColor = kColorWithRGB(200, 200, 200, 1.0);
        [self addSubview:lineLabel];
        
//        UIImageView* line = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 1, 40)];
//        line.image = KUIImage(@"line_2");
//        [self addSubview:line];
        
        self.hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(236, 10, 28, 41)];
        [self.hideBtn setImage:KUIImage(@"titleobj_hide") forState:UIControlStateNormal];
        [self.hideBtn addTarget:self action:@selector(hideButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hideBtn];
        
        UIButton* cellSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
        cellSelect.backgroundColor = [UIColor clearColor];
        [cellSelect addTarget:self action:@selector(cellSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cellSelect];
        
        UIImageView* arrow = [[UIImageView alloc] initWithFrame:CGRectMake(205, 24, 8, 12)];
        arrow.image = KUIImage(@"right_arrow");
        arrow.backgroundColor = [UIColor clearColor];
        [self addSubview:arrow];
    }
    return self;
}

- (void)hideButtonClick:(id)sender
{
    if (self.myCellDelegate && [self.myCellDelegate respondsToSelector:@selector(hideButtonClick:)]) {
        [self.myCellDelegate hideButtonClick:self];
    }
}

- (void)cellSelectClick:(id)sender
{
    if (self.myCellDelegate && [self.myCellDelegate respondsToSelector:@selector(showCellSelectClick:)]) {
        [self.myCellDelegate showCellSelectClick:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
