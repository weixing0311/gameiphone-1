//
//  PullDownRefreshView.h
//  RuYiCai
//
//  Created by huangxin on 13-10-23.
//
//

#import <UIKit/UIKit.h>
#define REFRESH_HEADER_HEIGHT 52.0f

@protocol PullDowmDelegate <NSObject>

- (void)PullDowmStartRefresh;

@end

@interface PullDownRefreshView : UIView
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

@property (nonatomic, assign) id<PullDowmDelegate> pullDownDelegate;

@property (nonatomic, retain) UIScrollView *myScrollView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UILabel *refreshDate;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, assign) NSInteger  viewMaxY;

- (void)refresh ;
- (void)startLoading;
- (void)stopLoading:(BOOL)isHidden;
- (void)viewWillBeginDragging:(UIScrollView *)scrollView;
- (void)viewdidScroll:(UIScrollView *)scrollView ;
- (void)didEndDragging:(UIScrollView *)scrollView;

@end
