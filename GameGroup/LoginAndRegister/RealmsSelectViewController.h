//
//  RealmsSelectViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-23.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@protocol RealmSelectDelegate <NSObject>

- (void)selectOneRealmWithName:(NSString*)name;

@end

@interface RealmsSelectViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, assign)id<RealmSelectDelegate> realmSelectDelegate;
@end
