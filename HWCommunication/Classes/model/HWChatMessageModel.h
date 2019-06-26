//
//  HWChatMessageModel.h
//  socketTest
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>




@interface HWChatMessageModel : NSObject <YYModel>


@property (nonatomic, copy) NSString* msg_id;
@property (nonatomic, copy) NSString *fromUid;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *linetype;
@property (nonatomic, copy) NSString *roomno;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, assign) int messagetype;
@property (nonatomic, copy) NSString *room;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, assign) int direction;
@property (nonatomic, assign) int read;
@property (nonatomic, assign)long long currentTimeMillis;




@end


