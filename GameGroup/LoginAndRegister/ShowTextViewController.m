//
//  ShowTextViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-10.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "ShowTextViewController.h"

@interface ShowTextViewController ()

@end

@implementation ShowTextViewController

@synthesize fileName;
@synthesize myViewTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:myViewTitle withBackButton:YES];
    
    NSString* path = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"txt"];
    NSData* proData = [NSData dataWithContentsOfFile:path];
    NSString* proContent = [[NSString alloc] initWithData:proData encoding:NSUTF8StringEncoding];
    
    UITextView* contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, startX, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    contentView.delegate = self;
    contentView.font = [UIFont boldSystemFontOfSize:13.0];
    [contentView setText:proContent];
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark 输入文本视图协议

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

@end
