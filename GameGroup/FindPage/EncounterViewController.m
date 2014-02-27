//
//  EncounterViewController.m
//  GameGroup 
//
//  Created by admin on 14-2-27.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "EncounterViewController.h"
#import "MyCharacterEditCell.h"
#import "EncoXHViewController.h"
#import "HostInfo.h"
@interface EncounterViewController ()

@end

@implementation EncounterViewController
{
    NSMutableArray *m_characterArray;
    HostInfo     *m_hostInfo;
    UITableView *m_tableView;
}

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
    
    m_characterArray = [[NSMutableArray alloc]init];
    
    [self setTopViewWithTitle:@"发现" withBackButton:YES];
    m_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX, 320, self.view.frame.size.height -startX) style:UITableViewStylePlain];
    m_tableView.rowHeight = 70;
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    m_tableView.showsVerticalScrollIndicator = NO;
    m_tableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_tableView];
    [self getCharacterByNet];
	// Do any additional setup after loading the view.
}
- (void)getCharacterByNet
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[DataStoreManager getMyUserID] forKey:@"userid"];
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"125" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([KISDictionaryHaveKey(responseObject, @"1") isKindOfClass:[NSArray class]]) {
            NSLog(@"responseObject%@",responseObject);
            [m_characterArray addObjectsFromArray:KISDictionaryHaveKey(responseObject, @"1")];
            NSLog(@"m_characterArray%@",m_characterArray);
            [m_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, id error) {
        if ([error isKindOfClass:[NSDictionary class]]) {
            if (![[GameCommon getNewStringWithId:KISDictionaryHaveKey(error, kFailErrorCodeKey)] isEqualToString:@"100001"])
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"%@", [error objectForKey:kFailMessageKey]] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
        [hud hide:YES];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_characterArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"myCharacter";
    MyCharacterEditCell *cell = (MyCharacterEditCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyCharacterEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary* tempDic = [m_characterArray objectAtIndex:indexPath.row];
    
        int imageId = [KISDictionaryHaveKey(tempDic, @"clazz") intValue];
        if (imageId > 0 && imageId < 12) {//1~11
            cell.heardImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%d", imageId]];
        }
        else
            cell.heardImg.image = [UIImage imageNamed:@"clazz_0.png"];
        NSString* realm = [KISDictionaryHaveKey(tempDic, @"raceObj") isKindOfClass:[NSDictionary class]] ? KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"raceObj"), @"sidename") : @"";
        cell.realmLabel.text = [KISDictionaryHaveKey(tempDic, @"realm") stringByAppendingString:realm];
        
        cell.editBtn.hidden = YES;
        //        cell.authBtn.hidden = NO;
    
    cell.myIndexPath = indexPath;
    cell.gameImg.image = KUIImage(@"wow");
    cell.nameLabel.text = KISDictionaryHaveKey(tempDic, @"name");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* tempDic = [m_characterArray objectAtIndex:indexPath.row];
    EncoXHViewController *enco = [[EncoXHViewController alloc]init];
    enco.characterId = KISDictionaryHaveKey(tempDic, @"id");
    enco.gameId = @"1";
    [self.navigationController pushViewController:enco animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
