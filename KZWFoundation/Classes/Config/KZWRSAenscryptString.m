//
//  KZWRSAenscryptString.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/2/28.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWRSAenscryptString.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/Security.h>

@implementation KZWRSAenscryptString

+ (NSString *)signStr:(NSMutableDictionary *)dict {
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {

        if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![[dict objectForKey:categoryId] isEqualToString:@"sign"] && ![[dict objectForKey:categoryId] isEqualToString:@"key"]) {
            [contentString appendFormat:@"&%@=%@", categoryId, [dict objectForKey:categoryId]];
        }
    }
    NSString *string = [contentString substringFromIndex:1];
    //HMACMD5
    NSString *signStr = [KZWRSAenscryptString hmacsha1:string secret:@"kongzhong"];
    return signStr;
}

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {

    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];

    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];

    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);


    NSString *hash;

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)

        [output appendFormat:@"%02x", cHMAC[i]];

    hash = output;

    return hash;
}

+ (NSString *)dictionaryToJson:(NSDictionary *)dic {

    NSError *parseError = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
