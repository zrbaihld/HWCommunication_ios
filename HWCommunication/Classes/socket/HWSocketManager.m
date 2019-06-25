//
//  HWSocketManager.m
//  socketTest
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWSocketManager.h"
#import "HWChatMessageModel.h"

static HWSocketManager *instance = nil;
static SocketManager *manager =nil;

@interface HWSocketManager ()

@end
@implementation HWSocketManager
#pragma mark - init
+ (instancetype)shareManager {
    return [[HWSocketManager alloc] init];
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
    });
    return instance;
}

- (void)connect:(NSString*)uid connected:(void(^)(void))connected newMsg:(void (^)(NSArray* data, SocketAckEmitter* ack))newMsg{
    
    
    NSURL* url = [[NSURL alloc] initWithString:HW_SocketUrl];
    
    /**
     log 是否打印日志
     forceNew      这个参数设为NO从后台恢复到前台时总是重连，暂不清楚原因
     forcePolling  是否强制使用轮询
     reconnectAttempts 重连次数，-1表示一直重连
     reconnectWait 重连间隔时间
     connectParams 参数
     forceWebsockets 是否强制使用websocket, 解释The reason it uses polling first is because some firewalls/proxies block websockets. So polling lets socket.io work behind those.
     来源：https://github.com/socketio/socket.io-client-swift/issues/449
     */
    SocketIOClient* socket;
    SocketManager* manager;
    if (!self.client||!self.manager) {
        manager=[[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"forceNew" : @YES, @"forcePolling": @NO, @"reconnectAttempts":@(-1), @"reconnectWait" : @4}];
        
        socket = [manager defaultSocket];
    }
    else {
        connected();
        return;
    }
 
    
    // 连接超时时间设置为15秒
    [socket connectWithTimeoutAfter:15 withHandler:^{
        
        
    }];
    
   
    // 监听一次连接成功
    [socket on:@"connect" callback:^(NSArray * _Nonnull data, SocketAckEmitter * _Nonnull ack) {
        [HWLogger Log:@"hw socket connected"];
        extern NSString* hw_orgno;
        NSString* scoketUid=[[hw_orgno stringByAppendingString:@"_"] stringByAppendingString:uid];
        [socket emit:@"login" with:@[scoketUid]];
        connected();
    }];
    
    [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket currentAmount"];
    }];
    [socket on:@"connect_error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket connect_error"];
    }];
    [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket disconnect"];
    }];
    [socket on:@"reconnect_failed" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket reconnect_failed"];
    }];
    [socket on:@"ping" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket ping"];
    }];
    [socket on:@"error" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket error"];
    }];
    
    // 辉网监听
    [socket on:@"new_msg" callback:^(NSArray* data, SocketAckEmitter* ack) {
        newMsg(data,ack);
        [HWLogger Log:@"hw socket new_msg"];

    }];
    
    [socket on:@"update_online_count" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket update_online_count"];
    }];
    [socket on:@"user joined" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket user joined"];
    }];
    [socket on:@"user joined" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket user joined"];
    }];
    [socket on:@"user left" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket user left"];
    }];
    [socket on:@"typing" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket typing"];
    }];
    [socket on:@"stop typing" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [HWLogger Log:@"hw socket stop typing"];
    }];
    
   
    
  
    [socket connect];
    
    _client = socket;
    _manager = manager;
}



- (void)dealloc
{
    if (self.client) {
        [self.client off:@"connect"];
        [self.client off:@"currentAmount"];
        [self.client off:@"connect_error"];
        [self.client off:@"disconnect"];
        [self.client off:@"reconnect_failed"];
        [self.client off:@"ping"];
        [self.client off:@"error"];
        [self.client off:@"new_msg"];
        [self.client off:@"update_online_count"];
        [self.client off:@"user joined"];
        [self.client off:@"user joined"];
        [self.client off:@"user left"];
        [self.client off:@"typing"];
        [self.client off:@"stop typing"];
        
    }
}
@end





