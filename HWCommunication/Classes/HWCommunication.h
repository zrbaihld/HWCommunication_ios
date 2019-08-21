//
//  HWCommunication.h
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
@class HWChatMessageModel;
@class HWMediaUtils;
@class HWChatMessageModel;
@class HWRequestUtil;
#import "HWNetWorkManager.h"
#import <AliyunOSSiOS/OSSService.h>

typedef void( ^ LoginSuccess)(id response);
typedef void( ^ LoginFaild)(id error);
typedef void( ^ NewMessage)(NSString* uid,NSString* message,NSString* msgId);
typedef void( ^ ApplyFriend)(NSString* uid,NSString* msgId);
typedef void( ^ ApplyFriendAgree)(NSString* uid,NSString* msgId);
typedef void( ^ ApplyFriendRefuce)(NSString* uid,NSString* msgId);
typedef void( ^ ApplyConnect)(NSString* type,NSString* uid,NSString* msgId);
typedef void( ^ RefuseConnectApply)(NSString* type,NSString* uid,NSString* msgId);
typedef Boolean( ^ ChatRoomNewMessageModel)(HWChatMessageModel* message);
typedef void( ^ UnLineMessageBackSuccess)(id response);
typedef void( ^ UnLineMessageBackFaild)(NSError* error);

typedef void( ^ DataBaseBack)(id data);
typedef UIView*( ^ GetLocalView)(void);


NS_ASSUME_NONNULL_BEGIN

@interface HWCommunication : NSObject
extern NSString* hw_key;
extern NSString* hw_orgno;

@property (nonatomic,copy)NSString* mPhone;
@property (nonatomic,copy)NSString* mUid;
@property (nonatomic,copy)NSString* mDataBaseName;

@property (nonatomic,copy)LoginSuccess mLoginSuccess;//登录成功回调
@property (nonatomic,copy)LoginFaild mLoginFaild;//登录失败
@property (nonatomic,copy)NewMessage mNewMessage;//有新消息回调
@property (nonatomic,copy)RefuseConnectApply mRefuseConnectApply;//拒绝连接请求回调
@property (nonatomic,copy)ApplyFriend mApplyFriend;//有好友发起申请
@property (nonatomic,copy)ApplyFriendAgree mApplyFriendAgree;//好友申请通过
@property (nonatomic,copy)ApplyFriendRefuce mApplyFriendRefuce;//好友申请拒绝
@property (nonatomic,copy)ApplyConnect mApplyConnect;//请求语音/视频聊天
@property (nonatomic,copy)ChatRoomNewMessageModel mChatRoomNewMessageModel;//聊天室中有新消息
@property (nonatomic,copy)UnLineMessageBackSuccess mUnLineMessageBackSuccess;//获取未读消息回调
@property (nonatomic,copy)UnLineMessageBackFaild mUnLineMessageBackFaild;//获取唯独消息失败回调

@property (nonatomic,copy)GetLocalView mLocalView;//本人视频展示VIEW
@property (nonatomic,copy)GetLocalView mRemoteVideo;//聊天视频对象VIEW

@property (nonatomic,strong)NSMutableDictionary* mSocketMessageList;


+ (instancetype)shareManager;//单例获取对象
+ (void)initConfig:(NSString*)baseUrl key:(NSString*)key_p orgno:(NSString*)orgno_p mCername:(NSString*)mCername;//初始化

-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid zone:(NSString*)zone;//登录 zone 为手机区号 默认是86
-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid;//登录

-(void)refuceConnect:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;//拒绝通讯 msgId 为通讯消息的id

-(void)getUnLineAllMessageList:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;//获取离线消息列表

-(void)getConversationList:(DataBaseBack)dataBack;//获取对话列表
-(void)getChatMessageByUid:(DataBaseBack)dataBack;//获取k聊天消息列表
-(void)getChatMessageByUid:(DataBaseBack)dataBack messageId:(NSString*)msgId;//通过uid 获取聊天消息列表

/**
 查询用户
 **/
-(void)queryUser:(NSString*)phone name:(NSString*)name withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 好友申请
 **/
-(void)applyUser:(NSString*)tuid memo:(NSString*)memo withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


/**
 是否同意好友申请
 **/
-(void)handlerUserApply:(NSString*)id isAgree:(Boolean)isAgree withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 获取离线消息
 **/
-(void)getOutLineMessage;
/**
 发送文本
 0文本 4 图片 5 文件
 **/
-(void)sendTextMessage:(NSString*)tuid message:(NSString*)message type:(int)type withSuccessBlock:(ChatRoomNewMessageModel)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 发送语音
 **/
-(void)sendVoiceMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 发起语音
 type 0语音 1视频
 **/
-(void)appalyVoice:(NSString*)tuid type:(NSString*)type config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
-(void)appalyVoice:(NSString*)tuid type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;
/**
 同意语音
 **/
-(void)agreeApplyVoice:(NSString*)id withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


///**
// 拒绝语音
// **/
//-(void)refuseApplyVoice:(NSString*)fuid uid:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


/**
 获取好友列表
 **/
-(void)getfriendlist:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 获取好友申请列表
 **/
-(void)getfriendapplylist:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 获取未读消息列表
 **/
-(void)getUnLineMessageList:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

/**
 删除好友
 **/
-(void)deletFriend:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;


-(void)uploadFile:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress;//上传文件

-(void)leaveChannel;//离开频道
- (int)switchCamera;//切换摄像头（前置/后置）
- (int)muteLocalAudioStream:(BOOL)mute;//视频开关
- (int)muteLocalVideoStream:(BOOL)mute;//音频开关
- (void)setDebug:(BOOL)debug;//是否开启调试模式的日志 （默认关闭）
- (void)joinChannel:(NSString*)msgID type:(NSString*)type;//加入频道
-(void)joinChannel:(NSString*)msgID type:(NSString*)type config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration;//加入频道 config 是配置文件
-(id)getLoginEntity;//获取登录返回的参数
-(NSString*)getPicBaseUrl;
-(OSSClient*)getOSSClient;
-(NSString*)getRoomName:uid;
NS_ASSUME_NONNULL_END
@end
