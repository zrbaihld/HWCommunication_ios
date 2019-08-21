//
//  HWEncryptionUtil.m
//  socketTest
//
//  Created by mac on 2019/6/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "HWEncryptionUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

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


+(NSString *)encryptString:(NSString *)originalString{
    
    if (!originalString)
        return nil;
    SecKeyRef publicKey = [self getPublicKeyRef];
    size_t cipherBufferSize = SecKeyGetBlockSize(publicKey);
    uint8_t *cipherBuffer = malloc(cipherBufferSize);
    uint8_t *nonce = (uint8_t *) [originalString UTF8String];
    
    SecKeyEncrypt(publicKey,
                  kSecPaddingPKCS1,
                  nonce,
                  strlen((char *) nonce),
                  &cipherBuffer[0],
                  &cipherBufferSize);
    NSData *encryptedData = [NSData dataWithBytes:cipherBuffer length:cipherBufferSize];
    free(cipherBuffer);
    
    return [encryptedData base64EncodedStringWithOptions:0];
    
}

+(NSString *)decryptString:(NSString *)ciphertextString{
    
    
    return @"";
    ;
    
}

//获取公钥

+(SecKeyRef)getPublicKeyRef{
    
    NSString *bundlePath = [NSBundle bundleForClass:[self class]].resourcePath;
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *cerNameString= [HWUserDefault stringForKey:HW_CER_NAME];
    NSString * path =[resource_bundle.resourcePath
                      stringByAppendingPathComponent:cerNameString];
    
    NSData *certData = [NSData dataWithContentsOfFile:path];
    
    if (!certData) {
        return nil;
    }
    
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (CFDataRef)certData);
    
    SecKeyRef publicKey = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    publicKey = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    
    return publicKey;
}


NSString *const kInitVector = @"16-Bytes--String";
size_t const kKeySize = kCCKeySizeAES128;

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        NSData* data= [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
        return [HWEncryptionUtil hexStringFromData:data];
    }
    free(encryptedBytes);
    return nil;
}

+ (NSData *)decodeAES:(NSString *)content key:(NSString *)key {
     NSData *data = [HWEncryptionUtil dataForHexString:content];
    
//    NSMutableData *data = [NSMutableData dataWithCapacity:content.length/2.0];
//    unsigned char whole_bytes;
//    char byte_chars[3] = {'\0','\0','\0'};
//    int i;
//    for(i = 0 ; i < [content length]/2 ; i++)    {
//        byte_chars[0] = [content characterAtIndex:i * 2];
//        byte_chars[1] = [content characterAtIndex:i * 2 + 1];
//        whole_bytes = strtol(byte_chars, NULL, 16);
//        [data appendBytes:&whole_bytes length:1];
//    }
    
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, NULL, [data bytes], dataLength, buffer, bufferSize, &numBytesDecrypted);
    
    if(cryptStatus == kCCSuccess){
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    
    return nil;
    
}

// 普通字符串转换为十六进
+ (NSString *)hexStringFromData:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    // 下面是Byte 转换为16进制。
    NSString *hexStr = @"";
    for(int i=0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i] & 0xff]; //16进制数
        newHexStr = [newHexStr uppercaseString];
        
        if([newHexStr length] == 1) {
            newHexStr = [NSString stringWithFormat:@"0%@",newHexStr];
        }
        
        hexStr = [hexStr stringByAppendingString:newHexStr];
        
    }
    return hexStr;
}


//参考：http://blog.csdn.net/linux_zkf/article/details/17124577
//十六进制转Data
+ (NSData*)dataForHexString:(NSString*)hexString
{
    if (hexString == nil) {
        
        return nil;
    }
    
    const char* ch = [[hexString lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [NSMutableData data];
    while (*ch) {
        if (*ch == ' ') {
            continue;
        }
        char byte = 0;
        if ('0' <= *ch && *ch <= '9') {
            
            byte = *ch - '0';
        }else if ('a' <= *ch && *ch <= 'f') {
            
            byte = *ch - 'a' + 10;
        }else if ('A' <= *ch && *ch <= 'F') {
            
            byte = *ch - 'A' + 10;
            
        }
        
        ch++;
        
        byte = byte << 4;
        
        if (*ch) {
            
            if ('0' <= *ch && *ch <= '9') {
                
                byte += *ch - '0';
                
            } else if ('a' <= *ch && *ch <= 'f') {
                
                byte += *ch - 'a' + 10;
                
            }else if('A' <= *ch && *ch <= 'F'){
                
                byte += *ch - 'A' + 10;
                
            }
            
            ch++;
            
        }
        
        [data appendBytes:&byte length:1];
        
    }
    
    return data;
}

@end
