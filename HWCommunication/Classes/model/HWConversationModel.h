//
//  HWConversationModel.h
//  socketTest
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HWChatMessageModel;



@interface HWConversationModel : NSObject

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, copy) NSString *latestMsgStr;
@property (nonatomic, assign) NSInteger unReadCount;
@property (nonatomic, assign)long long currentTimeMillis;

- (instancetype)initWithMessageModel:(HWChatMessageModel *)message conversationId:(NSString *)conversationId;
- (void)setLatestMessage:(HWChatMessageModel *)latestMessage;
+ (NSString *)getMessageStrWithMessage:(HWChatMessageModel *)message;
@end


