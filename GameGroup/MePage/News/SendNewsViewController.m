//
//  SendNewsViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 13-12-31.
//  Copyright (c) 2013年 Swallow. All rights reserved.
//

#import "SendNewsViewController.h"
#import "Emoji.h"

@interface SendNewsViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
    NSInteger  m_maxZiShu;//发表字符数量
    UILabel *m_ziNumLabel;//提示文字
}
@property (nonatomic,strong)UITextView* dynamicTV;
@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;

@end

@implementation SendNewsViewController

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    m_maxZiShu = 225;
    [self setTopViewWithTitle:@"发表动态" withBackButton:YES];

    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(270, startX - 44, 50, 44);
    [addButton setBackgroundImage:KUIImage(@"ok_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"ok_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(saveMyNews:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setMainView];
}

- (void)setMainView
{
    UIImage* bgImage = [[UIImage imageNamed:@"edit_bg"]
                        stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(13.75, 21.75+startX, 292.5, 128)];
    editIV.image = bgImage;
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(13.75, 21.75+startX, 292.5, 128)];
    _dynamicTV.backgroundColor = [UIColor clearColor];
    _dynamicTV.font = [UIFont systemFontOfSize:13];
    _dynamicTV.delegate = self;
    if (self.defaultContent && ![self.defaultContent isEqualToString:@""]) {
        _dynamicTV.text = self.defaultContent;
    }
    [self.view addSubview:_dynamicTV];
    [self.dynamicTV becomeFirstResponder];
    
    UIImageView* tool = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (startX==64) {
        tool.image = [UIImage imageNamed:@"inputbg"];
    }
    else
    {
        tool.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        tool.layer.borderColor = [[UIColor grayColor] CGColor];
        tool.layer.borderWidth = 1;
    }
    tool.userInteractionEnabled = YES;
    _dynamicTV.inputAccessoryView = tool;
    
    UIButton* imageB = [UIButton buttonWithType:UIButtonTypeCustom];
    imageB.frame = CGRectMake(270, 4, 35, 35);
    [imageB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    [imageB setBackgroundImage:[UIImage imageNamed:@"picBtn"] forState:UIControlStateNormal];
    [tool addSubview:imageB];
    
    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 28.75+startX, 200, 20)];
    
    
    _placeholderL.backgroundColor = [UIColor clearColor];
    _placeholderL.textColor = [UIColor grayColor];
    if (self.defaultContent && ![self.defaultContent isEqualToString:@""]) {//不是分享头衔
        _placeholderL.text = @"";
    }
    else
        _placeholderL.text = @"今天想跟别人说点什么……";
    _placeholderL.font = [UIFont systemFontOfSize:13.0];
    [self.view addSubview:_placeholderL];
    
    PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoB.frame = CGRectMake(13, startX + 155, 48.5, 48.5);
    [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
    [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    PhotoB.hidden = YES;
    [self.view addSubview:PhotoB];

    if (self.titleImage) {
        UIImageView* titleimg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 155 + startX, 48.5, 48.5)];
        titleimg.image = self.titleImage;
        titleimg.userInteractionEnabled = YES;
        [self.view addSubview:titleimg];
        
        UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
        [titleimg addGestureRecognizer:tapGR];

        PhotoB.frame = CGRectMake(13 + 48.5 +12.875, startX  + 155, 48.5, 48.5);
        if (self.pictureArray == nil) {
            self.pictureArray = [[NSMutableArray alloc]init];
        }
        [_pictureArray addObject:titleimg];

    }
    
    m_ziNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, startX, 200, 20)];
    m_ziNumLabel.backgroundColor = [UIColor clearColor];
    m_ziNumLabel.font= [UIFont systemFontOfSize:12];
    m_ziNumLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:m_ziNumLabel];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在为您发布...";
    
}




- (void)backButtonClick:(id)sender
{
    if (!KISEmptyOrEnter(self.dynamicTV.text) || self.pictureArray.count>0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您是否放弃当前编辑？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 67;
        [alert show];
    }
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshZiLabelText];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 67) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark 保存

- (void)saveMyNews:(id)sender
{
    if (_dynamicTV.text.length<=0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"你还没有想好说些什么!" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if (_dynamicTV.text.length>225) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您发布的字数已超出限制" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 67;
        [alert show];
        return;
    }

    [hud show:YES];
    [self.dynamicTV resignFirstResponder];
    if (self.pictureArray.count>0) {
        [self.view bringSubviewToFront:hud];
        NSMutableArray* imageArray = [[NSMutableArray alloc]init];
        NSMutableArray* nameArray = [[NSMutableArray alloc]init];
        for (int i = 0;i< self.pictureArray.count;i++) {
            [imageArray addObject:((UIImageView*)self.pictureArray[i]).image];
            [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
        hud.labelText = @"上传图片中...";
        [hud show:YES];
        [self publishOnePicture:0 image:imageArray imageName:nameArray reponseStrDic:[NSMutableDictionary dictionaryWithCapacity:1]];
//        [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {//上传图片
//            [hud hide:YES];
//
//            self.imageId = [[NSMutableString alloc]init];
//            for (NSString*a in responseObject) {
//                [_imageId appendFormat:@"%@,",[responseObject objectForKey:a]];
//            }
//            [self publishWithImageString:_imageId];
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [hud hide:YES];
//        }];
    }else
    {
        [self publishWithImageString:@""];
    }
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
            self.imageId = [[NSMutableString alloc]init];
            for (NSString*a in reponseStrArray) {
                [_imageId appendFormat:@"%@,",[reponseStrArray objectForKey:a]];
            }
            [self publishWithImageString:_imageId];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        [self showAlertViewWithTitle:@"提示" message:@"上传图片失败" buttonTitle:@"确定"];
    }];
}

-(void)publishWithImageString:(NSString*)imageID
{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"3" forKey:@"type"];
    [paramDict setObject:self.dynamicTV.text forKey:@"msg"];
    [paramDict setObject:imageID forKey:@"img"];
//    [paramDict setObject:@"" forKey:@"urlLink"];

    [postDict addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [postDict setObject:paramDict forKey:@"params"];
    [postDict setObject:@"134" forKey:@"method"];
    [postDict setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    
    hud.labelText = @"发表中...";
    [hud show:YES];
    
    [NetManager requestWithURLStr:BaseClientUrl Parameters:postDict TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            [self addNewNewsToStore:responseObject];
            if (self.delegate&&[self.delegate respondsToSelector:@selector(dynamicListAddOneDynamic:)])
                [self.delegate dynamicListAddOneDynamic:responseObject];
        }
        if (self.defaultContent && ![self.defaultContent isEqualToString:@""])
        {
        }
        else{
            [self showMessageWindowWithContent:@"发表成功" imageType:0];
        }
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

//- (void)addNewNewsToStore:(NSDictionary*)dic
//{
//    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
//        NSArray * dMyNews = [DSMyNewsList MR_findAllInContext:localContext];
//        if ([dMyNews count] >= 20) {
//            DSMyNewsList* news = [dMyNews lastObject];
//            [news deleteInContext:localContext];//删除最后面一个
//        }
//    }];
//    [DataStoreManager saveMyNewsWithData:dic];
//}

#pragma mark 照片
-(void)getAnActionSheet
{
    if (_pictureArray.count<9) {
        [_dynamicTV resignFirstResponder];
        if (self.addActionSheet != nil) {
            [_addActionSheet showInView:self.view];
            return;
        }
        self.addActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [_addActionSheet showInView:self.view];
    }
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == _addActionSheet) {
        switch (buttonIndex) {
            case 0:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
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
            }break;
            case 1:
            {
                UIImagePickerController * imagePicker;
                if (imagePicker==nil) {
                    imagePicker=[[UIImagePickerController alloc]init];
                    imagePicker.delegate=self;
                }
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;

                    [self presentViewController:imagePicker animated:YES completion:^{
                        
                    }];
                }
                else {
                    UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
                    [libraryAlert show];
                }
            }break;
            default:
                break;
        }
    }else{
        if (buttonIndex == 0) {
            NSUInteger index = [_pictureArray indexOfObject:deleteIV];
            [UIView animateWithDuration:0.3 animations:^{
                PhotoB.frame = ((UIImageView*)[_pictureArray lastObject]).frame;
                for (int i = _pictureArray.count-1; i > index ; i-- ) {
                    ((UIImageView*)_pictureArray[i]).frame = ((UIImageView*)_pictureArray[i-1]).frame;
                }
            }];
            [deleteIV removeFromSuperview];
            [_pictureArray removeObject:deleteIV];
            PhotoB.hidden = NO;
        }
    }
//    [self.dynamicTV becomeFirstResponder];
    
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (self.pictureArray == nil) {
        self.pictureArray = [[NSMutableArray alloc]init];
    }
    PhotoB.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:^{}];

    UIImage*selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView* imageV = [[UIImageView alloc]initWithFrame:PhotoB.frame];
    imageV.userInteractionEnabled = YES;
    imageV.image = selectImage;
    [self.view addSubview:imageV];
    if (PhotoB.frame.origin.x < 250) {
        PhotoB.frame = CGRectMake(PhotoB.frame.origin.x+ PhotoB.frame.size.width +12.875, PhotoB.frame.origin.y, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }else{
        PhotoB.frame = CGRectMake(13, 280.5, PhotoB.frame.size.width, PhotoB.frame.size.height);
    }
    [_pictureArray addObject:imageV];
    if (_pictureArray.count == 9) {
        PhotoB.hidden = YES;
    }
    UITapGestureRecognizer*tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [imageV addGestureRecognizer:tapGR];
//    [self.dynamicTV becomeFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

-(void)tapImage:(UIGestureRecognizer*)tapGR
{
    deleteIV = (UIImageView*)tapGR.view;
    self.deleteActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [_deleteActionSheet showInView:self.view];
}

#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length>2&&[[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length-2]]) {
        textView.text = [textView.text substringToIndex:textView.text.length-2];
    }
    if (textView.text.length>0 || text.length != 0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"今天想跟别人说点什么……";
    }
    if (textView.text.length>500)
    {
        textView.text=[textView.text substringToIndex:500];
    }
    return YES;
}

- (void)refreshZiLabelText
{
    NSInteger ziNum = m_maxZiShu - [[GameCommon shareGameCommon] unicodeLengthOfString:_dynamicTV.text];
    
    if(ziNum >= 0)
    {
        m_ziNumLabel.text = [NSString stringWithFormat:@"还可以输入%d字", ziNum];
        m_ziNumLabel.textColor = [UIColor grayColor];
    }
    else
    {
        m_ziNumLabel.text = [NSString stringWithFormat:@"已超过%d字", [[GameCommon shareGameCommon] unicodeLengthOfString:_dynamicTV.text] - m_maxZiShu];
        m_ziNumLabel.textColor = [UIColor redColor];
    }
}
#pragma mark - touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_dynamicTV resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
