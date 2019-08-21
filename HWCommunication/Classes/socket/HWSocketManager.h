//
//  HWSocketManager.h
//  socketTest
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SocketIO;





NS_ASSUME_NONNULL_BEGIN

@interface HWSocketManager : UIView

@property (nonatomic, strong) SocketIOClient *client;

@property (nonatomic, strong) SocketManager *manager;

+ (instancetype)shareManager;
- (void)connect:socketUrl uid:(NSString*)uid connected:(void(^)(void))connected newMsg:(void(^)(NSArray* data, SocketAckEmitter* ack))newMsg;

@end

NS_ASSUME_NONNULL_END
