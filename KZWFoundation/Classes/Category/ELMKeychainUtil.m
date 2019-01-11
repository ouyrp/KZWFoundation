//
//  ELMKeychainUtil.m
//  ELMFoundation
//
//  Created by 0oneo on 6/2/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import "ELMKeychainUtil.h"
#import <SAMKeychain/SAMKeychain.h>

static NSString *const ELEME_SERVICE_NAME = @"ElemeService";
static NSString *const ELEME_ACCOUNT_NAME = @"ElemeAccount";

@implementation ELMKeychainUtil

+ (void)saveKeychainDict:(NSMutableDictionary *)dict {
    [SAMKeychain setPassword:[dict description] forService:ELEME_SERVICE_NAME account:ELEME_ACCOUNT_NAME];
}

+ (NSMutableDictionary *)keychainDict {
    NSString *content = [SAMKeychain passwordForService:ELEME_SERVICE_NAME account:ELEME_ACCOUNT_NAME];
    if (content) {
        return [[content propertyList] mutableCopy];
    }
    return [NSMutableDictionary dictionary];
}

+ (NSString *)valueInKeyChainForKey:(NSString *)key {
    id value = [self keychainDict][key];
    if (value && [value isKindOfClass:[NSString class]] == NO) {
        return nil;
    }
    return value;
}

+ (void)saveValueToKeyChain:(NSString *)value forKey:(NSString *)key {
    NSMutableDictionary *keychainDict = [self keychainDict];
    if (value) {
        keychainDict[key] = value;
    } else {
        [keychainDict removeObjectForKey:key];
    }
    [self saveKeychainDict:keychainDict];
}

+ (void)deleteAllInfoInKeyChain {
    [self saveKeychainDict:[[NSMutableDictionary alloc] init]];
}

@end
