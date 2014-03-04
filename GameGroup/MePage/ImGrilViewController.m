//
//  ImGrilViewController.m
//  GameGroup
//
//  Created by wangxr on 14-3-4.
//  Copyright (c) 2014年 Swallow. All rights reserved.
//

#import "ImGrilViewController.h"

@interface ImGrilViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView * scV ;
}
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
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 80, 75, 78);
    [button setBackgroundImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [scV addSubview:button];
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
            imagePicker.allowsEditing = NO;
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
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
