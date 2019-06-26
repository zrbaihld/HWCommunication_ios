//
//  HWChatMessageModel.m
//  socketTest
//
//  Created by mac on 2019/6/17.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWChatMessageModel.h"
#import "HWEncryptionUtil.h"

@implementation HWChatMessageModel

-(NSString*)message{
    @try {
        return [HWEncryptionUtil getDecoderString:_message];
    } @catch (NSException *exception) {
        
    }
    return _message;
}



@end
