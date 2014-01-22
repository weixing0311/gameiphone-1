//
//  BaseViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-3.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CommonControlOrView.h"
#import "KGStatusBar.h"
#import "GameCommon.h"
#import "MLNavigationController.h"
#import "Custom_tabbar.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate>
{
    float              startX;//7系统与7以下坐标调节
    
    MBProgressHUD* hud;//提示框
}

- (BOOL)isHaveLogin;

- (void)setTopViewWithTitle:(NSString*)titleStr withBackButton:(BOOL)hasBacButton;
- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)bTitle;
- (void)showMessageWithContent:(NSString*)content point:(CGPoint)point;
- (void)showMessageWindowWithContent:(NSString*)content imageType:(NSInteger)imageType;

@end
