//
//  CharacterDetailsViewController.h
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterDetailsView.h"
/*
 gameId 暂时就1个 wow --->1
 */
typedef enum
{
    CHARA_INFO_PERSON,
    CHARA_INFO_MYSELF,
}CustomViewType;

@interface CharacterDetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,changeMyPageDelegate>

@property(nonatomic,strong)NSString *characterId;//角色ID
@property(nonatomic,strong)NSString *gameId;//游戏id
@property(nonatomic,strong)NSArray*  titleObjArray;
@property(nonatomic,assign)CustomViewType myViewType;
@end
