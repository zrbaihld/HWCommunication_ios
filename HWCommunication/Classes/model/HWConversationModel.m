//
//  HWConversationModel.m
//  socketTest
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWConversationModel.h"

@implementation HWConversationModel


- (void)setLatestMessage:(HWChatMessageModel*)latestMessage {

    self.currentTimeMillis = latestMessage.currentTimeMillis;
    self.latestMsgStr = latestMessage.message;

}

- (instancetype)initWithMessageModel:(HWChatMessageModel *)message conversationId:(NSString *)conversationId{
    if (self = [super init]) {

        self.latestMessage = message;
        self.conversationID = conversationId;
    }
    return self;
}


+ (NSString *)getMessageStrWithMessage:(HWChatMessageModel *)message {

    NSString *latestMsgStr;
    switch (message.messagetype) {
        case 0:
            latestMsgStr = message.message;
            break;

        case 4:
            latestMsgStr = @"[图片]";
            break;

        case 5:
            latestMsgStr = @"[文件]";
            break;

        default:
            latestMsgStr = @"错误";
            break;
    }
    return latestMsgStr;
}

@end
