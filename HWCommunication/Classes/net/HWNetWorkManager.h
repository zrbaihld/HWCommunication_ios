//
//  HWNetWorkManager.h
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>


/*！定义请求类型的枚举 */
typedef NS_ENUM(NSUInteger, HttpRequestType)
{
    /*! get请求 */
    Get = 0,
    /*! post请求 */
    Post
    
};

/*! 使用枚举NS_ENUM:区别可判断编译器是否支持新式枚举,支持就使用新的,否则使用旧的 */
typedef NS_ENUM(NSUInteger, NetworkStatus)
{
    /*! 未知网络 */
    NetworkStatusUnknown           = 0,
    /*! 没有网络 */
    NetworkStatusNotReachable,
    /*! 手机自带网络 */
    NetworkStatusReachableViaWWAN,
    /*! wifi */
    NetworkStatusReachableViaWiFi
};


/*! 定义请求成功的block */
typedef void( ^ ResponseSuccess)(id response);
/*! 定义请求失败的block */
typedef void( ^ ResponseFail)(NSError *error);

/*! 定义上传进度block */
typedef void( ^ UploadProgress)(int64_t bytesProgress,
                                int64_t totalBytesProgress);
/*! 定义下载进度block */
typedef void( ^ DownloadProgress)(CGFloat);

@interface HWNetWorkManager : NSObject

/*! 获取当前网络状态 */
@property (nonatomic, assign) NetworkStatus  netWorkStatus;
+ (instancetype)shareManager ;
/*!
 *  网络请求方法,block回调
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param parameters    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */
+ (NSURLSessionTask *)ba_requestWithType:(HttpRequestType)type
                           withUrlString:(NSString *)urlString
                          withParameters:(NSDictionary *)parameters
                        withSuccessBlock:(ResponseSuccess)successBlock
                        withFailureBlock:(ResponseFail)failureBlock;

#pragma mark - 图片上传
- (void)ba_uploadImageWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress;
+ (NSURLSessionTask *)ba_uploadImageWithUrlString2:(NSString *)urlString parameters:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress;
#pragma mark - 文件下载
+ (NSURLSessionDownloadTask *)downLoadWithUrl:(NSString *)url progress:(DownloadProgress)progress success:(ResponseSuccess)success fail:(ResponseFail)fail;

@end

