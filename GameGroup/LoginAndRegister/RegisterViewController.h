//
//  RegisterViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-6.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "RealmsSelectViewController.h"
#import "SearchRoleViewController.h"
@protocol RegisterViewControllerDelegate <NSObject>
@optional
-(void)RegisterViewControllerFinishRegister;

@end
@interface RegisterViewController : BaseViewController<UITextFieldDelegate, RealmSelectDelegate, UIAlertViewDelegate, SearchRoleDelegate, UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,retain) id <RegisterViewControllerDelegate>delegate;

@end
