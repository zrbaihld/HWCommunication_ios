//
//  HWDBManager.m
//  socketTest
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019年 mac. All rights reserved.
//


#import "HWDBManager.h"
#import "HWConversationModel.h"
#import "HWChatMessageModel.h"



//#import "FLChatViewController.h"
static HWDBManager *instance = nil;

@interface HWDBManager ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *DBQueue;

@end
@implementation HWDBManager

#pragma mark - Lazy
- (FMDatabaseQueue *)DBQueue {
    NSString *dbName = [NSString stringWithFormat:@"%@.db", [HWUserDefault objectForKey:HW_DATABASE]];
    
    NSString *path = _DBQueue.path;
    if (!_DBQueue || ![path containsString:dbName]) {
        NSString *tablePath = [[self DBMianPath] stringByAppendingPathComponent:dbName];
        
        _DBQueue = [FMDatabaseQueue databaseQueueWithPath:tablePath];
        [_DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
            
            // 打开数据库
            if ([db open]) {
                
                // 会话数据库表
                BOOL success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS conversation (id TEXT NOT NULL, type INT1, ext TEXT, unreadcount Integer, latestmsgtext TEXT, latestmsgtimestamp INT32)"];
                if (success) {
                    FLLog(@"创建会话表成功");
                }
                else {
                    FLLog(@"创建会话表失败");
                }
                
                // 消息数据表
                BOOL msgSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS message (id TEXT NOT NULL, currentTimeMillis INT32, conversation TEXT, msgdirection INT1, messagetype INT1, message TEXT, read INT1, fromUid TEXT, phone TEXT, name TEXT, uid TEXT)"];
                if (msgSuccess) {
                    FLLog(@"创建消息表成功");
                }
                else {
                    FLLog(@"创建消息表失败");
                }
                
            }
        }];
    }
    return _DBQueue;
    //    return nil;
}
#pragma mark - init
+ (instancetype)shareManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super init];
    });
    return instance;
}


#pragma mark - Private
- (NSString *)DBMianPath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    FLLog(@"%@======", NSHomeDirectory());
    //    path = @"/Users/fengli/Desktop";
    path = [path stringByAppendingPathComponent:@"FLChatDB"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = false;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    if (!(isDir && isDirExist)) {
        
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (bCreateDir) {
            
            FLLog(@"文件路径创建成功");
        }
    }
    return path;
    
}


/**
 查询会话再数据库是否存在
 
 @param conversationId 会话的ID
 @param exist 是否存在，且返回db以便下步操作
 */
- (void)conversation:(NSString *)conversationId isExist:(void(^)(BOOL isExist, FMDatabase *db, NSInteger unReadCount))exist{
    
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        BOOL e = NO;
        NSInteger unreadCount = 0;
        FMResultSet *result = [db executeQuery:@"SELECT * FROM conversation WHERE id = ?", conversationId];
        while (result.next) {
            e = YES;
            unreadCount = [result intForColumnIndex:3];
            break;
        }
        exist(e, db, unreadCount);
    }];
    
}

- (void)message:(HWChatMessageModel *)message baseId:(BOOL)baseId isExist:(void(^)(BOOL isExist, FMDatabase *db))exist {
    
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        BOOL e = NO;
        //        if (!message.msg_id.length) {
        //            exist(NO, db);
        //            return ;
        //        }
        FMResultSet *result;
        if (baseId) {  // 基于消息ID查询
            result = [db executeQuery:@"SELECT * FROM message WHERE id = ?", message.msg_id];
        }
        else {  // 基于消息发送的本地时间查询
            result = [db executeQuery:@"SELECT * FROM message WHERE localtime = ?", @(message.currentTimeMillis)];
        }
        
        while (result.next) {
            
            e = YES;
            break;
        }
        exist(e, db);
    }];
}

- (void)creatMessagesListTable {
    
    
    if ([self.db open]) {
        
        
    }
    else {
        FLLog(@"数据库打开失败");
    }
}

- (HWChatMessageModel *)makeMessageWithFMResult:(FMResultSet *)result {
    
    NSString *msgId = [result stringForColumnIndex:0];
    int currentTimeMillis = [result intForColumnIndex:1];
    NSString *conversation = [result stringForColumnIndex:2];
    int msgdirection = [result intForColumnIndex:3];
    int messagetype = [result intForColumnIndex:4];
    NSString *message = [result stringForColumnIndex:5];
    int read = [result intForColumnIndex:6];
    NSString *fromUid = [result stringForColumnIndex:7];
    NSString *phone = [result stringForColumnIndex:8];
    NSString *name = [result stringForColumnIndex:9];
    NSString *uid = [result stringForColumnIndex:10];
    
    HWChatMessageModel *messageModel = [[HWChatMessageModel alloc] init];
    messageModel.msg_id=msgId;
    messageModel.currentTimeMillis=currentTimeMillis;
    messageModel.room=conversation;
    messageModel.direction=msgdirection;
    messageModel.messagetype=messagetype;
    messageModel.message=message;
    messageModel.read=read;
    messageModel.fromUid=fromUid;
    messageModel.phone=phone;
    messageModel.name=name;
    messageModel.uid=uid;

    return messageModel;
}

#pragma mark - Public

- (NSArray<HWConversationModel *> *)queryAllConversations {
    
    NSMutableArray *conversations = [NSMutableArray array];
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        
        FMResultSet *result = [db executeQuery:@"SELECT * FROM conversation"];
        while (result.next) {
            HWConversationModel *conversation = [[HWConversationModel alloc] init];
//            CREATE TABLE IF NOT EXISTS conversation (id TEXT NOT NULL, type INT1, ext TEXT, unreadcount Integer, latestmsgtext TEXT, latestmsgtimestamp INT32)
                        conversation.conversationID = [result stringForColumnIndex:0];
                        conversation.unReadCount = [result intForColumnIndex:3];
                        conversation.latestMsgStr = [result stringForColumnIndex:4];
                        conversation.currentTimeMillis = [result longLongIntForColumnIndex:5];
            [conversations addObject:conversation];
        }
    }];
    return conversations;
}


- (void)addMessage:(HWChatMessageModel *)message {
    
    [self message:message baseId:YES isExist:^(BOOL isExist, FMDatabase *db) {
        
//         判断再数据库中不存在再插入消息
                if (!isExist) {
                    NSString *msgId = message.msg_id?message.msg_id:@"";
//                    @"CREATE TABLE IF NOT EXISTS message (id TEXT NOT NULL, currentTimeMillis INT32, conversation TEXT, msgdirection INT1, messagetype INT1, message TEXT, read INT1, fromUid TEXT, phone TEXT, name TEXT, uid TEXT)"
                    NSNumber* currentTimeMillis=[NSNumber numberWithLongLong:message.currentTimeMillis];
                        NSNumber* msgdirection=[NSNumber numberWithLongLong:message.direction];
                     NSNumber* messagetype=[NSNumber numberWithLongLong:message.messagetype];
                     NSNumber* read=[NSNumber numberWithLongLong:message.read];
                    [db executeUpdate:@"INSERT INTO message (id, currentTimeMillis, conversation, msgdirection, messagetype, message, read, fromUid,phone,name,uid) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?,?)", msgId, currentTimeMillis,message.room, msgdirection,messagetype, message.message, read, message.fromUid,message.phone,message.name,message.uid];
                }
//    [db executeUpdate:@"INSERT INTO message (id, localtime, timestamp, conversation, msgdirection, chattype, bodies, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", msgId, locTime,time, isSender?message.to:message.from, isSender?@1:@0, @"chat", bodies, status];
        
    }];
}

- (void)updateMessage:(HWChatMessageModel *)message {

    [self message:message baseId:NO  isExist:^(BOOL isExist, FMDatabase *db) {

        if (isExist) {

            [db executeUpdate:@"UPDATE message SET id = ?, currentTimeMillis = ?, message = ? WHERE currentTimeMillis = ?", message.msg_id, @(message.currentTimeMillis), [message.message yy_modelToJSONString],@(message.currentTimeMillis)];
        }

    }];
}

- (NSArray<HWChatMessageModel *> *)queryMessagesWithUser:(NSString *)userName {
    
    return [self queryMessagesWithUser:userName limit:10000 page:0];
}

- (NSArray<HWChatMessageModel *> *)queryMessagesWithUser:(NSString *)userName limit:(NSInteger)limit page:(NSInteger)page {
    
    if (limit <= 0) {
        return nil;
    }
    
        NSMutableArray *messages = [NSMutableArray array];
        [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
    
            NSDate *date = [NSDate date];
            NSNumber *timeStamp = [NSNumber numberWithLongLong:[date timeIntervalSince1970]* 1000];
            FMResultSet *result = [db executeQuery:@"SELECT * FROM (SELECT * FROM message WHERE conversation = ? AND currentTimeMillis < ? ORDER BY currentTimeMillis DESC LIMIT ? OFFSET ?) ORDER BY currentTimeMillis ASC", userName, timeStamp, @(limit), @(limit*page)];
            while (result.next) {
    
    
                HWChatMessageModel *message = [self makeMessageWithFMResult:result];
                [messages addObject:message];
            }
        }];
    
    
        // 数组倒序
        for (NSInteger index = 0; index < messages.count / 2; index++) {
            [messages exchangeObjectAtIndex:index withObjectAtIndex:messages.count - index - 1];
        }
    
        [messages sortUsingComparator:^NSComparisonResult(HWChatMessageModel * _Nonnull obj1, HWChatMessageModel *  _Nonnull obj2) {
    
            if (obj1.currentTimeMillis > obj2.currentTimeMillis) {
                return NSOrderedDescending;
            }
            else if (obj1.currentTimeMillis < obj2.currentTimeMillis) {
    
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        return messages;
    return nil;
    
}


- (void)updateLatestMessageOfConversation:(HWConversationModel *)conversation andMessage:(HWChatMessageModel *)message {

    if (!message.msg_id) {
        return;
    }

    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {

        BOOL success = [db executeUpdate:@"UPDATE conversation SET latestmsgid = ? WHERE id = ?", message.msg_id, conversation.conversationID];

        if (success) {
            FLLog(@"更新成功");
        }
        else {
            FLLog(@"更新失败");
        }
    }];
}


- (void)addOrUpdateConversationWithMessage:(HWChatMessageModel *)message isChatting:(BOOL)isChatting{
    
        if (!message) {
            FLLog(@"message为空");
            return;
        }
    
        // 最新消息字符
        NSString *latestMsgStr = [HWConversationModel getMessageStrWithMessage:message];
        // 会话是否开启
        [self conversation:message.room isExist:^(BOOL isExist, FMDatabase *db, NSInteger unreadCount) {
    
            // 判断不存在再插入数据库
            if (!isExist) {
    
                HWConversationModel *conversation = [[HWConversationModel alloc] initWithMessageModel:message conversationId:message.room];
                conversation.unReadCount = isChatting ? 0 : 1;
                NSInteger unreadCount = conversation.unReadCount;
                [db executeUpdate:@"INSERT INTO conversation (id, unreadcount, latestmsgtext, latestmsgtimestamp) VALUES (?, ?, ?, ?)", conversation.conversationID, @(unreadCount), latestMsgStr, @(message.currentTimeMillis)];
    
            }
            else {  // 如果已经存在，更新最后一条消息
    
                unreadCount = isChatting ? 0 : (unreadCount + 1);
                BOOL success = [db executeUpdate:@"UPDATE conversation SET latestmsgtext = ?, unreadcount = ?,latestmsgtimestamp = ?  WHERE id = ?", latestMsgStr, @(unreadCount), @(message.currentTimeMillis), message.room];
    
                if (success) {
                    FLLog(@"更新成功");
                }
                else {
                    FLLog(@"更新失败");
                }
            }
        }];
}

- (void)updateUnreadCountOfConversation:(NSString *)conversationName unreadCount:(NSInteger)unreadCount{
    
    [self conversation:conversationName isExist:^(BOOL isExist, FMDatabase *db, NSInteger unReadCount) {
        
        if (isExist) {
             NSNumber* unreadCountNs=[NSNumber numberWithLongLong:unreadCount];
            BOOL success = [db executeUpdate:@"UPDATE conversation SET unreadcount = ? WHERE id = ?", unreadCountNs,conversationName];
            
            if (success) {
                FLLog(@"更新成功");
            }
            else {
                FLLog(@"更新失败");
            }
        }
    }];
}
-(NSString*)getLastMessageID{
   
    NSString* msgId=@"";
    NSMutableArray* ids=[NSMutableArray new];
    [self.DBQueue inDatabase:^(FMDatabase * _Nonnull db) {
        @try {
            FMResultSet *result = [db executeQuery:@"SELECT * FROM message ORDER BY id ASC LIMIT 1"];
            while (result.next) {
                HWChatMessageModel *message = [self makeMessageWithFMResult:result];
                [ids setObject:message.msg_id atIndexedSubscript:0];
            }
        } @catch (NSException *exception) {
            
        }
    }];
    if (ids.count>0) {
        return ids[0];
    }
      return msgId;

}
@end
