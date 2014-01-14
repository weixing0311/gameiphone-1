//
//  ReplyCell.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface ReplyCell : UITableViewCell

@property (assign,nonatomic) id<CellButtonClickDelegate> myDelegate;
@property (strong,nonatomic) EGOImageButton * headImageV;

@property (strong,nonatomic) UILabel* nickNameLabel;
@property (strong,nonatomic) UILabel* commentLabel;
@property (strong,nonatomic) UILabel* timeLabel;
@property (strong,nonatomic) NSString* commentStr;
@property (assign,nonatomic) NSInteger rowIndex;

- (void)refreshCell;

+ (float)getContentHeigthWithStr:(NSString*)contStr;

@end
