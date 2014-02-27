//
//  EncounterCell.h
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncounterCell : UITableViewCell
@property(strong,nonatomic)UIImageView* heardImg;
@property(strong,nonatomic)UIImageView* authBg;
@property(strong,nonatomic)UILabel* nameLabel;
@property(strong,nonatomic)UILabel* realmLabel;
@property(strong,nonatomic)UIImageView* gameImg;
@property(strong,nonatomic)UILabel* pveLabel;//战斗力
@property(assign,nonatomic)NSInteger rowIndex;
@property(strong,nonatomic)UIButton* refreshPVEbtn;

@property(strong,nonatomic)UILabel* noCharacterLabel;

@end
