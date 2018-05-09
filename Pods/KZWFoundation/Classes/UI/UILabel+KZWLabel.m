//
//  UILabel+KZWLabel.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/5/16.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "UILabel+KZWLabel.h"

@implementation UILabel (KZWLabel)

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(CGFloat)font {
    if (self = [self initWithFrame:frame]) {
        self.numberOfLines = 0;
        self.textColor = textColor;
        self.font = [UIFont systemFontOfSize:font];
    }
    return self;
}

@end
