//
//  UIColor+KZWColor.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (KZWColor)


+ (UIColor *)colorWithHexString:(NSString *)hexString;


+ (UIColor *)colorWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)colorWithRGBA:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)baseColor;


@end
