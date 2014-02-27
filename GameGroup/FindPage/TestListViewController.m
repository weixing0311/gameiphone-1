//
//  TestListViewController.m
//  GameGroup
//
//  Created by admin on 14-2-26.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "TestListViewController.h"
#import "TitleObjUpView.h"
#import "PersonDetailViewController.h"
#import "SendNewsViewController.h"

#define degreesToRadians(x) (M_PI*(x)/180.0)//弧度

#define kSegmentFriend (0)
#define kSegmentRealm (1)
#define kSegmentCountry (2)

@interface TestListViewController ()
{
    //    UIView*        topView;
    NSArray *array;
    NSMutableArray *array1;
}

@end

@implementation TestListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        [self.view addSubview:tableview];
        
        array1 = [[NSMutableArray alloc]init];
        array = [UIFont familyNames];
        for (NSString * familyname in array) {
            NSLog(@"Family:%@",familyname);
            NSArray *fontnames = [UIFont fontNamesForFamilyName:familyname];
            for (NSString *name in fontnames) {
                NSLog(@"Font Name:%@",name);
                [array1 addObject:name];
            }
        }

    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array1.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        NSString *str = [array1 objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@12345",str];
        
        cell.textLabel.font = [UIFont fontWithName:str size:20];
    }
    return cell;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

@end
