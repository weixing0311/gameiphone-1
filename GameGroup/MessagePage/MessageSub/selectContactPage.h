//
//  ContactsViewController.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-6-26.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "TempData.h"
#import "AddContactViewController.h"
#import "PersonDetailViewController.h"
#import "HostInfo.h"

#import "BaseViewController.h"

@class AppDelegate, XMPPHelper;
@protocol getContact <NSObject>
-(void)getContact:(NSDictionary *)userDict;
@end
@interface selectContactPage : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    UISearchBar * searchBar;
    UISearchDisplayController * searchDisplay;
    NSMutableArray * friendsArray;
    NSMutableDictionary * friendDict;
    NSMutableArray * sectionArray;
    NSMutableArray * rowsArray;
    NSArray * searchResultArray;
    NSMutableArray * sectionIndexArray;
    
    float diffH;
}
@property (strong,nonatomic) AppDelegate * appDel;
@property (strong,nonatomic)UITableView *contactsTable;
@property (assign,nonatomic) id <getContact> contactDelegate;
@end
