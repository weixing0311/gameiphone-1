//
//  FinderView.h
//  GameGroup
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinderView : NSObject
+(UIButton *)setButtonWithFrame:(CGRect)frame center:(CGPoint)center backgroundNormalImage:(NSString *)normalImage backgroundHighlightImage:(NSString *)highImage setTitle:(NSString *)title nextImage:(NSString *)nImage nextImage:(NSString *)hImage;
+(UILabel *)setLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor textColor:(UIColor *)txColor font:(UIFont *)font;

+(UITextView *)setTextViewWithFrame:(CGRect)frame backgroundColor:(UIColor *)bgColor textColor:(UIColor *)txColor font:(UIFont *)font;

@end
