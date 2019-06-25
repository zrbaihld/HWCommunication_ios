//
//  HWRequestUtil.m
//  socketTest
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWRequestUtil.h"
#import "HWNetWorkManager.h"

@implementation HWRequestUtil

/**
 查询用户
 **/
+(void)queryUser:(NSString*)phone name:(NSString*)name withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:phone forKey:@"phone"];
    [parameters setValue:name forKey:@"name"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_USER_QUERY_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
    
}
/**
 好友申请
 **/
+(void)applyUser:(NSString*)fuid tuid:(NSString*)tuid memo:(NSString*)memo withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:fuid forKey:@"fuid"];
    [parameters setValue:tuid forKey:@"tuid"];
    [parameters setValue:memo forKey:@"memo"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_APPLY_USER_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}


/**
 是否同意好友申请
 **/
+(void)handlerUserApply:(NSString*)msid isAgree:(Boolean)isAgree withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:[NSString stringWithFormat:@"%@",msid] forKey:@"id"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:isAgree?HW_APPLY_AGREE_URL:HW_APPLY_REFUSE_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 发送文本
 **/
+(void)sendTextMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:fuid forKey:@"fuid"];
    [parameters setValue:tuid forKey:@"tuid"];
    [parameters setValue:message forKey:@"message"];
    [parameters setValue:type forKey:@"type"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_SEND_TEXT_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 发送语音
 **/
+(void)sendVoiceMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:fuid forKey:@"fuid"];
    [parameters setValue:tuid forKey:@"tuid"];
    [parameters setValue:message forKey:@"message"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_SEND_VOID_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}
/**
 发起语音
 **/
+(void)appalyVoice:(NSString*)fuid tuid:(NSString*)tuid type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:fuid forKey:@"fuid"];
    [parameters setValue:tuid forKey:@"tuid"];
    [parameters setValue:type forKey:@"type"];
    
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_APPLY_VOID_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 同意语音
 **/
+(void)agreeApplyVoice:(NSString*)msgid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:msgid forKey:@"id"];
    
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_AGREE_VOID_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}


/**
 拒绝语音
 **/
+(void)refuseApplyVoice:(NSString*)roomno uid:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:roomno forKey:@"roomno"];
    [parameters setValue:uid forKey:@"uid"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_REFUSE_VOID_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];

}

/**
 登陆
 **/
+(void)loginApi:(NSString*)phone name:(NSString*)name uid:(NSString*)uid zone:(NSString*)zone withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:phone forKey:@"phone"];
    [parameters setValue:name forKey:@"name"];
    [parameters setValue:zone forKey:@"zone"];
    [parameters setValue:uid forKey:@"uid"];
    
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_LOGIN_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}


/**
 获取好友列表
 **/
+(void)getfriendlist:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:uid forKey:@"uid"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_GET_FRIEND_LIST_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 获取好友申请列表
 **/
+(void)getfriendapplylist:(NSString*)uid  withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:uid forKey:@"uid"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_GET_FRIENDAPPLY_LIST_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 获取未读消息列表
 **/
+(void)getUnLineMessageList:(NSString*)uid msgId:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:uid forKey:@"uid"];
    [parameters setValue:msgId forKey:@"id"];
    [parameters setValue:@"0" forKey:@"status"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_GET_UNLINE_MESSAGE_LIST_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 删除好友
 **/
+(void)deletFriend:(NSString*)uid fid:(NSString*)fid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] init];
    [parameters setValue:fid forKey:@"fid"];
    [parameters setValue:uid forKey:@"uid"];
    [HWNetWorkManager ba_requestWithType:Post withUrlString:HW_DELETE_FRIEND_URL withParameters:parameters withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

+(void)uploadFile:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress{
    
    
     [HWNetWorkManager ba_uploadImageWithUrlString:HW_UPLOAD_FILE parameters:parameters imageData:imageData withSuccessBlock:successBlock withFailurBlock:failureBlock withUpLoadProgress:progress];
}

@end
