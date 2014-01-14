//
//  WebViewViewController.h
//  PetGroup
//
//  Created by Tolecen on 13-11-1.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "BaseViewController.h"

@interface WebViewViewController : BaseViewController<MBProgressHUDDelegate,UIAlertViewDelegate,UIWebViewDelegate>
{
    UIWebView * theWebView;
}
@property (strong,nonatomic)NSURL * addressURL;
@end
