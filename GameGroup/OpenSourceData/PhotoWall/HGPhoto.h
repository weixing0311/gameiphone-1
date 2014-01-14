//
//  Photo.h
//  PhotoDemo
//
//  Created by Harry on 12-12-6.
//  Copyright (c) 2012年 Harry. All rights reserved.
//

//Modified by Tolecen on 9/7/2013

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "EGOImageView.h"
@class HGPhoto,HGPhotoWall;

@protocol HGPhotoDelegate <NSObject>

@optional
- (void)photoTaped:(HGPhoto*)photo;
- (void)photoMoveFinished:(HGPhoto*)photo;
- (void)delPhoto:(HGPhoto *)photo;

@end

typedef NS_ENUM(NSInteger, PhotoType) {
    PhotoTypePhoto  = 0, //Default
    PhotoTypeAdd = 1,
};

@interface HGPhoto : UIView
{
    CALayer*viewLayer;
//    UIButton * delBtn;
    
}
@property (assign) id<HGPhotoDelegate> delegate;
@property (assign,nonatomic) BOOL wiggle;
@property (assign,nonatomic) BOOL moved;
@property (assign,nonatomic) BOOL useCache;
@property (strong,nonatomic) UIButton * delBtn;
- (id)initWithOrigin:(CGPoint)origin;

- (void)setPhotoType:(PhotoType)type;
- (PhotoType)getPhotoType;
- (void)setPhotoUrl:(NSString*)photoUrl;
- (void)moveToPosition:(CGPoint)point;
- (void)setEditModel:(BOOL)edit;
-(void)SetPhotoUrlWithCache:(NSString *)url;

@end
