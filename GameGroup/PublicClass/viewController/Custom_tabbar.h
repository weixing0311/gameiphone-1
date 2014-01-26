//
//  Custom_tabbar.h
//  RuYiCai
//
//  Created by haojie on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Custom_tabbar : UITabBarController 
{
	NSArray     *backgroud_image;
	NSArray     *select_image;
	NSMutableArray  *tab_btn;

	UIView          *tabBarView;
}

@property(nonatomic, strong)UIView *tabBarView;

- (void)init_tab;
- (void)when_tabbar_is_unselected;
- (void)add_custom_tabbar_elements;
- (void)when_tabbar_is_selected:(int)tabID;
- (void)hideTabBar:(BOOL)hide;
+ (Custom_tabbar*)showTabBar;

- (void)notificationWithNumber:(BOOL)ifNumber AndTheNumber:(int)number OrDot:(BOOL)dot WithButtonIndex:(int)index;
- (void)removeNotificatonOfIndex:(int)index;

@end
