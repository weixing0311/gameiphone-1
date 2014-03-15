    //
//  Custom_tabbar.m
//  RuYiCai
//
//  Created by haojie on 11-11-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Custom_tabbar.h"

@interface Custom_tabbar (internal)

@end


@implementation Custom_tabbar
@synthesize tabBarView;

static Custom_tabbar *s_tabbar = NULL;

- (void)init_tab
{
	backgroud_image = [[NSArray alloc]initWithObjects:@"message_normal.png",@"friend_normal.png",@"find_normal.png",@"wo_normal.png",nil];
	select_image = [[NSArray alloc]initWithObjects:@"message_click.png",@"friend_click.png",@"find_click.png",@"wo_click.png",nil];
    
    float startY = [[UIScreen mainScreen] bounds].size.height;
    tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, startY - 50, 320, 50)];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//	[self init_tab];
//	[self when_tabbar_is_unselected];
//	[self add_custom_tabbar_elements];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self init_tab];
	[self when_tabbar_is_unselected];
	[self add_custom_tabbar_elements];
}

- (void)when_tabbar_is_unselected
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
			break;
		}
	}
}

- (void)add_custom_tabbar_elements
{
	int tab_num = 4;
	
	[self.view addSubview:tabBarView];
	
	tab_btn = [[NSMutableArray alloc] initWithCapacity:0];
	for(int i = 0; i< tab_num; i++)
	{
		UIButton  *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setFrame:CGRectMake(i*80, 0, 80, 50)];
		NSString *back_image = [backgroud_image objectAtIndex:i];
		NSString *selected_image = [select_image objectAtIndex:i]; 
		[btn setBackgroundImage:[UIImage imageNamed:back_image] forState:UIControlStateNormal];
		[btn setBackgroundImage:[UIImage imageNamed:selected_image] forState:UIControlStateSelected];
		btn.backgroundColor = [UIColor clearColor];
		[btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
		if(i == 0)
		{
			[btn setSelected:YES];
		}
		[btn setTag:i];
		[tab_btn addObject:btn];
		[tabBarView addSubview:btn];
		[btn addTarget:self action:@selector(button_clicked_tag:) forControlEvents:UIControlEventTouchUpInside];
	}
}

- (void)button_clicked_tag:(id)sender
{
    UIButton* tempButton = (UIButton*)sender;
	int tagNum = tempButton.tag;
	[self when_tabbar_is_selected:tagNum];
}

- (void)when_tabbar_is_selected:(int)tabID
{
    switch (tabID)
	{
		case 0:
			[[tab_btn objectAtIndex:0]setSelected:true];
			[[tab_btn objectAtIndex:1]setSelected:false];
			[[tab_btn objectAtIndex:2]setSelected:false];
			[[tab_btn objectAtIndex:3]setSelected:false];
			break;
		case 1:
			[[tab_btn objectAtIndex:0]setSelected:false];
			[[tab_btn objectAtIndex:1]setSelected:true];
			[[tab_btn objectAtIndex:2]setSelected:false];
			[[tab_btn objectAtIndex:3]setSelected:false];

			break;
		case 2:
			[[tab_btn objectAtIndex:0]setSelected:false];
			[[tab_btn objectAtIndex:1]setSelected:false];
			[[tab_btn objectAtIndex:2]setSelected:true];
			[[tab_btn objectAtIndex:3]setSelected:false];
			break;
            
        case 3:
        {
            [[tab_btn objectAtIndex:0]setSelected:false];
            [[tab_btn objectAtIndex:1]setSelected:false];
            [[tab_btn objectAtIndex:2]setSelected:false];
            [[tab_btn objectAtIndex:3]setSelected:true];
			break;
        }
		default:
			break;
	}
	self.selectedIndex = tabID;
}

- (void)hideTabBar:(BOOL) hidden
{	
	if(hidden)
	{
		self.tabBarView.hidden = YES;
	}
	else
	{
		self.tabBarView.hidden = NO;
	}
}


-(void)notificationWithNumber:(BOOL)ifNumber AndTheNumber:(int)number OrDot:(BOOL)dot WithButtonIndex:(int)index
{
    UIButton * btn = [tab_btn objectAtIndex:index];
    for (UIView * view in btn.subviews) {
        if(view.tag==999)
            [view removeFromSuperview];
    }
    if (ifNumber) {
        UIImageView * notiBgV = [[UIImageView alloc] initWithFrame:CGRectMake(46, 4, 18, 18)];
        
        notiBgV.tag=999;
        [btn addSubview:notiBgV];
        UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [numberLabel setBackgroundColor:[UIColor clearColor]];
        [numberLabel setTextColor:[UIColor whiteColor]];
        [numberLabel setFont:[UIFont systemFontOfSize:12]];
        if (number>99) {
            [notiBgV setImage:[UIImage imageNamed:@"redCB_big.png"]];
            notiBgV.frame  = CGRectMake(46, 4, 22, 18);
            numberLabel.frame = CGRectMake(0, 0, 22, 18);
            [numberLabel setText:@"99+"];
        }else{
            [notiBgV setImage:[UIImage imageNamed:@"redCB.png"]];
            notiBgV.frame  = CGRectMake(46, 4, 18, 18);
            numberLabel.frame = CGRectMake(0, 0, 18, 18);
    [numberLabel setText:[NSString stringWithFormat:@"%d",number]];
            
        }
        [numberLabel setTextAlignment:NSTextAlignmentCenter];
        [notiBgV addSubview:numberLabel];
        
    }
    else if (dot){
        UIImageView * dotLabel = [[UIImageView alloc] initWithFrame:CGRectMake(52, 8, 7, 7)];
        dotLabel.tag = 999;
        [dotLabel setImage:[UIImage imageNamed:@"redCB.png"]];
        [btn addSubview:dotLabel];
    }
}

-(void)removeNotificatonOfIndex:(int)index
{
    UIButton * btn = [tab_btn objectAtIndex:index];
    for (UIView * view in btn.subviews) {
        if(view.tag==999)
            [view removeFromSuperview];
    }
}

+ (Custom_tabbar*)showTabBar
{
    @synchronized(self) 
    {
		if (s_tabbar == nil) 
		{
			s_tabbar = [[self alloc] init];  //assignment not done here
		}
	}
	return s_tabbar;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self) 
	{
		if (s_tabbar == nil) 
		{
			s_tabbar = [super allocWithZone:zone];
			return s_tabbar;  //assignment and return on first allocation
		}
	}	
	return nil;  //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone 
{
	return self;
}

@end
