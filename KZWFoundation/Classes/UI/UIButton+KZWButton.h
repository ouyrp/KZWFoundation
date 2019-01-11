//
//  UIButton+KZWButton.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/4/19.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KZWButtonType) {
    KZWButtonTypeLine,
    KZWButtonTypeBG,
    KZWButtonTypeCancel,
    KZWButtonTypeDefault
};

typedef NS_ENUM(NSInteger, ZXImagePosition) {
    ZXImagePositionLeft = 0, //图片在左，文字在右，默认
    ZXImagePositionRight = 1, //图片在右，文字在左
    ZXImagePositionTop = 2, //图片在上，文字在下
    ZXImagePositionBottom = 3, //图片在下，文字在上
};

@interface UIButton (KZWButton)

- (instancetype)initWithType:(KZWButtonType)buttonTYpe normalTitle:(NSString *)normalTitle titleFont:(CGFloat)titleFont cornerRadius:(NSInteger)cornerRadius;

- (void)setImagePosition:(ZXImagePosition)postion spacing:(CGFloat)spacing;

- (void)setImagePosition:(ZXImagePosition)postion WithMargin:(CGFloat)margin;


@end
