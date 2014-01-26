//
//  MyTitleObjShowCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-25.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyTitleEditDelegate;

@interface MyTitleObjShowCell : UITableViewCell

@property(assign,nonatomic)id<MyTitleEditDelegate> myCellDelegate;

@property(strong,nonatomic)UIImageView* heardImg;

@property(strong,nonatomic)UILabel* numLabel;
@property(strong,nonatomic)UILabel* nameLabel;
@property(strong,nonatomic)UILabel* characterLabel;
@property(strong,nonatomic)UIImageView* gameImg;

@property(strong,nonatomic)UIButton*    hideBtn;
@property(strong,nonatomic)NSIndexPath*  myIndexPath;

@end

@protocol MyTitleEditDelegate <NSObject>

- (void)hideButtonClick:(MyTitleObjShowCell*)myCell;
- (void)showCellSelectClick:(MyTitleObjShowCell*)myCell;

@end