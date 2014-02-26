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



/*
 {
 characters =
 dynamicmsg =
 fansnum = 12;
 shiptype = 2;
 title =     (
 {
 characterid = 1626;
 charactername = "\U767e\U5072\U9208\U561a\U9a91\U59d0";
 clazz = 8;
 gameid = 1;
 hasDate = 1389344380000;
 hide = 0;
 id = 47325;
 realm = "\U77f3\U722a\U5cf0";
 sortnum = 1;
 titleObj =             {
 createDate = 1389340897000;
 evolution = 0;
 gameid = 1;
 icon = " ";
 id = 111;
 img = 501;
 rank = 1;
 ranktype = "1,2,3";
 rankvaltype = itemlevel;
 rarememo = "1.53%";
 rarenum = 6;
 remark = "\U867d\U7136\U6c38\U6052\U5c9b\U5904\U5904\U5145\U6ee1\U5371\U9669\Uff0c\U4f46\U4e5f\U6709\U5f88\U591a\U4e0d\U9519\U7684\U673a\U9047\Uff0c\U5bcc\U8d35\U9669\U4e2d\U6c42\U554a\Uff01";
 remarkDetail = "\U83b7\U53d6\U6761\U4ef6\Uff1a
 \n\U83b7\U53d6\U88c5\U5907\U5230\U8fbe496\U7ea7\U522b
 \n
 \n\U4e0b\U4e00\U5934\U8854\Uff1a
 \n\U88c5\U5907\U7b49\U7ea7\U5230\U8fbe561";
 simpletitle = "\U7d2b\U88c5\U5f00\U59cb!";
 sortnum = 1;
 title = "\U7d2b\U88c5\U5f00\U59cb!";
 titlekey = "wow_itemlevel_496";
 titletype = "\U88c5\U5907\U7b49\U7ea7";
 };
 titleid = 111;
 userid = 10000025;
 userimg = " ";
 }
 );
 user =     {
 age = 10;
 alias = " ";
 appType = 91;
 backgroundImg = " ";
 birthdate = 20030601;
 city = " ";
 constellation = "\U53cc\U5b50\U5ea7";
 createTime = 1389233300000;
 deviceToken = "1a09c30b 3e96f7da 77404cde 4f6516db 8a8385f0 e901e827 c2bfe20b 02705531";
 distance = "3.933610660144203";
 email = "59762761@qq.com";
 fan = 12;
 gender = 1;
 hobby = " ";
 id = 10000025;
 ifFraudulent = " ";
 img = "971,973,972,975,974,970,";
 latitude = "39.982452";
 longitude = "116.304619";
 modTime = 1392206001000;
 nickname = "\U989c\U989c";
 password = "lueSGJZetyySpUndWjMBEg==";
 phoneNumber = " ";
 rarenum = 0;
 realname = " ";
 remark = "\U8840\U7cbe\U7075\U6cd5\U599e";
 signature = "Biu Biu Biu\Uff0c\U6df1\U7ed3\U53cc\U7206\U6765\U4e00\U53d1\Uff01";
 superremark = "";
 superstar = 0;
 title = " ";
 updateUserLocationDate = 1393241723438;
 username = 15120072204;
 };
 zannum = 0;
 }
 
 
 */