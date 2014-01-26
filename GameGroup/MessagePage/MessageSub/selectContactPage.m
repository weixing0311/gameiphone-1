//
//  ContactsViewController.m
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "selectContactPage.h"
#import "XMPPHelper.h"
#import "JSON.h"
#import "PersonTableCell.h"

@interface selectContactPage ()
{
    NSDictionary * selectDict;
}
@end

@implementation selectContactPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friendDict = [NSMutableDictionary dictionary];
        sectionArray = [NSMutableArray array];
        rowsArray = [NSMutableArray array];
        sectionIndexArray = [NSMutableArray array];
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"联系人" withBackButton:YES];
    
    self.hidesBottomBarWhenPushed = YES;
    
    self.contactsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, startX+44, 320, self.view.frame.size.height-44-startX) style:UITableViewStylePlain];
    [self.view addSubview:self.contactsTable];
    self.contactsTable.dataSource = self;
    self.contactsTable.delegate = self;
    //    self.contactsTable.contentOffset = CGPointMake(0, 44);
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, startX, 320, 44)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //searchBar.keyboardType = UIKeyboardTypeAlphabet;
    //    self.contactsTable.tableHeaderView = searchBar;
    searchBar.placeholder = @"搜索联系人";
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"查询中...";
    [hud show:YES];
}
//-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
//{
//    
//    if (diffH==20.0f) {
//        [searchBar setFrame:CGRectMake(0, 20, 320, 64)];
//        searchBar.backgroundImage = [UIImage imageNamed:@"topBar2.png"];
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.contactsTable setFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-(49+64))];
//        } completion:^(BOOL finished) {
//            
//        }];
////    }
//}
//
//-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
//{
//    if (diffH==20.0f) {
//        
//    }
//    
//}
//-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
//{
//    if (diffH==20.0f) {
//        [UIView animateWithDuration:0.2 animations:^{
//            [searchBar setFrame:CGRectMake(0, 64, 320, 44)];
//            [self.contactsTable setFrame:CGRectMake(0, 44+44+diffH, 320, self.view.frame.size.height-(49+44+diffH))];
//        } completion:^(BOOL finished) {
//            searchBar.backgroundImage = nil;
//        }];
//    }
//    
//    
//}
//-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
//{
//    
//    if (diffH==20.0f) {
//        //        [tableView setFrame:CGRectMake(0, 20, 320, self.view.frame.size.height-(49+diffH))];
//        //        [tableView setContentOffset:CGPointMake(0, 20)];
//    }
//    
//    
//}

-(void)viewWillAppear:(BOOL)animated
{
//    if ([[TempData sharedInstance] needChat]) {
//        [self.customTabBarController setSelectedPage:0];
//        return;
//    }
//    if ([[TempData sharedInstance] ifPanned]) {
//        [self.customTabBarController hidesTabBar:NO animated:NO];
//    }
//    else
//    {
//        [self.customTabBarController hidesTabBar:NO animated:YES];
//        [[TempData sharedInstance] Panned:YES];
//    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [self refreshFriendList];
    
    //   [self getFriendInfo:@"england"];
}

-(void)refreshFriendList
{
    friendDict = [DataStoreManager queryAllFriends];
    sectionArray = [DataStoreManager querySections];
    [sectionIndexArray removeAllObjects];
    for (int i = 0; i<sectionArray.count; i++) {
        [sectionIndexArray addObject:[[sectionArray objectAtIndex:i] objectAtIndex:0]];
    }
    
    friendsArray = [NSMutableArray arrayWithArray:[friendDict allKeys]];
    [friendsArray sortUsingSelector:@selector(compare:)];
    [self.contactsTable reloadData];
    [hud hide:YES];
}

-(void)addButton:(UIButton *)sender
{
    AddContactViewController * addV = [[AddContactViewController alloc] init];
    [self.navigationController pushViewController:addV animated:YES];
}
-(NSString *)convertChineseToPinYin:(NSString *)chineseName
{
    NSMutableString * theName = [NSMutableString stringWithString:chineseName];
    NSLog(@"hhhh0:%@",theName);
    CFRange range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformToLatin, NO);
    NSLog(@"hhhh1:%@",theName);
    range = CFRangeMake(0, theName.length);
    CFStringTransform((CFMutableStringRef)theName, &range, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"hhhh:%@",theName);
    NSString * dd = [theName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"hhhh3:%@",dd);
    return dd;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchBar.text];
    NSLog(@"%@",searchBar.text);
    
    searchResultArray = [friendsArray filteredArrayUsingPredicate:resultPredicate ]; //注意retain
    NSLog(@"%@",searchResultArray);
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return [searchResultArray count];
    }
    
    return [[[sectionArray objectAtIndex:section] objectAtIndex:1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * stringCell3 = @"cell33";
    PersonTableCell * cell = [tableView dequeueReusableCellWithIdentifier:stringCell3];
    if (!cell) {
        cell = [[PersonTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stringCell3];
    }
    NSDictionary * tempDict;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        tempDict = [friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
    }
    else
        tempDict = [friendDict objectForKey:[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];

    if ([[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"gender")] isEqualToString:@"0"]) {//男♀♂
        cell.ageLabel.text = [@"♂ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_man.png"];
    }
    else
    {
        cell.ageLabel.text = [@"♀ " stringByAppendingString:[GameCommon getNewStringWithId:[tempDict objectForKey:@"age"]]];
        cell.ageLabel.backgroundColor = kColorWithRGB(238, 100, 196, 1.0);
        cell.headImageV.placeholderImage = [UIImage imageNamed:@"people_woman.png"];
    }
    cell.headImageV.imageURL = [NSURL URLWithString:[BaseImageUrl stringByAppendingString:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"img")]]];
    cell.nameLabel.text = [tempDict objectForKey:@"displayName"];
    cell.gameImg_one.image = KUIImage(@"wow");
    cell.distLabel.text = [KISDictionaryHaveKey(tempDict, @"achievement") isEqualToString:@""] ? @"暂无头衔" : KISDictionaryHaveKey(tempDict, @"achievement");
    cell.distLabel.textColor = [GameCommon getAchievementColorWithLevel:[KISDictionaryHaveKey(tempDict, @"achievementLevel") integerValue]];
        
    cell.timeLabel.text = [GameCommon getTimeAndDistWithTime:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"updateUserLocationDate")] Dis:[GameCommon getNewStringWithId:KISDictionaryHaveKey(tempDict, @"distance")]];
    
    [cell refreshCell];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        selectDict = [friendDict objectForKey:[searchResultArray objectAtIndex:indexPath.row]];
    }
    else
    {
        selectDict = [friendDict objectForKey:[[[sectionArray objectAtIndex:indexPath.section] objectAtIndex:1] objectAtIndex:indexPath.row]];
    }
    [self.contactDelegate getContact:selectDict];

    [self.navigationController popViewControllerAnimated:YES];
//
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"是否确认发送给 %@?", KISDictionaryHaveKey(selectDict, @"displayName")] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = 567;
//    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 567) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.contactDelegate getContact:selectDict];

//            [self dismissViewControllerAnimated:YES completion:^{
//                
//            }];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return 1;
    }
    
    return sectionArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return @"";
    }
    return [[sectionArray objectAtIndex:section] objectAtIndex:0];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionIndexArray;
}
-(void)back
{
//    [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end