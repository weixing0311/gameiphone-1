//
//  EveryDataNewsViewController.m
//  GameGroup
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "EveryDataNewsViewController.h"
#import "DayNewsCell.h"
@interface EveryDataNewsViewController ()
{
    UITableView *m_myTableView;
    
}
@end

@implementation EveryDataNewsViewController

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
    
    [self setTopViewWithTitle:@"每日一闻" withBackButton:YES];
    m_myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX, self.view.bounds.size.width, self.view.bounds.size.height-startX) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.rowHeight = m_myTableView.bounds.size.height;
    [self.view addSubview:m_myTableView];
    
    
    
	// Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    DayNewsCell *cell = (DayNewsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DayNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       // [cell.headImageBtn setBackgroundImage:KUIImage(@"ceshi") forState:UIControlStateNormal];
        cell.nickNameLabel.text = @"测试";
        cell.signatureLabel.text = @"生命在于运动，每天不运动就胖了";
        cell.bigImageView.image = KUIImage(@"wowall.jpg");
        cell.authorLabel.text = @"图/百事可乐";
        cell.NumLabel.text = @"02";
        cell.timeLabel.text = @"Mar 2014";
        cell.titleLabel.text = @"测试标题上线了";
        cell.contentLabel.text = @"其实内容没有那么长 只不过是在凑字数，怎么还没够啊，应该差不多了吧，那就不打了";
        
        
        
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
