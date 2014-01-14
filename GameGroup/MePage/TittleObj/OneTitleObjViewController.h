//
//  OneTitleObjViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-30.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

//从动态进入
@interface OneTitleObjViewController : BaseViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>

@property(nonatomic, strong)NSString* titleId;

@end
