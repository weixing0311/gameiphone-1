//
//  HeightCalculate.m
//  sssssss
//
//  Created by Tolecen on 13-9-6.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "HeightCalculate.h"

@implementation HeightCalculate
+(CGSize)calSizeWithString:(NSString *)theStr WithMaxWidth:(float)maxWidth
{
//    NSString *text = [self transformString:theStr];
//    text = [NSString stringWithFormat:@"<font color='black'>%@",text];
//    
//    MarkupParser* p = [[MarkupParser alloc] init];
//    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
//    
//    [attString setFont:[UIFont systemFontOfSize:14]];
//
//    return [attString sizeConstrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) fitRange:NULL];
    return CGSizeMake(0, 0);
}
//+ (NSString *)transformString:(NSString *)originalStr
//{
//    //匹配表情，将表情转化为html格式
//    NSString *text = originalStr;
//    NSString *regex_emoji = @"/[:[\\u4e00-\\u9fa5]]{2}";
//    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
//    // NSLog(@"EMOJIARRAY:%@",array_emoji);
//    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"emotionImageThird.plist"];
//    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
//    if ([array_emoji count]) {
//        for (NSString *str in array_emoji) {
//            NSRange range = [text rangeOfString:str];
//            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
//            if (i_transCharacter) {
//                NSString *imageHtml = [NSString stringWithFormat:@"<img src='%@' width='15' height='15'>",i_transCharacter];
//                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
//            }
//        }
//    }
//    //返回转义后的字符串
//    return text;
//}

@end
