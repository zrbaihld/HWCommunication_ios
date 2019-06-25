//
//  Logger.h
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface HWLogger : NSObject
+ (void)LogResponse:(NSData *)data;
+(void)Log:(NSString*)msg;

@end

NS_ASSUME_NONNULL_END
