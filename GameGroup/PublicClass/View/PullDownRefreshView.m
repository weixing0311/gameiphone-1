//
//  PullDownRefreshView.m
//  RuYiCai
//
//  Created by huangxin on 13-10-23.
//
//

#import "PullDownRefreshView.h"
#import <QuartzCore/QuartzCore.h>

@implementation PullDownRefreshView

@synthesize myScrollView, textPull, textRelease, textLoading, refreshLabel, refreshDate, refreshArrow, refreshSpinner, viewMaxY;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        isStart = YES;
        
        //        self.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:241.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        textPull = @"下拉加载⋯⋯";
        textRelease = @"松手开始加载⋯⋯";
        textLoading = @"正在加载⋯⋯";
        
        self.currentTime = [GameCommon getCurrentTime];

        refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 20)];
        refreshLabel.backgroundColor = [UIColor clearColor];
        refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        refreshLabel.textColor = [UIColor blackColor];
        refreshLabel.textAlignment = NSTextAlignmentCenter;
        
        refreshDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, 320, 20)];
        refreshDate.backgroundColor = [UIColor clearColor];
        refreshDate.font = [UIFont boldSystemFontOfSize:12.0];
        refreshDate.textColor = [UIColor blackColor];
        refreshDate.textAlignment = NSTextAlignmentCenter;
        
        refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pulldown_arrow.png"]];
        refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 27) / 2,
                                        (REFRESH_HEADER_HEIGHT - 44) / 2,
                                        27, 44);
        
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 20) / 2, (REFRESH_HEADER_HEIGHT - 20) / 2, 20, 20);
        refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:refreshLabel];
        [self addSubview:refreshDate];
        [self addSubview:refreshArrow];
        [self addSubview:refreshSpinner];
    }
    return self;
}


- (void)viewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = YES;
}


- (void)viewdidScroll:(UIScrollView *)scrollView
{
    if(isDragging && scrollView.contentOffset.y < 0)
	{
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
		{
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        }
		else
		{ // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            
            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
        
        [self getLastTimeRefresh];
    }
}


- (void)didEndDragging:(UIScrollView *)scrollView
{
    if (isLoading) return;
    isDragging = NO;
        
    if (scrollView.contentOffset.y  < -REFRESH_HEADER_HEIGHT)
	{
        if(isStart)
            [self startLoading];
    }
}


//显示
- (void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.myScrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"startPullDownRefresh" object:nil];
    [self.pullDownDelegate PullDowmStartRefresh];
}

//隐藏
- (void)stopLoading:(BOOL)isHidden
{
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
	self.myScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
//	refreshDate.text = [NSString stringWithFormat:@"最后更新时间：%@", now];
    [self getLastTimeRefresh];
    
    self.currentTime = [GameCommon getCurrentTime];
    
    if(isHidden)
    {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
    }
    isStart = !isHidden;
}

- (void)getLastTimeRefresh
{
    refreshDate.text = [GameCommon getTimeWithMessageTime:self.currentTime];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh
{
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:5.0];
}


@end
