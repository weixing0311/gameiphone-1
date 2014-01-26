//
//  AddCharacterViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-23.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "RealmsSelectViewController.h"
#import "SearchRoleViewController.h"
#import "AuthViewController.h"

typedef enum
{
    CHA_TYPE_Base = 0,
    CHA_TYPE_Add,
    CHA_TYPE_Change,
}CharacterType;

@interface AddCharacterViewController : BaseViewController<UITextFieldDelegate, RealmSelectDelegate, UIAlertViewDelegate, SearchRoleDelegate, AuthCharacterDelegate>


@property(nonatomic, assign)CharacterType viewType;//增加或删除

//修改页面进入
@property(nonatomic,strong)NSString* gameId;
@property(nonatomic,strong)NSString* characterId;
@property(nonatomic,strong)NSString* character;
@property(nonatomic,strong)NSString* realm;

@end
