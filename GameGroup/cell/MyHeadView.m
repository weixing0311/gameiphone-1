//
//  MyHeadView.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "MyHeadView.h"
@interface MyHeadView ()
{
    
}
@end
@implementation MyHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 33)];
        imageV.image = [UIImage imageNamed:@"table_heard_bg"];
        [self addSubview:imageV];
        self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(10, 4, 300, 20)];
        _titleL.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleL];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
