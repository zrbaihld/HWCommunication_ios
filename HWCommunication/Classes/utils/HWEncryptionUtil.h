//
//  HWEncryptionUtil.h
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#define FileHashDefaultChunkSizeForReadingData 1024*8 // 8K

NS_ASSUME_NONNULL_BEGIN

@interface HWEncryptionUtil : NSObject
+(id)encryption:(NSDictionary *)parameters;
+(NSString*)getmd5WithString:(NSString *)string;
+(NSString*)getEncodeString:(NSString *)string;//获取message加密以后文本
+(NSString*)getDecoderString:(NSString *)string;//获取message解密以后文本
/**
 *
 * 加密
 * originalString 原始字符串
 */
+(NSString *)encryptString:(NSString *) originalString;

/**
 *
 * 解密
 *
 * ciphertextString 加密字符串
 */
+(NSString *)decryptString:(NSString *) ciphertextString;


+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
