//
//  CharacterDetailsView.h
//  GameGroup
//
//  Created by admin on 14-2-21.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@protocol MyCharacterDelegate;
@interface CharacterDetailsView : UIScrollView<UIScrollViewDelegate>


@property(assign,nonatomic)id<MyCharacterDelegate> myCharaterDelegate;
@property(nonatomic,strong)UIScrollView *  TopScrollView;
@property(nonatomic,strong)UIImageView  *  topImageView;
@property(nonatomic,strong)UIView       *  titleView;//头像后面的黑色背景
@property(nonatomic,strong)EGOImageView *  headerImageView;//头像
@property(nonatomic,strong)UILabel      *  NickNameLabel;//名字LB
@property(nonatomic,strong)UILabel      *  guildLabel;//公会label
@property(nonatomic,strong)UIView       *  rightPView;//右上透明veiw；
@property(nonatomic,strong)UILabel      *  realmView;//服务器 阵营 职业
@property(nonatomic,strong)UIImageView  *  gameIdView;//游戏图标
@property(nonatomic,strong)UIView       *  authView;//认证view；
@property(nonatomic,strong)UIImageView  *  clazzImageView;//职业图标
@property(nonatomic,strong)UILabel      *  levelLabel;//等级
@property(nonatomic,strong)UILabel      *  itemlevelView;//装等VIEWebFix；
@property(nonatomic,strong)UIButton     *  myFriendBtn;
@property(nonatomic,strong)UIButton     *  countryBtn;
@property(nonatomic,strong)UIButton     *  realmBtn;
@property(nonatomic,strong)UIImageView  *  underListImageView;//下划线img
@property(nonatomic,strong)UIScrollView *  listScrollView;
@property(nonatomic,strong)UIImageView  *  certificationImage;//认证button
-(void)comeFromMy;
-(void)comeFromPerson;

@end

@protocol MyCharacterDelegate <NSObject>

- (void)reLoadingList:(CharacterDetailsView *)characterdetailsView;
@end


