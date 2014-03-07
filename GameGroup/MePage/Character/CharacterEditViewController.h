//
//  CharacterEditViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-20.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "MyCharacterEditCell.h"

@interface CharacterEditViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, MyCharacterEditDelegate, UIAlertViewDelegate>
@property(nonatomic,assign)BOOL isFromMeet;
@end
