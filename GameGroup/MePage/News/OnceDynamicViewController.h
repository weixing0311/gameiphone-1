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
#import "selectContactPage.h"

@interface OnceDynamicViewController : BaseViewController
<HPGrowingTextViewDelegate,
TableViewDatasourceDidChange,
UIWebViewDelegate,
UIGestureRecognizerDelegate,
getContact,
UIActionSheetDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong)NSString* messageid;
@property (nonatomic, strong)NSString* urlLink;//如果不为空  内容用webView显示
@property (nonatomic,weak)id<TableViewDatasourceDidChange>delegate;
@property(nonatomic,copy)NSString *imgStr;
@property(nonatomic,copy)NSString *nickNameStr;
@property(nonatomic,copy)NSString *touxianStr;
@property(nonatomic,copy)NSString *zanStr;
@property(nonatomic,copy)NSString *timeStr;
@end
