//
//  CommonControlOrView.h
//  GameGroup
//
//  Created by shenyanping on 13-12-16.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonControlOrView : NSObject

+ (UIButton*)setButtonWithFrame:(CGRect)btnFrame title:(NSString*)title fontSize:(UIFont*)font textColor:(UIColor*)textColor bgImage:(UIImage*)bgImage HighImage:(UIImage*)highImg selectImage:(UIImage*)selectImg;

+ (UILabel*)setLabelWithFrame:(CGRect)myFrame textColor:(UIColor*)myColor font:(UIFont*)myFont text:(NSString*)text textAlignment:(NSTextAlignment)alignment;

+ (UIView*)setGenderAndAgeViewWithFrame:(CGRect)myFrame gender:(NSString*)gender age:(NSString*)age star:(NSString*)star gameId:(NSString*)gameId
;

//好友详情 个人动态
+ (UIView*)setPersonStateViewTime:(NSString*)time nameText:(NSString*)nameText achievement:(NSString*)achievement achievementLevel:(NSString*)level titleImage:(NSString*)titleImage;

+ (UIView*)setTwoLabelViewNameText:(NSString*)nameText text:(NSString*)text nameTextColor:(UIColor*)nameTextColor textColor:(UIColor*)textColor;


//我的角色
+ (UIView*)setCharactersViewWithName:(NSString*)text gameId:(NSString*)gameId realm:(NSString*)realm pveScore:(NSString*)pveScore img:(NSString*)image auth:(NSString*)auth;

//我的头衔
+ (UIView*)setMyTitleObjWithImage:(NSString*)imageName titleName:(NSString*)titleName rarenum:(NSString*)rarenum showCurrent:(BOOL)isNoShow
;
@end
