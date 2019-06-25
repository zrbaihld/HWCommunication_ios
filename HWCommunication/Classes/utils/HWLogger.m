//
//  Logger.m
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWLogger.h"


@implementation HWLogger


+ (void)Log:(NSString *)msg{
    bool isDebug=[HWUserDefault boolForKey:HW_LOOGER_ISDEBUG];
    if (isDebug) {
        NSLog(@"%@", msg);
    }
}
+ (void)LogResponse:(NSData *)data{
    bool isDebug=[HWUserDefault boolForKey:HW_LOOGER_ISDEBUG];
    if (isDebug) {
        NSLog(@"%@", [self returnDictionaryWithDataPath:data]);
    }
}
+(NSString*)returnDictionaryWithDataPath:(id)obj
{

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0 // If that option is not set, the most compact possible JSON will be generated
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    return jsonString;
}


@end
