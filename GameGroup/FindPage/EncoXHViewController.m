//
//  EncoXHViewController.m
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//


/*
 
 //打招呼  158
 [paramDict setObject:self.gameId forKey:@"gameid"];
 [paramDict setObject:self.characterId forKey:@"characterid"];
 [paramDict setObject:KISDictionaryHaveKey(getDic, @"userid") forKey:@"touserid"];
 [paramDict setObject:KISDictionaryHaveKey(getDic,@"roll") forKey:@"roll"];
 
 //邂逅  149
 [paramDict setObject:self.gameId forKey:@"gameid"];
 [paramDict setObject:self.characterId forKey:@"characterid"];

 
 //角色列表 125
 [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];

 */


#import "EncoXHViewController.h"
#import "HostInfo.h"
#import "EnteroCell.h"
#import "EGOImageView.h"
#import "UIView+i7Rotate360.h"
#import "PersonDetailViewController.h"
@interface EncoXHViewController ()

@end

@implementation EncoXHViewController
{
    UIButton *sayHelloBtn;//打招呼
    UIButton *inABtn;//换一个
    EGOImageView *headImageView;//头像
    UIImageView *clazzImageView;//职业图标
    UILabel *NickNameLabel;//昵称
    UILabel *customLabel;//年龄+性别+星座
    UITextView *promptLabel;//提示语
    NSDictionary *getDic;//获取邂逅字典
    UILabel *clazzLabel;//职业名称
    NSMutableArray *m_characterArray;//获取职业列表
    HostInfo     *m_hostInfo;//信息
    UITableView *m_tableView;//职业列表
    UITextField *tf;//请选择一个角色
    UIImageView *backgroundImageView;//背景图片
    UILabel *sexLabel;//性别
    
    NSInteger m_leftTime;
    NSTimer *m_verCodeTimer;

    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc]init];
    [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [self getSayHelloForNetWithDictionary:paramDict method:@"125" prompt:@"获取中..." type:3];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     getDic = [[NSDictionary alloc]init];
    m_characterArray = [[NSMutableArray alloc]init];
    [self setTopViewWithTitle:@"邂逅" withBackButton:YES];
    
    backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height -startX)];
    
    backgroundImageView.image =KUIImage(@"meet_bg_img.jpg");
    backgroundImageView.userInteractionEnabled = YES;
    [self.view addSubview:backgroundImageView];
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self buildTableView];
    
}
-(void)buildTableView
{
    tf = [[UITextField alloc]initWithFrame:CGRectMake(0, startX+40, 200, 30)];
    tf.center  = CGPointMake(160, startX+50);
    tf.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4];
    tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.text = @"请选择一个角色";
    tf.textAlignment =NSTextAlignmentCenter;
    tf.textColor = [UIColor whiteColor];
    [self.view addSubview:tf];
    
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(45, 80+startX, 230, 250) style:UITableViewStylePlain];
    m_tableView.layer.masksToBounds = YES;
    m_tableView.layer.cornerRadius = 6.0;
    m_tableView.layer.borderWidth = 0;
    m_tableView.layer.borderColor = [[UIColor whiteColor] CGColor];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.rowHeight = 70;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.backgroundColor = [UIColor clearColor];
    m_tableView.showsVerticalScrollIndicator = NO;
    m_tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_tableView];
}
#pragma mark ---创建邂逅界面
-(void)bulidEncounterView
{
    clazzImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260,6, 40, 40)];
    clazzImageView.image = KUIImage(@"ceshi.jpg");
    clazzImageView.layer.masksToBounds = YES;
    clazzImageView.layer.cornerRadius = 20;
    clazzImageView.layer.borderWidth = 2.0;
    clazzImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    [backgroundImageView addSubview:clazzImageView];
    clazzImageView.userInteractionEnabled = YES;
    [clazzImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showGameList:)]];
    
    
    
    
    
    clazzLabel = [[UILabel alloc]initWithFrame:CGRectMake(260-clazzLabel.text.length, 53, 50+clazzLabel.text.length *12, 20)];
    clazzLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.6];
    clazzLabel.layer.masksToBounds = YES;
    clazzLabel.layer.cornerRadius = 5;
    clazzLabel.textAlignment = NSTextAlignmentCenter;
    clazzLabel.font = [UIFont systemFontOfSize:12];
    clazzLabel.textColor = [UIColor whiteColor];
    [backgroundImageView addSubview:clazzLabel];
    
    headImageView = [[EGOImageView alloc]init];
    
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 80;
   // headImageView.layer.borderWidth = 2.0;
  //  headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    headImageView.placeholderImage = KUIImage(@"moren_people.png");
    headImageView.frame = CGRectMake(80, 76-40, 160, 160);
    [backgroundImageView addSubview:headImageView];
    headImageView.userInteractionEnabled = YES;
    [headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterToPernsonPage:)]];
    
    
    NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,251-40, 320, 20)];
    NickNameLabel.backgroundColor = [UIColor clearColor];
    NickNameLabel.font = [UIFont systemFontOfSize:18];
    NickNameLabel.textAlignment = NSTextAlignmentCenter;
    NickNameLabel.textColor = [UIColor whiteColor];
    [backgroundImageView addSubview:NickNameLabel];
    
    customLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 276-40, 120, 15)];
    customLabel.backgroundColor = [UIColor clearColor];
    customLabel.font = [UIFont systemFontOfSize:18];
  //  customLabel.textAlignment = NSTextAlignmentCenter;
    customLabel.textColor = [UIColor whiteColor];
    [backgroundImageView addSubview:customLabel];
    
    sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(customLabel.frame.origin.x-10, 276-40, 10, 15)];
    [sexLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
    sexLabel.layer.cornerRadius = 3;
    sexLabel.layer.masksToBounds = YES;
    sexLabel.textAlignment = NSTextAlignmentLeft;
    [backgroundImageView addSubview:sexLabel];
    
    
    promptLabel = [[UITextView alloc]initWithFrame:CGRectMake(0,318-40, 320, 30)];
    promptLabel.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5];
    promptLabel.textColor = UIColorFromRGBA(0xc3c3c3, 1);
    promptLabel.textAlignment =NSTextAlignmentCenter;
    promptLabel.userInteractionEnabled = NO;
    promptLabel.font = [UIFont boldSystemFontOfSize:12];
    [backgroundImageView addSubview:promptLabel];
    
    
    inABtn =[UIButton buttonWithType:UIButtonTypeCustom];
    inABtn.frame = CGRectMake(20, kScreenHeigth-70, 120, 44);
    [inABtn setBackgroundImage:KUIImage(@"white_onclick") forState:UIControlStateNormal];
    [inABtn setBackgroundImage:KUIImage(@"white") forState:UIControlStateHighlighted];
    [inABtn addTarget:self action:@selector(changeOtherOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inABtn];
    
    
    sayHelloBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    sayHelloBtn.frame = CGRectMake(180, kScreenHeigth-70, 120, 44);
    [sayHelloBtn setBackgroundImage:KUIImage(@"green") forState:UIControlStateNormal];
    [sayHelloBtn setBackgroundImage:KUIImage(@"green_onclick") forState:UIControlStateHighlighted];
    [sayHelloBtn addTarget:self action:@selector(sayHiToYou:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sayHelloBtn];

    
}
//换一个的说

- (void)changeOtherOne
{
    inABtn.selected = YES;
    inABtn.userInteractionEnabled = NO;
    [self headPhotoAnimation];
    m_leftTime = 3;
    if ([m_verCodeTimer isValid]) {
        [m_verCodeTimer invalidate];
        m_verCodeTimer = nil;
    }
    m_verCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refrenshVerCodeTime) userInfo:nil repeats:YES];
    
}

- (void)refrenshVerCodeTime
{
    m_leftTime--;
    if (m_leftTime == 0) {
        inABtn.selected = NO;
     //   [inABtn setTitle:@"重发" forState:UIControlStateNormal];
        inABtn.userInteractionEnabled = YES;
        if([m_verCodeTimer isValid])
        {
            [m_verCodeTimer invalidate];
            m_verCodeTimer = nil;
        }
    }
    //else
       // [inABtn setTitle:@"不行" forState:UIControlStateSelected];

}


-(void)headPhotoAnimation
{
//    NickNameLabel.text = nil;
//    customLabel.text = nil;
//    promptLabel.text =nil;
//    sexLabel.text = nil;
  //  sexLabel.backgroundColor = [UIColor clearColor];
    // headImageView.frame = CGRectMake(0, 400, 0, 0);
    NSMutableDictionary *paramDict =[[NSMutableDictionary alloc]init];
    
    [paramDict setObject:@"1" forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    
    [self getSayHelloForNetWithDictionary:paramDict method:@"149" prompt:@"邂逅中..." type:1];

}
-(void)sayHiToYou:(UIButton *)sender
{
    NSMutableDictionary *paramDict =[[NSMutableDictionary alloc]init];
    [paramDict setObject:@"1" forKey:@"gameid"];
    [paramDict setObject:self.characterId forKey:@"characterid"];
    [paramDict setObject:KISDictionaryHaveKey(getDic, @"userid") forKey:@"touserid"];
    [paramDict setObject:KISDictionaryHaveKey(getDic,@"roll") forKey:@"roll"];

    [self getSayHelloForNetWithDictionary:paramDict method:@"158" prompt:@"打招呼ING" type:2];
}
#pragma mark ---网络请求
- (void)getSayHelloForNetWithDictionary:(NSDictionary *)dic method:(NSString *)method prompt:(NSString *)prompt type:(NSInteger)COME_TYPE
{
    hud.labelText = prompt;
    [hud show:YES];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    
    [postDict setObject:dic forKey:@"params"];
    [postDict setObject:method forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        if (COME_TYPE ==1) {
            [hud hide:YES];
            getDic = nil;
            getDic = [NSDictionary dictionaryWithDictionary:responseObject];
            NSLog(@"getDic%@",getDic);
            
            //男♀♂
            if ([KISDictionaryHaveKey(getDic, @"gender")isEqualToString:@"1"]) {
                sexLabel.text = @"♀";
                sexLabel.backgroundColor = kColorWithRGB(238, 100, 196, 1.0);
            }else{
                sexLabel.text = @"♂";
                sexLabel.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);

            }
            
            
            NickNameLabel.text = KISDictionaryHaveKey(getDic, @"nickname");
            customLabel.text = [NSString stringWithFormat:@" %@ |%@",KISDictionaryHaveKey(getDic, @"age"),KISDictionaryHaveKey(getDic, @"constellation")];
            
            
            promptLabel.text =KISDictionaryHaveKey(getDic, @"prompt");
            NSInteger i;
            
            
            NSLog(@"%@",headImageView.image);

            if([KISDictionaryHaveKey(getDic, @"img") rangeOfString:@","].location !=NSNotFound) {
                NSString * fruits = KISDictionaryHaveKey(getDic, @"img");
                NSArray  * array= [fruits componentsSeparatedByString:@","];
                NSLog(@"array%@",[array objectAtIndex:0]);
               
                headImageView.imageURL =[NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",[array objectAtIndex:0]]];
               NSLog(@"imageUrl--->%@",headImageView.imageURL);
            }else{
                
            headImageView.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingFormat:@"%@",KISDictionaryHaveKey(getDic, @"img")]];
                NSLog(@"imageUrl111-->%@",headImageView.imageURL);
            }
            UIImage *image = headImageView.image;
            [headImageView rotate360WithDuration:1.0 repeatCount:2 timingMode:i7Rotate360TimingModeLinear];
            headImageView.animationDuration = 2.0;
            headImageView.animationImages =
            [NSArray arrayWithObjects:
             headImageView.placeholderImage,
             headImageView.placeholderImage,
            headImageView.placeholderImage,
            image,
             nil];
            headImageView.animationRepeatCount = 1;
            [headImageView startAnimating];

            
            i= promptLabel.text.length/23;
            promptLabel.frame = CGRectMake(0, 318-40, 320, 30+15*i);
            
        }
        if (COME_TYPE ==2) {
            NSLog(@"打招呼成功");
            [hud hide:YES];
            [self showMessageWindowWithContent:@"打招呼成功" imageType:0];
            
            [self changeOtherOne];
            
        }
        if (COME_TYPE ==3) {
            [hud hide:YES];
            if ([KISDictionaryHaveKey(responseObject, @"1") isKindOfClass:[NSArray class]]) {
                NSLog(@"responseObject%@",responseObject);
                [m_characterArray addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"1")];
                NSLog(@"m_characterArray%@",m_characterArray);
                [m_tableView reloadData];

        }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                 [hud hide:YES];
            }
        }
    }];
}


#pragma mark --tableViewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_characterArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCharacter";
    EnteroCell *cell = (EnteroCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[EnteroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4];
    
    NSDictionary* tempDic = [m_characterArray objectAtIndex:indexPath.row];
    
    int imageId = [KISDictionaryHaveKey(tempDic, @"clazz") intValue];
    if (imageId > 0 && imageId < 12) {//1~11
        cell.headerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%d", imageId]];
    }
    else
        cell.headerImageView.image = [UIImage imageNamed:@"clazz_0.png"];
    
    NSString* realm = [KISDictionaryHaveKey(tempDic, @"raceObj") isKindOfClass:[NSDictionary class]] ? KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"raceObj"), @"sidename") : @"";
    
    cell.serverLabel.text = [KISDictionaryHaveKey(tempDic, @"realm") stringByAppendingString:realm];
    cell.titleLabel.text = KISDictionaryHaveKey(tempDic, @"name");
    
//
//    cell.editBtn.hidden = YES;
//    //        cell.authBtn.hidden = NO;
//    
//    cell.myIndexPath = indexPath;
//    cell.gameImg.image = KUIImage(@"wow");
//    cell.nameLabel.text = KISDictionaryHaveKey(tempDic, @"name");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self bulidEncounterView];
     tableView.hidden = YES;
    tf.hidden = YES;
    headImageView.hidden = NO;
    clazzImageView.hidden = NO;
    clazzLabel.hidden =NO;
    NickNameLabel.hidden = NO;
    customLabel.hidden = NO;
    inABtn.hidden = NO;
    sexLabel.hidden = NO;
    sayHelloBtn.hidden =NO;
    promptLabel .hidden = NO;

    
    NSDictionary* tempDic = [m_characterArray objectAtIndex:indexPath.row];
    NSMutableDictionary *paramDict =[[NSMutableDictionary alloc]init];
    self.characterId =KISDictionaryHaveKey(tempDic, @"id");
    [paramDict setObject:@"1" forKey:@"gameid"];
    int imageId = [KISDictionaryHaveKey(tempDic, @"clazz") intValue];
    
    clazzImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%d", imageId]];
    clazzLabel.text =KISDictionaryHaveKey(tempDic, @"name");
    clazzLabel.frame = CGRectMake(260-clazzLabel.text.length*4, 53, 10+clazzLabel.text.length *12, 20);
   // clazzLabel.center = CGPointMake(286, 63);
    [paramDict setObject:KISDictionaryHaveKey(tempDic, @"id") forKey:@"characterid"];
   
    
    [self getSayHelloForNetWithDictionary:paramDict method:@"149" prompt:@"邂逅中..." type:1];

}
#pragma mark ---查看角色详情
-(void)enterToPernsonPage:(UIGestureRecognizer *)sender
{
    PersonDetailViewController *pv = [[PersonDetailViewController alloc]init];
    pv.userId =KISDictionaryHaveKey(getDic, @"userid");
    [self.navigationController pushViewController:pv animated:YES];
}
#pragma mark--- 查看角色列表
-(void)showGameList:(UIGestureRecognizer *)sender
{
    m_tableView.hidden = NO;
    tf.hidden = NO;
    headImageView.hidden = YES;
    clazzImageView.hidden = YES;
    clazzLabel.hidden =YES;
    NickNameLabel.hidden = YES;
    customLabel.hidden = YES;
    inABtn.hidden = YES;
    sexLabel.hidden = YES;
    sayHelloBtn.hidden =YES;
    promptLabel .hidden = YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
