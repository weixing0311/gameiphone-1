//
//  HGPhotoWall.h
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

//Modified by Tolecen on 9/6/2013

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol HGPhotoWallDelegate <NSObject>

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall;
- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex;
- (void)photoWallAddAction;
- (void)photoWallAddFinish;
- (void)photoWallDeleteFinish;
- (void)photoWallDelPhotoAtIndex:(NSInteger)index;

@end
typedef  enum
{
    DescriptionTypePet,
    DescriptionTypeImage
}DescriptionType;
@interface HGPhotoWall : UIView<UIAlertViewDelegate>
@property (strong, nonatomic) UILabel *labelDescription;
@property (assign) id<HGPhotoWallDelegate> delegate;
@property (strong,nonatomic)UIView *bg;
@property (strong, nonatomic) NSMutableArray *arrayPhotos;
@property (assign,nonatomic)DescriptionType descriptionType;
@property (assign,nonatomic) BOOL useCache;
- (void)setPhotos:(NSArray*)photos;
- (void)setEditModel:(BOOL)canEdit;
- (void)addPhoto:(NSString*)string;
- (void)deletePhotoByIndex:(NSUInteger)index;
-(void)setAnimationNO;
- (void)reloadPhotos:(BOOL)add;
-(void)delSuccess;

@end
