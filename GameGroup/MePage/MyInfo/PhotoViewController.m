//
//  PhotoViewController.m
//  PetGroup
//
//  Created by 阿铛 on 13-9-4.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import "PhotoViewController.h"
#import "EGOImageView.h"

@interface PhotoViewController ()<UIScrollViewDelegate,UIActionSheetDelegate,EGOImageViewDelegate>
@property (nonatomic,retain)UIScrollView* sc;
@property (nonatomic,retain)UIImage* myimage;
@property (nonatomic,retain)NSArray* smallImageArray;
@end

@implementation PhotoViewController
- (id)initWithSmallImages:(NSArray*)sImages images:(NSArray*)images indext:(int)indext
{
    self = [super init];
    if (self) {
        self.smallImageArray = sImages;
        self.imgIDArray = images;
        self.indext = indext;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    _sc.backgroundColor = [UIColor blackColor];
    _sc.pagingEnabled=YES;
    _sc.showsHorizontalScrollIndicator=NO;
    _sc.showsVerticalScrollIndicator=NO;
    _sc.bounces = NO;
    _sc.contentOffset = CGPointMake(self.indext*320, 0);
    _sc.contentSize = CGSizeMake(320*self.imgIDArray.count, _sc.frame.size.height);
    [self.view addSubview:_sc];
    
    UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
    tapOne.numberOfTapsRequired = 1;
    [_sc addGestureRecognizer:tapOne];

    for (int i = 0;i < self.imgIDArray.count;i++) {
        UIScrollView * subSC = [[UIScrollView alloc]initWithFrame:CGRectMake(i*320, 0, 320, _sc.frame.size.height)];
        EGOImageView* imageV = [[EGOImageView alloc]initWithFrame:CGRectMake(110,(_sc.frame.size.height-100)/2 , 100, 100)];
        imageV.placeholderImage = _smallImageArray[i];
        [subSC addSubview:imageV];
        imageV.userInteractionEnabled = YES;
        UIActivityIndicatorView*act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((_sc.frame.size.width-10)/2, (_sc.frame.size.height-10)/2, 10, 10)];
        [act startAnimating];
        [subSC addSubview:act];
        imageV.delegate = self;
        NSRange range=[self.imgIDArray[i] rangeOfString:@"<local>"];
        if (self.isComeFrmeUrl ==NO) {
         if (range.location!=NSNotFound) {
            //        self.viewPhoto.image =
            NSString *path = [RootDocPath stringByAppendingPathComponent:@"tempImage"];
            NSString  *openImgPath = [NSString stringWithFormat:@"%@/%@",path,[self.imgIDArray[i] substringFromIndex:7]];
            NSData * nsData= [NSData dataWithContentsOfFile:openImgPath];
            UIImage * openPic= [UIImage imageWithData:nsData];
            imageV.image = openPic;
            [self imageViewLoadedImage:imageV];
        }
        else
            imageV.imageURL = [NSURL URLWithString:[NSString stringWithFormat:BaseImageUrl"%@",self.imgIDArray[i]]];
//            self.viewPhoto.imageURL = [NSURL URLWithString:url];
        
        }
        else{
            imageV.imageURL = [NSURL URLWithString:self.imgIDArray[i]];

        }
        subSC.maximumZoomScale = 2.0;
        subSC.bouncesZoom = NO;
        subSC.delegate = self;
        [_sc addSubview:subSC];
        
//        UITapGestureRecognizer* tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
//        tapOne.numberOfTapsRequired = 1;
//        [imageV addGestureRecognizer:tapOne];

//        UITapGestureRecognizer* tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTwo:)];
//        tapTwo.numberOfTapsRequired = 2;
//        [imageV addGestureRecognizer:tapTwo];
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [imageV addGestureRecognizer:longPress];
        
//        [tapOne requireGestureRecognizerToFail:tapTwo];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tapOne:(UITapGestureRecognizer*)tap
{
    self.view.userInteractionEnabled = NO;
    int a = _sc.contentOffset.x/320;
    [UIView animateWithDuration:0.2 animations:^{
        ((UIView*)((UIView*)_sc.subviews[a]).subviews[0]).frame = CGRectMake(160,_sc.frame.size.height/2,0,0);
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

-(void)tapTwo:(UITapGestureRecognizer*)tap
{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(desappear) object:nil];
    UIScrollView*subSC = (UIScrollView*)tap.view.superview;
    CGPoint touchPoint = [tap locationInView:tap.view];
    if (subSC.contentSize.width>639) {
        [subSC setZoomScale:1 animated:YES];
    }else{
        [subSC zoomToRect:CGRectMake(touchPoint.x, touchPoint.y, 1, 1) animated:YES];
    }
}
-(void)longPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.myimage = ((EGOImageView*)longPress.view).image;
        UIActionSheet* act = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles: @"保存",nil];
        [act showInView:longPress.view];
    }
}
#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        UIImageWriteToSavedPhotosAlbum(self.myimage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    self.myimage = nil;
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败,请允许本应用访问您的相册";
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
    [alert show];
}
#pragma mark - scrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
// return a view that will be scaled. if delegate returns nil, nothing happens
{
    if (scrollView == _sc) {
        return nil;
    }
    return [scrollView.subviews objectAtIndex:0];
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize size = ((UIView*)scrollView.subviews[0]).frame.size;
    if (scrollView.frame.size.height>size.height) {
        ((UIView*)scrollView.subviews[0]).frame = CGRectMake(0, (scrollView.frame.size.height-size.height)/2, size.width, size.height);
    }
}
#pragma mark - EGOImageView delegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    float a = 0.0;
    CGSize size = imageView.image.size;
    if (320*size.height/size.width<_sc.frame.size.height) {
        a = (_sc.frame.size.height-320*size.height/size.width)/2;
    }
//    imageView.frame = CGRectMake(160,_sc.frame.size.height/2,0,0);
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = CGRectMake(0, a, 320, 320*size.height/size.width);
    }];
    [((UIActivityIndicatorView*)imageView.superview.subviews[1]) stopAnimating];
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error
{
    //未完待续
    [self dismissViewControllerAnimated:NO completion:^{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"图片加载失败" delegate:nil cancelButtonTitle:@"知道啦" otherButtonTitles: nil];
        [alert show];
    }];
}
@end
