//
//  SelectView.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-24.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectGameIdKey @"gameIdKey"
#define kSelectRealmKey  @"realmKey"
#define kSelectCharacterKey  @"characterKey"

@protocol SelectViewDelegate <NSObject>

- (void)selectButtonWithIndex:(NSInteger)buttonIndex;

@end

@interface SelectView : UIView

@property(nonatomic,assign)id<SelectViewDelegate> selectDelegate;
@property(nonatomic,strong)NSMutableArray*        buttonTitleArray;

- (void)setMainView;

@end
