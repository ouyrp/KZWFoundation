//
//  ELMKeychainUtil.h
//  ELMFoundation
//
//  Created by 0oneo on 6/2/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ELMKeychainUtil : NSObject

+ (void)saveKeychainDict:(NSMutableDictionary *)dict;

+ (NSMutableDictionary *)keychainDict;

+ (NSString *)valueInKeyChainForKey:(NSString *)key;

+ (void)saveValueToKeyChain:(NSString *)value forKey:(NSString *)key;

+ (void)deleteAllInfoInKeyChain;

@end
