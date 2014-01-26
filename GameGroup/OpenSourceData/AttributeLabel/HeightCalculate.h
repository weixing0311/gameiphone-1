//
//  HeightCalculate.h
//  sssssss
//
//  Created by Tolecen on 13-9-6.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"

@interface HeightCalculate : NSObject
+(CGSize)calSizeWithString:(NSString *)theStr WithMaxWidth:(float)maxWidth;
@end
