//
//  EveryDataNewsViewController.m
//  GameGroup
//
//  Created by admin on 14-3-10.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "EveryDataNewsViewController.h"
#import "TestViewController.h"
#import "OnceDynamicViewController.h"
#import "DayNewsCell.h"
@interface EveryDataNewsViewController ()
{
    UITableView *m_myTableView;
    NSMutableArray *m_tableArray;
    PullUpRefreshView      *refreshView;
    SRRefreshView   *_slimeView;
    NSInteger    *m_pageNum;
    NSMutableDictionary *dictDic;

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
    m_pageNum =0;
    m_tableArray = [NSMutableArray array];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, KISHighVersion_7 ? 64 : 44)];
    titleLabel.center = CGPointMake(160, KISHighVersion_7 ? 42 : 22);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"每日一闻";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x-30, KISHighVersion_7 ? 27 : 7, 30, 30)];
    imageView.image = KUIImage(@"WOW图标_03");
    [self.view addSubview:imageView];
    m_myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX, self.view.bounds.size.width, self.view.bounds.size.height-startX) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    m_myTableView.rowHeight = m_myTableView.bounds.size.height;
    [self.view addSubview:m_myTableView];
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.upInset = 0;
    _slimeView.slimeMissWhenGoingBack = NO;
    _slimeView.slime.bodyColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    [m_myTableView addSubview:_slimeView];
    
    refreshView = [[PullUpRefreshView alloc] initWithFrame:CGRectMake(0, kScreenHeigth - startX-(KISHighVersion_7?0:20), 320, REFRESH_HEADER_HEIGHT)];//上拉加载
    [m_myTableView addSubview:refreshView];
    refreshView.pullUpDelegate = self;
    refreshView.myScrollView = m_myTableView;
    [refreshView stopLoading:NO];
    
    
    dictDic = [NSMutableDictionary dictionary];
//    [dictDic setObject:@"ceshi.jpg" forKey:@"headimg"];
//    [dictDic setObject:@"小小鱼" forKey:@"nickname"];
//    [dictDic setObject:@"生命在于运动，每天不运动就胖了" forKey:@"qianming"];
//    [dictDic setObject:@"wowall.jpg" forKey:@"bgImg"];
//    [dictDic setObject:@"图/百事可乐" forKey:@"author"];
//    [dictDic setObject:@"02" forKey:@"number"];
//    [dictDic setObject:@"Mar 2014" forKey:@"time"];
//    [dictDic setObject:@"测试标题上线了" forKey:@"title"];
//    [dictDic setObject:@"其实内容没有那么长 只不过是在凑字数，怎么还没够啊，应该差不多了吧，那就不打了" forKey:@"contnet"];

    
    [self getNewsInfoByNet];
    
	// Do any additional setup after loading the view.
}
-(void)getNewsInfoByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"3" forKey:@"dailyNewsId"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"165" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject){
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            //[dictDic setValuesForKeysWithDictionary:responseObject];
            [m_tableArray addObject:responseObject];
            NSLog(@"dicdic%@",dictDic);
             [m_myTableView reloadData];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCell";
    DayNewsCell *cell = (DayNewsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DayNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
        NSDictionary *dic= [m_tableArray objectAtIndex:indexPath.row];
    NSString * fruits = KISDictionaryHaveKey(dic, @"userImg");
    NSArray  * array= [fruits componentsSeparatedByString:@","];
    NSString*friendImgStr =[array objectAtIndex:0];

    cell.headImageBtn.imageURL =[NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",friendImgStr]];
    cell.headImageBtn.tag = indexPath.row;
    [cell.headImageBtn addTarget:self action:@selector(enterToPerson:) forControlEvents:UIControlEventTouchUpInside];
        cell.nickNameLabel.text = KISDictionaryHaveKey(dic, @"nickname");
        cell.signatureLabel.text = KISDictionaryHaveKey(dic, @"editorNote");
    cell.bigImageView.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",KISDictionaryHaveKey(dic, @"img")]];
        cell.authorLabel.text = KISDictionaryHaveKey(dic, @"imgQuote");
        cell.NumLabel.text =[self getDataWithTimeDataInterval: [GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"time")]];
                             
    cell.timeLabel.text = [self getDataWithTimeInterval: [GameCommon getNewStringWithId:KISDictionaryHaveKey(dic, @"time")]];
        cell.titleLabel.text = KISDictionaryHaveKey(dic, @"title");
        cell.contentLabel.text = KISDictionaryHaveKey(dic, @"content");
    [cell.newsOfBtn addTarget:self action:@selector(toViewNews:) forControlEvents:UIControlEventTouchUpInside];
    cell.newsOfBtn.tag =1000 +indexPath.row;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)toViewNews:(UIButton *)sender
{
    OnceDynamicViewController* detailVC = [[OnceDynamicViewController alloc] init];
    detailVC.messageid = [GameCommon getNewStringWithId:KISDictionaryHaveKey([m_tableArray objectAtIndex:sender.tag-1000], @"messageId")];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)enterToPerson:(UIButton *)sender
{
    TestViewController *tv =[[TestViewController alloc]init];
    tv.userId =[GameCommon getNewStringWithId:KISDictionaryHaveKey([m_tableArray objectAtIndex:sender.tag], @"userid")];
    [self.navigationController pushViewController:tv animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (m_myTableView.contentSize.height < m_myTableView.frame.size.height) {
        refreshView.viewMaxY = 0;
    }
    else
        refreshView.viewMaxY = m_myTableView.contentSize.height - m_myTableView.frame.size.height;
    [refreshView viewdidScroll:scrollView];
    [_slimeView scrollViewDidScroll];
}



#pragma mark pull up refresh
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == m_myTableView)
    {
        [refreshView viewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == m_myTableView)
    {
        [refreshView didEndDragging:scrollView];
        [_slimeView scrollViewDidEndDraging];
        
    }
}

- (void)PullUpStartRefresh:(PullUpRefreshView *)refreshView
{
    NSLog(@"start");
        [self getNewsInfoByNet];
}

#pragma mark - slimeRefresh delegate
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //    [self performSelector:@selector(endRefresh)
    //               withObject:nil
    //               afterDelay:2
    //                  inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    m_pageNum = 0;
    
    [self getNewsInfoByNet];
}

-(void)endRefresh
{
    [_slimeView endRefreshFinish:^{
        
    }];
}

#pragma mark----处理时间戳
- (NSString*)getDataWithTimeInterval:(NSString*)timeInterval
{
    if ([NSString stringWithFormat:@"%.f", [timeInterval doubleValue]].length < 10) {
        return timeInterval;
    }
    NSString* timeStr = [timeInterval substringToIndex:timeInterval.length-3];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];//location设置为中国
    [dateFormatter setDateFormat:@"MMM,YYYY"];
    
    double time = [timeStr doubleValue];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]);
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}


- (NSString*)getDataWithTimeDataInterval:(NSString*)timeInterval
{
    if ([NSString stringWithFormat:@"%.f", [timeInterval doubleValue]].length < 10) {
        return timeInterval;
    }
    NSString* timeStr = [timeInterval substringToIndex:timeInterval.length-3];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    [dateFormatter setDateFormat:@"dd"];
    
    double time = [timeStr doubleValue];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]]);
    return [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}


@end
