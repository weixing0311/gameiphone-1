//
//  OnceDynamicViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 14-1-2.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "HPGrowingTextView.h"
#import "TableViewDatasourceDidChange.h"

@interface OnceDynamicViewController : BaseViewController<HPGrowingTextViewDelegate, TableViewDatasourceDidChange, UIWebViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong)NSString* messageid;
@property (nonatomic, strong)NSString* urlLink;//如果不为空  内容用webView显示
@property (nonatomic,weak)id<TableViewDatasourceDidChange>delegate;

@end