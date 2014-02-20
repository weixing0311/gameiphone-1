//
//  FindPasswordViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-9.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"

typedef enum
{
    FINDPAS_TYPE_BASE = 0,
    FINDPAS_TYPE_PHONENUM,
    FINDPAS_TYPE_EMAIL,
}FindPasType;

@interface FindPasswordViewController : BaseViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic, assign)FindPasType viewType;

@end
