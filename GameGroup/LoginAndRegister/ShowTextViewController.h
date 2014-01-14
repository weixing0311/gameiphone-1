//
//  ShowTextViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-10.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

@interface ShowTextViewController : BaseViewController<UITextViewDelegate>

@property(nonatomic, strong)NSString* fileName;
@property(nonatomic, strong)NSString* myViewTitle;
@end
