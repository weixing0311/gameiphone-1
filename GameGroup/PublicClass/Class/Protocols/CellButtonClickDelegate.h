//
//  CellButtonClickDelegate.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellButtonClickDelegate <NSObject>
@optional
-(void)CellHeardButtonClick:(int)rowIndex;
-(void)CellOneButtonClick:(int)rowIndex;
@end
