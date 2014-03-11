//
//  FinderView.m
//  GameGroup
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "FinderView.h"

@implementation FinderView
+(UIButton *)setButtonWithFrame:(CGRect)frame center:(CGPoint)center backgroundNormalImage:(NSString *)normalImage backgroundHighlightImage:(NSString *)highImage setTitle:(NSString *)title nextImage:(NSString *)nImage nextImage:(NSString *)hImage
{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    button.center = center;
    button.backgroundColor = [UIColor whiteColor];
    [button setBackgroundImage:KUIImage(highImage)  forState:UIControlStateNormal];
    [button setBackgroundImage:KUIImage(normalImage) forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setImage:KUIImage(nImage) forState:UIControlStateNormal];
    [button setImage:KUIImage(highImage) forState:UIControlStateSelected];
    return button;
}

+(UILabel *)setLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor textColor:(UIColor *)txColor font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.backgroundColor =bgColor;
    label.textColor = txColor;
    label.font = font;
    return label;
}

+(UITextView *)setTextViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor textColor:(UIColor *)txColor font:(UIFont *)font
{
    UITextView *label = [[UITextView alloc]initWithFrame:frame];
    label.backgroundColor =bgColor;
    label.textColor = txColor;
    label.font = font;
    return label;

}


@end
