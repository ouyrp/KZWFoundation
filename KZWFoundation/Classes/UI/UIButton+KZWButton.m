//
//  UIButton+KZWButton.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/4/19.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "UIButton+KZWButton.h"
#import "KZWConstants.h"
#import "UIColor+KZWColor.h"

@implementation UIButton (KZWButton)

- (instancetype)initWithType:(KZWButtonType)buttonTYpe normalTitle:(NSString *)normalTitle titleFont:(CGFloat)titleFont cornerRadius:(NSInteger)cornerRadius {
    if (self = [self init]) {
        [self setTitle:normalTitle forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
        self.layer.cornerRadius = cornerRadius;
        switch (buttonTYpe) {
            case KZWButtonTypeLine: {
                [self setBackgroundColor:[UIColor whiteColor]];
                [self setTitleColor:[UIColor colorWithHexString:FontColorcccccc] forState:UIControlStateDisabled];
                [self setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
                if (self.enabled) {
                    self.layer.borderColor = [UIColor baseColor].CGColor;
                    self.layer.borderWidth = 0.5;
                } else {
                    self.layer.borderColor = [UIColor colorWithHexString:FontColorcccccc].CGColor;
                    self.layer.borderWidth = 0.5;
                }
            } break;
            case KZWButtonTypeBG: {
                self.backgroundColor = [UIColor baseColor];
                [self addTarget:self action:@selector(kzwbuttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
                [self addTarget:self action:@selector(kzwbuttonBackGroundNormal:) forControlEvents:UIControlEventTouchUpInside];
                //            [button setBackgroundImage:[self imageWithColor:[[UIColor baseColor] colorWithAlphaComponent:0.3]] forState:UIControlStateDisabled];
            } break;
            case KZWButtonTypeCancel: {
                [self setTitleColor:[UIColor colorWithHexString:FontColor999999] forState:UIControlStateNormal];
                [self setTitleColor:[UIColor colorWithHexString:FontColor999999] forState:UIControlStateDisabled];
                self.layer.borderColor = [UIColor colorWithHexString:FontColor999999].CGColor;
                self.layer.borderWidth = 0.5;
                self.layer.masksToBounds = YES;
            } break;
            case KZWButtonTypeDefault: {
                [self setBackgroundColor:[UIColor whiteColor]];
                [self setTitleColor:[UIColor colorWithHexString:FontColor333333] forState:UIControlStateNormal];
            } break;
            default:
                break;
        }
    }
    return self;
}

- (void)kzwbuttonBackGroundNormal:(UIButton *)sender {
    sender.backgroundColor = [UIColor baseColor];
}

//  button1高亮状态下的背景色
- (void)kzwbuttonBackGroundHighlighted:(UIButton *)sender {
    sender.backgroundColor = [UIColor colorWithHexString:@"e15e0e"];
}

- (void)setImagePosition:(ZXImagePosition)postion spacing:(CGFloat)spacing {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].height;

    //image中心移动的x距离
    CGFloat imageOffsetX = labelWidth / 2;
    //image中心移动的y距离
    CGFloat imageOffsetY = labelHeight / 2 + spacing / 2;
    //label中心移动的x距离
    CGFloat labelOffsetX = imageWith / 2;
    //label中心移动的y距离
    CGFloat labelOffsetY = imageHeight / 2 + spacing / 2;

    switch (postion) {
        case ZXImagePositionLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing / 2, 0, spacing / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing / 2, 0, -spacing / 2);
            break;

        case ZXImagePositionRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing / 2, 0, -(labelWidth + spacing / 2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageHeight + spacing / 2), 0, imageHeight + spacing / 2);
            break;

        case ZXImagePositionTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            break;

        case ZXImagePositionBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            break;

        default:
            break;
    }
}

/**根据图文距边框的距离调整图文间距*/
- (void)setImagePosition:(ZXImagePosition)postion WithMargin:(CGFloat)margin {
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat labelWidth = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}].width;
    CGFloat spacing = self.bounds.size.width - imageWith - labelWidth - 2 * margin;

    [self setImagePosition:postion spacing:spacing];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
