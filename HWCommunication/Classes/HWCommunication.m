//
//  HWCommunication.m
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWCommunication.h"
#import "HWChatMessageModel.h"
#import "HWMediaUtils.h"


static HWCommunication *instance = nil;



@interface HWCommunication()
@property (strong,nonatomic)HWMediaUtils* mHWMediaUtil;
@end

@implementation HWCommunication

NSString *hw_key=nil;
NSString *hw_orgno=nil;

NSString* mPhone;
NSString* mUid;


+ (instancetype)shareManager {
    return [[HWCommunication alloc] init];
}

+ (void)initConfig:(NSString*)key_p orgno:(NSString*)orgno_p  {
    [HWUserDefault setObject:key_p forKey:HW_KEY];
    [HWUserDefault setObject:orgno_p forKey:HW_ORGNO];
    
    hw_key=key_p;
    hw_orgno=orgno_p;
}

- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
        
    });
    _mSocketMessageList=[NSMutableDictionary new];
    return instance;
}

-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid{
    [self login:phone name:name uid:uid zone:@"86"];
}

-(void)login:(NSString*)phone name:(NSString*)name uid:(NSString*)uid zone:(NSString*)zone{
    self.mPhone=phone;
    self.mUid=uid;
    self.mDataBaseName=[[hw_orgno stringByAppendingString:@"_"] stringByAppendingString:self.mUid];
    
    [[HWSocketManager shareManager] connect:uid connected:^{
        [HWRequestUtil loginApi:uid name:name uid:uid zone:zone withSuccessBlock:^(id response) {
            if(self.mLoginSuccess!=nil)
                self.mLoginSuccess(response);
        } withFailureBlock:^(NSError *error) {
            if(self.mLoginFaild!=nil)
                self.mLoginFaild(error);
        }];
        //todo
        NSString* msgId=[[HWDBManager shareManager] getLastMessageID];
        [self getUnLineMessageList:msgId withSuccessBlock:^(id response) {
            if (self->_mUnLineMessageBackSuccess!=nil) {
                self->_mUnLineMessageBackSuccess(response);
            }
           
           NSArray* unreadModes= response[@"data"];
            
//            {"status":1,"id":381,"message":"Ppp","uid":"1","messagetype":0,"createtime":"2019-06-21T11:00:10"}
      
            for (NSDictionary *messageStr in unreadModes) {
                HWChatMessageModel* messageModel=[HWChatMessageModel new];
                messageModel.direction=1;
                messageModel.msg_id=messageStr[@"id"];
                messageModel.message=messageStr[@"message"];
                 messageModel.uid=messageStr[@"uid"];
                messageModel.room=messageStr[@"uid"];
          
                NSNumber *type=messageStr[@"messagetype"];
                messageModel.messagetype=type==nil?0:type.intValue;
                messageModel.createtime=messageStr[@"createtime"];
                [[HWDBManager shareManager] addMessage:messageModel];
                [[HWDBManager shareManager] addOrUpdateConversationWithMessage:messageModel isChatting:false];
            }
            
        } withFailureBlock:^(NSError *error) {
            if (self->_mUnLineMessageBackFaild!=nil) {
                self->_mUnLineMessageBackFaild(error);
            }
        }];
    } newMsg:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        
        NSDictionary *message ;
        NSString *messageStr = data.firstObject;
        [HWLogger Log:messageStr];
        messageStr= [messageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        [HWLogger Log:messageStr];
        message=[self dictForJSONString:messageStr];
        NSDictionary *content = message[@"content"];
        [self->_mSocketMessageList setObject:content forKey:[NSString stringWithFormat:@"%@",content[@"id"]]];
        NSLog(@"%@", [self->_mSocketMessageList objectForKey:[NSString stringWithFormat:@"%@",content[@"id"]]]);
        
        
        if ([@"lineapply" isEqual:message[@"type"]]) {//linetype 0 语音 1视频
            if(self->_mApplyConnect!=nil)
            self->_mApplyConnect(content[@"linetype"],content[@"uid"],content[@"id"]);
        }else if([@"lineagree" isEqual:message[@"type"]]){
            //            self->_mApplyConnect(content[@"linetype"],content[@"uid"],content[@"id"]);
        }else if([@"linerefuse" isEqual:message[@"type"]]){
            if(self->_mRefuseConnectApply!=nil)
            self->_mRefuseConnectApply(content[@"linetype"],content[@"uid"],content[@"id"]);
        }else if([@"friendapply" isEqual:message[@"type"]]){
              if(self->_mApplyFriend!=nil)
            self->_mApplyFriend(content[@"uid"],content[@"id"]);
        }else if([@"friendagree" isEqual:message[@"type"]]){
                if(self->_mApplyFriendAgree!=nil)
            self->_mApplyFriendAgree(content[@"uid"],content[@"id"]);
        }else if([@"friendrefuse" isEqual:message[@"type"]]){
              if(self->_mApplyFriendRefuce!=nil)
            self->_mApplyFriendRefuce(content[@"uid"],content[@"id"]);
        }else if([@"messages" isEqual:message[@"type"]]){
            if(self->_mNewMessage!=nil)
                self->_mNewMessage(content[@"uid"],content[@"messages"],content[@"id"]);
            HWChatMessageModel *messageModel = [HWChatMessageModel yy_modelWithJSON:content];
            Boolean read=false;
            if(self->_mChatRoomNewMessageModel!=nil){
            read= self->_mChatRoomNewMessageModel(messageModel);
            }
          
            messageModel.read=read;
          
            messageModel.room=messageModel.uid;
            messageModel.fromUid=messageModel.uid;
            messageModel.msg_id=content[@"id"];
            messageModel.direction=1;
           
            messageModel.currentTimeMillis=[[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] longLongValue];
            
            [[HWDBManager shareManager] addMessage:messageModel];
             [[HWDBManager shareManager] addOrUpdateConversationWithMessage:messageModel isChatting:false];
          [self->_mSocketMessageList removeObjectForKey:[NSString stringWithFormat:@"%@",content[@"id"]]];
        }
    }
     ];
    
}

/**
 查询用户
 **/
-(void)queryUser:(NSString*)phone name:(NSString*)name withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil queryUser:phone name:name withSuccessBlock:successBlock withFailureBlock:failureBlock];
    
    
}



/**
 好友申请
 **/
-(void)applyUser:(NSString*)tuid memo:(NSString*)memo withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil applyUser:self.mUid tuid:tuid memo:memo withSuccessBlock:successBlock withFailureBlock:failureBlock];
}


/**
 是否同意好友申请
 **/
-(void)handlerUserApply:(NSString*)id isAgree:(Boolean)isAgree withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil handlerUserApply:id isAgree:isAgree withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 发送文本
 **/
-(void)sendTextMessage:(NSString*)tuid message:(NSString*)message type:(int)type withSuccessBlock:(ChatRoomNewMessageModel)successBlock withFailureBlock:(ResponseFail)failureBlock{
    
    
    [HWRequestUtil sendTextMessage:self.mUid tuid:tuid message:message type:[NSString stringWithFormat:@"%d",type] withSuccessBlock:^(id response){
        HWChatMessageModel *messageModel = [HWChatMessageModel new];
        messageModel.uid=tuid;
        messageModel.message=message;
        messageModel.msg_id=response[@"data"];
        messageModel.room=tuid;
        messageModel.currentTimeMillis=[[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] longLongValue];
        messageModel.direction=0;
        messageModel.read=0;
        messageModel.messagetype=type;
        [[HWDBManager shareManager] addMessage:messageModel];
        successBlock(messageModel);
        
        
    } withFailureBlock:failureBlock];
    
    
    
}

/**
 发送语音
 **/
-(void)sendVoiceMessage:(NSString*)fuid tuid:(NSString*)tuid message:(NSString*)message withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil sendVoiceMessage:fuid tuid:tuid message:message withSuccessBlock:successBlock withFailureBlock:failureBlock];
}
/**
 发起语音
 **/
-(void)appalyVoice:(NSString*)tuid type:(NSString*)type config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    
    [HWRequestUtil appalyVoice:self.mUid tuid:tuid type:type withSuccessBlock:^(id response) {
        
        if ([@"900" isEqual:response[@"status"]]) {
              [self joinCHannelRoom:response[@"data"][@"key"] type:type channel:response[@"data"][@"roomno"] config:encoderConfiguration];
        }
        successBlock(response);
    } withFailureBlock:failureBlock];
}
-(void)appalyVoice:(NSString*)tuid type:(NSString*)type withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [self appalyVoice:tuid type:type config:nil withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

-(void)leaveChannel{
    if (_mHWMediaUtil!=nil) {
           [self.mHWMediaUtil leaveChannel];
        _mHWMediaUtil=nil;
    }
 
}
- (int)switchCamera{
    if (_mHWMediaUtil!=nil) {
       return  [self.mHWMediaUtil switchCamera];
    }
    return -1;
}

- (int)muteLocalAudioStream:(BOOL)mute{
    if (_mHWMediaUtil!=nil) {
     return   [self.mHWMediaUtil muteLocalAudioStream:mute];
       
    }
      return -1;
}

- (int)muteLocalVideoStream:(BOOL)mute{
    if (_mHWMediaUtil!=nil) {
       return [self.mHWMediaUtil muteLocalVideoStream:mute];
        
    }
      return -1;
}


/**
 同意语音
 **/
-(void)agreeApplyVoice:(NSString*)id withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil agreeApplyVoice:id withSuccessBlock:successBlock withFailureBlock:failureBlock];
}


///**
// 拒绝语音
// **/
//-(void)refuseApplyVoice:(NSString*)fuid uid:(NSString*)uid withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
//    [HWRequestUtil refuseApplyVoice:fuid uid:uid withSuccessBlock:successBlock withFailureBlock:failureBlock];
//}


/**
 获取好友列表
 **/
-(void)getfriendlist:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil getfriendlist:self.mUid withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 获取好友申请列表
 **/
-(void)getfriendapplylist:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil getfriendapplylist:self.mUid withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 获取未读消息列表
 **/
-(void)getUnLineMessageList:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil getUnLineMessageList:self.mUid msgId:msgId withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

/**
 删除好友
 **/
-(void)deletFriend:(NSString*)uid  withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    [HWRequestUtil deletFriend:uid fid:self.mUid withSuccessBlock:successBlock withFailureBlock:failureBlock];
}

-(void)uploadFile:(NSDictionary *)parameters imageData:(NSData *)imageData withSuccessBlock:(ResponseSuccess)successBlock withFailurBlock:(ResponseFail)failureBlock withUpLoadProgress:(UploadProgress)progress{
    [HWRequestUtil uploadFile:parameters imageData:imageData withSuccessBlock:successBlock withFailurBlock:failureBlock withUpLoadProgress:progress];
}

-(void)refuceConnect:(NSString*)msgId withSuccessBlock:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    if (self->_mSocketMessageList==nil) {
        return;
    }
    NSString* msg_id=[NSString stringWithFormat:@"%@",msgId];
    NSDictionary* content=[self->_mSocketMessageList objectForKey:msg_id];
    if (content==nil) {
        return;
    }
    [HWRequestUtil refuseApplyVoice:content[@"roomno"] uid:content[@"uid"] withSuccessBlock:successBlock withFailureBlock:failureBlock];
      [self->_mSocketMessageList removeObjectForKey:msg_id];

}

-(void)getUnLineAllMessageList:(ResponseSuccess)successBlock withFailureBlock:(ResponseFail)failureBlock{
    
}

-(void)getConversationList:(DataBaseBack)dataBack{
    
}
-(void)getChatMessageByUid:(DataBaseBack)dataBack{
    
}
-(void)getChatMessageByUid:(DataBaseBack)dataBack messageId:(NSString*)msgId{
    
}

- (NSString*)stringINJSONFormatForObject:(id)obj
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0 // If that option is not set, the most compact possible JSON will be generated
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    return jsonString;
}

- (NSDictionary *)dictForJSONString:(NSString *)str
{
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    return dic;
}
- (void)setDebug:(BOOL)debug{
    [HWUserDefault setBool:debug forKey:HW_LOOGER_ISDEBUG];
}

- (void)joinChannel:(NSString*)msgID type:(NSString*)type{
    [self joinChannel:msgID type:type config:nil];
}

-(void)joinChannel:(NSString*)msgID type:(NSString*)type config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration{
    if (self->_mSocketMessageList==nil) {
        return;
    }
    NSString* msg_id=[NSString stringWithFormat:@"%@",msgID];
    NSDictionary* content=[self->_mSocketMessageList objectForKey:msg_id];
    if (content==nil) {
        return;
    }
    [self joinCHannelRoom:content[@"key"] type:type channel:content[@"roomno"] config:encoderConfiguration];
    
}

-(void)joinCHannelRoom:(NSString*)key type:(NSString*)type channel:(NSString*)channel config:(nullable AgoraVideoEncoderConfiguration*)encoderConfiguration{
    self.mHWMediaUtil=[[HWMediaUtils alloc] initWithKAPPID:key];
    if([@"0" isEqual:type]){
    }else{
        self.mHWMediaUtil.mLocalView = self->_mLocalView;
        self.mHWMediaUtil.mRemoteVideo  = self->_mRemoteVideo;
        [self.mHWMediaUtil setupVideo:encoderConfiguration];
    }
    [self.mHWMediaUtil joinChannel:channel];
}
@end
