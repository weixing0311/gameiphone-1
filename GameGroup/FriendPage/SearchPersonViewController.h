//
//  SearchPersonViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-16.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "RealmsSelectViewController.h"
#import "SearchRoleViewController.h"

typedef enum
{
    SEARCH_TYPE_ID = 0,
    SEARCH_TYPE_PHONE,
    SEARCH_TYPE_ROLE,
}SearchViewType;

@interface SearchPersonViewController : BaseViewController<UITextFieldDelegate, RealmSelectDelegate, SearchRoleDelegate>

@property (nonatomic, assign)SearchViewType viewType;

@end
