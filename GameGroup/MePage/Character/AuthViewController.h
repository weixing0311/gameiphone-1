//
//  AuthViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@protocol AuthCharacterDelegate <NSObject>

- (void)authCharacterSuccess;

@end

@interface AuthViewController : BaseViewController<UIAlertViewDelegate>

@property(nonatomic,strong)NSString* gameId;

@property(nonatomic,strong)NSString* realm;
@property(nonatomic,strong)NSString* character;
@property(nonatomic,assign)id<AuthCharacterDelegate> authDelegate;

@end
