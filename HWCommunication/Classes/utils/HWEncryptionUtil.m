//
//  HWEncryptionUtil.m
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWEncryptionUtil.h"


@implementation HWEncryptionUtil

+ (id)encryption:(NSMutableDictionary *)parameters{
    NSMutableArray *keyList = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in parameters) {
        if (![HWEncryptionUtil stringIsEmpty:parameters[key]]) {
            [keyList addObject:key];
        }
    }
    NSArray* keyListSort = [keyList sortedArrayUsingSelector:@selector(compare:)];
    NSString* data=@"";
    for (NSString *key in keyListSort) {
       data= [data stringByAppendingString:[[NSString alloc] initWithString:[NSString stringWithFormat:@"%@=%@&",key,parameters[key]]]];
    }
    
   data= [data stringByAppendingString:[NSString stringWithFormat:@"key=%@",[HWUserDefault objectForKey:HW_KEY]]];
    
    NSString* sign=[[HWEncryptionUtil getmd5WithString:data] uppercaseString];
    [parameters setValue:sign forKey:@"sign"];
    return parameters;
}

+(Boolean)stringIsEmpty:(id)str{
    if (str==nil||str==NULL) {
        return true;
    }
    if ([str isKindOfClass:[NSNull class]] ) {
        return true;
    }
    if ([@"" isEqual:str]) {
        return true;
    }
//    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ) {
//        return true;
//    }
    return false;
}


+ (NSString*)getmd5WithString:(NSString *)string
{
    const char* original_str=[string UTF8String];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x", digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return [outPutStr lowercaseString];
}
+(NSString*)getEncodeString:(NSString *)string{
    
    NSString * charaters = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSCharacterSet * set = [[NSCharacterSet characterSetWithCharactersInString:charaters] invertedSet];

    NSString * hString2 = [string stringByAddingPercentEncodingWithAllowedCharacters:set];
//    hString2=[hString2 stringByReplacingOccurrencesOfString:@"+" withString:@"%20"];
    return hString2;
}
+(NSString*)getDecoderString:(NSString *)string{

    string=[string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    return [string stringByRemovingPercentEncoding];
}



@end
