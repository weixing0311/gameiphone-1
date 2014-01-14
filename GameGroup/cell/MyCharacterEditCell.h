//
//  MyCharacterEditCell.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MyCharacterEditDelegate;

@interface MyCharacterEditCell : UITableViewCell

@property(nonatomic,assign)id<MyCharacterEditDelegate> myDelegate;

@property(strong,nonatomic)UIImageView* heardImg;
@property(strong,nonatomic)UIImageView* authBg;
@property(strong,nonatomic)UILabel* nameLabel;
@property(strong,nonatomic)UILabel* realmLabel;
@property(strong,nonatomic)UIImageView* gameImg;

@property(strong,nonatomic)UIButton*    delBtn;
@property(strong,nonatomic)UIButton*    authBtn;
@property(strong,nonatomic)UIButton*    editBtn;

@property(strong,nonatomic)NSIndexPath*  myIndexPath;

@end

@protocol MyCharacterEditDelegate <NSObject>

- (void)deleButtonClick:(MyCharacterEditCell*)editCell;
- (void)authButtonClick:(MyCharacterEditCell*)editCell;
- (void)editButtonClick:(MyCharacterEditCell*)editCell;

@end