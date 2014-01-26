//
//  RecommendCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@protocol RecommendDelegate;

@interface RecommendCell : UITableViewCell

@property(nonatomic, assign)id<RecommendDelegate> myDelegate;

@property (strong,nonatomic) EGOImageButton * headImageV;
@property (strong,nonatomic) UILabel * nameLabel;
@property (strong,nonatomic) UIImageView* fromImage;
@property (strong,nonatomic) UILabel* fromLabel;
@property (strong,nonatomic) UIButton* statusButton;
@property (strong,nonatomic) NSIndexPath * myIndexPath;

@end

@protocol RecommendDelegate <NSObject>

- (void)cellAddButtonClick:(RecommendCell*)myCell;
- (void)cellHeardImgClick:(RecommendCell*)myCell;
@end