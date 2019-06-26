//
//  HWMediaUtils.m
//  socketTest
//
//  Created by mac on 2019/6/24.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWMediaUtils.h"



@interface HWMediaUtils()

@property (strong, nonatomic) AgoraRtcEngineKit *agoraKit;
@property (strong, nonatomic) NSString *appID;
@end

@implementation HWMediaUtils



- (instancetype)initWithKAPPID:(NSString*)appID{
    self = [super init];
    if (self) {
        self.appID=appID;
        [self initializeAgoraEngine];
    }
    return self;
}




// Tutorial Step 1
- (void)initializeAgoraEngine {
    NSString* appID=self.appID;
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appID delegate:self];
}

// Tutorial Step 2
- (void)setupVideo :(AgoraVideoEncoderConfiguration*)encoderConfiguration{
    [self.agoraKit enableVideo];
    // Default mode is disableVideo

    if (encoderConfiguration==nil){
        encoderConfiguration =
        [[AgoraVideoEncoderConfiguration alloc] initWithSize:AgoraVideoDimension640x360
                                                   frameRate:AgoraVideoFrameRateFps15
                                                     bitrate:AgoraVideoBitrateStandard
                                        orientationMode:AgoraVideoOutputOrientationModeAdaptative];
    }
    
   
    [self.agoraKit setVideoEncoderConfiguration:encoderConfiguration];
    [self setupLocalVideo];
}

// Tutorial Step 3
- (void)setupLocalVideo {
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    // UID = 0 means we let Agora pick a UID for us
    if(_mLocalView!=nil)
    videoCanvas.view = self->_mLocalView();
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupLocalVideo:videoCanvas];
    // Bind local video stream to view
}

// Tutorial Step 4
- (void)joinChannel :(NSString*)channelID{
    
    FLLog(@"joinChannel  ");
    FLLog(@"%@", channelID);
//    [HWLogger Log:channelID];
//    int uid=[[HWCommunication shareManager] mUid];
    NSInteger uid=0;
    @try {
        
         uid = [[HWUserDefault objectForKey:HW_UID] intValue];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
    [self.agoraKit joinChannelByToken:nil channelId:channelID info:nil uid:uid joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        // Join channel "demoChannel1"
        [self.agoraKit setEnableSpeakerphone:YES];
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }];
    // The UID database is maintained by your app to track which users joined which channels. If not assigned (or set to 0), the SDK will allocate one and returns it in joinSuccessBlock callback. The App needs to record and maintain the returned value as the SDK does not maintain it.
}

// Tutorial Step 5
- (void)rtcEngine:(AgoraRtcEngineKit *)engine firstRemoteVideoDecodedOfUid:(NSUInteger)uid size: (CGSize)size elapsed:(NSInteger)elapsed {
    if (_mRemoteVideo!=nil&&self->_mRemoteVideo().hidden)
        self->_mRemoteVideo().hidden = false;
    AgoraRtcVideoCanvas *videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = uid;
    // Since we are making a simple 1:1 video chat app, for simplicity sake, we are not storing the UIDs. You could use a mechanism such as an array to store the UIDs in a channel.
    
    videoCanvas.view = self->_mRemoteVideo();
    videoCanvas.renderMode = AgoraVideoRenderModeHidden;
    [self.agoraKit setupRemoteVideo:videoCanvas];
    // Bind remote video stream to view
    
    if (self->_mRemoteVideo!=nil&&self->_mRemoteVideo().hidden)
        self->_mRemoteVideo().hidden = false;
}

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didOccurError:(AgoraErrorCode)errorCode{
    [HWLogger Log:[NSString stringWithFormat:@"%ld",(long)errorCode]];
}

- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didOccurWarning:(AgoraWarningCode)warningCode{
     [HWLogger Log:[NSString stringWithFormat:@"%ld",(long)warningCode]];
}



- (void)dealloc
{
    [self leaveChannel];
}

- (void)leaveChannel {
    [self.agoraKit leaveChannel:^(AgoraChannelStats *stat) {

        [UIApplication sharedApplication].idleTimerDisabled = NO;
//        if (self) {
//            self.agoraKit = nil;
//        }
    }];
}




- (int)muteLocalAudioStream:(BOOL)mute{
    return [self.agoraKit muteLocalAudioStream:mute];
}

- (int)muteLocalVideoStream:(BOOL)mute{
      return [self.agoraKit muteLocalVideoStream:mute];
}


- (int)switchCamera{
    return [self.agoraKit switchCamera];
}


- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didJoinChannel:(NSString *_Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    if (_mUserJoinChannel!=nil) {
        _mUserJoinChannel([NSString stringWithFormat:@"%lu",(unsigned long)uid]);
    }
}
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didRejoinChannel:(NSString *_Nonnull)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed{
    if (_mReUserJoinChannel!=nil) {
        _mReUserJoinChannel([NSString stringWithFormat:@"%lu",(unsigned long)uid]);
    }
}
- (void)rtcEngine:(AgoraRtcEngineKit *_Nonnull)engine didOfflineOfUid:(NSUInteger)uid reason:(AgoraUserOfflineReason)reason{
    @try {
        if (self) {
            if (_mRemoteVideo!=nil) {
                _mRemoteVideo().hidden = true;
            }
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    if (_mUserLeavelChannel!=nil) {
        _mUserLeavelChannel([NSString stringWithFormat:@"%lu",(unsigned long)uid]);
    }
    
}

@end
