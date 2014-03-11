//
//  PhotoViewController.h
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
@property (nonatomic,strong)NSArray* imgIDArray;
@property (nonatomic,assign)int indext;
@property(nonatomic,assign)BOOL isComeFrmeUrl;//来自后台推送网页
- (id)initWithSmallImages:(NSArray*)sImages images:(NSArray*)images indext:(int)indext;
@end
