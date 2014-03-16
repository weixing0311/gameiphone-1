//
//  MyProfileViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-11.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "MyProfileViewController.h"
#import "PhotoViewController.h"
#import "EditMessageViewController.h"

@interface MyProfileViewController ()
{
    UILabel*       m_titleLabel;
    
    UITableView*   m_myTableView;
    HGPhotoWall    *m_photoWall;
    
    NSMutableArray * waitingUploadImgArray;
    NSMutableArray * waitingUploadStrArray;
    
    NSMutableArray * deleteImageIdArray;//需要删除的图片
    
    UILabel*        m_starSignLabel;//星座
    UILabel*        m_ageLabel;//年龄
    NSTimer *timer;
    BOOL            m_isSort;//图片顺序变化
}
@end

@implementation MyProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"userName==[c]%@",[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
        self.hostInfo = [DSFriends MR_findFirstWithPredicate:predicate];
    }];
    m_titleLabel.text = [DataStoreManager queryNickNameForUser:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil]];
    
    if ([self.headImgArray count] == 0) {
        [self getHead:self.hostInfo.headImgID];//相册 小图_大图,
        [m_photoWall setPhotos:[self imageToURL:self.headImgArray]];
        [m_photoWall setEditModel:YES];
    }
  
    [m_myTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"" withBackButton:YES];
    
    m_isSort = NO;
    
    m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, KISHighVersion_7 ? 20 : 0, 220, 44)];
    m_titleLabel.textColor = [UIColor whiteColor];
    m_titleLabel.backgroundColor = [UIColor clearColor];
    m_titleLabel.text = self.nickName;
    m_titleLabel.textAlignment = NSTextAlignmentCenter;
    m_titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:m_titleLabel];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [addButton setBackgroundImage:KUIImage(@"ok_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"ok_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(saveMyPicter) forControlEvents:UIControlEventTouchUpInside];
    
    waitingUploadImgArray = [NSMutableArray array];
    waitingUploadStrArray = [NSMutableArray array];
    deleteImageIdArray = [NSMutableArray array];
    
    m_photoWall = [[HGPhotoWall alloc] initWithFrame:CGRectZero];
    m_photoWall.descriptionType = DescriptionTypeImage;
    m_photoWall.useCache = YES;
    m_photoWall.delegate = self;
    m_photoWall.backgroundColor = kColorWithRGB(105, 105, 105, 1.0);
    m_photoWall.tag =1;
    
    m_myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, startX, kScreenWidth, kScreenHeigth - startX-(KISHighVersion_7?0:20))];
    m_myTableView.delegate = self;
    m_myTableView.dataSource = self;
    [self.view addSubview:m_myTableView];
    UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, -2, 320, 2)];
    footView.backgroundColor = [UIColor whiteColor];
    m_myTableView.tableFooterView = footView;
    
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"修改中...";
}

-(void)getHead:(NSString *)headImgStr
{
    NSMutableArray * littleHeadArray = [NSMutableArray array];
    NSArray* i = [headImgStr componentsSeparatedByString:@","];
    if (i.count>0) {
        for (NSString* a in i) {
            if (a.length > 0 && ![a isEqualToString:@" "])  {
                [littleHeadArray addObject:a];
            }
        }
    }//动态大图ID数组和小图ID数组
    self.headImgArray = littleHeadArray;//47,39
}
#pragma mark 返回
- (void)backButtonClick:(id)sender
{
    if ([waitingUploadImgArray count] != 0 || [deleteImageIdArray count] != 0 || m_isSort) {
        UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的相册还未保存，确认要退出吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alter.tag = 75;
        [alter show];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 75) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 初始化头像
-(NSArray *)imageToURL:(NSArray *)imageArray;
{
    NSMutableArray * temp = [NSMutableArray array];
    for (id headID in imageArray) {
        NSRange range=[headID rangeOfString:@"<local>"];
        if (range.location!=NSNotFound) {
            [temp addObject:headID];
        }
        else
            [temp addObject:[NSString stringWithFormat:@"%@%@",BaseImageUrl,headID]];
    }
    return temp;
}

#pragma mark - 相片

- (void)photoWallPhotoTaped:(NSUInteger)index WithPhotoWall:(UIView *)photoWall
{
    PhotoViewController * photoV = [[PhotoViewController alloc] initWithSmallImages:nil images:self.headImgArray indext:index];
    [self presentViewController:photoV animated:NO completion:^{
        
    }];
}

- (void)photoWallMovePhotoFromIndex:(NSInteger)index toIndex:(NSInteger)newIndex
{
    if (index!=newIndex) {
        NSMutableArray * array1 = [NSMutableArray arrayWithArray:self.headImgArray];
//        NSMutableArray * array2 = [NSMutableArray arrayWithArray:self.headBigImgArray];

        NSString * tempStr = [array1 objectAtIndex:index];
//        NSString * tempStr2 = [array2 objectAtIndex:index];
        
        if (newIndex<index) {
            [array1 insertObject:tempStr atIndex:newIndex];
//            [array2 insertObject:tempStr2 atIndex:newIndex];
            [array1 removeObjectAtIndex:index+1];
//            [array2 removeObjectAtIndex:index+1];
        }
        else{
            [array1 removeObjectAtIndex:index];
//            [array2 removeObjectAtIndex:index];
            [array1 insertObject:tempStr atIndex:newIndex];
//            [array2 insertObject:tempStr2 atIndex:newIndex];
        }
        m_isSort = YES;
        self.headImgArray = array1;
//        self.headBigImgArray = array2;
    }
}


- (void)photoWallAddAction
{
    UIActionSheet *actionSheetTemp = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"相册选择",@"拍照", nil];
    actionSheetTemp.tag = ActionSheetTypeChoosePic;
    [actionSheetTemp showInView:self.view];
}

- (void)photoWallAddFinish
{
    
}
-(void)photoWallDelPhotoAtIndex:(NSInteger)index
{
    NSLog(@"%d",index);
    NSMutableArray * tempH = [NSMutableArray arrayWithArray:self.headImgArray];
//    NSMutableArray * tempHBig = [NSMutableArray arrayWithArray:self.headBigImgArray];
    NSString * tempStr = [tempH objectAtIndex:index];
    if ([waitingUploadStrArray containsObject:tempStr]) {
        int tempIndex = [waitingUploadStrArray indexOfObject:tempStr];
        [waitingUploadStrArray removeObject:tempStr];
        [waitingUploadImgArray removeObjectAtIndex:tempIndex];
    }
    else//需要删除的id
    {
        [deleteImageIdArray addObject:tempStr];//小图
        
//        NSString* bigStr = [tempHBig objectAtIndex:index];
//        
//        [deleteImageIdArray addObject:bigStr];//大图
        NSLog(@"需要删除的图片id %@", deleteImageIdArray);
    }
    [tempH removeObjectAtIndex:index];
//    [tempHBig removeObjectAtIndex:index];
    self.headImgArray = tempH;
//    self.headBigImgArray = tempHBig;

    [m_myTableView reloadData];
}

- (void)photoWallDeleteFinish
{
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [m_photoWall setAnimationNO];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==ActionSheetTypeChoosePic) {
        UIImagePickerController * imagePicker;
        if (buttonIndex==1)
            //这里捕捉“毁灭键”,其实该键的index是0，从上到下从0开始，称之为毁灭是因为是红的
        {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *cameraAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相机" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
                [cameraAlert show];
            }
        }
        else if (buttonIndex==0) {
            if (imagePicker==nil) {
                imagePicker=[[UIImagePickerController alloc]init];
                imagePicker.delegate=self;
                imagePicker.allowsEditing = YES;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                //                [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                [libraryAlert show];
            }
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@",info);
    UIImage * upImage = (UIImage *)[info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    UIImage* a = [NetManager compressImageDownToPhoneScreenSize:image targetSizeX:100 targetSizeY:100];
    //    UIImage* upImage = [NetManager image:a centerInSize:CGSizeMake(100, 100)];
    NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString  *openImgPath = [NSString stringWithFormat:@"%@/%d_me.jpg",path,self.headImgArray.count];
    
    if ([UIImageJPEGRepresentation(upImage, 1.0) writeToFile:openImgPath atomically:YES]) {
        NSLog(@"success///");
    }
    else
    {
        NSLog(@"fail");
    }
    NSMutableArray * tempArray;
    NSMutableArray * tempBigArray;
    if (self.headImgArray) {
        tempArray = [NSMutableArray arrayWithArray:self.headImgArray];
//        tempBigArray = [NSMutableArray arrayWithArray:self.headBigImgArray];
    }
    else
    {
        tempArray = [NSMutableArray array];
        tempBigArray = [NSMutableArray array];
    }
    [tempArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.headImgArray.count]];
    [tempBigArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.headImgArray.count]];
    [waitingUploadImgArray addObject:upImage];
    [waitingUploadStrArray addObject:[NSString stringWithFormat:@"<local>%d_me.jpg",self.headImgArray.count]];
    [m_photoWall addPhoto:[NSString stringWithFormat:@"<local>%d_me.jpg",self.headImgArray.count]];
    self.headImgArray = tempArray;
//    self.headBigImgArray = tempBigArray;
    NSLog(@"新图 %@", self.headImgArray);// 47,39,"<local>2_me.jpg"

    [m_myTableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)saveMyPicter
{
    [hud show:YES];
    if (waitingUploadImgArray.count>0) {
        
       /*
//        [NetManager uploadImagesWithCompres:waitingUploadImgArray WithURLStr:BaseUploadImageUrl ImageName:waitingUploadStrArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {//上传一张压缩图片成功后 上传一张不压缩图片
        
//            NSDictionary* CompresID = responseObject;//"<local>0_me.jpg" = 8; 8为id
        [NetManager uploadImages:waitingUploadImgArray
                      WithURLStr:BaseUploadImageUrl
                       ImageName:waitingUploadStrArray
                   TheController:self
                        Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
        {
            hud.labelText = [NSString stringWithFormat:@"图片上传中..%.2f％",((double)totalBytesWritten/(double)totalBytesExpectedToWrite) * 100];
        }
                         Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
           
                [hud hide:YES];
                
                NSMutableArray * a1 = [NSMutableArray arrayWithArray:self.headImgArray];//压缩图 头像
//                NSMutableArray * a2 = [NSMutableArray arrayWithArray:self.headBigImgArray];//大图 点开时用
                for (NSString*a in responseObject) {// "<local>0_me.jpg" = 22; "<local>1_me.jpg" = 21;
                    
                    for (int i = 0;i<a1.count;i++) {
                        if ([[a1 objectAtIndex:i] isEqualToString:a]) {
//                            [a1 replaceObjectAtIndex:i withObject:[CompresID objectForKey:a]];
                            [a1 replaceObjectAtIndex:i withObject:[responseObject objectForKey:a]];
                        }
//                        if ([[a2 objectAtIndex:i] isEqualToString:a]) {
//                            [a2 replaceObjectAtIndex:i withObject:[responseObject objectForKey:a]];
//                        }
                    }
                }
                self.headImgArray = a1;
//                self.headBigImgArray = a2;
                
                [self refreshMyInfo];

//                if([deleteImageIdArray count] > 0)
//                    [self deleteImageIdByNet];//删除
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [hud hide:YES];

                [self showAlertViewWithTitle:@"提示" message:@"上传失败" buttonTitle:@"确定"];
            }];
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            [hud hide:YES];
//            [self showAlertViewWithTitle:@"提示" message:@"上传失败" buttonTitle:@"确定"];
//        }];
        */
        [self publishOnePicture:0 image:waitingUploadImgArray imageName:waitingUploadStrArray reponseStrDic:[NSMutableDictionary dictionaryWithCapacity:1]];
        
    }
//    else if([deleteImageIdArray count] > 0) //有删除
//    {
//        [self deleteImageIdByNet];
//        [self refreshMyInfo];
//    }
    else//只是修改顺序
        [self refreshMyInfo];
}

-(void)publishOnePicture:(NSInteger)picIndex image:(NSArray*)imageArray imageName:(NSArray*)imageNameArray reponseStrDic:(NSMutableDictionary*)reponseStrArray
{
    [NetManager uploadImage:[imageArray objectAtIndex:picIndex] WithURLStr:BaseUploadImageUrl ImageName:[imageNameArray objectAtIndex:picIndex] TheController:self Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite){
        hud.labelText = [NSString stringWithFormat:@"上传第%d张 %.2f％", picIndex+1,((double)totalBytesWritten/(double)totalBytesExpectedToWrite) * 100];
    }Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [GameCommon getNewStringWithId:responseObject];//图片id
        [reponseStrArray setObject:response forKey:[imageNameArray objectAtIndex:picIndex]];
        if (reponseStrArray.count != imageArray.count) {
            NSLog(@"aaaaaaaaa");
            [self publishOnePicture:(picIndex+1) image:imageArray imageName:imageNameArray reponseStrDic:reponseStrArray];
        }
        else
        {
            [hud hide:YES];
            NSLog(@"reponseStrArray %@", reponseStrArray);
            //self.imageId = [[NSMutableString alloc]init];
             NSMutableArray * a1 = [NSMutableArray arrayWithArray:self.headImgArray];//压缩图 头像
            for (NSString*a in reponseStrArray) {
                    for (int i = 0;i<a1.count;i++) {
                        if ([[a1 objectAtIndex:i] isEqualToString:a]) {
                            [a1 replaceObjectAtIndex:i withObject:[reponseStrArray objectForKey:a]];
                        }
                    }
                }
                self.headImgArray = a1;
             [self refreshMyInfo];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showAlertViewWithTitle:@"提示" message:@"上传图片失败" buttonTitle:@"确定"];
    }];
}



- (void)refreshMyInfo//更新个人头像数据
{
    NSString* headImgStr = @"";
    for (int i = 0;i<self.headImgArray.count;i++) {
        NSString * temp1 = [self.headImgArray objectAtIndex:i];
//        NSString * temp2 = [self.headBigImgArray objectAtIndex:i];
//        headImgStr = [headImgStr stringByAppendingFormat:@"%@_%@,",temp1,temp2];
        headImgStr = [headImgStr stringByAppendingFormat:@"%@,",temp1];
    }
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    [paramDict setObject:headImgStr forKey:@"img"];
   
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"104" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        
        [self showMessageWindowWithContent:@"保存成功" imageType:0];
        [self.navigationController popViewControllerAnimated:YES];

        
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
-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)deleteImageIdByNet
{
    [NetManager deleteImagesWithURLStr:BaseDeleteImageUrl ImageName:deleteImageIdArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark - 表格
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        default:
            return 30;
            break;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    UIImageView* topBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UILabel* titleLabel;
    switch (section) {
        case 1:
        {
            topBg.image = KUIImage(@"inputbg");

//            UIView* genderView = [CommonControlOrView setGenderAndAgeViewWithFrame:CGRectMake(10, 15/2.0, 40, 15) gender:self.hostInfo.gender age:@""];
//            [topBg addSubview:genderView];
            
            m_ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 9, 30, 12)];
            [m_ageLabel setTextColor:[UIColor whiteColor]];
            [m_ageLabel setFont:[UIFont boldSystemFontOfSize:10.0]];
            m_ageLabel.layer.cornerRadius = 3;
            m_ageLabel.layer.masksToBounds = YES;
            m_ageLabel.textAlignment = NSTextAlignmentLeft;
            [topBg addSubview:m_ageLabel];
            
            if ([self.hostInfo.gender isEqualToString:@"0"]) {//男♀♂
                m_ageLabel.text = [@"♂ " stringByAppendingString:self.hostInfo.age];
                m_ageLabel.backgroundColor = kColorWithRGB(33, 193, 250, 1.0);
            }
            else
            {
                m_ageLabel.text = [@"♀ " stringByAppendingString:self.hostInfo.age];
                m_ageLabel.backgroundColor = kColorWithRGB(238, 100, 196, 1.0);
            }
            CGSize ageSize = [m_ageLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:10.0] constrainedToSize:CGSizeMake(100, 12) lineBreakMode:NSLineBreakByWordWrapping];
            m_ageLabel.frame = CGRectMake(10, 9, ageSize.width + 5, 12);

            UIImageView* gameImg_one = [[UIImageView alloc] initWithFrame:CGRectMake(ageSize.width + 70, 6, 18, 18)];
            gameImg_one.backgroundColor = [UIColor clearColor];
            gameImg_one.image = KUIImage(@"wow");
            [topBg addSubview:gameImg_one];
            
//            m_ageLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(30, 0, 20, 30) textColor:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:12.0] text:self.hostInfo.age textAlignment:NSTextAlignmentLeft];
//            [topBg addSubview:m_ageLabel];
            m_starSignLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(ageSize.width + 25, 0, 50, 30) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:self.hostInfo.starSign textAlignment:NSTextAlignmentLeft];
            [topBg addSubview:m_starSignLabel];
            
            
        } break;
        case 2:
        {
            topBg.image = KUIImage(@"table_heard_bg");

            titleLabel = [CommonControlOrView setLabelWithFrame:CGRectMake(10, 0, 100, 25) textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:12.0] text:@"其他" textAlignment:NSTextAlignmentLeft];
        }break;
        default:
            break;
    }
    [topBg addSubview:titleLabel];
    return topBg;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return m_photoWall.frame.size.height;
    }
    if([[GameCommon getNewStringWithId:self.hostInfo.superstar] isEqualToString:@"1"])//有认证
    {
        if(indexPath.section == 1 && indexPath.row == 5)//签名
        {
            CGSize textSize = [self.hostInfo.signature sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
            return textSize.height == 0 ? 40 : textSize.height + 25;
        }
        if(indexPath.section == 1 && indexPath.row == 4)//标签
        {
            CGSize textSize = [self.hostInfo.hobby sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
            return textSize.height == 0 ? 40 : textSize.height + 25;
        }
    }
    else
    {
        if(indexPath.section == 1 && indexPath.row == 4)//签名
        {
            CGSize textSize = [self.hostInfo.signature sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
            return textSize.height == 0 ? 40 : textSize.height + 25;
        }
        if(indexPath.section == 1 && indexPath.row == 3)//标签
        {
            CGSize textSize = [self.hostInfo.hobby sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
            return textSize.height == 0 ? 40 : textSize.height + 25;
        }
    }
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }break;
        case 1:
        {
            if([[GameCommon getNewStringWithId:self.hostInfo.superstar] isEqualToString:@"1"])
                return 6;
            return 5;
        }
        break;
        default:
        {
            return 1;
        } break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        static NSString *Cell = @"userinfo";
        TextLabelTableCell *cell = (TextLabelTableCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[TextLabelTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
        }
        if([[GameCommon getNewStringWithId:self.hostInfo.superstar] isEqualToString:@"1"])//有认证
        {
            cell.disField.hidden = YES;
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.nameLabel.text = @"      认证";
                cell.disLabel.text = self.hostInfo.superremark;
                cell.vAuthImg.hidden = NO;
            }
            else if(indexPath.row == 1)
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.nameLabel.text = @"陌游ID";
                cell.disLabel.text = self.hostInfo.userId;
                cell.vAuthImg.hidden = YES;
                UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(230, 15, 29, 12)];
                [cell.contentView addSubview:image];
                if (![self.hostInfo.action boolValue]) {
                    NSLog(@"未激活");
                    image.image = [UIImage imageNamed:@"unactive"];
                }else
                {
                    NSLog(@"已状态");
                    image.image = [UIImage imageNamed:@"active"];
                }

            }
            else{
                cell.vAuthImg.hidden = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch (indexPath.row) {
                    case 2:
                    {
                        cell.nameLabel.text = @"昵称";
                        cell.disLabel.text = self.hostInfo.nickName;
                    } break;
                    case 3:
                    {
                        cell.nameLabel.text = @"生日";
                        cell.disField.hidden = NO;
                        cell.disField.text = self.hostInfo.birthday;
                        cell.cellDelegate = self;
                    } break;
                    case 4:
                    {
                        cell.nameLabel.text = @"个人标签";
                        CGSize textSize = [self.hostInfo.hobby sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
                        cell.disLabel.frame = CGRectMake(100, 10, 190, textSize.height == 0 ? 20 : textSize.height + 5);
                        cell.disLabel.text = [self.hostInfo.hobby isEqualToString:@""] ? @"暂无" : self.hostInfo.hobby;
                        
                    } break;
                    case 5:
                    {
                        cell.nameLabel.text = @"个性签名";
                        CGSize textSize = [self.hostInfo.signature sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
                        cell.disLabel.frame = CGRectMake(100, 10, 190, textSize.height == 0 ? 20 : textSize.height + 5);
                        cell.disLabel.text = [self.hostInfo.signature isEqualToString:@""] ? @"暂无" : self.hostInfo.signature;
                    } break;
                    default:
                        break;
                }
            }
            [cell refreshCell];
            return cell;
        }
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.nameLabel.text = @"陌游ID";
            cell.disLabel.text = self.hostInfo.userId;
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(230, 15, 29, 12)];
            [cell.contentView addSubview:image];
            
            NSLog(@"self.hostInfo.action%@",self.hostInfo.action);
            if (![self.hostInfo.action boolValue]) {
                NSLog(@"未激活");
                image.image = [UIImage imageNamed:@"unactive"];
            }else
            {
                NSLog(@"已状态");
                image.image = [UIImage imageNamed:@"active"];
            }
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            switch (indexPath.row) {
                case 1:
                {
                    cell.nameLabel.text = @"昵称";
                    cell.disLabel.text = self.hostInfo.nickName;
                } break;
                case 2:
                {
                    cell.nameLabel.text = @"生日";
                    cell.disField.hidden = NO;
                    cell.disField.text = self.hostInfo.birthday;
                    cell.cellDelegate = self;
                } break;
                case 3:
                {
                    cell.nameLabel.text = @"个人标签";
                    CGSize textSize = [self.hostInfo.hobby sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
                    cell.disLabel.frame = CGRectMake(100, 10, 190, textSize.height == 0 ? 20 : textSize.height + 5);
                    cell.disLabel.text = [self.hostInfo.hobby isEqualToString:@""] ? @"暂无" : self.hostInfo.hobby;

                } break;
                case 4:
                {
                    cell.nameLabel.text = @"个性签名";
                    CGSize textSize = [self.hostInfo.signature sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(190, 200)];
                    cell.disLabel.frame = CGRectMake(100, 10, 190, textSize.height == 0 ? 20 : textSize.height + 5);
                    cell.disLabel.text = [self.hostInfo.signature isEqualToString:@""] ? @"暂无" : self.hostInfo.signature;
                } break;
                default:
                    break;
            }
        }
        [cell refreshCell];
        return cell;
    }
    else if(indexPath.section == 2)
    {
        static NSString *Cell = @"otherCells";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:Cell];
        }
        cell.imageView.image = KUIImage(@"time");
        cell.textLabel.text = @"注册时间";
        
        NSString* timeStr = [[GameCommon shareGameCommon] getDataWithTimeInterval:self.hostInfo.createTime];
        cell.detailTextLabel.text = timeStr;
        
        return cell;
    }
    static NSString *Cell = @"Cells";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:Cell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:Cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (indexPath.section == 0) {
        [cell.contentView addSubview:m_photoWall];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [m_myTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 || indexPath.section == 2) {
        return;
    }
    if([[GameCommon getNewStringWithId:self.hostInfo.superstar] isEqualToString:@"1"])//有认证
    {
        EditMessageViewController* editVC = [[EditMessageViewController alloc] init];
        switch (indexPath.row) {
            case 0:
            case 1:
                return;
                break;
            case 2:
                editVC.editType = EDIT_TYPE_nickName;
                editVC.placeHold = self.hostInfo.nickName;
                break;
            case 3:
//                editVC.editType = EDIT_TYPE_birthday;
                return;
                break;
            case 4:
                editVC.editType = EDIT_TYPE_hobby;
                editVC.placeHold = self.hostInfo.hobby;
                break;
            case 5:
                editVC.editType = EDIT_TYPE_signature;
                editVC.placeHold = self.hostInfo.signature;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:editVC animated:YES];
        return;
    }
    EditMessageViewController* editVC = [[EditMessageViewController alloc] init];
    switch (indexPath.row) {
        case 0:
            return;
            break;
        case 1:
            editVC.editType = EDIT_TYPE_nickName;
            editVC.placeHold = self.hostInfo.nickName;
            break;
        case 2:
//            editVC.editType = EDIT_TYPE_birthday;
            return;
            break;
        case 3:
            editVC.editType = EDIT_TYPE_hobby;
            editVC.placeHold = self.hostInfo.hobby;
            break;
        case 4:
            editVC.editType = EDIT_TYPE_signature;
            editVC.placeHold = self.hostInfo.signature;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)birthDaySelected:(NSString*)birthday
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:[SFHFKeychainUtils getPasswordForUsername:ACCOUNT andServiceName:LOCALACCOUNT error:nil] forKey:@"username"];
    [paramDict setObject:birthday forKey:@"birthdate"];
    
    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"104" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // [hud hide:YES];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD_isok"]];
        hud.labelText = @"保存成功";
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:4];

        NSLog(@"%@", responseObject);
        
        [DataStoreManager saveUserInfo:responseObject];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
