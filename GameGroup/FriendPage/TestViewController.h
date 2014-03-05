//
//  TestViewController.h
//  GameGroup 
//
//  Created by admin on 14-3-4.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "BaseViewController.h"
#import "HGPhotoWall.h"
#import "HostInfo.h"
typedef enum
{
    VIEW_TYPE_FriendPage1 = 0,
    VIEW_TYPE_AttentionPage1,
    VIEW_TYPE_FansPage1,
    VIEW_TYPE_STRANGER1,//陌生人
    VIEW_TYPE_Self1,//自己
}MyViewType1;

@interface TestViewController : BaseViewController<HGPhotoWallDelegate, UIAlertViewDelegate>

@property(nonatomic, assign)MyViewType1    viewType;
@property(nonatomic, strong)HostInfo*     hostInfo;
@property(nonatomic, strong)NSString*     userId;
@property(nonatomic, strong)NSString*     nickName;
@property(nonatomic, assign)BOOL          isChatPage;//从聊天页面进入 点发起聊天pop
@property(nonatomic,strong)UIImageView *c_headImageView;
@property(nonatomic,copy)NSString *timeStr;//更新时间
@property(nonatomic,copy)NSString *jlStr;//距离
@property(nonatomic,copy)NSString *ageStr;//年龄
@property(nonatomic,copy)NSString *sexStr;//性别
@property(nonatomic,copy)NSString *imgUrl;//图片
@property(nonatomic,copy)NSString *achievementStr;//头衔
@property(nonatomic,strong)UIColor achievementColor;
@end
