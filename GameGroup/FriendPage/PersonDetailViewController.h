//
//  PersonDetailViewController.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-13.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "HGPhotoWall.h"
#import "HostInfo.h"

typedef enum
{
    VIEW_TYPE_FriendPage = 0,
    VIEW_TYPE_AttentionPage,
    VIEW_TYPE_FansPage,
    VIEW_TYPE_STRANGER,//陌生人
    VIEW_TYPE_Self,//自己
}MyViewType;

@interface PersonDetailViewController : BaseViewController<HGPhotoWallDelegate, UIAlertViewDelegate>

@property(nonatomic, assign)MyViewType    viewType;
@property(nonatomic, strong)HostInfo*     hostInfo;
@property(nonatomic, strong)NSString*     userId;
@property(nonatomic, strong)NSString*     nickName;
@property(nonatomic, assign)BOOL          isChatPage;//从聊天页面进入 点发起聊天pop

@end
