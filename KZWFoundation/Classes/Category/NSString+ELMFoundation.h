//
//  NSString+ELMFoundation.h
//  ELMFoundation
//
//  Created by 0oneo on 6/2/15.
//  Copyright (c) 2015 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ELMFoundation)

+ (BOOL)elm_isBlank:(NSString *)string;

- (NSString *)elm_trim;

// JSON

- (NSDictionary *)elm_JSON;

- (NSString *)elm_URLEncodedString;

- (NSString *)elm_URLDecodedString;

- (NSString *)lpd_urlEncode;

- (NSString *)lpd_urlDecode;

- (NSString *)imageURL;

+ (NSString *)notRounding:(float)price afterPoint:(int)position;


@end
