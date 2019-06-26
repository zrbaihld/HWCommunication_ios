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

@property (nonatomic,copy)LoginSuccess mLoginSuccess;
@property (nonatomic,copy)LoginFaild mLoginFaild;
@property (nonatomic,copy)NewMessage mNewMessage;
@property (nonatomic,copy)RefuseConnectApply mRefuseConnectApply;
@property (nonatomic,copy)ApplyFriend mApplyFriend;
@property (nonatomic,copy)ApplyFriendAgree mApplyFriendAgree;
@property (nonatomic,copy)ApplyFriendRefuce mApplyFriendRefuce;
@property (nonatomic,copy)ApplyConnect mApplyConnect;
@property (nonatomic,copy)ChatRoomNewMessageModel mChatRoomNewMessageModel;
@property (nonatomic,copy)UnLineMessageBackSuccess mUnLineMessageBackSuccess;
@property (nonatomic,copy)UnLineMessageBackFaild mUnLineMessageBackFaild;

@property (nonatomic,copy)GetLocalView mLocalView;
@property (nonatomic,copy)GetLocalView mRemoteVideo;

@property (nonatomic,strong)NSMutableDictionary* mSocketMessageList;


+ (instancetype)shareManager;
+ (void)initConfig:(NSString*)key_p orgno:(NSString*)orgno_p ;

-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid zone:(NSString*)zone;
-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid;

-(void)refuceConnect:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

-(void)getUnLineAllMessageList:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock;

-(void)getConversationList:(DataBaseBack)dataBack;
-(void)getChatMessageByUid:(DataBaseBack)dataBack;
-(void)getChatMessageByUid:(DataBaseBack)dataBack messageId:(NSString*)msgId;

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


-(void)uploadFile:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress;

-(void)leaveChannel;
- (int)switchCamera;
- (int)muteLocalAudioStream:(BOOL)mute;
- (int)muteLocalVideoStream:(BOOL)mute;
- (void)setDebug:(BOOL)debug;
- (void)joinChannel:(NSString*)msgID type:(NSString*)type;
-(void)joinChannel:(NSString*)msgID type:(NSString*)type config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration;
NS_ASSUME_NONNULL_END
@end
