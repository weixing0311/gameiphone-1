//
//  NetManager.h
//  PetGroup
//
//  Created by Tolecen on 13-8-20.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kFailMessageKey @"failMessage"
#define kFailErrorCodeKey @"failErrorCode"
//联网

@interface NetManager : NSObject
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters TheController:(UIViewController *)controller success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
    failure:(void (^)(AFHTTPRequestOperation *operation, id error))failure;
+(void)requestWithURLStrNoController:(NSString *)urlStr Parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)requestWithURLStr:(NSString *)urlStr Parameters:(NSDictionary *)parameters TheController:(UIViewController *)controller success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;
+(void)downloadImageWithBaseURLStr:(NSString *)url ImageId:(NSString *)imgId success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
    failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;
//上传注册时头像
+(void)uploadImageWithRegister:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImage:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImageWithCompres:(UIImage *)uploadImage WithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName TheController:(UIViewController *)controller  Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImages:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary * responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadImagesWithCompres:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)uploadAudioFileData:(NSData *)audioData WithURLStr:(NSString *)urlStr AudioName:(NSString *)audioName TheController:(UIViewController *)controller Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)downloadAudioFileWithURL:(NSString *)downloadURL FileName:(NSString *)audioName TheController:(UIViewController *)controller Success:(void (^)(AFHTTPRequestOperation *operation,  id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
+(void)uploadWaterMarkImages:(NSArray *)imageArray WithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(UIImage*)compressImageDownToPhoneScreenSize:(UIImage*)theImage targetSizeX:(CGFloat) sizeX targetSizeY:(CGFloat) sizeY;
+ (UIImage *) image: (UIImage *) image centerInSize: (CGSize) viewsize;

//删除图片
+(void)deleteImageWithURLStr:(NSString *)urlStr ImageName:(NSString *)imageName TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+(void)deleteImagesWithURLStr:(NSString *)urlStr ImageName:(NSArray *)imageNameArray TheController:(UIViewController *)controller Progress:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))block Success:(void (^)(AFHTTPRequestOperation *operation,  NSDictionary *responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
