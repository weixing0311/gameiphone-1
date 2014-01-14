//
//  TitleSortTableCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-26.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleSortCellDelegate;

@interface TitleSortTableCell : UITableViewCell

@property(nonatomic, assign)id<TitleSortCellDelegate> myDelegate;

@property(nonatomic, strong)UIImageView* bgImage;
@property(nonatomic, strong)UILabel* numLabel;
@property(nonatomic, strong)UILabel* characterLabel;
@property(nonatomic, strong)UILabel* clazzLabel;
@property(nonatomic, strong)UIButton* nickNameButton;
@property(nonatomic, strong)UILabel*  pveScoreLabel;

@property(nonatomic, strong)NSIndexPath* myIndexPath;
@end

@protocol TitleSortCellDelegate <NSObject>

- (void)userNameClick:(TitleSortTableCell*)myCell;

@end