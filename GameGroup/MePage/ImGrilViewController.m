//
//  ImGrilViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-4.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "ImGrilViewController.h"

@interface ImGrilViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIScrollView * scV ;
    UIButton * button;
}
@property (nonatomic,retain)UIImage * upDataImage;
@end

@implementation ImGrilViewController

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
    // Do any additional setup after loading the view.
    scV = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scV];
    [self setTopViewWithTitle:@"妹子认证" withBackButton:YES];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 80, 75, 78);
    [button setBackgroundImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:button];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 300, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = @"请用手机拍摄一张举牌照";
    [scV addSubview:label];
    
    UIButton * referB = [[UIButton alloc]initWithFrame:CGRectMake(60, 210, 200, 40)];
    [referB setTitle:@"提交认证" forState:UIControlStateNormal];
    [referB setBackgroundImage:[UIImage imageNamed:@"btn_updata_normol"] forState:UIControlStateNormal];
    [referB setBackgroundImage:[UIImage imageNamed:@"btn_updata_click"] forState:UIControlStateHighlighted];
    [referB addTarget:self action:@selector(uploadImage) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:referB];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 320, 33)];
    image.image = [UIImage imageNamed:@"table_heard_bg"];
    [scV addSubview: image];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 266, 300, 20)];
    label1.backgroundColor = [UIColor clearColor];
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"注意事项";
    [scV addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 300, 300, 160)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor grayColor];
    label2.text = @"此照片只作系统自动审核使用,任何人无法查看,请放心上传.\n\n牌子上需写明您在陌游上的昵称,字迹要清晰!\n\n若是不想露脸,也要能够表示您是女孩子的身份才行哦.请参考如下举牌实例:";
    label2.numberOfLines = 0;
    label2.font = [UIFont boldSystemFontOfSize:16];
    [scV addSubview:label2];
    
    UIImageView * photo1 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 480, 171, 216)];
    photo1.image = [UIImage imageNamed:@"gril2"];
    [scV addSubview:photo1];
    UIImageView * photo2 = [[UIImageView alloc]initWithFrame:CGRectMake(75, 720, 171, 202)];
    photo2.image = [UIImage imageNamed:@"gril3"];
    [scV addSubview:photo2];
    
    scV.contentSize = CGSizeMake(320, 940);
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    hud.labelText = @"发送中...";
}
- (void)addPhoto
{
    UIActionSheet * action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"照相", nil];
    [action showInView:self.view];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * imagePicker;
    if (buttonIndex==1)
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
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
        }
        else {
            UIAlertView *libraryAlert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的设备不支持相册" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil];
            [libraryAlert show];
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [button setBackgroundImage:info[UIImagePickerControllerOriginalImage]  forState:UIControlStateNormal];
    self.upDataImage = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)uploadImage
{
    if (!self.upDataImage) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择上传的照片" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
        return;
    }
    hud.labelText = @"发送中...";
    [hud show:YES];
    [NetManager uploadGrilImage:self.upDataImage
        WithURLStr:BaseUploadImageUrl
        ImageName:@"1"
        TheController:self
                       Progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite){
                           hud.labelText = [NSString stringWithFormat:@"%.2f％",((double)totalBytesWritten/(double)totalBytesExpectedToWrite) * 100];
                       }
        Success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            NSLog(@"%@",responseObject);
            [self updateImGrilWithID:responseObject];
            
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            [hud hide:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"上传失败" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles:nil];
            [alert show];
        }];

}
- (void)updateImGrilWithID:(NSString*)imgID
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
    [params setObject:imgID forKey:@"img"];
    NSMutableDictionary* body = [[NSMutableDictionary alloc]init];
    [body addEntriesFromDictionary:[[GameCommon shareGameCommon] getNetCommomDic]];
    [body setObject:params forKey:@"params"];
    [body setObject:@"157" forKey:@"method"];
    [body setObject:[SFHFKeychainUtils getPasswordForUsername:LOCALTOKEN andServiceName:LOCALACCOUNT error:nil] forKey:@"token"];
    [NetManager requestWithURLStr:BaseClientUrl Parameters:body TheController:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        [self showMessageWindowWithContent:@"提交成功" imageType:0];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
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
