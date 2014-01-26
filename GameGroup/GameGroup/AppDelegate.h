//
//  AppDelegate.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-3.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartViewController;
@class XMPPHelper;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) StartViewController *startViewController;
@property (nonatomic,strong) XMPPHelper *xmppHelper;

@end
