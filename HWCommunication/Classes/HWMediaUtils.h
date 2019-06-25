//
//  HWMediaUtils.h
//  socketTest
//
//  Created by mac on 2019/6/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AgoraRtcEngineKit/AgoraRtcEngineKit.h>
typedef void( ^ UserJoinChannel)(NSString* uid);

typedef UIView*( ^ GetLocalView)(void);




@interface HWMediaUtils : NSObject<AgoraRtcEngineDelegate>
@property (nonatomic,copy)GetLocalView mLocalView;
@property (nonatomic,copy)GetLocalView mRemoteVideo;
@property (nonatomic,copy)UserJoinChannel mUserJoinChannel;
@property (nonatomic,copy)UserJoinChannel mReUserJoinChannel;
@property (nonatomic,copy)UserJoinChannel mUserLeavelChannel;

- (instancetype)initWithKAPPID:(NSString*)appID;
- (void)setupVideo :(AgoraVideoEncoderConfiguration*)encoderConfiguration;
- (void)joinChannel :(NSString*)channelID;
- (int)muteLocalAudioStream:(BOOL)mute;
- (int)muteLocalVideoStream:(BOOL)mute;
- (int)switchCamera;
- (void)leaveChannel;
@end

