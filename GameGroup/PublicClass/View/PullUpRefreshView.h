//
//  PullUpRefreshView.h
//  RuYiCai
//
//  Created by  on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PullUpRefreshView;
#define REFRESH_HEADER_HEIGHT 52.0f

@protocol PullUpDelegate <NSObject>

- (void)PullUpStartRefresh:(PullUpRefreshView*)refreshView;

@end

@interface PullUpRefreshView : UIView
{
    UIScrollView           *myScrollView;
    
    UILabel                 *refreshLabel;
    UILabel                 *refreshDate;
    UIImageView             *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL                    isDragging;
    BOOL                    isLoading;
    NSString                *textPull;
    NSString                *textRelease;
    NSString                *textLoading;
    
    NSInteger               viewMaxY;
    
    BOOL                    isStart;
}
@property (nonatomic, assign) id<PullUpDelegate>pullUpDelegate;

@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UILabel *refreshDate;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, assign) NSInteger  viewMaxY;

@property (nonatomic, retain) NSString* currentTime;

- (void)refresh ;
- (void)startLoading;
- (void)stopLoading:(BOOL)isHidden;
- (void)viewWillBeginDragging:(UIScrollView *)scrollView;
- (void)viewdidScroll:(UIScrollView *)scrollView ;
- (void)didEndDragging:(UIScrollView *)scrollView;
- (void)setRefreshViewFrame;

@end
