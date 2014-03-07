//
//  FindSubView.m
//  GameGroup
//
//  Created by admin on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "FindSubView.h"

@implementation FindSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    
    //    [self huaxianWithx:154 y:219+startX tox:105 toy:96+startX];
    //    [self huaxianWithx:154 y:219+startX tox:252 toy:137+startX];
    //    [self huaxianWithx:154 y:219+startX tox:53 toy:193+startX];
    //    [self huaxianWithx:154 y:219+startX tox:262 toy:251+startX];
    //    [self huaxianWithx:154 y:219+startX tox:85 toy:333+startX];

    //获得处理的上下文
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,105, 96);
    //绘制完成
    CGContextStrokePath(context);

    
    CGContextRef
    context1 = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,252, 137);
    //绘制完成
    CGContextStrokePath(context1);

    CGContextRef
    context2 = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,53, 193);
    //绘制完成
    CGContextStrokePath(context2);

    CGContextRef
    context3 = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,262, 251);
    //绘制完成
    CGContextStrokePath(context3);

    CGContextRef
    context4 = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,2.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 0/255.0f, 0/255.0f, 0/255.0f, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,154, 219);
    //下一点
    CGContextAddLineToPoint(context,85, 333);
    //绘制完成
    CGContextStrokePath(context4);

}


@end
