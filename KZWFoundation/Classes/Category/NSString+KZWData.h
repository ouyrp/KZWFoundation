//
//  NSString+KZWData.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/3/23.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (KZWData)

+ (NSString *)stringWithData:(NSInteger)time;

+ (NSString *)stringWithDay:(NSInteger)time;

+ (NSString *)stringWithHour:(NSInteger)time;

+ (NSString *)getCurrentTimestamp;

- (NSString *)md5;

- (NSString *)smsmd5;

- (NSString *)kzw_urlEncode;

- (NSString *)kzw_urlDecode;

+ (NSMutableAttributedString *)attWithString:(NSString *)string imageName:(NSString *)imageName;

+ (NSMutableAttributedString *)attWithString:(NSString *)string lastImageName:(NSString *)imageName;

+ (NSMutableAttributedString *)attWithString:(NSString *)string color:(UIColor *)color font:(CGFloat)font rang:(NSRange)rang;

- (BOOL)validateMobile;
- (BOOL)validateEmail;
- (BOOL)validatePassword;
- (BOOL)validateIdentityCard;
- (BOOL)validateBankCardNumCheck;
- (BOOL)validateTextField;
- (BOOL)validateMoney;

@end
