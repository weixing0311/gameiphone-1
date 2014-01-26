//
//  TitleObjUpView.h
//  GameGroup
//
//  Created by Shen Yanping on 13-12-26.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleObjUpView : UIView

@property(nonatomic,strong)NSString* rightImageId;
@property(nonatomic,strong)NSString* gameId;
@property(nonatomic,strong)NSString* rarenum;//稀有度
@property(nonatomic,strong)NSString* titleName;
@property(nonatomic,strong)NSString* characterName;
@property(nonatomic,strong)NSString* remark;
@property(nonatomic,strong)NSString* rarememo;//%
@property(nonatomic,strong)NSString* detailDis;//查看详情内容

@property(nonatomic,strong)UIView*   showDetailView;

@property(nonatomic,strong)UIImageView* rightBgImage;
@property(nonatomic,strong)UIImageView* waitImageView;
@property(nonatomic,strong)UILabel*     waitLabel;
- (void)setMainView;

@end
