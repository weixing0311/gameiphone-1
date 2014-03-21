//
//  PersonViewController.m
//  GameGroup
//
//  Created by admin on 14-3-20.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "PersonViewController.h"
#import "PersonTableCell.h"
#import "MyCharacterCell.h"
#import "MyNormalTableCell.h"
#import "SetViewController.h"
#import "TitleObjTableCell.h"
#import "MyStateTableCell.h"
#import "NewsViewController.h"

@interface PersonViewController ()
{
    UITableView *m_myTableView;
    UILabel*        m_titleLabel;
    HGPhotoWall*    m_photoWall;

}
@end

@implementation PersonViewController

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
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    
    m_myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, startX, self.view.bounds.size.width, self.view.bounds.size.height-startX) style:UITableViewStylePlain];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    
    
    
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
           return 2 ;//img
            break;
        case 1:
           return 2 ;//动态
            break;
        case 2:
            return 4;
            break;
        case 3:
            return 1;//返回角色数量
            break;
        case 4:
            return 1;//返回头衔数量
            break;
        case 5:
           return 1 ;//返回注册时间
            break;
   
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 ==indexPath.section)//照片墙
    {
        static NSString *identifier = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell ==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (indexPath.row==0) {
            m_photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
            m_photoWall.descriptionType = DescriptionTypeImage;
           // [m_photoWall setPhotos:[self imageToURL:self.hostInfo.headImgArray]];
            m_photoWall.delegate = self;
           // [m_myScrollView addSubview:m_photoWall];
            m_photoWall.backgroundColor = kColorWithRGB(105, 105, 105, 1.0);
           // m_currentStartY += m_photoWall.frame.size.height;
            [cell.contentView addSubview:m_photoWall];
        }else{
            UIView* genderView = [CommonControlOrView setGenderAndAgeViewWithFrame:CGRectMake(10, 0, 320, 30) gender:self.hostInfo.gender age:self.hostInfo.age star:self.hostInfo.starSign gameId:@"1"];
            [cell.contentView addSubview:genderView];
            
            UILabel* timeLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(150,0, 160, 30) textColor:kColorWithRGB(151, 151, 151, 1.0) font:[UIFont systemFontOfSize:12.0] text:[GameCommon getTimeAndDistWithTime:self.hostInfo.updateTime Dis:self.hostInfo.distrance] textAlignment:NSTextAlignmentRight];
            [cell.contentView addSubview:timeLabel];
        }
    }
    else if (1 ==indexPath.section)//动态
    {
        static NSString *identifier = @"mystate";
        MyStateTableCell *cell = (MyStateTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyStateTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if([self.hostInfo.state isKindOfClass:[NSDictionary class]] && [[self.hostInfo.state allKeys] count] != 0)//动态
        {
            if ([KISDictionaryHaveKey(self.hostInfo.state, @"destUser") isKindOfClass:[NSDictionary class]]) {//目标 别人评论了我
                NSDictionary* destDic = KISDictionaryHaveKey(self.hostInfo.state, @"destUser");
                NSString * imgid = [GameCommon getHeardImgId: KISDictionaryHaveKey(destDic, @"userimg")];
                if (imgid) {
                    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:imgid]];
                }else
                {
                    cell.headImageV.imageURL = nil;
                }
                
                cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",[[GameCommon getNewStringWithId:KISDictionaryHaveKey(destDic, @"alias")] isEqualToString:@""] ? KISDictionaryHaveKey(destDic, @"nickname") : KISDictionaryHaveKey(destDic, @"alias") , KISDictionaryHaveKey(self.hostInfo.state, @"showtitle")];
            }
            else
            {
                NSString * imgid = [GameCommon getHeardImgId: KISDictionaryHaveKey(self.hostInfo.state, @"userimg")];
                if ([imgid isEqualToString:@""]||[imgid isEqualToString:@" "]) {
                    cell.headImageV.imageURL = nil;
                }else{
                    if (imgid) {
                        cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:imgid]];
                    }else
                    {
                        cell.headImageV.imageURL = nil;
                    }
                    
                }
                if([KISDictionaryHaveKey(self.hostInfo.state, @"userid") isEqualToString:[DataStoreManager getMyUserID]])
                {
                    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"type")] isEqualToString:@"3"]) {
                        cell.titleLabel.text = @"我发表了该内容";
                    }
                    else
                        cell.titleLabel.text = [NSString stringWithFormat:@"我%@",KISDictionaryHaveKey(self.hostInfo.state, @"showtitle")];
                }
                else
                    cell.titleLabel.text = [NSString stringWithFormat:@"%@%@",[[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"alias")] isEqualToString:@""] ? KISDictionaryHaveKey(self.hostInfo.state, @"nickname") : KISDictionaryHaveKey(self.hostInfo.state, @"alias") , KISDictionaryHaveKey(self.hostInfo.state, @"showtitle")];
            }
            NSString* tit = [[GameCommon getNewStringWithId:[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"title")]] isEqualToString:@""] ? KISDictionaryHaveKey(self.hostInfo.state, @"msg") : KISDictionaryHaveKey(self.hostInfo.state, @"title");
            if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"title")] isEqualToString:@""]) {
                cell.nameLabel.text = tit;
                
            }
            else
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"「%@」", tit];
            }
            cell.timeLabel.text = [GameCommon getTimeWithMessageTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(self.hostInfo.state, @"createDate")]];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:haveMyNews] && [[[NSUserDefaults standardUserDefaults] objectForKey:haveMyNews] isEqualToString:@"1"]){
                cell.notiBgV.hidden = NO;
            }
            else
                cell.notiBgV.hidden = YES;
        }
        else
        {
            cell.titleLabel.text = @"";
            cell.nameLabel.text = @"暂无新的动态";
            cell.timeLabel.text = @"";
        }
        cell.fansLabel.text = [GameCommon getNewStringWithId:self.hostInfo.fanNum];
        cell.zanLabel.text = [GameCommon getNewStringWithId:self.hostInfo.zanNum];
        [cell.cellButton addTarget:self action:@selector(myStateClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (2 ==indexPath.section)//个人资料
    {
        
    }
    else if (3==indexPath.section)//角色
    {
        static NSString *identifier = @"myCharacter";
        MyCharacterCell *cell = (MyCharacterCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyCharacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSArray* characterArray = KISDictionaryHaveKey(self.hostInfo.characters, @"1");//魔兽世界
        [[NSUserDefaults standardUserDefaults]setObject:characterArray forKey:@"CharacterArrayOfAllForYou"];
        
        
        if (![characterArray isKindOfClass:[NSArray class]]) {
            
            //            cell.heardImg.image = [UIImage imageNamed:@"clazz_0.png"];
            //            cell.nameLabel.text = @"暂无角色";
            cell.heardImg.hidden = YES;
            cell.authBg.hidden = YES;
            cell.nameLabel.hidden = YES;
            cell.realmLabel.hidden = YES;
            cell.gameImg.hidden = YES;
            cell.pveLabel.hidden = YES;
            cell.noCharacterLabel.hidden = NO;
            return cell;
        }
        else
        {
            cell.heardImg.hidden = NO;
            cell.authBg.hidden = NO;
            cell.nameLabel.hidden = NO;
            cell.realmLabel.hidden = NO;
            cell.gameImg.hidden = NO;
            cell.pveLabel.hidden = NO;
            NSDictionary* tempDic = [characterArray objectAtIndex:indexPath.row];
            if ([KISDictionaryHaveKey(tempDic, @"failedmsg") isEqualToString:@"404"])//角色不存在
            {
                cell.heardImg.image = [UIImage imageNamed:@"clazz_0.png"];
                cell.realmLabel.text = @"角色不存在";
            }
            else
            {
                int imageId = [KISDictionaryHaveKey(tempDic, @"clazz") intValue];
                if (imageId > 0 && imageId < 12) {//1~11
                    cell.heardImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"clazz_%d", imageId]];
                }
                else
                    cell.heardImg.image = [UIImage imageNamed:@"clazz_0.png"];
                NSString* realm = [KISDictionaryHaveKey(tempDic, @"raceObj") isKindOfClass:[NSDictionary class]] ? KISDictionaryHaveKey(KISDictionaryHaveKey(tempDic, @"raceObj"), @"sidename") : @"";
                cell.realmLabel.text = [KISDictionaryHaveKey(tempDic, @"realm") stringByAppendingString:realm];
            }
            if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"auth")] isEqualToString:@"1"]) {//已认证
                cell.authBg.hidden = NO;
                cell.authBg.image= KUIImage(@"chara_auth_1");
            }
            else
            {
                cell.authBg.hidden = NO;
                cell.authBg.image= KUIImage(@"chara_auth_2");
            }
            cell.rowIndex = indexPath.row;
            cell.myDelegate = self;
            cell.gameImg.image = KUIImage(@"wow");
            cell.nameLabel.text = KISDictionaryHaveKey(tempDic, @"name");
            cell.pveLabel.text = [GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDic, @"pveScore")];
            cell.noCharacterLabel.hidden = YES;
            return cell;
        }
    }
    else if (4==indexPath.section)//头衔
    {
        static NSString *identifier = @"myTitleObjTableCell";
        TitleObjTableCell *cell = (TitleObjTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[TitleObjTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if([self.hostInfo.achievementArray count] == 0)//头衔
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.headImageV.hidden = YES;
            cell.nameLabel.text = @"没有头衔展示";
            cell.nameLabel.textColor = [UIColor blackColor];
            return cell;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSDictionary* infoDic = [self.hostInfo.achievementArray objectAtIndex:indexPath.row];
        NSString* rarenum = [NSString stringWithFormat:@"rarenum_small_%@", [GameCommon getNewStringWithId:KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj") , @"rarenum")]];
        cell.headImageV.hidden = NO;
        cell.headImageV.image = KUIImage(rarenum);
        cell.nameLabel.text = KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj"), @"title");
        cell.nameLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(KISDictionaryHaveKey(infoDic, @"titleObj"), @"rarenum") integerValue]];
        if (indexPath.row == 0) {
            cell.userdButton.hidden = NO;
        }
        else
            cell.userdButton.hidden = YES;
        return cell;
    }
    else if (5 == indexPath.section)//注册时间
    {
        static NSString *identifier = @"my";
        MyNormalTableCell *cell = (MyNormalTableCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[MyNormalTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.heardImg.image = KUIImage(@"me_system");
        cell.upLabel.text = @"系统设置";
        cell.downLabel.text = @"进行我的系统设置";
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
