//
//  HWRequestUtil.h
//  socketTest
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HWRequestUtil : NSObject
/**
 查询用户
 **/
+(void)queryUser:(NSString*)phone name:(NSString*)name withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 好友申请
 **/
+(void)applyUser:(NSString*)fuid tuid:(NSString*)tuid memo:(NSString*)memo withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


/**
 是否同意好友申请
 **/
+(void)handlerUserApply:(NSString*)id isAgree:(Boolean)isAgree withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 发送文本
 **/
+(void)sendTextMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 发送语音
 **/
+(void)sendVoiceMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 发起语音
 **/
+(void)appalyVoice:(NSString*)fuid tuid:(NSString*)tuid type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 同意语音
 **/
+(void)agreeApplyVoice:(NSString*)id withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


/**
 拒绝语音
 **/
+(void)refuseApplyVoice:(NSString*)fuid uid:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 登陆
 **/
+(void)loginApi:(NSString*)phone name:(NSString*)name uid:(NSString*)uid zone:(NSString*)zone withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


/**
 获取好友列表
 **/
+(void)getfriendlist:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 获取好友申请列表
 **/
+(void)getfriendapplylist:(NSString*)uid  withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 获取未读消息列表
 **/
+(void)getUnLineMessageList:(NSString*)uid msgId:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 删除好友
 **/
+(void)deletFriend:(NSString*)uid fid:(NSString*)fid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

+(void)uploadFile:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress;

@end

NS_ASSUME_NONNULL_END
