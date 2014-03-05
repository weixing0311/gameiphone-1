//
//  SendArticleViewController.m
//  GameGroup
//
//  Created by Shen Yanping on 14-1-1.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "SendArticleViewController.h"
#import "Emoji.h"

@interface SendArticleViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MBProgressHUDDelegate, UITextFieldDelegate>
{
    UIButton* PhotoB;
    UIImageView* deleteIV;
}
@property (nonatomic,strong)UITextField* titleTV;

@property (nonatomic,strong)UITextView* dynamicTV;

@property (nonatomic,strong)UILabel* placeholderL;
@property (nonatomic,strong)NSMutableArray* pictureArray;
@property (nonatomic,strong)UIActionSheet* addActionSheet;
@property (nonatomic,strong)UIActionSheet* deleteActionSheet;
@property (nonatomic,strong)NSMutableString* imageId;

@end

@implementation SendArticleViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTopViewWithTitle:@"发表文章" withBackButton:YES];
    
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(320-42, KISHighVersion_7?27:7, 37, 30);
    [addButton setBackgroundImage:KUIImage(@"ok_normal") forState:UIControlStateNormal];
    [addButton setBackgroundImage:KUIImage(@"ok_click") forState:UIControlStateHighlighted];
    [self.view addSubview:addButton];
    [addButton addTarget:self action:@selector(saveMyArticle:) forControlEvents:UIControlEventTouchUpInside];
    [self setMainView];
}

- (void)setMainView
{
    UIImageView* titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5 + startX, 300, 35)];
    titleBg.image = KUIImage(@"text_bg");
    [self.view addSubview:titleBg];
    
    self.titleTV= [[UITextField alloc]initWithFrame:CGRectMake(13.75, 5+startX, 292.5,35)];
    self.titleTV.backgroundColor = [UIColor clearColor];
    self.titleTV.font = [UIFont systemFontOfSize:12];
    self.titleTV.delegate = self;
    self.titleTV.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.titleTV];
    [self.titleTV becomeFirstResponder];

    UIImage* bgImage = [[UIImage imageNamed:@"edit_bg"]
                        stretchableImageWithLeftCapWidth:0 topCapHeight:10];
    
    UIImageView* editIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45.75+startX, 300, 128)];
    editIV.image = bgImage;
    [self.view addSubview:editIV];
    
    self.dynamicTV = [[UITextView alloc]initWithFrame:CGRectMake(13.75, 45.75+startX, 292.5,128)];
    _dynamicTV.backgroundColor = [UIColor clearColor];
    _dynamicTV.font = [UIFont systemFontOfSize:13];
    _dynamicTV.delegate = self;
    [self.view addSubview:_dynamicTV];
    [self refreshTextState:YES];
    
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
    
    self.placeholderL = [[UILabel alloc]initWithFrame:CGRectMake(23, 5+startX, 200, 35)];
    _placeholderL.backgroundColor = [UIColor clearColor];
    _placeholderL.textColor = [UIColor grayColor];
    _placeholderL.text = @"标题……";
    _placeholderL.font = [UIFont systemFontOfSize:12.0];
    [self.view addSubview:_placeholderL];
    
    PhotoB = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoB.frame = CGRectMake(13, 200+startX, 48.5, 48.5);
    [PhotoB setBackgroundImage:[UIImage imageNamed:@"tianjiazhaopian"] forState:UIControlStateNormal];
    [PhotoB addTarget:self action:@selector(getAnActionSheet) forControlEvents:UIControlEventTouchUpInside];
    PhotoB.hidden = YES;
    [self.view addSubview:PhotoB];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.labelText = @"正在为您发布...";
}
#pragma mark 保存
- (void)saveMyArticle:(id)sender
{
    if (KISEmptyOrEnter(self.titleTV.text) || self.titleTV.text.length<3 || self.titleTV.text.length>40) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"写个标题吧，最少3个字，但是也不要超过40个字" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (_dynamicTV.text.length<4 || KISEmptyOrEnter(self.dynamicTV.text) || [_dynamicTV.text isEqualToString:@"说点什么吧..."]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不写点内容能行么，至少4个字吧" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [hud show:YES];
    [_titleTV resignFirstResponder];
    [_dynamicTV resignFirstResponder];
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

        [NetManager uploadImages:imageArray WithURLStr:BaseUploadImageUrl ImageName:nameArray TheController:self Progress:nil Success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {//上传图片
            [hud hide:YES];

            self.imageId = [[NSMutableString alloc]init];
            for (NSString*a in responseObject) {
                [_imageId appendFormat:@"%@,",[responseObject objectForKey:a]];
            }
            [self publishWithImageString:_imageId];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [hud hide:YES];

        }];
    }else
    {
        [self publishWithImageString:@""];
    }

}

-(void)publishWithImageString:(NSString*)imageID
{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSMutableDictionary * postDict = [NSMutableDictionary dictionary];
    
    [paramDict setObject:@"3" forKey:@"type"];
    [paramDict setObject:self.dynamicTV.text forKey:@"msg"];
    [paramDict setObject:imageID forKey:@"img"];
    [paramDict setObject:self.titleTV.text forKey:@"title"];
    
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
        [self showMessageWindowWithContent:@"成功" imageType:0];

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
    [self.dynamicTV becomeFirstResponder];
    
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
    [self.dynamicTV becomeFirstResponder];
    
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

#pragma mark textView delegate
- (void)refreshTextState:(BOOL)isPlace
{
    if (isPlace)
    {
        self.dynamicTV.textColor = kColorWithRGB(125.0, 125.0, 125.0, 1.0);
        self.dynamicTV.text = @"说点什么吧...";
    }
    else
    {
        self.dynamicTV.textColor = [UIColor blackColor];
        self.dynamicTV.text = @"";
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"说点什么吧..."])
    {
        [self refreshTextState:NO];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (KISEmptyOrEnter(textView.text) || [textView.text isEqualToString:@"说点什么吧..."])
    {
        [self refreshTextState:YES];
    }
}

#pragma mark - text field delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length>0 || string.length != 0) {
        _placeholderL.text = @"";
    }else{
        _placeholderL.text = @"标题……";
    }
    if (self.titleTV.text.length >= 40 && range.length == 0)//只允许输入40位
    {
        return  NO;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (KISEmptyOrEnter(textField.text)) {
        _placeholderL.text = @"标题……";
    }else{
        _placeholderL.text = @"";
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
