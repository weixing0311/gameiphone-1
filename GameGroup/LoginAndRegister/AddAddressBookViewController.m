//
//  AddAddressBookViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-6.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddAddressBookViewController.h"

@interface AddAddressBookViewController ()

@end

@implementation AddAddressBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self setTopViewWithTitle:@"添加通讯录好友" withBackButton:NO];
    
    
}
- (NSArray*)getAddressBook
{
    NSMutableArray * addressArray = [NSMutableArray array];
    return addressArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
