//
//  SearchRoleViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-27.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "RealmsSelectViewController.h"
#import "ListRoleViewController.h"

@protocol SearchRoleDelegate <NSObject>

- (void)searchRoleSuccess:(NSString*)roleName realm:(NSString*)realm;

@end

@interface SearchRoleViewController : BaseViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, RealmSelectDelegate, ListRoleDelegate>

@property(nonatomic, assign)id<SearchRoleDelegate> searchDelegate;
@property(nonatomic, strong)NSString* getRealmName;//从上个页面获取
@end
