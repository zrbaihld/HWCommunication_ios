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
+(NSString*)getEncodeString:(NSString *)string;
+(NSString*)getDecoderString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
