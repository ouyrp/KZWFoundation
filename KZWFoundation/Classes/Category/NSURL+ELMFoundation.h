//
//  NSURL+ELMFoundation.h
//  ELMFoundation
//
//  Created by Andy on 5/14/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ELMFoundation)

+ (NSString *)elm_queryStringFromParameters:(NSDictionary *)paramters;

- (NSURL *)URLByAppendingQueryString:(NSString *)queryString;

@end
