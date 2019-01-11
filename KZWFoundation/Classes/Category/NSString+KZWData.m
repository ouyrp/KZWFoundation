//
//  NSString+KZWData.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/3/23.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "NSString+KZWData.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (KZWData)

+ (NSString *)stringWithData:(NSInteger)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    /*
     yyyy-MM-dd HH:mm:ss.SSS
     yyyy-MM-dd HH:mm:ss
     yyyy-MM-dd
     MM dd yyyy
     */
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    return [formatter stringFromDate:timeDate];
}

+ (NSString *)stringWithDay:(NSInteger)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM/dd"];
    /*
     yyyy-MM-dd HH:mm:ss.SSS
     yyyy-MM-dd HH:mm:ss
     yyyy-MM-dd
     MM dd yyyy
     */
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    return [formatter stringFromDate:timeDate];
}

+ (NSString *)stringWithHour:(NSInteger)time {
    int seconds = time % 60;
    int minutes = (time / 60) % 60;
    int hours = (int)time / 3600;

    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

+ (NSString *)getCurrentTimestamp {

    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];

    NSTimeInterval a = [dat timeIntervalSince1970];

    NSString *timeString = [NSString stringWithFormat:@"%0.f", a]; //转为字符型

    return timeString;
}

- (NSString *)md5 {
    //    NSString *oustr = [NSString stringWithFormat:@"kzyjj%@", self];
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]];
}

- (NSString *)smsmd5 {
    NSString *oustr = [NSString stringWithFormat:@"0dea830e9abed107263215c003fdfeae%@", self];
    const char *cStr = [oustr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]];
}

+ (NSMutableAttributedString *)attWithString:(NSString *)string imageName:(NSString *)imageName {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    attch.bounds = CGRectMake(0, -4, 16, 16);
    NSAttributedString *sstring = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:sstring atIndex:0];
    return attri;
}

+ (NSMutableAttributedString *)attWithString:(NSString *)string lastImageName:(NSString *)imageName {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:imageName];
    attch.bounds = CGRectMake(0, -4, 16, 16);
    NSAttributedString *sstring = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:sstring];
    return attri;
}

+ (NSMutableAttributedString *)attWithString:(NSString *)string color:(UIColor *)color font:(CGFloat)font rang:(NSRange)rang {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSForegroundColorAttributeName value:color range:rang];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:rang];
    return attri;
}

- (NSString *)kzw_urlEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)kzw_urlDecode {
    return [self stringByRemovingPercentEncoding];
}

- (BOOL)validateMobile {
    NSString *pattern = @"(1)[0-9]{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)validatePassword {
    NSString *passWordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}

- (BOOL)validateMoney {
    NSString *phoneRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}


- (BOOL)validateIdentityCard {
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

- (BOOL)validateBankCardNumCheck {
    if (self.length < 15) {
        return NO;
    }
    NSString *lastNum = [[self substringFromIndex:(self.length - 1)] copy]; //取出最后一位
    NSString *forwardNum = [[self substringToIndex:(self.length - 1)] copy]; //前15或18位

    NSMutableArray *forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < forwardNum.length; i++) {
        NSString *subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }

    NSMutableArray *forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count - 1); i > -1; i--) { //前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }

    NSMutableArray *arrOddNum = [[NSMutableArray alloc] initWithCapacity:0]; //奇数位*2的积 < 9
    NSMutableArray *arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0]; //奇数位*2的积 > 9
    NSMutableArray *arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0]; //偶数位数组

    for (int i = 0; i < forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i % 2) { //偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        } else { //奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            } else {
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }

    __block NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];

    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];

    __block NSInteger sumEvenNumTotal = 0;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];

    NSInteger lastNumber = [lastNum integerValue];

    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;

    return (luhmTotal % 10 == 0) ? YES : NO;
}

- (BOOL)validateTextField {
    NSString *pattern = @"[^a-zA-Z0-9\u4e00-\u9fa5]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

@end
